/**
 * @description Agent action to get a summary of the rate change workflow for an account and contract.
 * Shows: clinicians selected, contracts created, letters generated, and emails sent.
 * Returns a single rich-formatted message string.
 */
public with sharing class RateChangeSummaryAction {

    /**
     * @description Returns a summary of the rate change workflow: clinicians selected, contracts created, letters, emails.
     * @param inputs List of RateChangeInvocableInput containing accountId and contractId
     * @return List of RateChangeInvocableOutput with success and rich-formatted message
     */
    @InvocableMethod(label='Rate Change Summary' description='Returns summary of rate change workflow: clinicians selected, contracts created, letters generated, and emails sent. Pass accountId and contractId from context.' category='Contract Management')
    public static List<RateChangeInvocableOutput> getRateChangeSummary(List<RateChangeInvocableInput> inputs) {
        List<RateChangeInvocableOutput> outputs = new List<RateChangeInvocableOutput>();
        RateChangeInvocableOutput output = new RateChangeInvocableOutput();

        RateChangeInvocableInput.ValidationResult validation = RateChangeInvocableInput.validateAccountAndContract(inputs);
        if (!validation.isValid) {
            output.success = false;
            output.message = validation.errorMessage;
            outputs.add(output);
            return outputs;
        }

        String accountId = validation.input.accountId;
        String contractId = validation.input.contractId;

        try {
            Clinical_Rate_Change__c crc = RateChangeQueryService.getRateChangeForSummary(accountId, contractId);

            if (crc == null) {
                output.success = false;
                output.message = 'No rate change found for this account and contract.';
                outputs.add(output);
                return outputs;
            }

            output.success = true;

            List<SummaryItem> cliniciansList = getCliniciansSelected(crc.user_selected_IDs__c);
            List<SummaryItem> contractsList = getContractsCreated(crc.PreviewClonedContractIds__c);
            List<SummaryItem> lettersList = getLettersCreated(crc.DocGenerationBatchProcessId__c);
            List<SummaryItem> emailsList = getEmailsSent(crc.PreviewClonedContractIds__c);

            output.message = buildRichSummaryMessage(
                cliniciansList,
                contractsList,
                lettersList,
                emailsList
            );

        } catch (Exception e) {
            output.success = false;
            output.message = 'Error retrieving summary: ' + e.getMessage();
        }

        outputs.add(output);
        return outputs;
    }

    private class SummaryItem {
        public String id;
        public String name;
        public String detail;
    }

    private static List<SummaryItem> getCliniciansSelected(String userSelectedIdsJson) {
        List<SummaryItem> items = new List<SummaryItem>();
        if (String.isBlank(userSelectedIdsJson)) {
            return items;
        }

        try {
            Object jsonResult = JSON.deserializeUntyped(userSelectedIdsJson);
            List<String> clinicianIds = IdParsingUtil.extractSelectedClinicianIds(jsonResult);
            if (clinicianIds.isEmpty()) {
                return items;
            }

            Map<Id, String> idToName = new Map<Id, String>();
            for (Contact c : [SELECT Id, Name FROM Contact WHERE Id IN :clinicianIds]) {
                idToName.put(c.Id, c.Name);
            }
            for (String idStr : clinicianIds) {
                SummaryItem item = new SummaryItem();
                item.id = idStr;
                item.name = idToName.containsKey((Id) idStr) ? idToName.get((Id) idStr) : idStr;
                item.detail = item.name;
                items.add(item);
            }
        } catch (Exception e) {
            System.debug('Error parsing user_selected_IDs__c: ' + e.getMessage());
        }
        return items;
    }

    private static List<SummaryItem> getContractsCreated(String previewClonedContractIds) {
        List<SummaryItem> items = new List<SummaryItem>();
        List<Id> contractIds = IdParsingUtil.parseCommaSeparatedIds(previewClonedContractIds);
        if (contractIds.isEmpty()) {
            return items;
        }

        for (Contract c : [SELECT Id, ContractNumber, Account.Name FROM Contract WHERE Id IN :contractIds AND Status IN ('Draft', 'Executed')]) {
            SummaryItem item = new SummaryItem();
            item.id = c.Id;
            item.name = c.Account != null ? c.Account.Name : 'Unknown';
            item.detail = (String.isNotBlank(c.ContractNumber) ? c.ContractNumber + ' - ' : '') + item.name;
            items.add(item);
        }
        return items;
    }

    private static List<SummaryItem> getLettersCreated(Id docGenerationBatchProcessId) {
        List<SummaryItem> items = new List<SummaryItem>();
        if (docGenerationBatchProcessId == null) {
            return items;
        }

        List<Id> contractIds = new List<Id>();
        for (DocumentGenerationProcess dgp : [
            SELECT ReferenceObject FROM DocumentGenerationProcess
            WHERE DocGenerationBatchProcessId = :docGenerationBatchProcessId
            AND ReferenceObject != null
        ]) {
            contractIds.add(dgp.ReferenceObject);
        }
        if (contractIds.isEmpty()) {
            return items;
        }

        List<Contract> draftContracts = [
            SELECT Id, ContractNumber, Account.Name FROM Contract WHERE Id IN :contractIds
        ];
        Set<Id> contractsWithLetter = RateChangeContractUtil.getContractsWithCompensationNoticeLetter(draftContracts);
        for (Contract c : draftContracts) {
            if (!contractsWithLetter.contains(c.Id)) {
                continue;
            }
            SummaryItem item = new SummaryItem();
            item.id = c.Id;
            item.name = c.Account != null ? c.Account.Name : 'Unknown';
            item.detail = (String.isNotBlank(c.ContractNumber) ? c.ContractNumber + ' - ' : '') + item.name;
            items.add(item);
        }
        return items;
    }

    private static List<SummaryItem> getEmailsSent(String previewClonedContractIds) {
        List<SummaryItem> items = new List<SummaryItem>();
        List<Id> contractIds = IdParsingUtil.parseCommaSeparatedIds(previewClonedContractIds);
        if (contractIds.isEmpty()) {
            return items;
        }

        Set<Id> contractsWithEmailSent = new Set<Id>();
        for (EmailMessage em : [
            SELECT RelatedToId FROM EmailMessage
            WHERE RelatedToId IN :contractIds
            AND Status = '3'
        ]) {
            if (em.RelatedToId != null) {
                contractsWithEmailSent.add(em.RelatedToId);
            }
        }
        if (contractsWithEmailSent.isEmpty()) {
            return items;
        }

        for (Contract c : [SELECT Id, ContractNumber, Account.Name FROM Contract WHERE Id IN :contractsWithEmailSent]) {
            SummaryItem item = new SummaryItem();
            item.id = c.Id;
            item.name = c.Account != null ? c.Account.Name : 'Unknown';
            item.detail = item.name;
            items.add(item);
        }
        return items;
    }

    private static String buildRichSummaryMessage(
        List<SummaryItem> clinicians,
        List<SummaryItem> contracts,
        List<SummaryItem> letters,
        List<SummaryItem> emails
    ) {
        List<String> sections = new List<String>();
        sections.add('Rate Change Summary');
        sections.add('');

        if (clinicians != null && !clinicians.isEmpty()) {
            sections.add('Clinicians Selected (' + clinicians.size() + ')');
            for (SummaryItem item : clinicians) {
                sections.add('  • ' + (String.isNotBlank(item.name) ? item.name : item.id));
            }
            sections.add('');
        }

        if (contracts != null && !contracts.isEmpty()) {
            sections.add('Contracts Created (' + contracts.size() + ')');
            for (SummaryItem item : contracts) {
                sections.add('  • ' + (String.isNotBlank(item.detail) ? item.detail : item.name));
            }
            sections.add('');
        }

        if (letters != null && !letters.isEmpty()) {
            sections.add('Letters Generated (' + letters.size() + ')');
            for (SummaryItem item : letters) {
                sections.add('  • ' + (String.isNotBlank(item.detail) ? item.detail : item.name));
            }
            sections.add('');
        }

        if (emails != null && !emails.isEmpty()) {
            sections.add('Emails Sent (' + emails.size() + ')');
            for (SummaryItem item : emails) {
                sections.add('  • ' + (String.isNotBlank(item.detail) ? item.detail : item.name));
            }
            sections.add('');
        }

        if (sections.size() <= 2) {
            return 'No rate change activity found.';
        }
        return String.join(sections, '\n').trim();
    }
}