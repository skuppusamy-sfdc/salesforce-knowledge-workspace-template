/***************************************************************************************************************************
* Class Name    : ClinicianContractSyncService
* Description   : Reusable service that synchronizes Clinician Contracts based on Practice Operations contract updates.
*                 Compares shift rates between PO and Clinician contracts, updates CCM records, and creates tasks
*                 when manual intervention is needed. Can be called from Queueable, Batch, or other contexts.
* Author        : Abhinav Mishra
* Created Date  : 2026-03-02
* Last Modified : 2026-04-20
***************************************************************************************************************************/
public with sharing class ClinicianContractSyncService {

    // Constants
    private static final String SHIFT_TYPE = 'Shift';
    private static final String CLINICIAN_RECORD_TYPE = 'Clinician';
    private static final String PROCESS_TYPE_AUTOMATION = 'Automation';
    private static final String PROCESS_TYPE_MANUAL = 'Manual';
    private static final String PROCESS_TYPE_AGENT = 'Agent';
    private static final String CCM_STATUS_CANCELED = 'Canceled';
    private static final String CCM_STATUS_NEW = 'New';
    private static final String CLINICIAN_CONTRACT_STATUS_EXECUTED = 'Executed';
    private static final String CCM_CANCELED_REASON_FIELD = 'Canceled_Reason__c';
    private static final String CCM_CANCELED_REASON_NO_EXECUTED_CONTRACT = 'No Executed Contract';
    private static final String CCM_CANCELED_REASON_MISSING_UPDATED_RATES = 'Clinician’s executed contract does not contain the rate(s) that have been updated.';
    private static final Set<String> CLINICIAN_CONTRACT_VALID_STATUSES = new Set<String>{
        'Draft', 'Submitted', 'Approved', 'Executed', 'Contracting - In Progress'
    };
    private static final String TASK_SUBJECT = 'New Clinician Contract Needed - Coverage Change';
    private static final String TASK_COMMENTS = 'Review clinician rate for coverage only change. This clinician has rates that are different from other rates with the same type. If an adjustment is needed, request a new clinician contract record.';
    private static final String TEAM_ROLE_CE_SPECIALIST = 'Clinician Experience Specialist';

    // Error messages
    private static final String CCM_UPDATE_ERROR = 'Error updating Client Change Management records: ';

    // Populated by getClinicianContractShifts - ContractId to ContractNumber for Clinician Contracts
    @TestVisible
    private Map<Id, String> contractIdToContractNumberMap = new Map<Id, String>();

    // Test seam: keep production behavior as Executed-only, while allowing tests to avoid contract status transitions.
    @TestVisible
    private static Set<String> AGENT_CLINICIAN_CONTRACT_STATUSES = new Set<String>{ CLINICIAN_CONTRACT_STATUS_EXECUTED };

    /**
     * Main entry point - synchronizes Clinician Contracts based on Practice Operations contract updates.
     * Call this method from Queueable, Batch, or any other context.
     *
     * @param contractIds List of Practice Operations Contract IDs to process
     */
    public void syncClinicianContracts(List<Id> contractIds) {
        List<Id> ids = contractIds != null ? contractIds : new List<Id>();
        if (ids.isEmpty()) {
            return;
        }

        // New, separate CCM Agent logic path.
        processAgentCcmRecords(ids);

        // Step 1: Get PO Contract Data - Map<ContractId, Map<ShiftType, Set<Rates>>>
        Map<Id, Map<String, Set<Decimal>>> mapPoContractIdWithShiftTypes = getPOContractShiftData(ids);

        if (mapPoContractIdWithShiftTypes.isEmpty()) {
            return;
        }

        // Extract all unique shift types from PO contracts
        Set<String> allShiftTypes = new Set<String>();
        for (Map<String, Set<Decimal>> shiftTypeMap : mapPoContractIdWithShiftTypes.values()) {
            allShiftTypes.addAll(shiftTypeMap.keySet());
        }

        if (allShiftTypes.isEmpty()) {
            return;
        }

        // Step 2: Get Clinician Contract Data - CCM records with Process_Type = Automation
        List<Client_Change_Management__c> ccmRecords = getClinicianContractData(ids);
        if (ccmRecords.isEmpty()) {
            return;
        }

        // Step 3: Create Map<ContractId, List<CCM>>
        Map<Id, List<Client_Change_Management__c>> contractIdWithCCMMap = new Map<Id, List<Client_Change_Management__c>>();
        Set<Id> practitionerIds = new Set<Id>();
        Map<Id, Id> practitionerIdWithAccountId = new Map<Id, Id>();
        Set<Id> setClinicianAccountIds = new Set<Id>();
        Set<Id> hpfIdsFromCCM = new Set<Id>();

        for (Client_Change_Management__c ccm : ccmRecords) {
            Id contractId = ccm.Contract__c;
            Id practitionerId = ccm.Healthcare_Practitioner_Facility__r.PractitionerId;
            Id accountId = ccm.Healthcare_Practitioner_Facility__r.Practitioner.AccountId;
            Id hpfId = ccm.Healthcare_Practitioner_Facility__c;

            if (contractId == null || practitionerId == null || accountId == null) {
                continue;
            }

            // Build contractIdWithCCMMap
            if (!contractIdWithCCMMap.containsKey(contractId)) {
                contractIdWithCCMMap.put(contractId, new List<Client_Change_Management__c>());
            }
            contractIdWithCCMMap.get(contractId).add(ccm);

            // Build practitionerIdWithAccountId map
            practitionerIds.add(practitionerId);
            practitionerIdWithAccountId.put(practitionerId, accountId);
            setClinicianAccountIds.add(accountId);
            if (hpfId != null) {
                hpfIdsFromCCM.add(hpfId);
            }
        }

        if (practitionerIds.isEmpty() || setClinicianAccountIds.isEmpty()) {
            return;
        }

        // Step 4: Get Clinician PreventiveCareAgreement shifts (all shift types - no filter)
        // Map<HPFId, Map<ContractId, Map<ShiftType, Set<Rates>>>> - per-contract rates for multi-contract HPFs
        Map<Id, Map<Id, Map<String, Set<Decimal>>>> mapOfHPFToContractShiftRates = getClinicianContractShifts(setClinicianAccountIds, null, hpfIdsFromCCM);
        // Step 5: Bulk query all clinician names
        Map<Id, String> practitionerToNameMap = getClinicianNamesBulk(practitionerIds);
        // Step 6: Compare shifts and rates, update CCM records
        List<Client_Change_Management__c> ccmToUpdate = new List<Client_Change_Management__c>();
        Map<Id, Id> ccmToAccountMap = new Map<Id, Id>();
        Map<Id, String> ccmToClinicianNameMap = new Map<Id, String>();
        Map<Id, String> ccmToContractNumbersMap = new Map<Id, String>();
        List<Task> tasksToInsert = new List<Task>();

        // Iterate through each PO Contract
        for (Id poContractId : mapPoContractIdWithShiftTypes.keySet()) {
            Map<String, Set<Decimal>> poShiftRates = mapPoContractIdWithShiftTypes.get(poContractId);
            List<Client_Change_Management__c> ccmList = contractIdWithCCMMap.get(poContractId);

            if (ccmList == null || ccmList.isEmpty()) {
                continue;
            }
            // Iterate through all CCM records for this contract
            for (Client_Change_Management__c ccm : ccmList) {
                Id practitionerId = ccm.Healthcare_Practitioner_Facility__r.PractitionerId;
                Id accountId = practitionerIdWithAccountId.get(practitionerId);
                Id hpfId = ccm.Healthcare_Practitioner_Facility__c;

                if (accountId == null) {
                    continue;
                }

                // Get all Clinician Contracts for this HPF (may have multiple contracts per HPF)
                Map<Id, Map<String, Set<Decimal>>> contractsForHPF = mapOfHPFToContractShiftRates.get(hpfId);
                if (contractsForHPF == null) {
                    contractsForHPF = new Map<Id, Map<String, Set<Decimal>>>();
                }

                // Merge all shift types across contracts to check if clinician has at least one PO shift type
                Set<String> allShiftTypesForHPF = new Set<String>();
                for (Map<String, Set<Decimal>> contractRates : contractsForHPF.values()) {
                    if (contractRates != null) {
                        allShiftTypesForHPF.addAll(contractRates.keySet());
                    }
                }

                // Check if Clinician has shifts for AT LEAST ONE Type from PO Contract (across any contract)
                Boolean hasAtLeastOneType = false;
                for (String shiftType : poShiftRates.keySet()) {
                    if (allShiftTypesForHPF.contains(shiftType)) {
                        hasAtLeastOneType = true;
                        break;
                    }
                }

                if (!hasAtLeastOneType) {
                    // NO shift types available in Clinician Contract - set Status to Canceled
                    ccm.Status__c = CCM_STATUS_CANCELED;
                    ccmToUpdate.add(ccm);
                    continue;
                }

                // Only compare shift types that clinician HAS - ignore PO shift types clinician doesn't have (e.g., Night)
                // Manual when: ANY contract has mixed rates for a shift category AND PO has new shift for that category
                // Automation when: ALL contracts have same rates across shift (per category)
                Boolean needsManualProcessing = false;

                // Build PO categories that have newly added shifts (PO map only contains Existing_Shift_Type_Added__c = TRUE)
                Set<String> poCategoriesWithNewShifts = new Set<String>();
                for (String shiftType : poShiftRates.keySet()) {
                    poCategoriesWithNewShifts.add(getShiftCategory(shiftType));
                }

                // For EACH contract for this HPF: check if it has mixed rates in any category
                for (Map<String, Set<Decimal>> clinicianShiftRates : contractsForHPF.values()) {
                    if (clinicianShiftRates == null || clinicianShiftRates.isEmpty()) {
                        continue;
                    }
                    // Build clinician rates by category for this contract
                    Map<String, Set<Decimal>> clinicianRatesByCategory = new Map<String, Set<Decimal>>();
                    for (String shiftType : clinicianShiftRates.keySet()) {
                        Set<Decimal> rates = clinicianShiftRates.get(shiftType);
                        if (rates == null || rates.isEmpty()) {
                            continue;
                        }
                        String category = getShiftCategory(shiftType);
                        if (!clinicianRatesByCategory.containsKey(category)) {
                            clinicianRatesByCategory.put(category, new Set<Decimal>());
                        }
                        clinicianRatesByCategory.get(category).addAll(rates);
                    }
                    // For each category: Manual if (mixed rates in this contract) AND (PO has new shift for that category)
                    for (String category : clinicianRatesByCategory.keySet()) {
                        Set<Decimal> clinicianRatesForCategory = clinicianRatesByCategory.get(category);
                        Boolean clinicianHasMixedRates = clinicianRatesForCategory != null && clinicianRatesForCategory.size() > 1;
                        Boolean poHasNewShiftForCategory = poCategoriesWithNewShifts.contains(category);
                        if (clinicianHasMixedRates && poHasNewShiftForCategory) {
                            needsManualProcessing = true;
                            break;
                        }
                    }
                    if (needsManualProcessing) {
                        break;
                    }
                }
                // If needsManualProcessing is true, update CCM to Manual and create Task
                // If needsManualProcessing is false (all Types passed), do nothing (skip record)
                if (needsManualProcessing) {
                    ccm.Process_Type__c = PROCESS_TYPE_MANUAL;
                    ccmToUpdate.add(ccm);

                    // Prepare task creation data using bulk queried names
                    String clinicianName = practitionerToNameMap.containsKey(practitionerId)
                        ? practitionerToNameMap.get(practitionerId)
                        : 'Unknown Clinician';

                    ccmToAccountMap.put(ccm.Id, ccm.Contract__r.AccountId);
                    ccmToClinicianNameMap.put(ccm.Id, clinicianName);
                    // Build comma-separated Clinician Contract Numbers for this HPF
                    List<String> contractNumbers = new List<String>();
                    for (Id clinicianContractId : contractsForHPF.keySet()) {
                        String cn = contractIdToContractNumberMap.get(clinicianContractId);
                        if (String.isNotBlank(cn)) {
                            contractNumbers.add(cn);
                        }
                    }
                    ccmToContractNumbersMap.put(ccm.Id, String.join(contractNumbers, ', '));
                }
                // Else: Do Nothing - skip this CCM record (no update, no task creation)
            }
        }
        // Step 7: Update CCM records
        if (!ccmToUpdate.isEmpty()) {
            updateCCMRecords(ccmToUpdate);
        }

        // Step 8: Create tasks for Manual path CCM records (reuse Contract__r.OwnerId from CCM query)
        if (!ccmToAccountMap.isEmpty()) {
            Map<Id, Id> contractToOwnerMap = buildContractToOwnerMapFromCCM(ccmToUpdate);
            createTasks(ccmToUpdate, ccmToAccountMap, ccmToClinicianNameMap, ccmToContractNumbersMap, contractToOwnerMap, tasksToInsert);
        }
    }

    /**
     * Separate Agent CCM flow:
     * - Process_Type__c = Agent and Status__c = New
     * - PO rates that triggered Agent are Existing_Rate_Increased__c = TRUE
     * - Compare only against Executed clinician contracts
     */
    private void processAgentCcmRecords(List<Id> contractIds) {
        List<Client_Change_Management__c> agentCcmRecords = getAgentCcmData(contractIds);
        if (agentCcmRecords.isEmpty()) {
            return;
        }

        Set<Id> poContractIds = new Set<Id>();
        Set<Id> clinicianAccountIds = new Set<Id>();
        Set<Id> hpfIds = new Set<Id>();
        for (Client_Change_Management__c ccm : agentCcmRecords) {
            if (ccm.Contract__c != null) {
                poContractIds.add(ccm.Contract__c);
            }
            if (ccm.Healthcare_Practitioner_Facility__r?.Practitioner?.AccountId != null) {
                clinicianAccountIds.add(ccm.Healthcare_Practitioner_Facility__r.Practitioner.AccountId);
            }
            if (ccm.Healthcare_Practitioner_Facility__c != null) {
                hpfIds.add(ccm.Healthcare_Practitioner_Facility__c);
            }
        }

        Map<Id, Map<String, Set<Decimal>>> poUpdatedRateShiftData = getPOUpdatedRateShiftData(poContractIds);

        // PNC-level check: which HPFs have ANY Executed Clinician Contract at all,
        // even if that contract has no CPA or PCA records.
        Set<Id> hpfsWithAnyExecutedContract = getHpfsWithExecutedContractViaPNC(clinicianAccountIds, hpfIds);
        Map<Id, Map<Id, Map<String, Set<Decimal>>>> executedClinicianRatesByHpf =
            getExecutedClinicianContractShifts(clinicianAccountIds, hpfIds);

        List<Client_Change_Management__c> ccmToUpdate = new List<Client_Change_Management__c>();
        for (Client_Change_Management__c ccm : agentCcmRecords) {
            if (ccm.Contract__c == null || ccm.Healthcare_Practitioner_Facility__c == null) {
                continue;
            }

            Map<String, Set<Decimal>> expectedShiftRates = poUpdatedRateShiftData.get(ccm.Contract__c);
            if (expectedShiftRates == null || expectedShiftRates.isEmpty()) {
                continue;
            }

            Id hpfId = ccm.Healthcare_Practitioner_Facility__c;

            // No Executed Clinician Contract linked to this HPF via PNC at all
            if (!hpfsWithAnyExecutedContract.contains(hpfId)) {
                ccm.Status__c = CCM_STATUS_CANCELED;
                setCcmCanceledReason(ccm, CCM_CANCELED_REASON_NO_EXECUTED_CONTRACT);
                ccmToUpdate.add(ccm);
                continue;
            }

            Map<Id, Map<String, Set<Decimal>>> executedContractsForHpf =
                executedClinicianRatesByHpf.get(hpfId);

            // Executed contract exists (confirmed via PNC) but has no Shift-type CPA / PCA rate records
            if (executedContractsForHpf == null || executedContractsForHpf.isEmpty()) {
                ccm.Status__c = CCM_STATUS_CANCELED;
                setCcmCanceledReason(ccm, CCM_CANCELED_REASON_MISSING_UPDATED_RATES);
                ccmToUpdate.add(ccm);
                continue;
            }
        
            // NEW LOGIC: Check if ALL expected shift types exist across executed contracts
            Boolean allShiftTypesPresent = true;
        
            for (String shiftType : expectedShiftRates.keySet()) {
                Boolean currentShiftTypeFound = false;
                
                // Check across all executed contracts for this specific shift type
                for (Map<String, Set<Decimal>> contractShiftRates : executedContractsForHpf.values()) {
                    if (contractShiftRates != null && contractShiftRates.containsKey(shiftType)) {
                        currentShiftTypeFound = true;
                        break; // Found this shift type, move to the next expected one
                    }
                }
        
                // If even ONE expected shift type is not found in any contract, fail the whole record
                if (!currentShiftTypeFound) {
                    allShiftTypesPresent = false;
                    break; 
                }
            }
        
            if (!allShiftTypesPresent) {
                ccm.Status__c = CCM_STATUS_CANCELED;
                
                setCcmCanceledReason(ccm, CCM_CANCELED_REASON_MISSING_UPDATED_RATES); 
                ccmToUpdate.add(ccm);
            }
        }

        if (!ccmToUpdate.isEmpty()) {
            updateCCMRecords(ccmToUpdate);
        }
    }

    /**
     * Extracts shift category from shift name (e.g., "Day1" -> "Day", "Round2" -> "Round").
     * Used to group shift types for rate comparison.
     */
    private static String getShiftCategory(String shiftName) {
        if (String.isBlank(shiftName)) {
            return shiftName;
        }
        String category = shiftName.replaceAll('\\d+$', '');
        return String.isNotBlank(category) ? category : shiftName;
    }

    /**
     * Gets PO Contract Data - queries PCA records with new shift types added.
     *
     * @param contractIds List of Practice Operations Contract IDs
     * @return Map<ContractId, Map<ShiftType, Set<Rates>>>
     *         Example: 001 => Day => [100, 100], Night => [200, 200]
     */
    private Map<Id, Map<String, Set<Decimal>>> getPOContractShiftData(List<Id> contractIds) {
        Map<Id, Map<String, Set<Decimal>>> mapPoContractIdWithShiftTypes = new Map<Id, Map<String, Set<Decimal>>>();

        for (PreventiveCareAgreement pca : [
            SELECT Id,
            ContractPaymentAgreement.ContractId,
            Shift__r.Shift_Name__r.Name,
            Rate__c
            FROM PreventiveCareAgreement
            WHERE ContractPaymentAgreement.ContractId IN :contractIds
            AND ContractPaymentAgreement.Type__c = :SHIFT_TYPE
            AND Cloned_From__c = NULL
            AND Existing_Rate_Increased__c = FALSE
            AND Existing_Rate_Decreased__c = FALSE
            AND Existing_Shift_Type_Added__c = TRUE
            AND Shift__r.Shift_Name__c != NULL
            AND Rate__c != NULL
        ]) {
            Id contractId = pca.ContractPaymentAgreement.ContractId;
            if (contractId == null) {
                continue;
            }

            // Use Name only
            String shiftName = pca.Shift__r.Shift_Name__r.Name;

            if (String.isBlank(shiftName)) {
                continue;
            }

            // Initialize contract map if needed
            if (!mapPoContractIdWithShiftTypes.containsKey(contractId)) {
                mapPoContractIdWithShiftTypes.put(contractId, new Map<String, Set<Decimal>>());
            }

            Map<String, Set<Decimal>> shiftTypeMap = mapPoContractIdWithShiftTypes.get(contractId);

            // Initialize shift type set if needed
            if (!shiftTypeMap.containsKey(shiftName)) {
                shiftTypeMap.put(shiftName, new Set<Decimal>());
            }

            // Add rate (Rate__c guaranteed non-null by SOQL filter)
            shiftTypeMap.get(shiftName).add(pca.Rate__c);
        }
        return mapPoContractIdWithShiftTypes;
    }

    /**
     * Gets PO Contract Data for Agent flow - updated rates that triggered Agent.
     * Existing_Rate_Increased__c = TRUE
     */
    private Map<Id, Map<String, Set<Decimal>>> getPOUpdatedRateShiftData(Set<Id> contractIds) {
        Map<Id, Map<String, Set<Decimal>>> poUpdatedRateShiftData = new Map<Id, Map<String, Set<Decimal>>>();
        if (contractIds == null || contractIds.isEmpty()) {
            return poUpdatedRateShiftData;
        }

        for (PreventiveCareAgreement pca : [
            SELECT ContractPaymentAgreement.ContractId, Shift__r.Shift_Name__r.Name, Rate__c
            FROM PreventiveCareAgreement
            WHERE ContractPaymentAgreement.ContractId IN :contractIds
            AND ContractPaymentAgreement.Type__c = :SHIFT_TYPE
            AND Existing_Rate_Increased__c = TRUE
            AND Shift__r.Shift_Name__c != NULL
            AND Rate__c != NULL
        ]) {
            Id contractId = pca.ContractPaymentAgreement.ContractId;
            String shiftName = pca.Shift__r.Shift_Name__r.Name;
            if (contractId == null || String.isBlank(shiftName)) {
                continue;
            }

            if (!poUpdatedRateShiftData.containsKey(contractId)) {
                poUpdatedRateShiftData.put(contractId, new Map<String, Set<Decimal>>());
            }
            Map<String, Set<Decimal>> shiftRateMap = poUpdatedRateShiftData.get(contractId);
            if (!shiftRateMap.containsKey(shiftName)) {
                shiftRateMap.put(shiftName, new Set<Decimal>());
            }
            shiftRateMap.get(shiftName).add(pca.Rate__c);
        }

        return poUpdatedRateShiftData;
    }

    /**
     * Gets Clinician Contract Data - queries CCM records with Process_Type = Automation.
     *
     * @param contractIds List of Practice Operations Contract IDs
     * @return List of Client_Change_Management__c records
     */
    private List<Client_Change_Management__c> getClinicianContractData(List<Id> contractIds) {
        return [
            SELECT Id,
            Contract__c,
            Contract__r.AccountId,
            Contract__r.OwnerId,
            Healthcare_Practitioner_Facility__c,
            Healthcare_Practitioner_Facility__r.PractitionerId,
            Healthcare_Practitioner_Facility__r.Practitioner.AccountId,
            Process_Type__c,
            Status__c
            FROM Client_Change_Management__c
            WHERE Process_Type__c = :PROCESS_TYPE_AUTOMATION
            AND Contract__c IN :contractIds
            AND Healthcare_Practitioner_Facility__r.PractitionerId != NULL
        ];
    }

    /**
     * Gets Clinician Contract shifts for all HPFs, grouped by Contract (bulkified).
     * When an HPF has multiple ContractPaymentAgreements (hence multiple Contracts), each contract's
     * rates are kept separate so we can evaluate "same across shift" per contract.
     * Fetches ContractPaymentAgreement first (filtered by ContractId and Healthcare_Practitioner_Facility__c),
     * then PreventiveCareAgreement filtered by those CPA IDs.
     *
     * @param clinicianAccountIds Set of Clinician Account IDs
     * @param shiftTypes Set of Shift Name Code values to match (e.g., "Day", "Night")
     * @param hpfIdsFromCCM Set of Healthcare_Practitioner_Facility__c IDs from Client_Change_Management__c
     * @return Map<HPFId, Map<ContractId, Map<ShiftType, Set<Rates>>>>
     */
    @TestVisible
    private Map<Id, Map<Id, Map<String, Set<Decimal>>>> getClinicianContractShifts(Set<Id> clinicianAccountIds, Set<String> shiftTypes, Set<Id> hpfIdsFromCCM) {
        Map<Id, Map<Id, Map<String, Set<Decimal>>>> mapOfHPFToContractShiftRates = new Map<Id, Map<Id, Map<String, Set<Decimal>>>>();
        contractIdToContractNumberMap.clear();

        if (clinicianAccountIds.isEmpty() || hpfIdsFromCCM == null || hpfIdsFromCCM.isEmpty()) {
            return mapOfHPFToContractShiftRates;
        }

        // Single query: CPA with Contract filters (avoids separate Contract query)
        Map<Id, Id> cpaIdToContractIdMap = new Map<Id, Id>();
        Map<Id, Id> cpaIdToHPFIdMap = new Map<Id, Id>();
        for (ContractPaymentAgreement cpa : [
            SELECT Id, ContractId, Contract.ContractNumber, Provider_Network_Contract__r.Healthcare_Practitioner_Facility__c
            FROM ContractPaymentAgreement
            WHERE Contract.RecordType.DeveloperName = :CLINICIAN_RECORD_TYPE
            AND Contract.Status IN :CLINICIAN_CONTRACT_VALID_STATUSES
            AND Contract.AccountId IN :clinicianAccountIds
            AND Provider_Network_Contract__r.Healthcare_Practitioner_Facility__c IN :hpfIdsFromCCM
            AND Type__c = :SHIFT_TYPE
        ]) {
            Id hpfId = cpa.Provider_Network_Contract__r?.Healthcare_Practitioner_Facility__c;
            if (hpfId != null && cpa.ContractId != null) {
                cpaIdToContractIdMap.put(cpa.Id, cpa.ContractId);
                cpaIdToHPFIdMap.put(cpa.Id, hpfId);
                if (!contractIdToContractNumberMap.containsKey(cpa.ContractId)) {
                    contractIdToContractNumberMap.put(cpa.ContractId, cpa.Contract?.ContractNumber != null ? cpa.Contract.ContractNumber : '');
                }
            }
        }

        if (cpaIdToContractIdMap.isEmpty()) {
            return mapOfHPFToContractShiftRates;
        }

        // Fetch PreventiveCareAgreement where ContractPaymentAgreementId IN cpaIds
        Set<Id> cpaIds = cpaIdToContractIdMap.keySet();
        String soql = 'SELECT ContractPaymentAgreementId, ContractPaymentAgreement.ContractId, ContractPaymentAgreement.Contract.ContractNumber, ' +
            'Shift__r.Shift_Name__r.Name, Rate__c FROM PreventiveCareAgreement ' +
            'WHERE ContractPaymentAgreementId IN :cpaIds ' +
            'AND ContractPaymentAgreement.Type__c = :SHIFT_TYPE ' +
            'AND Shift__r.Shift_Name__c != NULL AND Rate__c != NULL';
        if (shiftTypes != null && !shiftTypes.isEmpty()) {
            soql += ' AND Shift__r.Shift_Name__r.Name IN :shiftTypes';
        }

        // Bulk query Clinician PCA shifts - group by HPF and Contract
        for (PreventiveCareAgreement clinicianPCA : Database.query(soql)) {
            Id cpaId = clinicianPCA.ContractPaymentAgreementId;
            Id hpfId = cpaIdToHPFIdMap.get(cpaId);
            Id contractId = cpaIdToContractIdMap.get(cpaId);
            if (hpfId == null || contractId == null) {
                continue;
            }

            String shiftName = clinicianPCA.Shift__r.Shift_Name__r.Name;
            if (String.isBlank(shiftName)) {
                continue;
            }
            if (shiftTypes != null && !shiftTypes.isEmpty() && !shiftTypes.contains(shiftName)) {
                continue;
            }

            if (!mapOfHPFToContractShiftRates.containsKey(hpfId)) {
                mapOfHPFToContractShiftRates.put(hpfId, new Map<Id, Map<String, Set<Decimal>>>());
            }
            Map<Id, Map<String, Set<Decimal>>> contractRatesMap = mapOfHPFToContractShiftRates.get(hpfId);
            if (!contractRatesMap.containsKey(contractId)) {
                contractRatesMap.put(contractId, new Map<String, Set<Decimal>>());
            }
            Map<String, Set<Decimal>> shiftTypeMap = contractRatesMap.get(contractId);
            if (!shiftTypeMap.containsKey(shiftName)) {
                shiftTypeMap.put(shiftName, new Set<Decimal>());
            }
            if (clinicianPCA.Rate__c != null) {
                shiftTypeMap.get(shiftName).add(clinicianPCA.Rate__c);
            }
        }
        return mapOfHPFToContractShiftRates;
    }

    /**
     * Gets Executed Clinician Contract shifts for Agent CCM flow.
     * Map<HPFId, Map<ContractId, Map<ShiftType, Set<Rates>>>>
     */
    private Map<Id, Map<Id, Map<String, Set<Decimal>>>> getExecutedClinicianContractShifts(
        Set<Id> clinicianAccountIds,
        Set<Id> hpfIdsFromCCM
    ) {
        Map<Id, Map<Id, Map<String, Set<Decimal>>>> mapOfHPFToContractShiftRates = new Map<Id, Map<Id, Map<String, Set<Decimal>>>>();
        if (clinicianAccountIds == null || clinicianAccountIds.isEmpty() || hpfIdsFromCCM == null || hpfIdsFromCCM.isEmpty()) {
            return mapOfHPFToContractShiftRates;
        }

        Map<Id, Id> cpaIdToContractIdMap = new Map<Id, Id>();
        Map<Id, Id> cpaIdToHPFIdMap = new Map<Id, Id>();
        for (ContractPaymentAgreement cpa : [
            SELECT Id, ContractId, Provider_Network_Contract__r.Healthcare_Practitioner_Facility__c
            FROM ContractPaymentAgreement
            WHERE Contract.RecordType.DeveloperName = :CLINICIAN_RECORD_TYPE
            AND Contract.Status IN :AGENT_CLINICIAN_CONTRACT_STATUSES
            AND Contract.AccountId IN :clinicianAccountIds
            AND Provider_Network_Contract__r.Healthcare_Practitioner_Facility__c IN :hpfIdsFromCCM
            AND Type__c = :SHIFT_TYPE
        ]) {
            Id hpfId = cpa.Provider_Network_Contract__r?.Healthcare_Practitioner_Facility__c;
            if (hpfId != null && cpa.ContractId != null) {
                cpaIdToContractIdMap.put(cpa.Id, cpa.ContractId);
                cpaIdToHPFIdMap.put(cpa.Id, hpfId);
            }
        }

        if (cpaIdToContractIdMap.isEmpty()) {
            return mapOfHPFToContractShiftRates;
        }

        Set<Id> cpaIds = cpaIdToContractIdMap.keySet();
        for (PreventiveCareAgreement clinicianPca : [
            SELECT ContractPaymentAgreementId, Shift__r.Shift_Name__r.Name, Rate__c
            FROM PreventiveCareAgreement
            WHERE ContractPaymentAgreementId IN :cpaIds
            AND ContractPaymentAgreement.Type__c = :SHIFT_TYPE
            AND Shift__r.Shift_Name__c != NULL
            AND Rate__c != NULL
        ]) {
            Id cpaId = clinicianPca.ContractPaymentAgreementId;
            Id hpfId = cpaIdToHPFIdMap.get(cpaId);
            Id contractId = cpaIdToContractIdMap.get(cpaId);
            String shiftName = clinicianPca.Shift__r.Shift_Name__r.Name;
            if (hpfId == null || contractId == null || String.isBlank(shiftName)) {
                continue;
            }

            if (!mapOfHPFToContractShiftRates.containsKey(hpfId)) {
                mapOfHPFToContractShiftRates.put(hpfId, new Map<Id, Map<String, Set<Decimal>>>());
            }
            Map<Id, Map<String, Set<Decimal>>> contractRates = mapOfHPFToContractShiftRates.get(hpfId);
            if (!contractRates.containsKey(contractId)) {
                contractRates.put(contractId, new Map<String, Set<Decimal>>());
            }
            Map<String, Set<Decimal>> shiftRateMap = contractRates.get(contractId);
            if (!shiftRateMap.containsKey(shiftName)) {
                shiftRateMap.put(shiftName, new Set<Decimal>());
            }
            shiftRateMap.get(shiftName).add(clinicianPca.Rate__c);
        }

        return mapOfHPFToContractShiftRates;
    }

    /**
     * Queries ProviderNetworkContract to find every HPF that is linked to at least one
     * Executed Clinician Contract, regardless of whether that contract has any CPA or PCA records.
     * Used as the authoritative "does an Executed contract exist for this HPF?" check in the Agent CCM flow.
     *
     * @param clinicianAccountIds Set of Clinician Account IDs
     * @param hpfIds              Set of Healthcare_Practitioner_Facility__c IDs from Agent CCM records
     * @return Set of HPF IDs that have at least one Executed Clinician Contract via PNC
     */
    private Set<Id> getHpfsWithExecutedContractViaPNC(Set<Id> clinicianAccountIds, Set<Id> hpfIds) {
        Set<Id> hpfsWithContract = new Set<Id>();
        if (clinicianAccountIds == null || clinicianAccountIds.isEmpty() || hpfIds == null || hpfIds.isEmpty()) {
            return hpfsWithContract;
        }
        for (ProviderNetworkContract pnc : [
            SELECT Healthcare_Practitioner_Facility__c
            FROM ProviderNetworkContract
            WHERE Contract.RecordType.DeveloperName = :CLINICIAN_RECORD_TYPE
            AND Contract.Status IN :AGENT_CLINICIAN_CONTRACT_STATUSES
            AND Contract.AccountId IN :clinicianAccountIds
            AND Healthcare_Practitioner_Facility__c IN :hpfIds
        ]) {
            if (pnc.Healthcare_Practitioner_Facility__c != null) {
                hpfsWithContract.add(pnc.Healthcare_Practitioner_Facility__c);
            }
        }
        return hpfsWithContract;
    }

    private List<Client_Change_Management__c> getAgentCcmData(List<Id> contractIds) {
        return [
            SELECT Id,
                Contract__c,
                Healthcare_Practitioner_Facility__c,
                Healthcare_Practitioner_Facility__r.Practitioner.AccountId,
                Process_Type__c,
                Status__c
            FROM Client_Change_Management__c
            WHERE Process_Type__c = :PROCESS_TYPE_AGENT
            AND Status__c = :CCM_STATUS_NEW
            AND Contract__c IN :contractIds
        ];
    }

    private static void setCcmCanceledReason(Client_Change_Management__c ccm, String reason) {
        Map<String, Schema.SObjectField> ccmFields = Client_Change_Management__c.SObjectType.getDescribe().fields.getMap();
        if (ccmFields.containsKey(CCM_CANCELED_REASON_FIELD)) {
            ccm.put(CCM_CANCELED_REASON_FIELD, reason);
        }
    }

    /**
     * Gets Clinician Names from Contacts (bulkified).
     *
     * @param practitionerIds Set of Practitioner Contact IDs
     * @return Map of Practitioner ID to Clinician Name (FirstName LastName)
     */
    private Map<Id, String> getClinicianNamesBulk(Set<Id> practitionerIds) {
        Map<Id, String> practitionerToNameMap = new Map<Id, String>();

        if (practitionerIds.isEmpty()) {
            return practitionerToNameMap;
        }

        for (Contact c : [
            SELECT Id, FirstName, LastName
            FROM Contact
            WHERE Id IN :practitionerIds
        ]) {
            String name = '';
            if (String.isNotBlank(c.FirstName)) {
                name = c.FirstName;
            }
            if (String.isNotBlank(c.LastName)) {
                name += (String.isNotBlank(name) ? ' ' : '') + c.LastName;
            }

            practitionerToNameMap.put(c.Id, String.isNotBlank(name) ? name : 'Unknown Clinician');
        }
        return practitionerToNameMap;
    }

    /**
     * Updates Client Change Management records with error handling.
     *
     * @param ccmToUpdate List of Client Change Management records to update
     */
    private void updateCCMRecords(List<Client_Change_Management__c> ccmToUpdate) {
        try {
            update ccmToUpdate;
        } catch (DmlException de) {
            System.debug(CCM_UPDATE_ERROR + de.getMessage());
            PracticeOperationChangeUtil.logDmlException(de, 'ClinicianContractSyncService', 'updateCCMRecords');
        }
    }

    /**
     * Builds Contract Id -> Owner Id map from CCM records (reuses Contract__r.OwnerId from CCM query).
     */
    private Map<Id, Id> buildContractToOwnerMapFromCCM(List<Client_Change_Management__c> ccmRecords) {
        Map<Id, Id> contractToOwnerMap = new Map<Id, Id>();
        if (ccmRecords == null) {
            return contractToOwnerMap;
        }
        for (Client_Change_Management__c ccm : ccmRecords) {
            if (ccm.Contract__c != null && ccm.Contract__r != null && ccm.Contract__r.OwnerId != null) {
                contractToOwnerMap.put(ccm.Contract__c, ccm.Contract__r.OwnerId);
            }
        }
        return contractToOwnerMap;
    }

    /**
     * Creates tasks for Manual path CCM records.
     * @param contractToOwnerMap Pre-built from CCM records (no extra SOQL).
     */
    private void createTasks(
        List<Client_Change_Management__c> ccmRecords,
        Map<Id, Id> ccmToAccountMap,
        Map<Id, String> ccmToClinicianNameMap,
        Map<Id, String> ccmToContractNumbersMap,
        Map<Id, Id> contractToOwnerMap,
        List<Task> tasksToInsert
    ) {
        if (ccmRecords == null || ccmRecords.isEmpty()) {
            return;
        }

        // Use Schema for Task Record Type (avoids SOQL)
        Id defaultTaskRecordTypeId = getDefaultTaskRecordTypeId();

        // Get Account Team Members - Clinician Experience Specialist
        Map<Id, Id> accountToTeamMemberMap = getAccountTeamMembers(new Set<Id>(ccmToAccountMap.values()));

        for (Client_Change_Management__c ccm : ccmRecords) {
            if (ccm.Process_Type__c != PROCESS_TYPE_MANUAL) {
                continue;
            }

            Id accountId = ccmToAccountMap.get(ccm.Id);
            String clinicianName = ccmToClinicianNameMap.get(ccm.Id);

            if (accountId == null) {
                continue;
            }

            // Determine task owner - prefer CE Specialist, fallback to Contract Owner (from CCM query)
            Id taskOwnerId = accountToTeamMemberMap.get(accountId);
            if (taskOwnerId == null && ccm.Contract__c != null && contractToOwnerMap != null) {
                taskOwnerId = contractToOwnerMap.get(ccm.Contract__c);
            }

            if (taskOwnerId == null) {
                continue; // Skip if no owner found
            }

            String taskDescription = TASK_COMMENTS;
            String contractNumbers = ccmToContractNumbersMap != null ? ccmToContractNumbersMap.get(ccm.Id) : '';
            if (String.isNotBlank(contractNumbers)) {
                taskDescription += ' Clinician Contract Number(s): ' + contractNumbers;
            }

            Task newTask = new Task();
            newTask.RecordTypeId = defaultTaskRecordTypeId;
            newTask.OwnerId = taskOwnerId;
            newTask.Subject = TASK_SUBJECT;
            newTask.Description = taskDescription;
            newTask.WhatId = ccm.Id; // Related to Client_Change_Management__c
            newTask.WhoId = ccm.Healthcare_Practitioner_Facility__r?.PractitionerId; // Related to Contact (Clinician)

            tasksToInsert.add(newTask);
        }

        // Insert tasks
        if (!tasksToInsert.isEmpty()) {
            insertTasks(tasksToInsert);
        }
    }

    /**
     * Gets Default Task Record Type ID (uses Schema - no SOQL).
     */
    private Id getDefaultTaskRecordTypeId() {
        Schema.RecordTypeInfo rti = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Default');
        return rti != null ? rti.getRecordTypeId() : null;
    }

    /**
     * Gets Account Team Members with role 'Clinician Experience Specialist'.
     *
     * @param accountIds Set of Account IDs
     * @return Map of Account Id to User Id (Team Member)
     */
    private Map<Id, Id> getAccountTeamMembers(Set<Id> accountIds) {
        Map<Id, Id> accountToTeamMemberMap = new Map<Id, Id>();

        for (AccountTeamMember atm : [
            SELECT AccountId, UserId
            FROM AccountTeamMember
            WHERE AccountId IN :accountIds
            AND TeamMemberRole = :TEAM_ROLE_CE_SPECIALIST
            ORDER BY LastModifiedDate DESC
        ]) {
            // Use first team member found for each account
            if (!accountToTeamMemberMap.containsKey(atm.AccountId)) {
                accountToTeamMemberMap.put(atm.AccountId, atm.UserId);
            }
        }
        return accountToTeamMemberMap;
    }

    /**
     * Inserts Task records with error handling.
     *
     * @param tasksToInsert List of Task records to insert
     */
    @TestVisible
    private void insertTasks(List<Task> tasksToInsert) {
        try {
            insert tasksToInsert;
        } catch (DmlException de) {
            System.debug('Error inserting Task records: ' + de.getMessage());
            PracticeOperationChangeUtil.logDmlException(de, 'ClinicianContractSyncService', 'insertTasks');
        }
    }
}