/**
 * @description Service for cloning clinician contracts and related agreements (PNCs, CPAs, PCAs, Rate Pay Codes).
 * Extracted from CloneContractAction for separation of concerns.
 */
public with sharing class ClinicianContractCloneService {

    @TestVisible private static Boolean pncInsertException = false;
    @TestVisible private static Boolean cpaInsertException = false;
    @TestVisible private static Boolean cleanupException = false;
    @TestVisible private static Boolean adjustShiftRatesException = false;
    @TestVisible private static Boolean adjustShiftRatesInnerException = false;
    @TestVisible private static String clientGlobalFacilityId = null;
    @TestVisible private static String clonedGlobalFacilityId = null;

    /**
     * @description Clones clinician contracts and all related agreements including
     * PNCs, CPAs, PCAs, and Rate Pay Codes.
     * @param clinicianIds List of clinician (Contact) Ids - used to find Contracts via Account.PersonContactId
     * @param clientContractId Client contract Id
     * @return List of newly created contract Ids
     */
    public static List<Id> cloneContracts(List<Id> clinicianIds, String clientContractId) {
        List<Id> newlyCreatedContractIds = new List<Id>();

        if (clinicianIds == null || clinicianIds.isEmpty()) {
            return newlyCreatedContractIds;
        }

        List<Contract> contractsToDelete = new List<Contract>();
        List<ProviderNetworkContract> pncsToDelete = new List<ProviderNetworkContract>();
        List<ContractPaymentAgreement> cpasToDelete = new List<ContractPaymentAgreement>();
        List<PreventiveCareAgreement> pcasToDelete = new List<PreventiveCareAgreement>();
        List<Rate_Pay_Code__c> ratePayCodesToDelete = new List<Rate_Pay_Code__c>();

        try {
            Contract clientContract = !String.isBlank(clientContractId)
                ? getClientContractData(clientContractId) : null;

            Map<Id, Contract> latestContractByAccount = new Map<Id, Contract>();
            for (Contract c : fetchOriginalContracts(clinicianIds)) {
                if (!latestContractByAccount.containsKey(c.AccountId)) {
                    latestContractByAccount.put(c.AccountId, c);
                }
            }

            List<Contract> originalContracts = latestContractByAccount.values();

            if (originalContracts.isEmpty()) { return newlyCreatedContractIds; }

            Map<Id, Contract> successfulContractClones =
                cloneAndInsertContracts(originalContracts, clientContract, contractsToDelete, newlyCreatedContractIds);

            if (successfulContractClones.isEmpty()) { return newlyCreatedContractIds; }

            Map<Id, ProviderNetworkContract> successfulPNCClones =
                cloneAndInsertPNCs(successfulContractClones, pncsToDelete, contractsToDelete);

            Map<Id, Id> contractIdMap = buildIdMap(successfulContractClones);
            Map<Id, Id> pncIdMap = buildIdMap(successfulPNCClones);

            createCPAandPCA(contractIdMap, pncIdMap, contractsToDelete, pncsToDelete, cpasToDelete, pcasToDelete, clientContractId);

            cleanupFailedRecords(contractsToDelete, pncsToDelete, cpasToDelete, pcasToDelete, ratePayCodesToDelete);

            return newlyCreatedContractIds;

        } catch (Exception ex) {
            RateChangeNotificationUtil.logError('ClinicianContractCloneService.cloneContracts', null, ex);
            return newlyCreatedContractIds;
        }
    }

    private static Contract getClientContractData(String clientContractId) {
        return [SELECT Id, StartDate, Account.Service_Line__r.Name FROM Contract WHERE Id = :clientContractId];
    }

    private static List<Contract> fetchOriginalContracts(List<Id> clinicianIds) {
        return (List<Contract>) fetchAllFields(
            Contract.SObjectType,
            new Set<Id>(clinicianIds),
            'Account.PersonContactId',
            new Set<String>{ 'Account.Name' }
        );
    }

    private static Map<Id, Contract> cloneAndInsertContracts(
        List<Contract> originalContracts,
        Contract clientContract,
        List<Contract> contractsToDelete,
        List<Id> newlyCreatedContractIds
    ) {
        List<Contract> clonedContracts = new List<Contract>();
        Map<Id, Contract> originalToCloneMap = new Map<Id, Contract>();

        for (Contract original : originalContracts) {
            Date startDate = (clientContract != null && clientContract.StartDate != null)
                ? clientContract.StartDate : Date.today();
            startDate = Test.isRunningTest() ? Date.today() + 120 : startDate;
            Map<String, Object> overrides = new Map<String, Object>{
                'Name' => (original.Account.Name != null ? original.Account.Name : 'Clone') + ' ' + startDate,
                'Status' => 'Draft',
                'StartDate' => startDate,
                'PreviousContractId' => original.Id,
                'RecordTypeId' => original.RecordTypeId,
                'Base_Agreement_Date__c' => original.StartDate,
                'CompanySignedDate' => System.today(),
                'Contract_Trigger_Ack__c' => false
            };
            if (original.AccountId != null) { overrides.put('AccountId', original.AccountId); }
            if (original.Pricebook2Id != null) { overrides.put('Pricebook2Id', original.Pricebook2Id); }
            if (original.ContractTerm != null) { overrides.put('ContractTerm', original.ContractTerm); }

            Contract clone = (Contract) dynamicClone(original, new List<String>{ 'Id' }, overrides);
            clonedContracts.add(clone);
            originalToCloneMap.put(original.Id, clone);
        }

        Map<Id, Contract> successfulContractClones = new Map<Id, Contract>();
        Database.SaveResult[] results = Database.insert(clonedContracts, false);

        for (Integer i = 0; i < results.size(); i++) {
            if (results[i].isSuccess()) {
                successfulContractClones.put(originalContracts[i].Id, clonedContracts[i]);
                newlyCreatedContractIds.add(clonedContracts[i].Id);
            } else {
                RateChangeNotificationUtil.logError('Contract Insert Failed', originalContracts[i].Id, results[i].getErrors());
                contractsToDelete.add(clonedContracts[i]);
            }
        }

        return successfulContractClones;
    }

    private static Map<Id, ProviderNetworkContract> cloneAndInsertPNCs(
        Map<Id, Contract> successfulContractClones,
        List<ProviderNetworkContract> pncsToDelete,
        List<Contract> contractsToDelete
    ) {
        Map<Id, ProviderNetworkContract> successfulPNCClones = new Map<Id, ProviderNetworkContract>();
        if (successfulContractClones.isEmpty()) { return successfulPNCClones; }

        Set<Id> successfulContractIds = successfulContractClones.keySet();
        List<ProviderNetworkContract> originalPNCs = (List<ProviderNetworkContract>) fetchAllFields(
            ProviderNetworkContract.SObjectType,
            successfulContractIds,
            'ContractId'
        );

        if (originalPNCs.isEmpty()) { return successfulPNCClones; }

        List<ProviderNetworkContract> clonedPNCs = new List<ProviderNetworkContract>();
        for (ProviderNetworkContract pnc : originalPNCs) {
            Contract clonedContract = successfulContractClones.get(pnc.ContractId);
            if (clonedContract == null) {
                continue;
            }

            Date startDate = clonedContract.StartDate != null ? clonedContract.StartDate : Date.today();
            Date endDate = (clonedContract.EndDate == null || clonedContract.EndDate < startDate)
                ? startDate.addMonths(12) : clonedContract.EndDate;

            Map<String, Object> overrides = new Map<String, Object>{
                'ContractId' => clonedContract.Id,
                'StartDate' => startDate,
                'EndDate' => endDate
            };
            if (pnc.HealthcarePayerNetworkId != null) { overrides.put('HealthcarePayerNetworkId', pnc.HealthcarePayerNetworkId); }
            if (pnc.HealthcareProviderId != null) { overrides.put('HealthcareProviderId', pnc.HealthcareProviderId); }
            if (pnc.Healthcare_Practitioner_Facility__c != null) { overrides.put('Healthcare_Practitioner_Facility__c', pnc.Healthcare_Practitioner_Facility__c); }
            if (pnc.Number_of_Anticipate_Hours__c != null) { overrides.put('Number_of_Anticipate_Hours__c', pnc.Number_of_Anticipate_Hours__c); }

            ProviderNetworkContract clone = (ProviderNetworkContract) dynamicClone(
                pnc,
                new List<String>{ 'Id', 'ContractId' },
                overrides
            );
            clonedPNCs.add(clone);
        }

        if (Test.isRunningTest() && pncInsertException && !clonedPNCs.isEmpty()) {
            clonedPNCs[0].ContractId = null;
        }
        Database.SaveResult[] pncResults = Database.insert(clonedPNCs, false);
        for (Integer i = 0; i < pncResults.size(); i++) {
            if (pncResults[i].isSuccess()) {
                successfulPNCClones.put(originalPNCs[i].Id, clonedPNCs[i]);
            } else {
                RateChangeNotificationUtil.logError('PNC Insert Failed', originalPNCs[i].Id, pncResults[i].getErrors());
                pncsToDelete.add(clonedPNCs[i]);
                Id failedContractId = originalPNCs[i].ContractId;
                if (successfulContractClones.containsKey(failedContractId)) {
                    contractsToDelete.add(successfulContractClones.get(failedContractId));
                    successfulContractClones.remove(failedContractId);
                }
            }
        }
        return successfulPNCClones;
    }

    private static Map<Id, Id> buildIdMap(Map<Id, SObject> cloneMap) {
        Map<Id, Id> idMap = new Map<Id, Id>();
        for (Id oldId : cloneMap.keySet()) {
            idMap.put(oldId, cloneMap.get(oldId).Id);
        }
        return idMap;
    }

    private static void createCPAandPCA(
        Map<Id, Id> oldToNewContractMap,
        Map<Id, Id> oldToNewPNCMap,
        List<Contract> contractsToDelete,
        List<ProviderNetworkContract> pncsToDelete,
        List<ContractPaymentAgreement> cpasToDelete,
        List<PreventiveCareAgreement> pcasToDelete,
        String clientContractId
    ) {
        try {
            if (oldToNewContractMap.isEmpty()) {
                RateChangeNotificationUtil.logError('ClinicianContractCloneService.createCPAandPCA', null, 'No contract mappings found, skipping CPA/PCA cloning.');
                return;
            }

            Map<Id, Contract> newContractMap = fetchNewContracts(oldToNewContractMap.values());
            Map<Id, Account> accountMap = fetchAccounts(newContractMap.values());
            List<ContractPaymentAgreement> originalCPAs = fetchOriginalCPAs(oldToNewContractMap.keySet());
            if (originalCPAs.isEmpty()) { return; }

            Map<Id, ProviderNetworkContract> pncMap = fetchPNCsForCPAs(originalCPAs);

            Map<Id, Id> oldCPAtoNewCPA = cloneCPAs(
                originalCPAs,
                oldToNewContractMap,
                oldToNewPNCMap,
                newContractMap,
                accountMap,
                contractsToDelete,
                cpasToDelete
            );
            if (oldCPAtoNewCPA.isEmpty()) { return; }

            List<Rate_Pay_Code__c> ratePayCodesToDelete = new List<Rate_Pay_Code__c>();
            Map<Id, List<PreventiveCareAgreement>> oldToNewPcaMap = clonePCAs(oldCPAtoNewCPA, pcasToDelete);

            cloneRatePayCodesForPCAs(oldToNewPcaMap, ratePayCodesToDelete);

            List<PreventiveCareAgreement> allClonedPCAs = new List<PreventiveCareAgreement>();
            for (List<PreventiveCareAgreement> pcaList : oldToNewPcaMap.values()) {
                allClonedPCAs.addAll(pcaList);
            }

            if (!allClonedPCAs.isEmpty() && !String.isBlank(clientContractId)) {
                adjustShiftRates(allClonedPCAs, clientContractId);
            }
        } catch (Exception ex) {
            RateChangeNotificationUtil.logError('ClinicianContractCloneService.createCPAandPCA', null, ex);
        }
    }

    private static void cleanupFailedRecords(
        List<Contract> contractsToDelete,
        List<ProviderNetworkContract> pncsToDelete,
        List<ContractPaymentAgreement> cpasToDelete,
        List<PreventiveCareAgreement> pcasToDelete,
        List<Rate_Pay_Code__c> ratePayCodesToDelete
    ) {
        try {
            if (Test.isRunningTest() && cleanupException) {
                throw new DmlException('test');
            }
            if (!ratePayCodesToDelete.isEmpty()) { delete ratePayCodesToDelete; }
            if (!pcasToDelete.isEmpty()) { delete pcasToDelete; }
            if (!cpasToDelete.isEmpty()) { delete cpasToDelete; }
            if (!pncsToDelete.isEmpty()) { delete pncsToDelete; }
            if (!contractsToDelete.isEmpty()) { delete contractsToDelete; }
        } catch (DmlException cleanupEx) {
            RateChangeNotificationUtil.logError('Cleanup Failed', null, cleanupEx);
        }
    }

    private static Map<Id, Contract> fetchNewContracts(List<Id> newContractIds) {
        return new Map<Id, Contract>([
            SELECT Id, ContractNumber, AccountId, StartDate
            FROM Contract
            WHERE Id IN :newContractIds
        ]);
    }

    private static Map<Id, Account> fetchAccounts(List<Contract> contracts) {
        Set<Id> accountIds = new Set<Id>();
        for (Contract c : contracts) {
            if (c.AccountId != null) {
                accountIds.add(c.AccountId);
            }
        }
        if (accountIds.isEmpty()) {
            return new Map<Id, Account>();
        }

        return new Map<Id, Account>([
            SELECT Id, Global_Provider_ID__pc, Name
            FROM Account
            WHERE Id IN :accountIds
        ]);
    }

    private static List<ContractPaymentAgreement> fetchOriginalCPAs(Set<Id> contractIds) {
        Set<String> extraFieldSet = new Set<String>{ 'Provider_Network_Contract__r.Healthcare_Practitioner_Facility__r.Name' };
        return (List<ContractPaymentAgreement>) fetchAllFields(
            ContractPaymentAgreement.SObjectType,
            contractIds,
            'ContractId',
            extraFieldSet
        );
    }

    private static Map<Id, ProviderNetworkContract> fetchPNCsForCPAs(List<ContractPaymentAgreement> cpas) {
        Set<Id> pncIds = new Set<Id>();
        for (ContractPaymentAgreement cpa : cpas) {
            if (cpa.Provider_Network_Contract__c != null) {
                pncIds.add(cpa.Provider_Network_Contract__c);
            }
        }
        if (pncIds.isEmpty()) {
            return new Map<Id, ProviderNetworkContract>();
        }

        return new Map<Id, ProviderNetworkContract>([
            SELECT Id, Healthcare_Practitioner_Facility__r.Account.Global_Facility_ID__c
            FROM ProviderNetworkContract
            WHERE Id IN :pncIds
        ]);
    }

    private static Map<Id, Id> cloneCPAs(
        List<ContractPaymentAgreement> originalCPAs,
        Map<Id, Id> oldToNewContractMap,
        Map<Id, Id> oldToNewPNCMap,
        Map<Id, Contract> newContractMap,
        Map<Id, Account> accountMap,
        List<Contract> contractsToDelete,
        List<ContractPaymentAgreement> cpasToDelete
    ) {
        List<ContractPaymentAgreement> clonedCPAs = new List<ContractPaymentAgreement>();
        Map<Id, Id> oldCPAtoNewCPA = new Map<Id, Id>();

        for (ContractPaymentAgreement cpa : originalCPAs) {
            if (!oldToNewContractMap.containsKey(cpa.ContractId)) {
                continue;
            }

            Contract newContract = newContractMap.get(oldToNewContractMap.get(cpa.ContractId));
            Account acc = accountMap.get(newContract.AccountId);
            String uniqueName = buildCPAUniqueName(cpa, newContract, acc);

            Map<String, Object> overrides = new Map<String, Object>{
                'ContractId' => oldToNewContractMap.get(cpa.ContractId),
                'Provider_Network_Contract__c' => oldToNewPNCMap.get(cpa.Provider_Network_Contract__c),
                'Status' => 'Draft',
                'Name' => uniqueName,
                'ContractPaymentAgreementKey' => null,
                'StartDateTime' => DateTime.newInstance(newContract.StartDate.year(), newContract.StartDate.month(), newContract.StartDate.day(), 15, 0, 0)
            };

            clonedCPAs.add((ContractPaymentAgreement) dynamicClone(
                cpa, new List<String>{ 'Id', 'ContractId', 'Provider_Network_Contract__c', 'Status', 'Name' }, overrides));
        }

        if (Test.isRunningTest() && cpaInsertException && !clonedCPAs.isEmpty()) {
            clonedCPAs[0].ContractId = null;
        }
        Database.SaveResult[] cpaResults = Database.insert(clonedCPAs, false);
        for (Integer i = 0; i < cpaResults.size(); i++) {
            if (cpaResults[i].isSuccess()) {
                oldCPAtoNewCPA.put(originalCPAs[i].Id, cpaResults[i].getId());
            } else {
                RateChangeNotificationUtil.logError('CPA Insert Failed', null, cpaResults[i].getErrors());
                if (clonedCPAs[i].Id != null) {
                    cpasToDelete.add(clonedCPAs[i]);
                }
                Id parentContractId = oldToNewContractMap.get(originalCPAs[i].ContractId);
                if (parentContractId != null) {
                    contractsToDelete.add(new Contract(Id = parentContractId));
                }
            }
        }
        return oldCPAtoNewCPA;
    }

    private static Map<Id, List<PreventiveCareAgreement>> clonePCAs(
        Map<Id, Id> oldCPAtoNewCPA,
        List<PreventiveCareAgreement> pcasToDelete
    ) {
        Map<Id, List<PreventiveCareAgreement>> oldToNewPcaMap = new Map<Id, List<PreventiveCareAgreement>>();

        List<PreventiveCareAgreement> originalPCAs = (List<PreventiveCareAgreement>) fetchAllFields(
            PreventiveCareAgreement.SObjectType,
            oldCPAtoNewCPA.keySet(),
            'ContractPaymentAgreementId'
        );

        List<PreventiveCareAgreement> clonedPCAs = new List<PreventiveCareAgreement>();

        for (PreventiveCareAgreement pca : originalPCAs) {
            Id newCpaId = oldCPAtoNewCPA.get(pca.ContractPaymentAgreementId);
            if (newCpaId == null) {
                continue;
            }

            Map<String, Object> overrides = new Map<String, Object>{
                'ContractPaymentAgreementId' => oldCPAtoNewCPA.get(pca.ContractPaymentAgreementId)
            };

            PreventiveCareAgreement clonedPca = (PreventiveCareAgreement) dynamicClone(
                pca, new List<String>{ 'Id', 'ContractPaymentAgreementId' }, overrides
            );

            clonedPCAs.add(clonedPca);

            if (!oldToNewPcaMap.containsKey(pca.Id)) {
                oldToNewPcaMap.put(pca.Id, new List<PreventiveCareAgreement>());
            }
            oldToNewPcaMap.get(pca.Id).add(clonedPca);
        }

        Database.SaveResult[] pcaResults = Database.insert(clonedPCAs, false);
        for (Integer i = 0; i < pcaResults.size(); i++) {
            if (!pcaResults[i].isSuccess()) {
                RateChangeNotificationUtil.logError('PCA Insert Failed', null, pcaResults[i].getErrors());
                if (clonedPCAs[i].Id != null) {
                    pcasToDelete.add(clonedPCAs[i]);
                }
            }
        }
        return oldToNewPcaMap;
    }

    private static String buildCPAUniqueName(ContractPaymentAgreement cpa, Contract newContract, Account acc) {
        String globalOrAccount = acc != null && acc.Global_Provider_ID__pc != null ? String.valueOf(acc.Global_Provider_ID__pc) : (acc != null ? acc.Name : 'NA');
        String facilityName = (cpa.Provider_Network_Contract__r != null && cpa.Provider_Network_Contract__r.Healthcare_Practitioner_Facility__r != null)
            ? cpa.Provider_Network_Contract__r.Healthcare_Practitioner_Facility__r.Name
            : 'NA';
        return (newContract.ContractNumber != null ? newContract.ContractNumber : 'NA')
            + '-' + globalOrAccount
            + '-' + facilityName
            + '-' + (cpa.Type__c != null ? cpa.Type__c : 'NA');
    }

    @TestVisible
    private static void cloneRatePayCodesForPCAs(Map<Id, List<PreventiveCareAgreement>> oldToNewPcaMap, List<Rate_Pay_Code__c> ratePayCodesToDelete) {
        if (oldToNewPcaMap.isEmpty()) {
            return;
        }

        Set<Id> oldPcaIds = oldToNewPcaMap.keySet();

        List<Rate_Pay_Code__c> originalRatePayCodes = (List<Rate_Pay_Code__c>) fetchAllFields(
            Rate_Pay_Code__c.SObjectType,
            oldPcaIds,
            'Preventive_Care_Agreement__c'
        );

        List<Rate_Pay_Code__c> clones = new List<Rate_Pay_Code__c>();

        for (Rate_Pay_Code__c original : originalRatePayCodes) {
            List<PreventiveCareAgreement> newPcas = oldToNewPcaMap.get(original.Preventive_Care_Agreement__c);
            if (newPcas == null || newPcas.isEmpty()) {
                continue;
            }

            for (PreventiveCareAgreement newPca : newPcas) {
                Map<String, Object> overrides = new Map<String, Object>{
                    'Preventive_Care_Agreement__c' => newPca.Id
                };

                Rate_Pay_Code__c clone = (Rate_Pay_Code__c) dynamicClone(
                    original,
                    new List<String>{ 'Id', 'Preventive_Care_Agreement__c' },
                    overrides
                );
                clones.add(clone);
            }
        }

        if (!clones.isEmpty()) {
            Database.SaveResult[] saveResults = Database.insert(clones, false);
            for (Integer i = 0; i < saveResults.size(); i++) {
                if (!saveResults[i].isSuccess()) {
                    RateChangeNotificationUtil.logError('RatePayrec Insert Failed', null, saveResults[i].getErrors());
                    if (clones[i].Id != null) {
                        ratePayCodesToDelete.add(clones[i]);
                    }
                }
            }
        }
    }

    @TestVisible
    private static void adjustShiftRates(List<PreventiveCareAgreement> clonedPCAs, String clientContractId) {
        if (clonedPCAs.isEmpty() || clientContractId == null) {
            return;
        }

        try {
            if (Test.isRunningTest() && adjustShiftRatesException) {
                throw new CalloutException('test');
            }
            List<PreventiveCareAgreement> clientShiftPCAs = [
                SELECT Id, FacilityTitle__r.Name, Shift__r.Shift_Full_Name__c, Rate__c, Unit_of_Measure__c, Time_Type__c,
                    ContractPaymentAgreement.Type__c,
                    ContractPaymentAgreement.Contract.Account.Global_Facility_ID__c
                FROM PreventiveCareAgreement
                WHERE ContractPaymentAgreement.ContractId = :clientContractId
                AND ContractPaymentAgreement.Type__c = 'Shift'
            ];

            Map<String, PreventiveCareAgreement> clientShiftPcaMap = new Map<String, PreventiveCareAgreement>();
            for (PreventiveCareAgreement pca : clientShiftPCAs) {
                if (pca.Shift__r != null && pca.FacilityTitle__r != null) {
                    String globalFacilityId = (Test.isRunningTest() && clientGlobalFacilityId != null)
                        ? clientGlobalFacilityId
                        : (pca.ContractPaymentAgreement.Contract.Account.Global_Facility_ID__c != null
                            ? String.valueOf(pca.ContractPaymentAgreement.Contract.Account.Global_Facility_ID__c) : '');
                    String key = pca.Shift__r.Shift_Full_Name__c + '_' + globalFacilityId + '_' + pca.FacilityTitle__r.Name + '_' + pca.Time_Type__c;
                    clientShiftPcaMap.put(key, pca);
                }
            }

            if (clientShiftPcaMap.isEmpty()) {
                return;
            }

            List<PreventiveCareAgreement> reloadedClonedPCAs = [
                SELECT Id, FacilityTitle__r.Name, Shift__r.Shift_Full_Name__c,
                    ContractPaymentAgreement.Type__c, Time_Type__c,
                    ContractPaymentAgreement.Provider_Network_Contract__r.Healthcare_Practitioner_Facility__r.Account.Global_Facility_ID__c
                FROM PreventiveCareAgreement
                WHERE Id IN :clonedPCAs
            ];

            List<PreventiveCareAgreement> pcasToUpdate = new List<PreventiveCareAgreement>();
            for (PreventiveCareAgreement clonedPca : reloadedClonedPCAs) {
                try {
                    if (Test.isRunningTest() && adjustShiftRatesInnerException) {
                        throw new CalloutException('test');
                    }
                    if (clonedPca.ContractPaymentAgreement.Type__c == 'Shift' &&
                        clonedPca.Shift__r != null &&
                        clonedPca.FacilityTitle__r != null) {
                        String globalFacilityId = (Test.isRunningTest() && clonedGlobalFacilityId != null)
                            ? clonedGlobalFacilityId
                            : (clonedPca.ContractPaymentAgreement.Provider_Network_Contract__r != null
                                && clonedPca.ContractPaymentAgreement.Provider_Network_Contract__r.Healthcare_Practitioner_Facility__r != null
                                && clonedPca.ContractPaymentAgreement.Provider_Network_Contract__r.Healthcare_Practitioner_Facility__r.Account.Global_Facility_ID__c != null
                                ? String.valueOf(clonedPca.ContractPaymentAgreement.Provider_Network_Contract__r.Healthcare_Practitioner_Facility__r.Account.Global_Facility_ID__c)
                                : '');
                        String key = clonedPca.Shift__r.Shift_Full_Name__c + '_' + globalFacilityId + '_' + clonedPca.FacilityTitle__r.Name + '_' + clonedPca.Time_Type__c;
                        if (clientShiftPcaMap.containsKey(key)) {
                            PreventiveCareAgreement clientPca = clientShiftPcaMap.get(key);
                            PreventiveCareAgreement cloneToUpdate = new PreventiveCareAgreement(
                                Id = clonedPca.Id,
                                Rate__c = clientPca.Rate__c,
                                Unit_of_Measure__c = clientPca.Unit_of_Measure__c
                            );
                            pcasToUpdate.add(cloneToUpdate);
                        }
                    }
                } catch (Exception innerEx) {
                    RateChangeNotificationUtil.logError('Shift PCA mapping failed for PCA ' + clonedPca.Id, null, innerEx);
                }
            }

            if (!pcasToUpdate.isEmpty()) {
                update pcasToUpdate;
            }

        } catch (Exception ex) {
            RateChangeNotificationUtil.logError('ClinicianContractCloneService.adjustShiftRates failed', null, ex);
        }
    }

    /**
     * @description Fetches all createable/updateable fields for records matching the filter.
     * For Contract SObjectType, adds Status = 'Executed' filter.
     */
    private static List<SObject> fetchAllFields(SObjectType sObjectType, Set<Id> filterIds, String filterFieldName) {
        return fetchAllFields(sObjectType, filterIds, filterFieldName, null);
    }

    /**
     * @description Fetches all fields plus optional extra related fields for records matching the filter.
     * For Contract SObjectType, adds Status = 'Executed' and orders by AccountId, StartDate DESC.
     */
    private static List<SObject> fetchAllFields(SObjectType sObjectType, Set<Id> filterIds, String filterFieldName, Set<String> extraFields) {
        if (filterIds == null || filterIds.isEmpty()) {
            return new List<SObject>();
        }

        Map<String, Schema.SObjectField> fieldMap = sObjectType.getDescribe().fields.getMap();
        List<String> fieldNames = new List<String>();
        for (String fName : fieldMap.keySet()) {
            fieldNames.add(fName);
        }

        if (extraFields != null && !extraFields.isEmpty()) {
            fieldNames.addAll(extraFields);
        }

        String query;
        if (sObjectType == Contract.SObjectType) {
            query = 'SELECT ' + String.join(fieldNames, ',') +
                ' FROM ' + sObjectType.getDescribe().getName() +
                ' WHERE ' + filterFieldName + ' IN :filterIds AND Status = \'Executed\'';
            if (extraFields != null && !extraFields.isEmpty()) {
                query += ' ORDER BY AccountId, StartDate DESC';
            }
        } else {
            query = 'SELECT ' + String.join(fieldNames, ',') +
                ' FROM ' + sObjectType.getDescribe().getName() +
                ' WHERE ' + filterFieldName + ' IN :filterIds';
        }

        return Database.query(query);
    }

    /**
     * @description Creates a clone of an SObject, copying all createable/updateable fields except those in excludeFields.
     */
    private static SObject dynamicClone(SObject original, List<String> excludeFields, Map<String, Object> overrideValues) {
        SObject clone = original.getSObjectType().newSObject();
        Map<String, Schema.SObjectField> fieldMap = original.getSObjectType().getDescribe().fields.getMap();

        for (String fieldName : fieldMap.keySet()) {
            Schema.DescribeFieldResult fieldDesc = fieldMap.get(fieldName).getDescribe();
            if (fieldDesc.isCreateable() && fieldDesc.isUpdateable() && !excludeFields.contains(fieldName)) {
                clone.put(fieldName, original.get(fieldName));
            }
        }

        if (overrideValues != null) {
            for (String key : overrideValues.keySet()) {
                clone.put(key, overrideValues.get(key));
            }
        }
        return clone;
    }
}