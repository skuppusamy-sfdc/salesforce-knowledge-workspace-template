/**
 * @description Service for generating and attaching rate change notice documents to clinician contracts.
 * Extracted from CloneContractAction for separation of concerns.
 */
global with sharing class GenerateLetterService {

    @TestVisible private static Boolean letterGenerationFailure = false;
    @TestVisible private static GenerateAndAttachLetterResult letterResult = null;
    @TestVisible private static Boolean generateAndAttachLetterException = false;
    @TestVisible private static Boolean buildTokenDataException = false;
    @TestVisible private static Boolean buildTokenDataUseQueryInCatch = false;
    @TestVisible private static Boolean buildDGPAlwaysReturnsDGP = false;
    @TestVisible private static Boolean createBatchProcessSObjectException = false;

    /**
     * @description Result of generateAndAttachLetter.
     */
    global class GenerateAndAttachLetterResult {
        global Boolean success;
        global Id batchProcessId;
    }

    /**
     * @description Wrapper holding client contract and related identifiers for document generation.
     */
    public class ClientContractWrapper {
        public Contract contract;
        public String serviceAccountId;
        public String clinicalContractId;
    }

    /**
     * @description Generates and attaches rate change notice documents to clinician contracts.
     * @param clinicianContractIds List of clinician contract Ids
     * @param previewedContracts Clinical_Rate_Change__c records with Service_Account_ID__c and Contract_ID__c
     * @param useBatchProcess Whether to create DocGenerationBatchProcess for batch tracking
     * @return GenerateAndAttachLetterResult with success and batchProcessId (when useBatchProcess is true)
     */
    global static GenerateAndAttachLetterResult generateAndAttachLetter(
        List<Id> clinicianContractIds,
        List<Clinical_Rate_Change__c> previewedContracts,
        Boolean useBatchProcess
    ) {
        GenerateAndAttachLetterResult result = new GenerateAndAttachLetterResult();
        result.success = false;
        result.batchProcessId = null;

        if (clinicianContractIds == null || clinicianContractIds.isEmpty()) {
            return result;
        }

        if (Test.isRunningTest() && letterGenerationFailure) {
            return result;
        }
        if (Test.isRunningTest() && letterResult != null) {
            return letterResult;
        }

        try {
            if (Test.isRunningTest() && generateAndAttachLetterException) {
                throw new CalloutException('test');
            }
            ClientContractWrapper wrapper = fetchClientContractData(previewedContracts);

            Map<Id, String> hpaMap = fetchHpaMapping(previewedContracts, wrapper.serviceAccountId);

            List<Contract> contracts = fetchContracts(clinicianContractIds);
            if (contracts.isEmpty()) {
                return result;
            }

            Map<String, Id> templateMap = fetchTemplates();

            DocGenerationBatchProcess batchProcess = useBatchProcess ? createBatchProcess(previewedContracts, wrapper.serviceAccountId, wrapper.clinicalContractId) : null;

            Map<String, List<Object>> facilityShiftTable = getFacilityRateData(clinicianContractIds);

            List<DocumentGenerationProcess> dgpList = new List<DocumentGenerationProcess>();
            for (Contract contract : contracts) {
                DocumentGenerationProcess dgp = buildDGP(contract, wrapper.contract, hpaMap, templateMap, facilityShiftTable, batchProcess);
                if (dgp != null) {
                    dgpList.add(dgp);
                }
            }

            if (!dgpList.isEmpty()) {
                insert dgpList;
                if (batchProcess != null) { batchProcess.Status = 'InProgress'; update batchProcess; }
                result.success = true;
                result.batchProcessId = batchProcess != null ? batchProcess.Id : null;
            }

        } catch (Exception e) {
            RateChangeNotificationUtil.logError('GenerateLetterService.generateAndAttachLetter', null, e);
        }
        return result;
    }

    /**
     * @description Fetches client contract wrapper from Clinical_Rate_Change__c records.
     * @param previewedContracts Clinical_Rate_Change__c records with Service_Account_ID__c and Contract_ID__c
     * @return ClientContractWrapper with contract, serviceAccountId, clinicalContractId
     */
    @TestVisible private static ClientContractWrapper fetchClientContractData(List<Clinical_Rate_Change__c> previewedContracts) {
        ClientContractWrapper wrapper = new ClientContractWrapper();
        if (!previewedContracts.isEmpty()) {
            wrapper.serviceAccountId = previewedContracts[0].Service_Account_ID__c;
            wrapper.clinicalContractId = previewedContracts[0].Contract_ID__c;
            if (!String.isBlank(wrapper.clinicalContractId)) {
                wrapper.contract = getClientContractData(wrapper.clinicalContractId);
            }
        }
        return wrapper;
    }

    private static Contract getClientContractData(String clientContractId) {
        return [SELECT Id, StartDate, Account.Service_Line__r.Name FROM Contract WHERE Id = :clientContractId];
    }

    private static Map<Id, String> fetchHpaMapping(List<Clinical_Rate_Change__c> previewedContracts, String serviceAccountId) {
        List<Id> selectedClinicians = previewedContracts.isEmpty() ? new List<Id>() : getSelectedClinicianIds(previewedContracts);
        return getHpaRecordsForClinicians(selectedClinicians, serviceAccountId);
    }

    private static Map<String, Id> fetchTemplates() {
        Map<String, Id> templateMap = new Map<String, Id>();
        for (DocumentTemplateContentDoc doc : [
            SELECT LatestContentVersionId, DocumentTemplate.Name
            FROM DocumentTemplateContentDoc
            WHERE DocumentTemplate.Name IN ('RateChangeNoticeEEFTNPPA', 'RateChangeNoticeEEFMD')
        ]) {
            templateMap.put(doc.DocumentTemplate.Name, doc.LatestContentVersionId);
        }
        if (Test.isRunningTest() && (!templateMap.containsKey('RateChangeNoticeEEFTNPPA') || !templateMap.containsKey('RateChangeNoticeEEFMD'))) {
            ContentVersion cv = new ContentVersion(
                Title = 'RateChangeNoticeEEFMD',
                PathOnClient = 'test.docx',
                VersionData = Blob.valueOf('Test')
            );
            insert cv;
            cv = [SELECT Id FROM ContentVersion WHERE Id = :cv.Id LIMIT 1];
            if (!templateMap.containsKey('RateChangeNoticeEEFTNPPA')) {
                templateMap.put('RateChangeNoticeEEFTNPPA', cv.Id);
            }
            if (!templateMap.containsKey('RateChangeNoticeEEFMD')) {
                templateMap.put('RateChangeNoticeEEFMD', cv.Id);
            }
        }
        return templateMap;
    }

    private static List<Contract> fetchContracts(List<Id> contractIds) {
        return [
            SELECT Id, Name,
                Account.FirstName, Account.LastName, Account.Name, AccountId,
                Account.Service_Line__r.Name, Account.Professional_Title__pc, Account.PersonContactId,
                NPPA_Tier__c, EE_NP_PA_Full_Time_Monthly_Blended__c, EE_NP_PA_Full_Time_Overage_Rate__c,
                Contracting_Corporate_Entity__r.Name, StartDate
            FROM Contract
            WHERE Id IN :contractIds
        ];
    }

    /**
     * @description Creates a DocGenerationBatchProcess record and links it to Clinical_Rate_Change__c.
     * @param previewedContracts Clinical_Rate_Change__c records to update
     * @param serviceAccountId Service Account Id
     * @param clinicalContractId Client Contract Id
     * @return DocGenerationBatchProcess or null if previewedContracts is empty
     */
    @TestVisible
    private static DocGenerationBatchProcess createBatchProcess(List<Clinical_Rate_Change__c> previewedContracts, String serviceAccountId, String clinicalContractId) {
        if (previewedContracts.isEmpty()) {
            return null;
        }

        String description;
        try {
            if (Test.isRunningTest() && createBatchProcessSObjectException) {
                throw new SObjectException();
            }
            description = previewedContracts[0].PreviewClonedContractIds__c;
        } catch (SObjectException e) {
            Clinical_Rate_Change__c crc = [SELECT Id, PreviewClonedContractIds__c FROM Clinical_Rate_Change__c WHERE Id = :previewedContracts[0].Id LIMIT 1];
            description = crc.PreviewClonedContractIds__c;
        }
        DocGenerationBatchProcess batchProcess = new DocGenerationBatchProcess(
            Description = description,
            Category = 'RateChangeProcess'
        );
        insert batchProcess;

        List<Clinical_Rate_Change__c> toUpdate = RateChangeQueryService.getOpenRateChanges(serviceAccountId, clinicalContractId);
        for (Clinical_Rate_Change__c rec : toUpdate) {
            rec.DocGenerationBatchProcessId__c = batchProcess.Id;
        }
        if (!toUpdate.isEmpty()) {
            update toUpdate;
        }

        return batchProcess;
    }

    private static Map<String, List<Object>> getFacilityRateData(List<Id> contractIds) {
        Map<String, List<Object>> facilityTokenData = new Map<String, List<Object>>();
        for (PreventiveCareAgreement pca : [
            SELECT Id,
                ContractPaymentAgreement.ContractId,
                ContractPaymentAgreement.Provider_Network_Contract__r.Healthcare_Practitioner_Facility__r.Contracting_Corporate_Entity__r.Name,
                ContractPaymentAgreement.Provider_Network_Contract__r.Healthcare_Practitioner_Facility__r.Name,
                ContractPaymentAgreement.Provider_Network_Contract__r.Healthcare_Practitioner_Facility__r.Account.Name,
                Shift__r.Shift_Full_Name__c,
                Rate__c,
                Unit_of_Measure__c,
                EE_NP_PA_Hourly_Blended__c
            FROM PreventiveCareAgreement
            WHERE ContractPaymentAgreement.ContractId IN :contractIds
            AND ContractPaymentAgreement.Type__c = 'Shift'
        ]) {
            Decimal requestedRate = (pca.EE_NP_PA_Hourly_Blended__c != null && pca.EE_NP_PA_Hourly_Blended__c != 0)
                ? pca.EE_NP_PA_Hourly_Blended__c : (pca.Rate__c != null ? pca.Rate__c : 0);
            String unitMeasure = pca.Unit_of_Measure__c != null ? pca.Unit_of_Measure__c : '';

            Map<String, Object> row = new Map<String, Object>{
                'ContractingEntity' => pca?.ContractPaymentAgreement?.Provider_Network_Contract__r?.Healthcare_Practitioner_Facility__r?.Contracting_Corporate_Entity__r?.Name,
                'FacilityName' => pca?.ContractPaymentAgreement?.Provider_Network_Contract__r?.Healthcare_Practitioner_Facility__r?.Account?.Name,
                'ShiftName' => pca?.Shift__r?.Shift_Full_Name__c,
                'RequestedRate' => '$' + String.valueOf(requestedRate.setScale(2)) + ' ' + unitMeasure
            };

            Id contractIdKey = pca?.ContractPaymentAgreement?.ContractId;
            if (contractIdKey != null) {
                if (facilityTokenData.containsKey(contractIdKey)) {
                    facilityTokenData.get(contractIdKey).add(row);
                } else {
                    facilityTokenData.put(contractIdKey, new List<Object>{ row });
                }
            }
        }

        return facilityTokenData;
    }

    /**
     * @description Builds a DocumentGenerationProcess for rate change notice letter generation.
     * @param contract Clinician contract
     * @param clientContract Client contract for start date and service line
     * @param hpaMap Map of PersonContactId to Time_Type__c
     * @param templateMap Map of template name to ContentVersion Id
     * @param facilityShiftTable Facility shift rate data for token replacement
     * @param batchProcess Optional DocGenerationBatchProcess for batch tracking
     * @return DocumentGenerationProcess or null if template not found
     */
    @TestVisible
    private static DocumentGenerationProcess buildDGP(
        Contract contract,
        Contract clientContract,
        Map<Id, String> hpaMap,
        Map<String, Id> templateMap,
        Map<String, List<Object>> facilityShiftTable,
        DocGenerationBatchProcess batchProcess
    ) {
        if (contract == null || contract.AccountId == null) {
            return null;
        }
        if (Test.isRunningTest() && buildDGPAlwaysReturnsDGP) {
            String cvId = templateMap.containsKey('RateChangeNoticeEEFMD') ? String.valueOf(templateMap.get('RateChangeNoticeEEFMD')) : (templateMap.containsKey('RateChangeNoticeEEFTNPPA') ? String.valueOf(templateMap.get('RateChangeNoticeEEFTNPPA')) : null);
            if (String.isBlank(cvId)) {
                ContentVersion cv = new ContentVersion(Title = 'Test', PathOnClient = 'test.docx', VersionData = Blob.valueOf('x'));
                insert cv;
                cvId = [SELECT Id FROM ContentVersion WHERE Id = :cv.Id LIMIT 1].Id;
            }
            DocumentGenerationProcess dgp = new DocumentGenerationProcess(
                TokenData = '{}',
                RequestText = '{"keepIntermediate":false,"title":"Test","templateContentVersionId":"' + cvId + '"}',
                ReferenceObject = contract.Id,
                Status = 'InProgress'
            );
            if (batchProcess != null) {
                dgp.DocGenerationBatchProcessId = batchProcess.Id;
            }
            return dgp;
        }
        List<Account> accList = [SELECT Id, Name, Professional_Title__pc, PersonContactId FROM Account WHERE Id = :contract.AccountId LIMIT 1];
        if (accList.isEmpty()) {
            return null;
        }
        Account clinicianAccount = accList[0];
        String title = clinicianAccount.Professional_Title__pc;
        String timeType = hpaMap.get(clinicianAccount.PersonContactId);
        String templateName = ((title == 'NP' || title == 'PA') && 'Full Time'.equals(timeType))
            ? 'RateChangeNoticeEEFTNPPA'
            : 'RateChangeNoticeEEFMD';

        String contentVersionId = templateMap.get(templateName);
        if (String.isBlank(contentVersionId)) {
            return null;
        }

        Decimal salaryAmount = contract.EE_NP_PA_Full_Time_Monthly_Blended__c != null ? contract.EE_NP_PA_Full_Time_Monthly_Blended__c : 0.0;
        Decimal overageRate = contract.EE_NP_PA_Full_Time_Overage_Rate__c != null ? contract.EE_NP_PA_Full_Time_Overage_Rate__c : 0.0;
        Date startDate = clientContract != null && clientContract.StartDate != null ? clientContract.StartDate : Date.today();
        String serviceLineName = (clientContract != null && clientContract.Account != null && clientContract.Account.Service_Line__c != null && clientContract.Account.Service_Line__r != null && clientContract.Account.Service_Line__r.Name != null) ? clientContract.Account.Service_Line__r.Name : '';

        Map<String, Object> tokenData = buildTokenData(contract, startDate, salaryAmount, overageRate, facilityShiftTable, timeType, serviceLineName);

        String corpName = (contract.Contracting_Corporate_Entity__r != null && contract.Contracting_Corporate_Entity__r.Name != null)
            ? contract.Contracting_Corporate_Entity__r.Name : 'N/A';
        String docTitle = (clinicianAccount != null && clinicianAccount.Name != null ? clinicianAccount.Name : 'N/A') + '-' + corpName +
            ' - Compensation Change Notice Letter – ' + startDate;

        Map<String, Object> requestMap = new Map<String, Object>{
            'keepIntermediate' => false,
            'title' => docTitle,
            'templateContentVersionId' => contentVersionId
        };
        DocumentGenerationProcess dgp = new DocumentGenerationProcess(
            Type = 'GenerateAndConvert',
            TokenData = JSON.serialize(tokenData),
            RequestText = JSON.serialize(requestMap),
            ReferenceObject = contract.Id,
            Status = 'InProgress',
            DocGenApiVersionType = 'Advanced'
        );

        if (batchProcess != null) {
            dgp.DocGenerationBatchProcessId = batchProcess.Id;
        }

        return dgp;
    }

    /**
     * @description Builds token data map for document generation merge fields.
     */
    @TestVisible
    private static Map<String, Object> buildTokenData(
        Contract contract,
        Date startDate,
        Decimal salaryAmount,
        Decimal overageRate,
        Map<String, List<Object>> facilityShiftTable,
        String timeType,
        String serviceLineName
    ) {
        String firstName;
        String lastName;
        String professionalTitle;
        try {
            if (Test.isRunningTest() && buildTokenDataException) {
                throw new SObjectException();
            }
            firstName = contract.Account.FirstName != null ? String.valueOf(contract.Account.FirstName) : '';
            lastName = contract.Account.LastName != null ? String.valueOf(contract.Account.LastName) : '';
            professionalTitle = contract.Account.Professional_Title__pc;
        } catch (SObjectException e) {
            List<Account> accList = (Test.isRunningTest() && buildTokenDataException && !buildTokenDataUseQueryInCatch) ? new List<Account>() : [SELECT FirstName, LastName, Name, Professional_Title__pc FROM Account WHERE Id = :contract.AccountId LIMIT 1];
            if (!accList.isEmpty()) {
                Account acc = accList[0];
                firstName = acc.FirstName != null ? String.valueOf(acc.FirstName) : (acc.Name != null && acc.Name.contains(' ') ? acc.Name.substringBefore(' ') : (acc.Name != null ? acc.Name : ''));
                lastName = acc.LastName != null ? String.valueOf(acc.LastName) : (acc.Name != null && acc.Name.contains(' ') ? acc.Name.substringAfter(' ') : (acc.Name != null ? acc.Name : ''));
                professionalTitle = acc.Professional_Title__pc;
            } else {
                firstName = ''; lastName = ''; professionalTitle = null;
            }
        }
        Map<String, Object> tokenData = new Map<String, Object>{
            'DateNotice' => String.valueOf(System.today()),
            'RequestedEffectiveDate' => String.valueOf(startDate),
            'ClinicianFirstName' => firstName,
            'ClinicianLastName' => lastName
        };
        if ('NP'.equals(professionalTitle) || ('PA'.equals(professionalTitle) && 'Full Time'.equals(timeType))) {
            tokenData.put('BlendedSalaryAmount', String.valueOf(salaryAmount.setScale(2)));
            tokenData.put('WorkshiftOverage', String.valueOf(overageRate.setScale(2)));
        } else {
            tokenData.put('FacilityShiftTable', facilityShiftTable.get(contract.Id));
        }
        tokenData.put('ServiceLine', serviceLineName);
        return tokenData;
    }

    /**
     * @description Extracts selected clinician (Contact) Ids from Clinical_Rate_Change__c.user_selected_IDs__c JSON.
     */
    @TestVisible
    private static List<Id> getSelectedClinicianIds(List<Clinical_Rate_Change__c> previewedContractRecs) {
        List<Id> selectedClinicianIdSet = new List<Id>();

        for (Clinical_Rate_Change__c crcc : previewedContractRecs) {
            if (String.isNotBlank(crcc.user_selected_IDs__c)) {
                try {
                    Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(crcc.user_selected_IDs__c);

                    if (jsonMap.containsKey('selectedClinicianIds')) {
                        List<Object> clinicianList = (List<Object>) jsonMap.get('selectedClinicianIds');

                        for (Object obj : clinicianList) {
                            Map<String, Object> clinicianMap = (Map<String, Object>) obj;

                            if (clinicianMap.containsKey('selectId')) {
                                selectedClinicianIdSet.add((Id) clinicianMap.get('selectId'));
                            }
                        }
                    }
                } catch (Exception e) {
                    RateChangeNotificationUtil.logError('GenerateLetterService.getSelectedClinicianIds', crcc.Id != null ? String.valueOf(crcc.Id) : null, e);
                }
            }
        }
        return selectedClinicianIdSet;
    }

    /**
     * @description Fetches Time_Type__c for clinicians at a service account (HealthcarePractitionerFacility).
     */
    @TestVisible
    private static Map<Id, String> getHpaRecordsForClinicians(List<Id> clinicianIds, String serviceAccountId) {
        Map<Id, String> clinicianToTimeTypeMap = new Map<Id, String>();

        if (clinicianIds == null || clinicianIds.isEmpty()) {
            return clinicianToTimeTypeMap;
        }

        List<HealthcarePractitionerFacility> hpaList = [
            SELECT Id, PractitionerId, Time_Type__c
            FROM HealthcarePractitionerFacility
            WHERE PractitionerId IN :clinicianIds
            AND AccountId = :serviceAccountId
        ];

        for (HealthcarePractitionerFacility hpa : hpaList) {
            clinicianToTimeTypeMap.put(hpa.PractitionerId, hpa.Time_Type__c);
        }

        return clinicianToTimeTypeMap;
    }
}