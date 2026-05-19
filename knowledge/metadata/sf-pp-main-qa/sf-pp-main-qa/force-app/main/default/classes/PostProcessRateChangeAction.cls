/**
 * @description Agent action to send rate change emails and finalize.
 * Takes accountId and contractId as input, queries Clinical_Rate_Change__c,
 * and uses Non_Processed_Clinical_Ids__c (user selections from draft contracts table) to run post-process logic.
 * Stores contract IDs for whom emails were sent in ContractsForPostProcessing__c.
 */
public with sharing class PostProcessRateChangeAction {

    /**
     * @description Sends rate change emails and finalizes using DocGenerationBatchProcessId from Clinical_Rate_Change__c.
     * @param inputs List of RateChangeInvocableInput containing accountId and contractId.
     * @return List of RateChangeInvocableOutput with success status.
     */
    @InvocableMethod(label='Post Process Rate Change' description='Sends rate change emails and finalizes. Pass accountId and contractId from context.' category='Contract Management')
    public static List<RateChangeInvocableOutput> postProcessRateChange(List<RateChangeInvocableInput> inputs) {
        List<RateChangeInvocableOutput> outputs = new List<RateChangeInvocableOutput>();
        RateChangeInvocableOutput output = new RateChangeInvocableOutput();

        RateChangeInvocableInput.ValidationResult validation = RateChangeInvocableInput.validateAccountAndContract(inputs);
        if (!validation.isValid) {
            output.success = false;
            output.message = validation.errorMessage;
            outputs.add(output);
            return outputs;
        }

        RateChangeInvocableInput input = validation.input;

        try {
            PostProcessInput processInput = preparePostProcessInput(input.accountId, input.contractId);

            if (processInput == null) {
                output.success = false;
                output.message = 'No contracts selected for processing. Please make your selection in Available Contracts and click Save before continuing.';
                outputs.add(output);
                return outputs;
            }

            Id orgWideEmailId = getOrgWideEmailId();
            EmailBatchResult emailResult = sendEmailBatch(
                processInput.contractIds,
                processInput.serviceAccountId,
                orgWideEmailId
            );
            finalize(
                processInput.contractIds,
                processInput.serviceAccountId,
                processInput.contractId,
                emailResult.resultMap,
                processInput.createdByPerson,
                orgWideEmailId,
                emailResult.successfulContractIds
            );

            output.success = true;
            output.message = 'Rate change notices have been sent successfully.';

        } catch (Exception e) {
            output.success = false;
            output.message = 'Something went wrong. Please try again.';
        }

        outputs.add(output);
        return outputs;
    }

    /**
     * @description Holds prepared inputs for post-process.
     */
    private class PostProcessInput {
        List<Id> contractIds;
        String serviceAccountId;
        String contractId;
        String createdByPerson;
    }

    /**
     * @description Prepares post-process inputs from Clinical_Rate_Change__c.Non_Processed_Clinical_Ids__c.
     * Uses user selections from draft contracts table (comma-separated contract IDs).
     * @param accountId Service Account Id (Service_Account_ID__c)
     * @param contractId Client Contract Id (Contract_ID__c)
     * @return PostProcessInput or null if no records found or Non_Processed_Clinical_Ids__c is blank
     */
    private static PostProcessInput preparePostProcessInput(String accountId, String contractId) {
        Clinical_Rate_Change__c crc = RateChangeQueryService.getOpenRateChange(accountId, contractId);
        if (crc == null) {
            return null;
        }

        List<Id> contractIds = IdParsingUtil.parseCommaSeparatedIds(crc.Non_Processed_Clinical_Ids__c);
        if (contractIds.isEmpty()) {
            return null;
        }

        PostProcessInput result = new PostProcessInput();
        result.contractIds = contractIds;
        result.serviceAccountId = crc.Service_Account_ID__c;
        result.contractId = crc.Contract_ID__c;
        result.createdByPerson = crc.CreatedById != null ? String.valueOf(crc.CreatedById) : null;
        return result;
    }

    // --- Methods copied from RateChangeService ---

    /**
     * @description Fetches the Org-Wide Email Address Id for 'No Reply'.
     * @return OrgWideEmailAddress Id or null
     */
    private static Id getOrgWideEmailId() {
        OrgWideEmailAddress[] owea = [
            SELECT Id FROM OrgWideEmailAddress
            WHERE DisplayName = 'No Reply'
            LIMIT 1
        ];
        return !owea.isEmpty() ? owea[0].Id : null;
    }

    /**
     * @description Result of sendEmailBatch: counts and contract IDs for whom emails were sent successfully.
     */
    private class EmailBatchResult {
        Map<String, Integer> resultMap;
        List<Id> successfulContractIds;
    }

    /**
     * @description Sends rate change notice emails to clinicians in batches.
     * @param clinicianContractIds List of clinician contract Ids
     * @param serviceAccountId Service account Id
     * @param orgWideEmailId Org-wide email address Id
     * @return EmailBatchResult with resultMap and successfulContractIds
     */
    private static EmailBatchResult sendEmailBatch(List<Id> clinicianContractIds, Id serviceAccountId, Id orgWideEmailId) {
        EmailBatchResult result = new EmailBatchResult();
        result.resultMap = new Map<String, Integer>{ 'Success' => 0, 'Failure' => 0 };
        result.successfulContractIds = new List<Id>();
        if (clinicianContractIds.isEmpty()) {
            return result;
        }
        Map<Id, Contract> contractMap = fetchContractsWithAccounts(clinicianContractIds);
        Map<Id, ContentVersion> contractDocs = fetchLatestContractDocuments(clinicianContractIds);
        EmailMessagesResult messagesResult = buildEmailMessages(contractMap, contractDocs, serviceAccountId, orgWideEmailId);
        sendEmailsInBatches(messagesResult.emails, messagesResult.contractIds, result.resultMap, result.successfulContractIds, 10);
        return result;
    }

    private static Map<Id, Contract> fetchContractsWithAccounts(List<Id> contractIds) {
        return new Map<Id, Contract>([
            SELECT Id, AccountId, Account.Name, Account.PersonEmail, Account.PersonContactId, Employment_Type__c
            FROM Contract WHERE Id IN :contractIds
        ]);
    }

    private static Map<Id, ContentVersion> fetchLatestContractDocuments(List<Id> contractIds) {
        Map<Id, List<ContentDocumentLink>> docLinksByContract = new Map<Id, List<ContentDocumentLink>>();
        for (ContentDocumentLink link : [
            SELECT ContentDocumentId, LinkedEntityId FROM ContentDocumentLink
            WHERE LinkedEntityId IN :contractIds
        ]) {
            if (!docLinksByContract.containsKey(link.LinkedEntityId)) {
                docLinksByContract.put(link.LinkedEntityId, new List<ContentDocumentLink>());
            }
            docLinksByContract.get(link.LinkedEntityId).add(link);
        }
        Set<Id> contentDocIds = new Set<Id>();
        for (List<ContentDocumentLink> links : docLinksByContract.values()) {
            for (ContentDocumentLink link : links) {
                contentDocIds.add(link.ContentDocumentId);
            }
        }
        Map<Id, ContentVersion> latestVersions = new Map<Id, ContentVersion>();
        if (!contentDocIds.isEmpty()) {
            for (ContentVersion version : [
                SELECT Id, Title, VersionData, ContentDocumentId FROM ContentVersion
                WHERE ContentDocumentId IN :contentDocIds AND IsLatest = true
            ]) {
                latestVersions.put(version.ContentDocumentId, version);
            }
        }
        Map<Id, ContentVersion> contractDocMap = new Map<Id, ContentVersion>();
        for (Id contractId : docLinksByContract.keySet()) {
            for (ContentDocumentLink link : docLinksByContract.get(contractId)) {
                if (latestVersions.containsKey(link.ContentDocumentId)) {
                    contractDocMap.put(contractId, latestVersions.get(link.ContentDocumentId));
                    break;
                }
            }
        }
        return contractDocMap;
    }

    private class EmailMessagesResult {
        List<Messaging.SingleEmailMessage> emails;
        List<Id> contractIds;
    }

    private static EmailMessagesResult buildEmailMessages(
        Map<Id, Contract> contractMap,
        Map<Id, ContentVersion> contractDocs,
        Id serviceAccountId,
        Id orgWideEmailId
    ) {
        EmailMessagesResult result = new EmailMessagesResult();
        result.emails = new List<Messaging.SingleEmailMessage>();
        result.contractIds = new List<Id>();
        String templateName = System.Label.ClinicianCompensationIncreaseNoticeTemplate;
        String hrEmail = System.Label.HREmail;
        EmailTemplate template = [
            SELECT Id FROM EmailTemplate
            WHERE DeveloperName = :templateName
            LIMIT 1
        ];
        for (Contract contract : contractMap.values()) {
            if (contract.AccountId == null || String.isBlank(contract.Account.PersonEmail)) {
                continue;
            }
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setTemplateId(template.Id);
            email.setSaveAsActivity(true);
            email.setWhatId(contract.Id);
            email.setToAddresses(new List<String>{ contract.Account.PersonEmail });
            if (contract.Employment_Type__c == 'Employee') {
                email.setCcAddresses(new List<String>{ hrEmail });
            }            
            email.setTargetObjectId(contract.Account.PersonContactId);
            if (orgWideEmailId != null) {
                email.setOrgWideEmailAddressId(orgWideEmailId);
            }
            if (contractDocs.containsKey(contract.Id)) {
                ContentVersion doc = contractDocs.get(contract.Id);
                Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
                attachment.setFileName(doc.Title + '.pdf');
                attachment.setBody(doc.VersionData);
                attachment.setContentType('application/pdf');
                email.setFileAttachments(new Messaging.EmailFileAttachment[]{ attachment });
            }
            result.emails.add(email);
            result.contractIds.add(contract.Id);
        }
        return result;
    }

    private static void sendEmailsInBatches(
        List<Messaging.SingleEmailMessage> emails,
        List<Id> contractIdsForEmails,
        Map<String, Integer> resultMap,
        List<Id> successfulContractIds,
        Integer batchSize
    ) {
        List<Messaging.SingleEmailMessage> batch = new List<Messaging.SingleEmailMessage>();
        List<Id> batchContractIds = new List<Id>();
        for (Integer i = 0; i < emails.size(); i++) {
            batch.add(emails[i]);
            batchContractIds.add(contractIdsForEmails[i]);
            if (batch.size() == batchSize || i == emails.size() - 1) {
                Messaging.SendEmailResult[] results = Messaging.sendEmail(batch, false);
                updateResultMap(results, batchContractIds, resultMap, successfulContractIds);
                batch.clear();
                batchContractIds.clear();
            }
        }
    }

    private static void updateResultMap(
        Messaging.SendEmailResult[] results,
        List<Id> contractIds,
        Map<String, Integer> resultMap,
        List<Id> successfulContractIds
    ) {
        for (Integer i = 0; i < results.size(); i++) {
            if (results[i].isSuccess()) {
                resultMap.put('Success', resultMap.get('Success') + 1);
                if (i < contractIds.size()) {
                    successfulContractIds.add(contractIds[i]);
                }
            } else {
                resultMap.put('Failure', resultMap.get('Failure') + 1);
                RateChangeNotificationUtil.logError('PostProcessRateChangeAction.updateResultMap', null, results[i].getErrors());
            }
        }
    }

    /**
     * @description Finalizes rate change: updates contract status, creates tasks, sends summary email,
     * stores contract IDs for whom emails were sent in ContractsForPostProcessing__c, closes Clinical_Rate_Change__c.
     * @param newContractIds Newly cloned contract Ids
     * @param serviceAccountId Service account Id
     * @param contractId Client contract Id
     * @param resultMap Email send result counts
     * @param createdByPerson User Id who initiated the process
     * @param orgWideEmailId Org-wide email address Id
     * @param successfulContractIds Contract IDs for whom emails were sent successfully
     */
    private static void finalize(
        List<Id> newContractIds,
        String serviceAccountId,
        String contractId,
        Map<String, Integer> resultMap,
        String createdByPerson,
        Id orgWideEmailId,
        List<Id> successfulContractIds
    ) {
        try {
            if (newContractIds.isEmpty()) {
                return;
            }
            Map<Id, Date> previousContractStartDates = new Map<Id, Date>();
            List<Contract> newContracts = fetchNewContracts(newContractIds, previousContractStartDates);
            updateContractsStatus(newContracts, 'Executed');
            updateClientChangeManagementToCompleted(newContracts, serviceAccountId, contractId);
            List<Task> tasksToCreate = createTasksForNewContracts(newContracts, createdByPerson);
            Account serviceAccount = getSrviceAccountData(serviceAccountId);
            sendRateChangeSummaryEmail(
                newContracts.size(),
                newContracts.size(),
                tasksToCreate.size(),
                serviceAccount,
                resultMap,
                createdByPerson,
                orgWideEmailId
            );
            List<Clinical_Rate_Change__c> rateChanges = RateChangeQueryService.getOpenRateChangesByAccount(serviceAccountId);
            Clinical_Rate_Change__c crcForAccount = RateChangeQueryService.getOpenRateChange(serviceAccountId, contractId);
            Set<Id> allEmailsSentContractIds = new Set<Id>();
            if (crcForAccount != null && String.isNotBlank(crcForAccount.ContractsForPostProcessing__c)) {
                allEmailsSentContractIds.addAll(IdParsingUtil.parseCommaSeparatedIds(crcForAccount.ContractsForPostProcessing__c));
            }
            if (successfulContractIds != null) {
                allEmailsSentContractIds.addAll(successfulContractIds);
            }
            List<String> idStrings = new List<String>();
            for (Id idVal : allEmailsSentContractIds) {
                idStrings.add(String.valueOf(idVal));
            }
            String mergedEmailsSentContractIds = !idStrings.isEmpty() ? String.join(idStrings, ',') : null;
            Set<Id> allCreatedContractIds = new Set<Id>();
            if (crcForAccount != null && String.isNotBlank(crcForAccount.PreviewClonedContractIds__c)) {
                allCreatedContractIds.addAll(IdParsingUtil.parseCommaSeparatedIds(crcForAccount.PreviewClonedContractIds__c));
            }
            Boolean allEmailsSent = !allCreatedContractIds.isEmpty() && allEmailsSentContractIds.containsAll(allCreatedContractIds);
            for (Clinical_Rate_Change__c crc : rateChanges) {
                if (allEmailsSent) {
                    crc.Status__c = 'Closed';
                }
                if (crcForAccount != null && crc.Id == crcForAccount.Id && String.isNotBlank(mergedEmailsSentContractIds)) {
                    crc.ContractsForPostProcessing__c = mergedEmailsSentContractIds;
                }
            }
            if (!rateChanges.isEmpty()) {
                update rateChanges;
            }
        } catch (Exception e) {
            RateChangeNotificationUtil.logError('PostProcessRateChangeAction.finalize', null, e);
        }
    }

    /**
     * @description Finds Client_Change_Management__c records for the selected client contract and HPFs of
     * the clinicians (from their contracts), then sets Status__c to 'Completed'.
     * @param newContracts Clinician contracts that were finalized
     * @param serviceAccountId Service account (facility) Id
     * @param contractId Client contract Id
     */
    private static void updateClientChangeManagementToCompleted(
        List<Contract> newContracts,
        String serviceAccountId,
        String contractId
    ) {
        if (newContracts.isEmpty() || String.isBlank(contractId) || String.isBlank(serviceAccountId)) {
            return;
        }
        Set<Id> personContactIds = new Set<Id>();
        for (Contract c : newContracts) {
            if (c.AccountId != null && c.Account != null && c.Account.PersonContactId != null) {
                personContactIds.add(c.Account.PersonContactId);
            }
        }
        if (personContactIds.isEmpty()) {
            return;
        }

        List<HealthcarePractitionerFacility> hpfs = [
            SELECT Id
            FROM HealthcarePractitionerFacility
            WHERE PractitionerId IN :personContactIds
              AND AccountId = :serviceAccountId
        ];
        if (hpfs.isEmpty()) {
            return;
        }

        Set<Id> hpfIds = new Set<Id>();
        for (HealthcarePractitionerFacility hpf : hpfs) {
            hpfIds.add(hpf.Id);
        }

        List<Client_Change_Management__c> ccmsToUpdate = [
            SELECT Id, Status__c
            FROM Client_Change_Management__c
            WHERE Contract__c = :contractId
              AND Healthcare_Practitioner_Facility__c IN :hpfIds
        ];
        for (Client_Change_Management__c ccm : ccmsToUpdate) {
            ccm.Status__c = 'Completed';
        }
        if (!ccmsToUpdate.isEmpty()) {
            update ccmsToUpdate;
        }
    }

    private static List<Contract> fetchNewContracts(List<Id> newContractIds, Map<Id, Date> previousContractStartDates) {
        List<Contract> newContracts = [
            SELECT Id, PreviousContractId, StartDate, Status, AccountId, Account.PersonContactId
            FROM Contract WHERE Id IN :newContractIds
        ];
        for (Contract c : newContracts) {
            if (c.PreviousContractId != null) {
                previousContractStartDates.put(c.PreviousContractId, c.StartDate);
            }
        }
        return newContracts;
    }

    private static void updateContractsStatus(List<Contract> contracts, String status) {
        for (Contract c : contracts) {
            c.Status = status;
        }
        if (!contracts.isEmpty()) {
            update contracts;
        }
    }

    private static List<Task> createTasksForNewContracts(List<Contract> newContracts, String createdByPerson) {
        List<Task> tasks = new List<Task>();
        for (Contract c : newContracts) {
            if (c.AccountId != null) {
                tasks.add(new Task(
                    Subject = 'Contract Cloned',
                    Status = 'Not Started',
                    Priority = 'Normal',
                    Description = 'A new contract has been cloned for this clinician.',
                    WhatId = c.Id,
                    OwnerId = createdByPerson != null ? createdByPerson : UserInfo.getUserId()
                ));
            }
        }
        if (!tasks.isEmpty()) {
            insert tasks;
        }
        return tasks;
    }

    private static Account getSrviceAccountData(String serviceAccountId) {
        return [SELECT Id, Name FROM Account WHERE Id = :serviceAccountId];
    }

    @TestVisible private static Boolean sendRateChangeSummaryEmailFailure = false;

    private static void sendRateChangeSummaryEmail(
        Integer totalContracts,
        Integer totalEmailsSent,
        Integer totalTasksCreated,
        Account accRec,
        Map<String, Integer> resultMap,
        String createdByPerson,
        Id orgWideEmailId
    ) {
        try {
            if (sendRateChangeSummaryEmailFailure) {
                throw new CalloutException('sendRateChangeSummaryEmail failure');
            }
            User usertonotify = [SELECT Id, email FROM User WHERE Id = :createdByPerson LIMIT 1];
            List<String> toAddresses = new List<String>{ usertonotify.email };
            Integer successCount = resultMap.containsKey('Success') ? resultMap.get('Success') : 0;
            Integer failureCount = resultMap.containsKey('Failure') ? resultMap.get('Failure') : 0;
            Integer totalEmails = successCount + failureCount;
            String emailBody = 'Please see the following outcome from your recent clinician facility rate change notice initiation request.<br/><br/>';
            emailBody += 'Request Date: ' + Date.today() + '<br/>';
            emailBody += 'Impacted Service Account(s): ' + (accRec != null ? accRec.Name : 'N/A') + '<br/>';
            emailBody += 'Total Impacted Clinicians: ' + totalContracts + '<br/>';
            emailBody += 'Total Emails Sent: ' + successCount + ' / Total (' + totalEmails + ')<br/>';
            emailBody += 'Total Contracts Created: ' + totalContracts + '<br/>';
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            if (orgWideEmailId != null) {
                mail.setOrgWideEmailAddressId(orgWideEmailId);
            }
            mail.setToAddresses(toAddresses);
            mail.setSubject('Clinician Facility Rate Change Notice Update - ' + (accRec != null ? accRec.Name : ''));
            mail.setHtmlBody(emailBody);
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });
        } catch (Exception e) {
            RateChangeNotificationUtil.logError('PostProcessRateChangeAction.sendRateChangeSummaryEmail', null, e);
        }
    }
}