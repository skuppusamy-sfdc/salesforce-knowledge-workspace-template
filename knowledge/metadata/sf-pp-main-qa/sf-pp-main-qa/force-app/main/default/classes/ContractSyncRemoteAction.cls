global with sharing class ContractSyncRemoteAction implements Callable {
    public Object call(String action, Map<String, Object> args) {
        Map<String, Object> input = (Map<String, Object>) args.get('input');
        Map<String, Object> output = (Map<String, Object>) args.get('output');
        Map<String, Object> options = (Map<String, Object>) args.get('options');
        return invokeMethod(action, input, output, options);
    }

    global Boolean invokeMethod(String methodName, Map<String, Object> inputMap,
                                Map<String, Object> outMap, Map<String, Object> options) {
        Boolean result = true;
        try {
            if ('processContract'.equalsIgnoreCase(methodName)) {
                processContract(inputMap, outMap, options);
            } else {
                result = false;
            }
        } catch (Exception e) {
            result = false;
            outMap.put('error', e.getMessage());
        }

        return result;
    }

    public void processContract(Map<String, Object> inputMap, Map<String, Object> outMap, Map<String, Object> options) {
        String contractId = (String) inputMap.get('ContractId');
        if (String.isBlank(contractId)) {
            outMap.put('error', 'ContractId is missing.');
            return;
        }
        Boolean UpdateRates = true;
        if(inputMap.containsKey('UpdateRates')){
            UpdateRates = Boolean.valueOf(inputMap.get('UpdateRates'));
        }

        List<PreventiveCareAgreement> allRecordsToUpdate = new List<PreventiveCareAgreement>();
        Set<Id> allRecordsToDeleteIdSet = new Set<Id>();
        List<ContractPaymentAgreement> allCpasToUpdate = new List<ContractPaymentAgreement>();

        List<Contract> clinicianContracts = [
            SELECT Id, Last_Synched_Date__c
            FROM Contract
            WHERE Id =: contractId
            LIMIT 1
        ];

        if (clinicianContracts.isEmpty()) {
            return;
        }
        Contract clinicianContract = clinicianContracts[0];

        List<ProviderNetworkContract> providerNetworkContracts = [
            SELECT Id, Name, ContractId, Healthcare_Practitioner_Facility__r.AccountId, Contract.StartDate,
                   Healthcare_Practitioner_Facility__r.Facility_Title__c
            FROM ProviderNetworkContract
            WHERE ContractId = :contractId
        ];

        if (providerNetworkContracts.isEmpty()) {
            return;
        }

        Set<Id> accountIds = new Set<Id>();
        Map<Id, Id> pncIdToAccountIdMap = new Map<Id, Id>();
        Map<Id, String> pncIdToFacilityTitleMap = new Map<Id, String>();

        for (ProviderNetworkContract pnc : providerNetworkContracts) {
            if (pnc.Healthcare_Practitioner_Facility__r.AccountId != null) {
                Id currentAccountId = pnc.Healthcare_Practitioner_Facility__r.AccountId;
                accountIds.add(currentAccountId);
                
                pncIdToAccountIdMap.put(pnc.Id, currentAccountId);
                if (pnc.Healthcare_Practitioner_Facility__r.Facility_Title__c != null) {
                    pncIdToFacilityTitleMap.put(pnc.Id, pnc.Healthcare_Practitioner_Facility__r.Facility_Title__c);
                }
            }
        }
        
        processAllPNCsBulk(
            providerNetworkContracts, 
            clinicianContract.Id, 
            allRecordsToUpdate, 
            allRecordsToDeleteIdSet, 
            allCpasToUpdate,
            accountIds,
            pncIdToAccountIdMap,
            pncIdToFacilityTitleMap
        );
        
        List<PreventiveCareAgreement> allRecordsToDelete = new List<PreventiveCareAgreement>();
        List<PreventiveCareAgreement> recordsNotDeleted = new List<PreventiveCareAgreement>();
        Set<Id> setOfCPA = new Set<Id>();
        List<Rate_Pay_Code__c> allRPCToDelete = new List<Rate_Pay_Code__c>();
        if (!allRecordsToDeleteIdSet.isEmpty()) {
            allRecordsToDelete = [SELECT Id,ContractPaymentAgreementId FROM PreventiveCareAgreement WHERE Id IN :allRecordsToDeleteIdSet];
            allRPCToDelete = [SELECT Id FROM Rate_Pay_Code__c 
                                 WHERE Preventive_Care_Agreement__c IN :allRecordsToDeleteIdSet];
        }

        
        if (!allRecordsToUpdate.isEmpty() && UpdateRates) {
            try {
                update allRecordsToUpdate;
            } catch (DmlException e) {
                System.debug(LoggingLevel.ERROR, 'Error bulk updating Clinician PCA records: ' + e.getMessage());
                ErrorLogUtil.logException(e, 'All Rate Updates', null);
            }
        }
        
        if (!allRecordsToDelete.isEmpty()) {
            try {
                for(PreventiveCareAgreement delPCA : allRecordsToDelete){
                    setOfCPA.add(delPCA.ContractPaymentAgreementId);
                }
                delete allRecordsToDelete;
                if (!allRPCToDelete.isEmpty()) {
                    delete allRPCToDelete;
                }
            } catch (DmlException e) {
                System.debug(LoggingLevel.ERROR, 'Error bulk deleting Clinician PCA records: ' + e.getMessage());
                        ErrorLogUtil.logException(e, 'Required Rate Deletion', null);
            }
        }

        if (!allCpasToUpdate.isEmpty()) {
            try {
                update allCpasToUpdate;
            } catch (DmlException e) {
                System.debug(LoggingLevel.ERROR, 'Error bulk updating CPA Facility_Rate__c: ' + e.getMessage());
                		ErrorLogUtil.logException(e, 'Required CPA Updation', null);
            }
        }

        recordsNotDeleted = [SELECT Id,ContractPaymentAgreementId FROM PreventiveCareAgreement WHERE ContractPaymentAgreementId IN :setOfCPA];
        if(!recordsNotDeleted.isEmpty()){
            for(PreventiveCareAgreement rndPCA : recordsNotDeleted){
                setOfCPA.remove(rndPCA.ContractPaymentAgreementId);
            }
        }
        
        DateTime currentDate = System.NOW();
        clinicianContract.Last_Synched_Date__c = currentDate;

        try {
            update clinicianContract;
        } catch (DmlException e) {
            System.debug(LoggingLevel.ERROR, 'Error updating clinician contract Last_Synched_Date__c: ' + e.getMessage());
            ErrorLogUtil.logException(e, 'Required Clinician Contract Updation', null);
        }

        outMap.put('Date', currentDate);
        
        try {
            if(!setOfCPA.isEmpty()){
                delete [SELECT Id from ContractPaymentAgreement Where Id IN:setOfCPA];
            }
        } catch (DmlException e) {
            System.debug(LoggingLevel.ERROR, 'Error deleting CPA' + e.getMessage());
            ErrorLogUtil.logException(e, 'Required CPA Deletion', null);
        }
    }  
    
private void processAllPNCsBulk(
        List<ProviderNetworkContract> providerNetworkContracts,
        Id clinicianContractId, 
        List<PreventiveCareAgreement> recordsToUpdate, 
        Set<Id> recordsToDeleteIdSet, 
        List<ContractPaymentAgreement> cpasToUpdate,
        Set<Id> accountIds,
        Map<Id, Id> pncIdToAccountIdMap,
        Map<Id, String> pncIdToFacilityTitleMap
    ) {
        Set<String> agreementTypes = new Set<String>{'Stipend', 'Shift', 'Variable', 'Target', 'Leadership Incentives'};
        Set<Id> pncIds = pncIdToAccountIdMap.keySet();
        
        Map<Id, PreventiveCareAgreement> pcaUpdatesMap = new Map<Id, PreventiveCareAgreement>(); 
        
        // 1. Fetch ALL candidate PO Contracts for the relevant accounts.
        List<Contract> poContracts = [
            SELECT Id, AccountId, StartDate
            FROM Contract
            WHERE AccountId IN :accountIds
            AND (Status = 'Executed' OR Status = 'Superseded')
            AND RecordType.DeveloperName = 'Client'
            ORDER By StartDate DESC 
        ];
        
        // Map to hold the single best PO Contract ID for each PNC.
        Map<Id, Id> pncIdToBestPoContractId = new Map<Id, Id>();

        // Map to hold the po contract objects by account for efficient lookup
        Map<Id, List<Contract>> poContractsByAccountId = new Map<Id, List<Contract>>();
        for(Contract c : poContracts) {
            if (!poContractsByAccountId.containsKey(c.AccountId)) {
                poContractsByAccountId.put(c.AccountId, new List<Contract>());
            }
            poContractsByAccountId.get(c.AccountId).add(c);
        }

        // Determine the single best PO Contract (most recent valid StartDate) for EACH PNC
        Set<Id> finalPoContractIds = new Set<Id>();
        for (ProviderNetworkContract pnc : providerNetworkContracts) {
            Id currentAccountId = pncIdToAccountIdMap.get(pnc.Id);
            Date contractStartDateThreshold = pnc.Contract.StartDate;
            Id bestPoContractId = null;

            if (currentAccountId != null && poContractsByAccountId.containsKey(currentAccountId) && contractStartDateThreshold != null) {
                // List is sorted DESC by StartDate, so the first match is the best.
                for (Contract c : poContractsByAccountId.get(currentAccountId)) {
                    if (c.StartDate <= contractStartDateThreshold) {
                        bestPoContractId = c.Id;
                        break; 
                    }
                }
            }
            
            if (bestPoContractId != null) {
                pncIdToBestPoContractId.put(pnc.Id, bestPoContractId);
                finalPoContractIds.add(bestPoContractId);
            }
        }
        
        if (finalPoContractIds.isEmpty()) {
            return;
        }

        // 2. Fetch PO Contract Payment Agreements (CPA) (BULK)
        List<ContractPaymentAgreement> allPoCpas = [
            SELECT Id, ContractId, Type__c
            FROM ContractPaymentAgreement
            WHERE ContractId IN :finalPoContractIds
            AND Type__c IN :agreementTypes
        ];
        
        Map<Id, List<ContractPaymentAgreement>> poCpasByContractId = new Map<Id, List<ContractPaymentAgreement>>();
        Set<Id> allPoCpaIds = new Set<Id>();
        for (ContractPaymentAgreement poCpa : allPoCpas) {
            if (!poCpasByContractId.containsKey(poCpa.ContractId)) {
                poCpasByContractId.put(poCpa.ContractId, new List<ContractPaymentAgreement>());
            }
            poCpasByContractId.get(poCpa.ContractId).add(poCpa);
            allPoCpaIds.add(poCpa.Id);
        }
        
        // 3. Fetch PO Preventive Care Agreements (PCA) (BULK)
        List<PreventiveCareAgreement> allPoAgreements = [
            SELECT Id, ContractPaymentAgreementId, ContractPaymentAgreement.Type__c, Type__c, Is_Deleted__c,
                   Rate__c, Shift__r.Shift_Full_Name__c, Shift__c, Shift__r.Type__c, FacilityTitle__c,ContractPaymentAgreement.Account__c,
                   Unit_of_Measure__c,Time_Type__c, Facility_Rate__c 
            FROM PreventiveCareAgreement
            WHERE ContractPaymentAgreementId IN :allPoCpaIds
            AND FacilityTitle__c IN :pncIdToFacilityTitleMap.values()
        ];

        Map<String, Map<String, Decimal>> shiftActiveRatesByFacility = new Map<String, Map<String, Decimal>>();
        Map<String, Map<String, Decimal>> otherTypeActiveRatesByFacility = new Map<String, Map<String, Decimal>>();
        
        // Maps to hold the matching PO PCA ID (NEW LOGIC)
        Map<String, Map<String, Id>> poShiftPcaMap = new Map<String, Map<String, Id>>();
        Map<String, Map<String, Id>> poOtherTypePcaMap = new Map<String, Map<String, Id>>();


        for (PreventiveCareAgreement poPca : allPoAgreements) {
            if (poPca.Is_Deleted__c || poPca.Rate__c == null || String.isBlank(poPca.FacilityTitle__c)) {
                continue;
            }

            String facilityTitle = poPca.FacilityTitle__c;
            String agreementType = poPca.ContractPaymentAgreement.Type__c;

            if ('Shift'.equalsIgnoreCase(agreementType)) {
                if (!shiftActiveRatesByFacility.containsKey(facilityTitle)) {
                    shiftActiveRatesByFacility.put(facilityTitle, new Map<String, Decimal>());
                    poShiftPcaMap.put(facilityTitle, new Map<String, Id>()); 
                }
                
                String shiftKey = '';
                if (poPca.Shift__c != null && poPca.Shift__r != null && poPca.Shift__r.Shift_Full_Name__c != null) {
                    shiftKey = poPca.Shift__r.Shift_Full_Name__c + '-' + poPca.Shift__r.Type__c + poPca.ContractPaymentAgreement.Account__c + poPca.Unit_of_Measure__c + poPca.Time_Type__c;
                } else {
                    continue; 
                }
                
                // Rate logic (Max Rate check)
                Map<String, Decimal> shiftActiveRates = shiftActiveRatesByFacility.get(facilityTitle);
                Decimal currentMaxRate = shiftActiveRates.containsKey(shiftKey) ? shiftActiveRates.get(shiftKey) : 0;
                if (poPca.Rate__c > currentMaxRate) {
                    shiftActiveRates.put(shiftKey, poPca.Rate__c);
                }

                // Store the PO PCA ID for lookup (This is safe because we use the max rate logic above)
                poShiftPcaMap.get(facilityTitle).put(shiftKey, poPca.Id);

            } else {
                if (!otherTypeActiveRatesByFacility.containsKey(facilityTitle)) {
                    otherTypeActiveRatesByFacility.put(facilityTitle, new Map<String, Decimal>());
                    poOtherTypePcaMap.put(facilityTitle, new Map<String, Id>()); 
                }
                
                String otherTypeKey = poPca.ContractPaymentAgreement.Type__c + poPca.ContractPaymentAgreement.Account__c + poPca.Type__c + poPca.Unit_of_Measure__c;
                if (String.isBlank(otherTypeKey)) {continue;}
                
                // Rate logic (Max Rate check)
                Map<String, Decimal> otherTypeActiveRates = otherTypeActiveRatesByFacility.get(facilityTitle);
                Decimal currentMaxRate = otherTypeActiveRates.containsKey(otherTypeKey) ? otherTypeActiveRates.get(otherTypeKey) : 0;
                if (poPca.Rate__c > currentMaxRate) {
                    otherTypeActiveRates.put(otherTypeKey, poPca.Rate__c);
                }

                // Store the PO PCA ID for lookup
                poOtherTypePcaMap.get(facilityTitle).put(otherTypeKey, poPca.Id);
            }
        }

        // 4. Fetch Clinician Contract Payment Agreements (CPA) (BULK)
        List<ContractPaymentAgreement> allClinicianCpas = [
            SELECT Id, Type__c, Facility_Rate__c, Provider_Network_Contract__c 
            FROM ContractPaymentAgreement
            WHERE ContractId =: clinicianContractId
            AND Type__c IN :agreementTypes
            AND Provider_Network_Contract__c IN :pncIds
        ];
        Map<Id, List<ContractPaymentAgreement>> clinicianCpasByPncId = new Map<Id, List<ContractPaymentAgreement>>();
        Set<Id> allClinicianCpaIds = new Set<Id>();
        for(ContractPaymentAgreement cpa : allClinicianCpas) {
            if (cpa.Provider_Network_Contract__c != null) {
                if (!clinicianCpasByPncId.containsKey(cpa.Provider_Network_Contract__c)) {
                     clinicianCpasByPncId.put(cpa.Provider_Network_Contract__c, new List<ContractPaymentAgreement>());
                }
                clinicianCpasByPncId.get(cpa.Provider_Network_Contract__c).add(cpa);
                allClinicianCpaIds.add(cpa.Id);
            }
        }
        
        // 5. Fetch Clinician Preventive Care Agreements (PCA) (BULK)
        List<PreventiveCareAgreement> allClinicianPcas = [
            SELECT Id, ContractPaymentAgreementId,ContractPaymentAgreement.Provider_Network_Contract__r.Healthcare_Practitioner_Facility__r.AccountId, ContractPaymentAgreement.Type__c,
            Type__c, Rate__c, Shift__r.Shift_Full_Name__c, Shift__c, Shift__r.Type__c,Unit_of_Measure__c,Time_Type__c, Facility_Rate__c 
            FROM PreventiveCareAgreement
            WHERE ContractPaymentAgreementId IN :allClinicianCpaIds
        ];
        Map<Id, List<PreventiveCareAgreement>> clinicianPcasByCpaId = new Map<Id, List<PreventiveCareAgreement>>();
        for(PreventiveCareAgreement pca : allClinicianPcas) {
            if (pca.ContractPaymentAgreementId != null) {
                if (!clinicianPcasByCpaId.containsKey(pca.ContractPaymentAgreementId)) {
                     clinicianPcasByCpaId.put(pca.ContractPaymentAgreementId, new List<PreventiveCareAgreement>());
                }
                clinicianPcasByCpaId.get(pca.ContractPaymentAgreementId).add(pca);
            }
        }
        
        // 6. Iterate and Process
        for (ProviderNetworkContract pnc : providerNetworkContracts) {
            Id poContractId = pncIdToBestPoContractId.get(pnc.Id);
            String currentFacilityTitle = pncIdToFacilityTitleMap.get(pnc.Id);
            
            if (poContractId == null || String.isBlank(currentFacilityTitle)) {
                 continue;
            }
            
            Map<String, ContractPaymentAgreement> poCpaMapByType = new Map<String, ContractPaymentAgreement>();
            if (poCpasByContractId.containsKey(poContractId)) {
                for (ContractPaymentAgreement poCpa : poCpasByContractId.get(poContractId)) {
                    if (poCpa.Type__c != null) {
                        poCpaMapByType.put(poCpa.Type__c, poCpa);
                    }
                }
            }
            
            Map<String, Decimal> currentShiftActiveRates = shiftActiveRatesByFacility.get(currentFacilityTitle);
            Map<String, Decimal> currentOtherTypeActiveRates = otherTypeActiveRatesByFacility.get(currentFacilityTitle);
            
            Map<String, Id> currentPoShiftPcaIdMap = poShiftPcaMap.get(currentFacilityTitle);
            Map<String, Id> currentPoOtherTypePcaIdMap = poOtherTypePcaMap.get(currentFacilityTitle);
            
            List<ContractPaymentAgreement> clinicianCpas = clinicianCpasByPncId.get(pnc.Id);
            if (clinicianCpas == null) {
                continue;
            }
            
            for (ContractPaymentAgreement clinicianCpa : clinicianCpas) {
                
                List<PreventiveCareAgreement> clinicianPcas = clinicianPcasByCpaId.get(clinicianCpa.Id);
                if (clinicianPcas != null) {
                    
                    for (PreventiveCareAgreement clinicianAgreement : clinicianPcas) {
                        String cpaType = clinicianAgreement.ContractPaymentAgreement.Type__c;
                        Id matchingPoPcaId = null; 
                        Boolean shouldUpdateRate = false;
                        Decimal practiceRate;

                        if ('Shift'.equalsIgnoreCase(cpaType)) {
                            
                            String shiftKey = '';
                            if (clinicianAgreement.Shift__c != null && clinicianAgreement.Shift__r != null && clinicianAgreement.Shift__r.Shift_Full_Name__c != null) {
                                shiftKey = clinicianAgreement.Shift__r.Shift_Full_Name__c + '-' + clinicianAgreement.Shift__r.Type__c +  clinicianAgreement.ContractPaymentAgreement.Provider_Network_Contract__r.Healthcare_Practitioner_Facility__r.AccountId + clinicianAgreement.Unit_of_Measure__c + clinicianAgreement.Time_Type__c;
                            }
                            
                            // Check for deletion/inactivity
                            if (String.isBlank(shiftKey) || currentShiftActiveRates == null || !currentShiftActiveRates.containsKey(shiftKey)) {
                                recordsToDeleteIdSet.add(clinicianAgreement.Id);
                                continue;
                            }

                            // Rate Update Check (existing)
                            practiceRate = currentShiftActiveRates.get(shiftKey);
                            if (practiceRate > clinicianAgreement.Rate__c) {
                                shouldUpdateRate = true;
                            }
                            
                            // Get the matching PO PCA Id (NEW LOGIC)
                            if (currentPoShiftPcaIdMap != null && currentPoShiftPcaIdMap.containsKey(shiftKey)) {
                                matchingPoPcaId = currentPoShiftPcaIdMap.get(shiftKey);
                            }

                        } else {
                            
                            String otherTypeKey = clinicianAgreement.ContractPaymentAgreement.Type__c + clinicianAgreement.ContractPaymentAgreement.Provider_Network_Contract__r.Healthcare_Practitioner_Facility__r.AccountId + clinicianAgreement.Type__c
                            + clinicianAgreement.Unit_of_Measure__c;

                            // Check for deletion/inactivity
                            if (String.isBlank(otherTypeKey) || currentOtherTypeActiveRates == null || !currentOtherTypeActiveRates.containsKey(otherTypeKey)) {
                                recordsToDeleteIdSet.add(clinicianAgreement.Id);
                                continue;
                            }

                            // Rate Update Check (existing)
                            practiceRate = currentOtherTypeActiveRates.get(otherTypeKey);
                            if (practiceRate > clinicianAgreement.Rate__c) {
                                shouldUpdateRate = true;
                            }
                            
                            // Get the matching PO PCA Id (NEW LOGIC)
                            if (currentPoOtherTypePcaIdMap != null && currentPoOtherTypePcaIdMap.containsKey(otherTypeKey)) {
                                matchingPoPcaId = currentPoOtherTypePcaIdMap.get(otherTypeKey);
                            }
                        }
                        
                        // **BULKIFIED UPDATE LOGIC (Using Map)**
                        Boolean needsUpdate = shouldUpdateRate || 
                                              (matchingPoPcaId != null && clinicianAgreement.Facility_Rate__c != matchingPoPcaId);

                        if (needsUpdate) {
                            // Get the record from the map (or create a new placeholder)
                            PreventiveCareAgreement pcaToUpdate = pcaUpdatesMap.get(clinicianAgreement.Id);
                            if (pcaToUpdate == null) {
                                pcaToUpdate = new PreventiveCareAgreement(Id = clinicianAgreement.Id);
                                pcaUpdatesMap.put(clinicianAgreement.Id, pcaToUpdate);
                            }
                            
                            // 1. Update Rate__c if necessary
                            if (shouldUpdateRate) {
                                pcaToUpdate.Rate__c = practiceRate;
                            }
                            
                            // 2. Update Facility_Rate__c if necessary (always update if different)
                            if (matchingPoPcaId != null && clinicianAgreement.Facility_Rate__c != matchingPoPcaId) {
                                pcaToUpdate.Facility_Rate__c = matchingPoPcaId;
                            }
                        }
                    }
                }
                
                // 7. Update Clinician ContractPaymentAgreement.Facility_Rate__c (existing logic)
                if (clinicianCpa.Type__c != null && poCpaMapByType.containsKey(clinicianCpa.Type__c)) {
                    Id originalPOCPAId = poCpaMapByType.get(clinicianCpa.Type__c).Id;
                    
                    if (clinicianCpa.Facility_Rate__c != originalPOCPAId) {
                        cpasToUpdate.add(new ContractPaymentAgreement(Id = clinicianCpa.Id, Facility_Rate__c = originalPOCPAId));
                    }
                }
            }
        }
        
        // Final step: Add all collected updates from the map back to the list passed by reference.
        recordsToUpdate.addAll(pcaUpdatesMap.values());
    }
}