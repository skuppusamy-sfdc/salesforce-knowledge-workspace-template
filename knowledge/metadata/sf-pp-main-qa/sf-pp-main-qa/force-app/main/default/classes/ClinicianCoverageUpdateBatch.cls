/**
 * @description
 * Batch class that updates Clinician Coverage details by processing Preventive Care Agreements (PCA)
 * and Contract Payment Agreements (CPA). This class ensures that clinician contracts are updated
 * with the correct shift type and rate details from associated client contracts.
 *
 * @author Srishty Sharma
 * @created 30-Sept-2025
 * @lastModified 22-Oct-2025
 * Updated the start query to include Client Change Management records
 * and added logic to avoid inserting duplicate PCAs and RPCs.
 */
public class ClinicianCoverageUpdateBatch implements Database.Batchable<SObject>, Database.Stateful {
    
    private static final String CLIENT_RECORD_TYPE = 'Client';
    private static final String CLINICIAN_RECORD_TYPE = 'Clinician';
    private static final String SHIFT_TYPE = 'Shift';
    private static final String CONTRACT_STATUS_EXECUTED = 'Executed';
    private static final String CONTRACT_STATUS_CANCELED = 'Canceled';
    private static final Set<String> CLINICIAN_CONTRACT_VALID_STATUSES = new Set<String>{
        'Draft', 'Submitted', 'Approved', 'Executed', 'Contracting - In Progress'
    };
    private static final String RATE_OF_HPF = 'Rate for HPF';
    private static final String CCM_STATUS_NEW = 'New';
    private static final String CCM_PROCESS_TYPE_AUTOMATION = 'Automation';
    private static final String CCM_STATUS_COMPLETED = 'Completed';
    private static final String CCM_STATUS_CANCELED = 'Canceled';
    private static final String CLASS_NAME = 'ClinicianCoverageUpdateBatch';
    private Set<Id> ccmRecordIds = new Set<Id>();
    private Set<Id> practitionerIds = new Set<Id>();
    private Map<String, Set<Id>> ccmRecordsByContractFacility = new Map<String, Set<Id>>();

    /**
    * @description
    * Batch start method that queries Client PreventiveCareAgreement (PCA) records
    * requiring processing based on contract status, start date, facility title,
    * and shift or rate change indicators.
    *
    * @param bc Database.BatchableContext instance
    * @return Database.QueryLocator containing PCAs to process
    */
    public Database.QueryLocator start(Database.BatchableContext bc) {
        Set<Id> contractIdsForSync = new Set<Id>();
        for (Client_Change_Management__c ccm : [SELECT Contract__c FROM Client_Change_Management__c
                                                WHERE Practice_Operation_Change__r.Facility_Title__c != null
                                                AND Contract__r.StartDate <= TOMORROW 
                                                AND Status__c =:CCM_STATUS_NEW 
                                                AND Process_Type__c =:CCM_PROCESS_TYPE_AUTOMATION]) {
            contractIdsForSync.add(ccm.Contract__c);
        }

        // Run ClinicianContractSyncService to sync clinician contracts before processing coverage updates
        if (!contractIdsForSync.isEmpty()) {
            ClinicianContractSyncService syncService = new ClinicianContractSyncService();
            syncService.syncClinicianContracts(new List<Id>(contractIdsForSync));
        }

        // Fetch fresh Client_Change_Management__c records after sync (CCM may have been updated by sync service)
        Set<Id> contractIds = new Set<Id>();
        Set<String> facilityTitles = new Set<String>();
        for (Client_Change_Management__c ccm : [SELECT Id,Contract__c, Practice_Operation_Change__r.Facility_Title__c,
        Healthcare_Practitioner_Facility__r.PractitionerId
                                                FROM Client_Change_Management__c
                                                WHERE Practice_Operation_Change__r.Facility_Title__c != null
                                                AND Contract__r.StartDate <= TOMORROW 
                                                AND Status__c =:CCM_STATUS_NEW 
                                                AND Process_Type__c =:CCM_PROCESS_TYPE_AUTOMATION]) {
            contractIds.add(ccm.Contract__c);
            facilityTitles.add(ccm.Practice_Operation_Change__r.Facility_Title__c);
            if (ccm.Healthcare_Practitioner_Facility__r != null && ccm.Healthcare_Practitioner_Facility__r.PractitionerId != null) {
                practitionerIds.add(ccm.Healthcare_Practitioner_Facility__r.PractitionerId);
            }
            ccmRecordIds.add(ccm.Id);
            
            String contractFacilityKey = String.valueOf(ccm.Contract__c) + String.valueOf(ccm.Practice_Operation_Change__r.Facility_Title__c);
            if (!ccmRecordsByContractFacility.containsKey(contractFacilityKey)) {
                ccmRecordsByContractFacility.put(contractFacilityKey, new Set<Id>());
            }
            ccmRecordsByContractFacility.get(contractFacilityKey).add(ccm.Id);
        }

        return Database.getQueryLocator([
            SELECT Id, Name, ContractPaymentAgreementId, Shift__c,BonusMeasureType,TargetMeasurePercent,BonusPayout, 
                   Shift__r.Shift_Name__r.Name,Shift__r.Shift_Full_Name__c, Rate__c, Unit_of_Measure__c, Time_Type__c, FacilityTitle__c,
                   ContractPaymentAgreement.ContractId,Is_Newly_Added__c,
                   ContractPaymentAgreement.Contract.AccountId, 
                   ContractPaymentAgreement.Contract.StartDate, ContractPaymentAgreement.Contract.EndDate,
                   Rate_Pay_Code_Added__c, Rate_Pay_Code_Remove__c,Cloned_From__c,	
                   Existing_Shift_Type_Added__c, Existing_Rate_Increased__c, Existing_Rate_Decreased__c
            FROM PreventiveCareAgreement
            WHERE ContractPaymentAgreement.Contract.RecordType.DeveloperName = :CLIENT_RECORD_TYPE
              AND ContractPaymentAgreement.Contract.Status = :CONTRACT_STATUS_EXECUTED
              AND ContractPaymentAgreement.Contract.PreviousContractId != NULL
              AND ContractPaymentAgreement.Type__c = :SHIFT_TYPE
			  AND ContractPaymentAgreement.ContractId IN:contractIds
              AND FacilityTitle__c IN:facilityTitles
              AND (
                    (
                        Existing_Shift_Type_Added__c = TRUE
                        AND Is_Newly_Added__c = TRUE
                        AND Existing_Rate_Increased__c = FALSE
                        AND Existing_Rate_Decreased__c = FALSE
                    )
                    OR (
                        Rate_Pay_Code_Added__c > 0 
                        OR Rate_Pay_Code_Remove__c > 0
                    )
                  )
            ORDER BY ContractPaymentAgreement.Contract.AccountId
        ]);
    }
    
    /**
    * @description
    * Batch execute method that processes each scope of Client PCAs by identifying
    * shift and rate changes, cloning applicable PCAs and Rate Pay Codes to
    * Clinician contracts, handling deletions, and publishing platform events.
    *
    * @param bc Database.BatchableContext instance
    * @param clientPCAs List of Client PreventiveCareAgreement records
    */
    public void execute(Database.BatchableContext bc, List<PreventiveCareAgreement> clientPCAs) {
        Set<Id> accountIds = new Set<Id>();
        Set<Id> pcaIdWithPayRateChange = new Set<Id>();
        Set<Id> facilityTitles = new Set<Id>();
        
        // Collect Client PCA details
        List<PreventiveCareAgreement> clientPCAsWithShiftAdded = collectClientPCAs(
            clientPCAs, accountIds, pcaIdWithPayRateChange, facilityTitles
        );
        
        // Create shared context
        ClinicianCloneContext context = new ClinicianCloneContext();
       
        // Fetch related Clinician CPAs
        Set<Id> existingClinicianCPAIds = getClinicianCPAs(accountIds, facilityTitles, practitionerIds, context.clinicianCPAMap);
        
        // Fetch existing Clinician PCAs (CPA ID + Shift ID)
        Map<String, PreventiveCareAgreement> existingPCAMap = getExistingClinicianPCAs(existingClinicianCPAIds);

        // Prepare map of existing Clinician rates
        context.clinicianRatesByCPA = prepareClinicianPCA(accountIds, facilityTitles);
        
        // Prepare map of existing Clinician rates by shift type only (for fallback lookup)
        context.clinicianRatesByShiftType = prepareClinicianPCAByShiftType(existingClinicianCPAIds);
        
        // Fetch Practice Operation Contract shifts for clinicians
        context.practiceOperationShifts = getPracticeOperationContractShifts(accountIds, facilityTitles);
        
        // Fetch existing shift names for each clinician CPA (to only create shifts that already exist)
        context.clinicianShiftNamesByCPA = getClinicianShiftNamesByCPA(existingClinicianCPAIds);
        
        // Fetch Clinician PCA for mapping Rate Pay Codes
        Map<String,List<PreventiveCareAgreement>> clinicianPCAWithSerAccTitleShift = new Map<String,List<PreventiveCareAgreement>>();     
        getClinicianPCA(existingClinicianCPAIds, clinicianPCAWithSerAccTitleShift);

        //Collect all existing Clinician PCA Ids that will receive cloned RPCs
        Set<Id> existingClinicianCPAIdsForRatePayCodes = new Set<Id>();
        for (List<PreventiveCareAgreement> pcas : clinicianPCAWithSerAccTitleShift.values()) {
            for (PreventiveCareAgreement pca : pcas) {
                existingClinicianCPAIdsForRatePayCodes.add(pca.Id);
            }
        }

        //Fetch existing Rate Pay Codes for duplication check
        Map<String, Rate_Pay_Code__c> existingRatePayCodeMap = getExistingClinicianRatePayCodes(existingClinicianCPAIdsForRatePayCodes);
        
        // Clone Client PCA to Clinician PCA 
        // Passing existingPCAMap to implement "Insert-If-Not-Exists" logic for PCAs
        ClinicianCloneResult clonePCAResult = cloneClinicianPCA(clientPCAsWithShiftAdded, context, existingPCAMap);
        Set<Id> successfullyProcessedCPAIds = new Set<Id>();
        successfullyProcessedCPAIds.addAll(saveRecords(clonePCAResult.newPCAs, 'PCA',null));
        
        // CHANGE: Process updates for existing PCAs
        successfullyProcessedCPAIds.addAll(updateRecords(clonePCAResult.pcasToUpdate, 'PCA'));
        
        // Clone Rate Pay Codes
        // Passing existingRatePayCodeMap to handle RPC duplicate checking
        ClinicianCloneResult ratePayCodeResult = handleRatePayCode(pcaIdWithPayRateChange, clinicianPCAWithSerAccTitleShift, context, existingRatePayCodeMap);
        successfullyProcessedCPAIds.addAll(saveRecords(ratePayCodeResult.newRatePayCodes, 'Rate Pay Code', ratePayCodeResult.pcaIdWithCPAId));
        
        //Delete Rate Pay Codes
        successfullyProcessedCPAIds.addAll(deleteRecords(ratePayCodeResult.clinicianRatePayCodesToDelete, ratePayCodeResult.rpcIdWithCPAId));
        
        // Track which contract+facility combinations had successful processing
        trackSuccessfulProcessing(clientPCAsWithShiftAdded, clonePCAResult, ratePayCodeResult, pcaIdWithPayRateChange);
        
        context.clinicianCPAWithUpdateMap = filterHPFUpdates(context.clinicianCPAWithUpdateMap, successfullyProcessedCPAIds);
        
        // Publish Platform Events for successfully inserted records
        if (!context.clinicianCPAWithUpdateMap.isEmpty()) {
            EventBus.publish(new List<HPFUpdates__e>(context.clinicianCPAWithUpdateMap.values()));
        }
    }
    
    /**
    * @description
    * Batch finish method that updates related Client Change Management (CCM)
    * records to Completed status after successful batch execution, or Cancelled
    * status if no processing occurred (e.g., when only Round shifts are present).
    *
    * @param bc Database.BatchableContext instance
    */
    public void finish(Database.BatchableContext bc) {
        List<Client_Change_Management__c> ccmRecordsToUpdate = new List<Client_Change_Management__c>();
        if (!ccmRecordIds.isEmpty()) {
            // Query CCM records with contract and facility info
            Map<Id, Client_Change_Management__c> ccmMap = new Map<Id, Client_Change_Management__c>();
            for (Client_Change_Management__c ccm : [Select Id, Status__c, Contract__c, Practice_Operation_Change__r.Facility_Title__c 
                                                      FROM Client_Change_Management__c 
                                                      WHERE Id IN:ccmRecordIds]) {
                ccmMap.put(ccm.Id, ccm);
            }
            
            // Determine status for each CCM record based on whether processing occurred
            for (Id ccmId : ccmMap.keySet()) {
                Client_Change_Management__c ccm = ccmMap.get(ccmId);
                String contractFacilityKey = String.valueOf(ccm.Contract__c) + String.valueOf(ccm.Practice_Operation_Change__r.Facility_Title__c);
                
                // Check if this contract+facility had successful processing
                if (processedContractFacilities.contains(contractFacilityKey)) {
                    ccm.Status__c = CCM_STATUS_COMPLETED;
                } else {
                    // No processing occurred (e.g., only Round shifts present)
                    ccm.Status__c = CCM_STATUS_CANCELED;
                }
                ccmRecordsToUpdate.add(ccm);
            }
            
            try {
                update ccmRecordsToUpdate;
            } catch (DmlException e) {
                String recordId = e.getNumDml() > 0 && e.getDmlId(0) != null ? String.valueOf(e.getDmlId(0)) : null;
                ErrorLogUtil.logException(e, CLASS_NAME + '.finish', recordId);
            }
        }
    }
    
    /**
    * @description
    * Tracks which contract+facility combinations had successful processing
    * (PCAs cloned or RPCs cloned/deleted). This is used to determine if
    * CCM records should be marked as Completed or Cancelled.
    *
    * @param clientPCAsWithShiftAdded List of Client PCAs that were processed
    * @param clonePCAResult Result containing cloned PCAs
    * @param ratePayCodeResult Result containing cloned/deleted RPCs
    * @param pcaIdWithPayRateChange Set of PCA Ids that had rate pay code changes
    */
    private Set<String> processedContractFacilities = new Set<String>();
    
    private void trackSuccessfulProcessing(
        List<PreventiveCareAgreement> clientPCAsWithShiftAdded,
        ClinicianCloneResult clonePCAResult,
        ClinicianCloneResult ratePayCodeResult,
        Set<Id> pcaIdWithPayRateChange
    ) {
        // Track contract+facility combinations from successfully cloned PCAs
        // Only track if PCAs were actually cloned (not just attempted)
        // When only Round shifts are present, no PCAs will be cloned, so nothing gets tracked
        if (!clonePCAResult.newPCAs.isEmpty()) {
            // Get unique contract+facility combinations from client PCAs that resulted in clones
            // Use Facility_Rate__c from cloned PCAs to map back to original client PCAs
            Set<Id> sourceClientPCAIds = new Set<Id>();
            for (PreventiveCareAgreement clonedPCA : clonePCAResult.newPCAs) {
                if (clonedPCA.Facility_Rate__c != null) {
                    sourceClientPCAIds.add(clonedPCA.Facility_Rate__c);
                }
            }
            
            // Map back to contract+facility combinations
            for (PreventiveCareAgreement clientPCA : clientPCAsWithShiftAdded) {
                if (sourceClientPCAIds.contains(clientPCA.Id)) {
                    String contractFacilityKey = String.valueOf(clientPCA.ContractPaymentAgreement.ContractId) + 
                                               String.valueOf(clientPCA.FacilityTitle__c);
                    processedContractFacilities.add(contractFacilityKey);
                }
            }
        }
        
        // Track contract+facility combinations from rate pay code changes
        // Only track if RPCs were actually cloned or deleted
        if ((!ratePayCodeResult.newRatePayCodes.isEmpty() || 
             !ratePayCodeResult.clinicianRatePayCodesToDelete.isEmpty()) && 
            !pcaIdWithPayRateChange.isEmpty()) {
            for (PreventiveCareAgreement clientPCA : [
                SELECT ContractPaymentAgreement.ContractId, FacilityTitle__c
                FROM PreventiveCareAgreement
                WHERE Id IN :pcaIdWithPayRateChange
            ]) {
                String contractFacilityKey = String.valueOf(clientPCA.ContractPaymentAgreement.ContractId) + 
                                           String.valueOf(clientPCA.FacilityTitle__c);
                processedContractFacilities.add(contractFacilityKey);
            }
        }
    }

    /**
    * @description
    * Fetches existing Clinician PreventiveCareAgreement records and maps them
    * using a composite key of ContractPaymentAgreementId and Shift Id
    * to prevent duplicate PCA creation.
    *
    * @param existingClinicianCPAIds Set of Clinician ContractPaymentAgreement Ids
    * @return Map of composite key (CPAId-ShiftId) to PreventiveCareAgreement
    */
    private Map<String, PreventiveCareAgreement> getExistingClinicianPCAs(Set<Id> existingClinicianCPAIds) {
        Map<String, PreventiveCareAgreement> existingPCAMap = new Map<String, PreventiveCareAgreement>();
        if (existingClinicianCPAIds.isEmpty()) { return existingPCAMap; }
        // CHANGE: Added Rate__c and Shift__r.Shift_Full_Name__c to SELECT to support rate comparison and key matching
        for (PreventiveCareAgreement existingPCA : [
                SELECT Id, ContractPaymentAgreementId, Shift__c, Rate__c, Shift__r.Shift_Name__r.Name, Shift__r.Shift_Full_Name__c
                FROM PreventiveCareAgreement
                WHERE ContractPaymentAgreementId IN :existingClinicianCPAIds
            ]) {
                // CHANGE: Create the unique key using CPA ID + Shift_Full_Name__c
                String uniqueKey = String.valueOf(existingPCA.ContractPaymentAgreementId) + '-' + String.valueOf(existingPCA.Shift__r.Shift_Full_Name__c);
                existingPCAMap.put(uniqueKey, existingPCA);
            }
        return existingPCAMap;
    }
    
    /**
    * @description
    * Fetches existing shift names for each clinician CPA to determine which shift types
    * (e.g., "Day", "Night") already exist in the clinician's contract.
    * This is used to only create new shifts of types that already exist.
    *
    * @param existingClinicianCPAIds Set of Clinician ContractPaymentAgreement Ids
    * @return Map of CPA Id to Set of shift names
    */
    private Map<Id, Set<String>> getClinicianShiftNamesByCPA(Set<Id> existingClinicianCPAIds) {
        Map<Id, Set<String>> shiftNamesByCPA = new Map<Id, Set<String>>();
        if (existingClinicianCPAIds.isEmpty()) { return shiftNamesByCPA; }
        
        for (PreventiveCareAgreement existingPCA : [
                SELECT Id, ContractPaymentAgreementId, Shift__r.Shift_Name__r.Name
                FROM PreventiveCareAgreement
                WHERE ContractPaymentAgreementId IN :existingClinicianCPAIds
                AND Shift__r.Shift_Name__r.Name != null
            ]) {
                Id cpaId = existingPCA.ContractPaymentAgreementId;
                String shiftName = existingPCA.Shift__r.Shift_Name__r.Name;
                
                if (!shiftNamesByCPA.containsKey(cpaId)) {
                    shiftNamesByCPA.put(cpaId, new Set<String>());
                }
                shiftNamesByCPA.get(cpaId).add(shiftName);
            }
        return shiftNamesByCPA;
    }
    
    /**
    * @description
    * Checks if a shift name exists in the clinician's contract for the given CPA.
    * This ensures we only create shifts of types that already exist in the clinician's contract.
    *
    * @param clinicianCPAId Clinician ContractPaymentAgreement Id
    * @param shiftName Shift name to check (e.g., "Day", "Night")
    * @param shiftNamesByCPA Map of CPA Id to Set of shift names
    * @return True if shift name exists in clinician's contract, false otherwise
    */
    private static Boolean doesShiftNameExistInClinicianContract(
        Id clinicianCPAId,
        String shiftName,
        Map<Id, Set<String>> shiftNamesByCPA
    ) {
        if (clinicianCPAId == null || String.isBlank(shiftName)) {
            return false;
        }
        
        Set<String> existingShiftNames = shiftNamesByCPA.get(clinicianCPAId);
        if (existingShiftNames == null || existingShiftNames.isEmpty()) {
            return false;
        }
        
        return existingShiftNames.contains(shiftName);
    }

    /**
    * @description
    * Fetches existing Clinician Rate Pay Code records and maps them using a
    * composite key of PCA Id and Pay Code Id to prevent duplicate RPC inserts.
    *
    * @param targetClinicianPCAIds Set of Clinician PCA Ids
    * @return Map of composite key (PCAId-PayCodeId) to Rate_Pay_Code__c
    */
    private Map<String, Rate_Pay_Code__c> getExistingClinicianRatePayCodes(Set<Id> targetClinicianPCAIds) {
        Map<String, Rate_Pay_Code__c> existingRPCMap = new Map<String, Rate_Pay_Code__c>();
        if (targetClinicianPCAIds.isEmpty()) { return existingRPCMap; }
        for (Rate_Pay_Code__c existingRPC : [
            SELECT Id, Preventive_Care_Agreement__c, Pay_Code__c
            FROM Rate_Pay_Code__c
            WHERE Preventive_Care_Agreement__c IN :targetClinicianPCAIds
            ]) {
                // Create the unique key: Parent PCA ID + Pay Code ID (the value of Pay_Code__c)
                String uniqueKey = String.valueOf(existingRPC.Preventive_Care_Agreement__c) + '-' + String.valueOf(existingRPC.Pay_Code__c);
                existingRPCMap.put(uniqueKey, existingRPC);
            }
        return existingRPCMap;
    }
    
    /**
    * @description
    * Collects Client PCAs, identifies newly added shifts and rate changes,
    * and populates Account, Facility Title, and PCA tracking collections.
    *
    * @param clientPCAs List of Client PreventiveCareAgreement records
    * @param accountIds Set to populate with Account Ids
    * @param pcaIdWithPayRateChange Set to populate with PCA Ids having rate changes
    * @param facilityTitles Set to populate with Facility Title values
    * @return List of Client PCAs with newly added shifts
    */
    private static List<PreventiveCareAgreement> collectClientPCAs(
        List<PreventiveCareAgreement> clientPCAs, 
        Set<Id> accountIds, 
        Set<Id> pcaIdWithPayRateChange, 
        Set<Id> facilityTitles
    ) {
        List<PreventiveCareAgreement> clientPCAsWithShiftAdded = new List<PreventiveCareAgreement>();
        for(PreventiveCareAgreement clientPCA : clientPCAs) {
            Id accountId = clientPCA.ContractPaymentAgreement.Contract.AccountId;
            
            if(clientPCA.Rate_Pay_Code_Added__c > 0
               || clientPCA.Rate_Pay_Code_Remove__c > 0) {
                pcaIdWithPayRateChange.add(clientPCA.Id);
            }
            
            if(clientPCA.Existing_Shift_Type_Added__c
               && clientPCA.Is_Newly_Added__c
               && !clientPCA.Existing_Rate_Increased__c
               && !clientPCA.Existing_Rate_Decreased__c) {
                accountIds.add(accountId);
                facilityTitles.add(clientPCA.FacilityTitle__c);
                clientPCAsWithShiftAdded.add(clientPCA);
            }
        }
        return clientPCAsWithShiftAdded;
    }
    
    /**
    * @description
    * Retrieves Clinician ContractPaymentAgreements filtered by Account
    * and Facility Title and groups them using a composite key.
    *
    * @param accountIds Set of Account Ids
    * @param facilityTitles Set of Facility Title values
    * @param practitionerIds Set of Practitioner Ids from CCM (filters to specific practitioners when non-empty)
    * @param clinicianCPAMap Map to populate with grouped Clinician CPAs
    * @return Set of Clinician ContractPaymentAgreement Ids
    */
    private Set<Id> getClinicianCPAs(Set<Id> accountIds, Set<Id> facilityTitles, Set<Id> practitionerIds, Map<String, List<ContractPaymentAgreement>> clinicianCPAMap) {
        Set<Id> existingClinicianCPAIds = new Set<Id>();
        System.debug('practitionerIds: ' + practitionerIds);
        for(ContractPaymentAgreement clinicianCPA : [
            SELECT Id, Name, ContractId, Contract.StartDate, Contract.EndDate,
            Contract.Status,Provider_Network_Contract__r.Healthcare_Practitioner_Facility__c,
            Provider_Network_Contract__r.Healthcare_Practitioner_Facility__r.AccountId,
            Provider_Network_Contract__r.Healthcare_Practitioner_Facility__r.Facility_Title__c,
            Provider_Network_Contract__r.Healthcare_Practitioner_Facility__r.Account.GlobalFacilityID__c,
            Provider_Network_Contract__r.Healthcare_Practitioner_Facility__r.Practitioner.Global_Provider_ID__c
            FROM ContractPaymentAgreement
            WHERE Contract.RecordType.DeveloperName = :CLINICIAN_RECORD_TYPE
            AND Contract.Status IN :CLINICIAN_CONTRACT_VALID_STATUSES
            AND Provider_Network_Contract__r.Healthcare_Practitioner_Facility__r.AccountId IN :accountIds
            AND Type__c = :SHIFT_TYPE
            AND Provider_Network_Contract__r.Healthcare_Practitioner_Facility__r.Facility_Title__c IN :facilityTitles
            AND Contract.Account.PersonContactId IN :practitionerIds
        ]) {
            existingClinicianCPAIds.add(clinicianCPA.Id);
            String clinicianKey = buildKey(clinicianCPA.Provider_Network_Contract__r.Healthcare_Practitioner_Facility__r.AccountId, 
                                           clinicianCPA.Provider_Network_Contract__r.Healthcare_Practitioner_Facility__r.Facility_Title__c, 
                                           null);
            if(!clinicianCPAMap.containsKey(clinicianKey)){
                clinicianCPAMap.put(clinicianKey, new List<ContractPaymentAgreement>());
            }
            clinicianCPAMap.get(clinicianKey).add(clinicianCPA);
        }
        return existingClinicianCPAIds;
    }
    
    /**
    * @description
    * Prepares a map of Clinician CPAs and their maximum existing rates
    * grouped by Facility Title and Shift.
    *
    * @param servAccIds Set of Service Account Ids
    * @param facilityTitles Set of Facility Title values
    * @return Map of CPA Id to composite key and maximum rate
    */
    private Map<Id,Map<String, Decimal>> prepareClinicianPCA(Set<Id> servAccIds, Set<Id> facilityTitles) {
        Map<Id,Map<String, Decimal>> ratesByCPAByServAccFacilityTitle = new Map<Id,Map<String, Decimal>>();
        
        for(AggregateResult results : [
            SELECT Max(Rate__c) maxRate, ContractPaymentAgreementId cpaId, FacilityTitle__c facilityTitle, 
                   Shift__r.Shift_Name__r.Name shiftName,
                   ContractPaymentAgreement.Provider_Network_Contract__r.Healthcare_Practitioner_Facility__r.AccountId acctName      
            FROM PreventiveCareAgreement 
            WHERE ContractPaymentAgreement.Type__c = :SHIFT_TYPE
              AND ContractPaymentAgreement.Contract.RecordType.Name = :CLINICIAN_RECORD_TYPE
              AND ContractPaymentAgreement.Provider_Network_Contract__r.Healthcare_Practitioner_Facility__r.AccountId IN :servAccIds
              AND ContractPaymentAgreement.Contract.Status IN :CLINICIAN_CONTRACT_VALID_STATUSES
              AND FacilityTitle__c IN :facilityTitles
            GROUP BY ContractPaymentAgreementId, FacilityTitle__c, Shift__r.Shift_Name__r.Name, 
                     ContractPaymentAgreement.Provider_Network_Contract__r.Healthcare_Practitioner_Facility__r.AccountId
        ]) {
            String key = buildKey(results.get('acctName'), results.get('facilityTitle'), results.get('shiftName'));
            Id cpaId = (Id)results.get('cpaId');
            Decimal maxRate = (Decimal)results.get('maxRate');
            
            // Check if map already exists for this CPA, if not create it
            if (!ratesByCPAByServAccFacilityTitle.containsKey(cpaId)) {
                ratesByCPAByServAccFacilityTitle.put(cpaId, new Map<String, Decimal>());
            }
            // Add the shift rate to the existing map
            ratesByCPAByServAccFacilityTitle.get(cpaId).put(key, maxRate);
        }
        return ratesByCPAByServAccFacilityTitle;
    }
    
    /**
    * @description
    * Prepares a map of Clinician CPAs and their maximum existing rates
    * grouped by Shift Type only (Day/Night), regardless of FacilityTitle.
    * This is used as a fallback when FacilityTitle-based lookup fails.
    * 
    * Note: This method queries all PCAs for the given CPAs, matching the same filters
    * as getClinicianShiftNamesByCPA to ensure consistency.
    *
    * @param existingClinicianCPAIds Set of Clinician ContractPaymentAgreement Ids
    * @return Map of CPA Id to shift type name and maximum rate
    */
    private Map<Id, Map<String, Decimal>> prepareClinicianPCAByShiftType(Set<Id> existingClinicianCPAIds) {
        Map<Id, Map<String, Decimal>> ratesByCPAByShiftType = new Map<Id, Map<String, Decimal>>();
        
        if (existingClinicianCPAIds.isEmpty()) {
            return ratesByCPAByShiftType;
        }
        
        // Query PCAs matching the same filters as getClinicianShiftNamesByCPA
        // This ensures we find rates for shifts that exist (as determined by shift name check)
        for(PreventiveCareAgreement pca : [
            SELECT ContractPaymentAgreementId, Shift__r.Shift_Name__r.Name, Rate__c
            FROM PreventiveCareAgreement
            WHERE ContractPaymentAgreementId IN :existingClinicianCPAIds
              AND Shift__r.Shift_Name__r.Name != null
              AND Rate__c != null
        ]) {
            Id cpaId = pca.ContractPaymentAgreementId;
            String shiftName = pca.Shift__r.Shift_Name__r.Name;
            Decimal rate = pca.Rate__c;
            
            if (cpaId == null || String.isBlank(shiftName) || rate == null) {
                continue;
            }
            
            // Check if map already exists for this CPA, if not create it
            if (!ratesByCPAByShiftType.containsKey(cpaId)) {
                ratesByCPAByShiftType.put(cpaId, new Map<String, Decimal>());
            }
            
            // Store the maximum rate for each shift type
            Map<String, Decimal> shiftTypeRates = ratesByCPAByShiftType.get(cpaId);
            if (!shiftTypeRates.containsKey(shiftName) || shiftTypeRates.get(shiftName) < rate) {
                shiftTypeRates.put(shiftName, rate);
            }
        }
        return ratesByCPAByShiftType;
    }
    
    /**
    * @description
    * Clones Client PCAs to Clinician PCAs while enforcing duplicate checks
    * and determining appropriate rate values.
    *
    * @param clientPCAsWithShiftAdded List of Client PCAs with newly added shifts
    * @param context Shared processing context
    * @param existingPCAMap Existing Clinician PCA map for duplicate validation
    * @return ClinicianCloneResult containing newly created PCAs
    */
    private ClinicianCloneResult cloneClinicianPCA(List<PreventiveCareAgreement> clientPCAsWithShiftAdded, ClinicianCloneContext context, Map<String, PreventiveCareAgreement> existingPCAMap) {
        ClinicianCloneResult result = new ClinicianCloneResult();
        
        for (PreventiveCareAgreement clientPCA : clientPCAsWithShiftAdded) {
            String keyWithoutShift = buildKey(clientPCA.ContractPaymentAgreement.Contract.AccountId, clientPCA.FacilityTitle__c, null);
            String keyWithShift = buildKey(clientPCA.ContractPaymentAgreement.Contract.AccountId, clientPCA.FacilityTitle__c, clientPCA.Shift__r.Shift_Name__r.Name);

            
            List<ContractPaymentAgreement> clinicianCPAs = context.clinicianCPAMap.get(keyWithoutShift);
            
            if (clinicianCPAs == null) {
                continue;
            }
            
            for(ContractPaymentAgreement clinicianCPA : clinicianCPAs) {
                // CHANGE: Duplicate Check for PCAs using Shift_Full_Name__c
                String uniqueKey = String.valueOf(clinicianCPA.Id) + '-' + String.valueOf(clientPCA.Shift__r.Shift_Full_Name__c);
				// CHANGE: Logic updated to update existing records instead of skipping
                if (existingPCAMap.containsKey(uniqueKey)) {
                    PreventiveCareAgreement existingPca = existingPCAMap.get(uniqueKey);
					// Updated to get rate from context to match same logic as new records
                    Decimal updatedRate = getRateToPopulate(
                        context.clinicianRatesByCPA.get(clinicianCPA.Id)?.get(keyWithShift),
                        clientPCA.Rate__c
                    );
					existingPca.Rate__c = updatedRate;
					result.pcasToUpdate.add(existingPca);
					continue;
                }
                
                // Check if shiftName exists in Practice Operation Contract
                if (!doesShiftExistInPracticeOperationContract(
                    clientPCA.ContractPaymentAgreement.Contract.AccountId,
                    clientPCA.FacilityTitle__c,
                    clientPCA.Shift__r.Shift_Name__r.Name,
                    context.practiceOperationShifts
                )) {
                    // Skip cloning if shiftName does not exist in Practice Operation Contract
                    continue;
                }
                
                // Check if shift name already exists in clinician's contract
                // Only create shifts that the clinician already has (e.g., if clinician has Day shifts, only create Day shifts, not Night)
                if (!doesShiftNameExistInClinicianContract(
                    clinicianCPA.Id,
                    clientPCA.Shift__r.Shift_Name__r.Name,
                    context.clinicianShiftNamesByCPA
                )) {
                    // Skip cloning if shift name does not exist in clinician's contract
                    continue;
                }
                
                // Get rate: first try FacilityTitle-based lookup, then fallback to shift type only
                Decimal existingRate = null;
                Map<String, Decimal> ratesByKey = context.clinicianRatesByCPA.get(clinicianCPA.Id);
                if (ratesByKey != null) {
                    existingRate = ratesByKey.get(keyWithShift);
                }
                
                // If not found by FacilityTitle, try shift type only lookup
                if (existingRate == null) {
                    Map<String, Decimal> ratesByShiftType = context.clinicianRatesByShiftType.get(clinicianCPA.Id);
                    if (ratesByShiftType != null) {
                        existingRate = ratesByShiftType.get(clientPCA.Shift__r.Shift_Name__r.Name);
                    }
                }
                
                Decimal rateToPopulate = getRateToPopulate(existingRate, clientPCA.Rate__c);
                
                // Clone PCA
                PreventiveCareAgreement clonedPca = clientPCA.clone(false, true, false, false);
                clonedPca.Rate__c = rateToPopulate;
                clonedPca.ContractPaymentAgreementId = clinicianCPA.Id;
                clonedPca.Facility_Rate__c = clientPCA.Id;
                clonedPca.Time_Type__c = clientPCA.Time_Type__c;
                result.newPCAs.add(clonedPca);
                
                // Add to shared platform event map
                if(!context.clinicianCPAWithUpdateMap.containsKey(clinicianCPA.Id)){
                    HPFUpdates__e hpfUpdate = buildHPFUpdate(clinicianCPA);
                    if(hpfUpdate != null) {
                        context.clinicianCPAWithUpdateMap.put(clinicianCPA.Id, hpfUpdate);
                    }
                }
            }
        }
        return result;
    }
    
    /**
    * @description
    * Retrieves Clinician PCAs and groups them by Account, Facility Title,
    * and Shift for Rate Pay Code processing.
    *
    * @param existingClinicianCPAIds Set of Clinician CPA Ids
    * @param clinicianPCAWithSerAccTitleShift Map to populate with grouped PCAs
    */
    private void getClinicianPCA(Set<Id> existingClinicianCPAIds, Map<String,List<PreventiveCareAgreement>> clinicianPCAWithSerAccTitleShift) {
        for(PreventiveCareAgreement clinicianPCA : [
            SELECT Id, ContractPaymentAgreementId, ContractPaymentAgreement.ContractId,
            ContractPaymentAgreement.Provider_Network_Contract__r.Healthcare_Practitioner_Facility__c,
            ContractPaymentAgreement.Provider_Network_Contract__r.Healthcare_Practitioner_Facility__r.Account.GlobalFacilityID__c,
            ContractPaymentAgreement.Provider_Network_Contract__r.Healthcare_Practitioner_Facility__r.Practitioner.Global_Provider_ID__c,
            ContractPaymentAgreement.Provider_Network_Contract__r.Healthcare_Practitioner_Facility__r.AccountId,
            ContractPaymentAgreement.Provider_Network_Contract__r.Healthcare_Practitioner_Facility__r.Facility_Title__c,
            Shift__r.Shift_Name__r.Name, Facility_Rate__c, Cloned_From__r.Facility_Rate__c
            FROM PreventiveCareAgreement 
            WHERE ContractPaymentAgreementId IN :existingClinicianCPAIds
        ]) {
            String clinicianKey = buildKey(clinicianPCA.ContractPaymentAgreement.Provider_Network_Contract__r.Healthcare_Practitioner_Facility__r.AccountId,
                                           clinicianPCA.ContractPaymentAgreement.Provider_Network_Contract__r.Healthcare_Practitioner_Facility__r.Facility_Title__c,
                                           clinicianPCA.Shift__r.Shift_Name__r.Name);
            
            if(!clinicianPCAWithSerAccTitleShift.containsKey(clinicianKey)){
                clinicianPCAWithSerAccTitleShift.put(clinicianKey, new List<PreventiveCareAgreement>());
            }
            clinicianPCAWithSerAccTitleShift.get(clinicianKey).add(clinicianPCA);
        }
    }
    
    /**
    * @description
    * Processes Rate Pay Code changes by cloning newly added RPCs and identifying
    * clinician RPCs to delete based on client deletions.
    *
    * @param pcaIds Set of Client PCA Ids
    * @param clinicianPCAWithSerAccTitleShift Grouped Clinician PCAs
    * @param context Shared processing context
    * @param existingRatePayCodeMap Existing RPC map for duplicate validation
    * @return ClinicianCloneResult containing RPC inserts and deletions
    */
    private ClinicianCloneResult handleRatePayCode(Set<Id> pcaIds, Map<String,List<PreventiveCareAgreement>> clinicianPCAWithSerAccTitleShift, ClinicianCloneContext context,Map<String, Rate_Pay_Code__c> existingRatePayCodeMap) {
        ClinicianCloneResult result = new ClinicianCloneResult();
        RatePayCodeChanges changes = collectRatePayCodeChanges(pcaIds);
        cloneNewRatePayCodes(changes.newClientRPCs, clinicianPCAWithSerAccTitleShift, context, result, existingRatePayCodeMap);
        findClinicianRatePayCodesToDelete(changes.deleteKeys, changes.serviceAccounts, changes.facilityTitles, changes.shiftNames, changes.payCodes, context, result);
        return result;
    }

    /**
     * @description
     * Collects client Rate Pay Code changes for the specified Client PCAs.
     * Identifies two sets of changes:
     * - Newly added RPCs (Is_Newly_Added__c = true) to be cloned to clinician PCAs
     * - Deleted RPCs (Is_Deleted__c = true) to drive deletion of matching clinician RPCs,
     *   captured via a composite delete key (Account + Facility Title + Shift + Pay Code)
     *
     * @param pcaIds Set of Client PreventiveCareAgreement Ids to analyze
     * @return RatePayCodeChanges container with new RPCs, delete keys, and filter sets for clinician lookups
     */
    private RatePayCodeChanges collectRatePayCodeChanges(Set<Id> pcaIds) {
        RatePayCodeChanges changes = new RatePayCodeChanges();
        for (Rate_Pay_Code__c payRateCode : [
            SELECT Id, Pay_Code__c, Preventive_Care_Agreement__c,
                   Preventive_Care_Agreement__r.ContractPaymentAgreementId,
                   Preventive_Care_Agreement__r.ContractPaymentAgreement.Contract.AccountId,
                   Preventive_Care_Agreement__r.FacilityTitle__c,
                   Preventive_Care_Agreement__r.Cloned_From__c,
                   Preventive_Care_Agreement__r.Shift__r.Shift_Name__r.Name,
                   Is_Newly_Added__c, Is_Deleted__c
            FROM Rate_Pay_Code__c
            WHERE Preventive_Care_Agreement__c IN :pcaIds
              AND (Is_Newly_Added__c = true OR Is_Deleted__c = true)
        ]) {
            if (payRateCode.Is_Newly_Added__c) {
                changes.newClientRPCs.add(payRateCode);
            } else if (payRateCode.Is_Deleted__c) {
                String deleteKey = buildDeleteKey(
                    payRateCode.Preventive_Care_Agreement__r.ContractPaymentAgreement.Contract.AccountId,
                    payRateCode.Preventive_Care_Agreement__r.FacilityTitle__c,
                    payRateCode.Preventive_Care_Agreement__r.Shift__r.Shift_Name__r.Name,
                    payRateCode.Pay_Code__c
                );
                changes.deleteKeys.add(deleteKey);
                changes.serviceAccounts.add(payRateCode.Preventive_Care_Agreement__r.ContractPaymentAgreement.Contract.AccountId);
                changes.facilityTitles.add(payRateCode.Preventive_Care_Agreement__r.FacilityTitle__c);
                changes.shiftNames.add(payRateCode.Preventive_Care_Agreement__r.Shift__r.Shift_Name__r.Name);
                changes.payCodes.add(payRateCode.Pay_Code__c);
            }
        }
        return changes;
    }

    /**
     * @description
     * Clones client Rate Pay Codes flagged as newly added to the corresponding clinician PCAs.
     * Matching is performed by Account + Facility Title + Shift. For each matching clinician PCA,
     * a cloned RPC is created and mapped to its CPA Id for downstream event filtering.
     *
     * @param newClientRPCs List of client Rate_Pay_Code__c records with Is_Newly_Added__c = true
     * @param clinicianPCAWithSerAccTitleShift Map of clinician PCAs grouped by composite key
     * @param context Shared context to populate HPFUpdates__e for affected CPAs
     * @param result Result accumulator to collect new RPCs and CPA mappings
     * @param existingRatePayCodeMap Map of existing RPCs for duplicate checking (PCA ID - Pay Code ID key)
     */
    private void cloneNewRatePayCodes(List<Rate_Pay_Code__c> newClientRPCs, Map<String,List<PreventiveCareAgreement>> clinicianPCAWithSerAccTitleShift, ClinicianCloneContext context, ClinicianCloneResult result, Map<String, Rate_Pay_Code__c> existingRatePayCodeMap) {
        for (Rate_Pay_Code__c payRateCode : newClientRPCs) {
            String clientKey = buildKey(
                payRateCode.Preventive_Care_Agreement__r.ContractPaymentAgreement.Contract.AccountId,
                payRateCode.Preventive_Care_Agreement__r.FacilityTitle__c,
                payRateCode.Preventive_Care_Agreement__r.Shift__r.Shift_Name__r.Name
            );
            if (!clinicianPCAWithSerAccTitleShift.containsKey(clientKey)) {
                continue;
            }
            for (PreventiveCareAgreement clinicianPCA : clinicianPCAWithSerAccTitleShift.get(clientKey)) {
                //Duplicate Check for RPCs
                String uniqueRPCKey = String.valueOf(clinicianPCA.Id) + '-' + String.valueOf(payRateCode.Pay_Code__c);
                if (existingRatePayCodeMap.containsKey(uniqueRPCKey)) {
                    // RPC already exists under this PCA with this Pay Code. Skip clone/insert.
                    continue;
                }
                
                // Check if shiftName exists in Practice Operation Contract before cloning Rate Pay Code
                if (!doesShiftExistInPracticeOperationContract(
                    payRateCode.Preventive_Care_Agreement__r.ContractPaymentAgreement.Contract.AccountId,
                    payRateCode.Preventive_Care_Agreement__r.FacilityTitle__c,
                    payRateCode.Preventive_Care_Agreement__r.Shift__r.Shift_Name__r.Name,
                    context.practiceOperationShifts
                )) {
                    // Skip cloning Rate Pay Code if shiftName does not exist in Practice Operation Contract
                    continue;
                }
                
                if (shouldCloneRatePayCode(clinicianPCA, payRateCode)) {
                    Rate_Pay_Code__c payRateToClone = payRateCode.clone(false, true, false, false);
                    payRateToClone.Preventive_Care_Agreement__c = clinicianPCA.Id;
                    result.newRatePayCodes.add(payRateToClone);
                    result.pcaIdWithCPAId.put(clinicianPCA.Id, clinicianPCA.ContractPaymentAgreementId);
                    if (!context.clinicianCPAWithUpdateMap.containsKey(clinicianPCA.ContractPaymentAgreementId)) {
                        HPFUpdates__e hpfUpdate = buildHPFUpdate(clinicianPCA.ContractPaymentAgreement);
                        if (hpfUpdate != null) {
                            context.clinicianCPAWithUpdateMap.put(clinicianPCA.ContractPaymentAgreementId, hpfUpdate);
                        }
                    }
                }
            }
        }
    }

    /**
     * @description
     * Finds clinician Rate Pay Codes that match client-deleted RPCs and stages them for deletion.     *
     * Matching is done by the composite delete key (Account + Facility Title + Shift + Pay Code).
     * The method collects matching clinician RPCs, maps them to CPA Ids, and prepares HPF updates.
     *
     * @param deleteKeys Composite keys built from client deletions
     * @param serviceAccounts Set of Account Ids used to scope the clinician RPC query
     * @param facilityTitles Set of Facility Title Ids used to scope the clinician RPC query
     * @param shiftNames Set of Shift names used to scope the clinician RPC query
     * @param payCodes Set of Pay Code Ids used to scope the clinician RPC query
     * @param context Shared context to populate HPFUpdates__e for affected CPAs
     * @param result Result accumulator to collect RPCs to delete and CPA mappings
     */
    private void findClinicianRatePayCodesToDelete(Set<String> deleteKeys, Set<Id> serviceAccounts, Set<Id> facilityTitles, Set<String> shiftNames, Set<Id> payCodes, ClinicianCloneContext context, ClinicianCloneResult result) {
        if (deleteKeys.isEmpty() || serviceAccounts.isEmpty() || facilityTitles.isEmpty() || shiftNames.isEmpty() || payCodes.isEmpty()) {
            return;
        }
        for (Rate_Pay_Code__c clinicianPayRateCode : [
            SELECT Id,
                   Preventive_Care_Agreement__r.ContractPaymentAgreementId,
                   Preventive_Care_Agreement__r.ContractPaymentAgreement.ContractId,
            	   Preventive_Care_Agreement__r.ContractPaymentAgreement.Provider_Network_Contract__r.Healthcare_Practitioner_Facility__r.Account.GlobalFacilityID__c,
                   Preventive_Care_Agreement__r.ContractPaymentAgreement.Provider_Network_Contract__r.Healthcare_Practitioner_Facility__r.Practitioner.Global_Provider_ID__c,
                   Preventive_Care_Agreement__r.ContractPaymentAgreement.Provider_Network_Contract__r.Healthcare_Practitioner_Facility__c,
                   Preventive_Care_Agreement__r.ContractPaymentAgreement.Provider_Network_Contract__r.Healthcare_Practitioner_Facility__r.AccountId,
                   Preventive_Care_Agreement__r.ContractPaymentAgreement.Provider_Network_Contract__r.Healthcare_Practitioner_Facility__r.Facility_Title__c,
                   Preventive_Care_Agreement__r.Shift__r.Shift_Name__r.Name,
                   Pay_Code__c
            FROM Rate_Pay_Code__c
            WHERE Preventive_Care_Agreement__r.ContractPaymentAgreement.Provider_Network_Contract__r.Healthcare_Practitioner_Facility__r.AccountId IN :serviceAccounts
              AND Preventive_Care_Agreement__r.ContractPaymentAgreement.Provider_Network_Contract__r.Healthcare_Practitioner_Facility__r.Facility_Title__c IN :facilityTitles
              AND Preventive_Care_Agreement__r.Shift__r.Shift_Name__r.Name IN :shiftNames
              AND Pay_Code__c IN :payCodes
              AND Preventive_Care_Agreement__r.ContractPaymentAgreement.Contract.RecordType.DeveloperName = :CLINICIAN_RECORD_TYPE
              AND Preventive_Care_Agreement__r.ContractPaymentAgreement.Contract.Status IN :CLINICIAN_CONTRACT_VALID_STATUSES
              AND Preventive_Care_Agreement__r.ContractPaymentAgreement.Type__c = :SHIFT_TYPE
        ]) {
            String clinicianDeleteKey = buildDeleteKey(
                clinicianPayRateCode.Preventive_Care_Agreement__r.ContractPaymentAgreement.Provider_Network_Contract__r.Healthcare_Practitioner_Facility__r.AccountId,
                clinicianPayRateCode.Preventive_Care_Agreement__r.ContractPaymentAgreement.Provider_Network_Contract__r.Healthcare_Practitioner_Facility__r.Facility_Title__c,
                clinicianPayRateCode.Preventive_Care_Agreement__r.Shift__r.Shift_Name__r.Name,
                clinicianPayRateCode.Pay_Code__c
            );
            if (deleteKeys.contains(clinicianDeleteKey)) {
                result.rpcIdWithCPAId.put(clinicianPayRateCode.Id, clinicianPayRateCode.Preventive_Care_Agreement__r.ContractPaymentAgreementId);
                result.clinicianRatePayCodesToDelete.add(clinicianPayRateCode);
                if (!context.clinicianCPAWithUpdateMap.containsKey(clinicianPayRateCode.Preventive_Care_Agreement__r.ContractPaymentAgreementId)) {
                    HPFUpdates__e hpfUpdate = buildHPFUpdate(clinicianPayRateCode.Preventive_Care_Agreement__r.ContractPaymentAgreement);
                    if (hpfUpdate != null) {
                        context.clinicianCPAWithUpdateMap.put(clinicianPayRateCode.Preventive_Care_Agreement__r.ContractPaymentAgreementId, hpfUpdate);
                    }
                }
            }
        }
    }

    /**
     * @description
     * Simple container for client Rate Pay Code change sets used during processing.
     * Fields:
     * - newClientRPCs: client RPCs to clone to clinician PCAs
     * - deleteKeys: composite keys marking client-deleted RPCs to match clinician RPCs
     * - serviceAccounts, facilityTitles, shiftNames, payCodes: filters to bound clinician RPC query
     */
    private class RatePayCodeChanges {
        public List<Rate_Pay_Code__c> newClientRPCs = new List<Rate_Pay_Code__c>();
        public Set<String> deleteKeys = new Set<String>();
        public Set<Id> serviceAccounts = new Set<Id>();
        public Set<Id> facilityTitles = new Set<Id>();
        public Set<String> shiftNames = new Set<String>();
        public Set<Id> payCodes = new Set<Id>();
    }
    
    /**
    * @description
    * Inserts records with partial success handling and returns affected
    * ContractPaymentAgreement Ids.
    *
    * @param records List of SObjects to insert
    * @param objectName Name of the object being inserted
    * @param pcaIdWithCPAId Map of PCA Id to CPA Id
    * @return Set of CPA Ids successfully processed
    */
     private Set<Id> saveRecords(List<SObject> records, String objectName, Map<Id,Id> pcaIdWithCPAId) {
        Set<Id> successfullIds = new Set<Id>();
        if (!records.isEmpty()) {
            Database.SaveResult[] results = Database.insert(records, false);
            for (Integer i = 0; i < results.size(); i++) {
                if (results[i].isSuccess()) {
                    if(objectName.equalsIgnoreCase('PCA')){
                        Id cpaId = (Id)records[i].get('ContractPaymentAgreementId');
                        if (cpaId != null) {
                            successfullIds.add(cpaId);
                        }
                    }
                    else if(objectName.equalsIgnoreCase('Rate Pay Code')){
                        System.debug(logginglevel.INFO+'Successful RatePayCodeId: '+results[i].getId());
                        Id cpaId = pcaIdWithCPAId != null ? pcaIdWithCPAId.get((Id)records[i].get('Preventive_Care_Agreement__c')) : null;
                        if (cpaId != null) {
                            successfullIds.add(cpaId);
                        }
                    }
                } else {
                    System.debug(logginglevel.INFO+'Error inserting ' + objectName + ': ' + results[i].getErrors()[0].getMessage());
                }
            }
        }
        return successfullIds;
    }
    
    /**
     * @description
     * Generic delete method for SObject lists with partial success handling.
     *
     * @param records List of SObjects to delete (e.g., Rate_Pay_Code__c records)
     * @param rpcIdWithCPAId Map of record Id → ContractPaymentAgreement Id, used to emit HPF updates for successful deletions
     * @return Set of CPA Ids for which the deletion succeeded (used to filter platform events)
     */
    private Set<Id> deleteRecords(List<SObject> records, Map<Id,Id> rpcIdWithCPAId) {
        Set<Id> successfullIds = new Set<Id>();
        if (!records.isEmpty()) {
            Database.DeleteResult[] deleteResults = Database.delete(records, false);
            for (Integer i = 0; i < deleteResults.size(); i++) {
                if (deleteResults[i].isSuccess()) {
                    Id cpaId = rpcIdWithCPAId.get((Id)records[i].get('Id'));
                    if (cpaId != null) {
                        successfullIds.add(cpaId);
                    }
                } else {
                    System.debug(logginglevel.INFO+'Error deleting : ' + deleteResults[i].getErrors()[0].getMessage());
                }
            }
        }
        return successfullIds;
    }
    
    /**
    * @description
    * CHANGE: Added updateRecords helper method to handle upserting existing PCAs
    *
    * @param records List of SObjects to update
    * @param objectName Name of the object being updated
    * @return Set of CPA Ids successfully processed
    */
    private Set<Id> updateRecords(List<SObject> records, String objectName) {
        Set<Id> successfullIds = new Set<Id>();
        if (!records.isEmpty()) {
            // Deduplicate by Id to avoid System.ListException: Duplicate id in list
            Map<Id, SObject> recordMap = new Map<Id, SObject>();
            for (SObject rec : records) {
                recordMap.put(rec.Id, rec);
            }
            List<SObject> dedupedRecords = recordMap.values();
            Database.SaveResult[] results = Database.update(dedupedRecords, false);
            for (Integer i = 0; i < results.size(); i++) {
                if (results[i].isSuccess()) {
                    if(objectName.equalsIgnoreCase('PCA')){
                        Id cpaId = (Id)dedupedRecords[i].get('ContractPaymentAgreementId');
                        if (cpaId != null) {
                            successfullIds.add(cpaId);
                        }
                    }
                } else {
                    System.debug(logginglevel.INFO+'Error updating ' + objectName + ': ' + results[i].getErrors()[0].getMessage());
                }
            }
        }
        return successfullIds;
    }
    
    
    /**
    * @description
    * Queries Practice Operation Contract shifts for clinicians by Account and Facility Title.
    * Returns a Set of composite keys (AccountId + FacilityTitle + ShiftName) representing
    * shifts that exist in Practice Operation Contracts.
    *
    * @param accountIds Set of Account Ids
    * @param facilityTitles Set of Facility Title values
    * @return Set of composite keys representing shifts in Practice Operation Contracts
    */
    private Set<String> getPracticeOperationContractShifts(Set<Id> accountIds, Set<Id> facilityTitles) {
        Set<String> practiceOperationShifts = new Set<String>();
        
        if (accountIds.isEmpty() || facilityTitles.isEmpty()) {
            return practiceOperationShifts;
        }
        
        // Query Practice Operation Contracts (Client contracts) for the given accounts
        List<Contract> practiceOperationContracts = [
            SELECT Id, AccountId
            FROM Contract
            WHERE AccountId IN :accountIds
            AND RecordType.DeveloperName = :CLIENT_RECORD_TYPE
            AND Status = :CONTRACT_STATUS_EXECUTED
        ];
        
        if (practiceOperationContracts.isEmpty()) {
            return practiceOperationShifts;
        }
        
        Set<Id> poContractIds = new Set<Id>();
        for (Contract poContract : practiceOperationContracts) {
            poContractIds.add(poContract.Id);
        }
        
        // Query Contract Payment Agreements for Practice Operation Contracts
        List<ContractPaymentAgreement> poCPAs = [
            SELECT Id, ContractId
            FROM ContractPaymentAgreement
            WHERE ContractId IN :poContractIds
            AND Type__c = :SHIFT_TYPE
        ];
        
        if (poCPAs.isEmpty()) {
            return practiceOperationShifts;
        }
        
        Set<Id> poCPAIds = new Set<Id>();
        for (ContractPaymentAgreement poCPA : poCPAs) {
            poCPAIds.add(poCPA.Id);
        }
        
        // Query Preventive Care Agreements to get shifts from Practice Operation Contracts
        for (PreventiveCareAgreement poPCA : [
            SELECT ContractPaymentAgreement.Contract.AccountId,
                   FacilityTitle__c,
                   Shift__r.Shift_Name__r.Name
            FROM PreventiveCareAgreement
            WHERE ContractPaymentAgreementId IN :poCPAIds
            AND FacilityTitle__c IN :facilityTitles
            AND Shift__r.Shift_Name__r.Name != null
            AND Is_Deleted__c = false
        ]) {
            String shiftKey = buildKey(
                poPCA.ContractPaymentAgreement.Contract.AccountId,
                poPCA.FacilityTitle__c,
                poPCA.Shift__r.Shift_Name__r.Name
            );
            practiceOperationShifts.add(shiftKey);
        }
        
        return practiceOperationShifts;
    }
    
    /**
    * @description
    * Checks if a shiftName exists in Practice Operation Contract for the given Account and Facility Title.
    *
    * @param accountId Account identifier
    * @param facilityTitle Facility Title value
    * @param shiftName Shift name to check
    * @param practiceOperationShifts Set of composite keys representing shifts in Practice Operation Contracts
    * @return True if shiftName exists in Practice Operation Contract, false otherwise
    */
    private static Boolean doesShiftExistInPracticeOperationContract(
        Id accountId,
        Id facilityTitle,
        String shiftName,
        Set<String> practiceOperationShifts
    ) {
        if (accountId == null || facilityTitle == null || String.isBlank(shiftName)) {
            return false;
        }
        
        String shiftKey = buildKey(accountId, facilityTitle, shiftName);
        return practiceOperationShifts.contains(shiftKey);
    }
    
    /**
    * @description
    * Builds a composite key using Account, Facility Title, and Shift.
    *
    * @param accountId Account identifier
    * @param facilityTitle Facility Title value
    * @param shiftName Shift name
    * @return Composite key string
    */
    private static String buildKey(Object accountId, Object facilityTitle, Object shiftName) {
        return String.valueOf(accountId) + String.valueOf(facilityTitle) + (shiftName != null ? shiftName : '');
    }

    /**
    * @description
    * Builds a composite delete key using Account, Facility Title,
    * Shift, and Pay Code.
    *
    * @param accountId Account identifier
    * @param facilityTitle Facility Title value
    * @param shiftName Shift name
    * @param payCode Pay Code identifier
    * @return Composite delete key string
    */
    private static String buildDeleteKey(Object accountId, Object facilityTitle, Object shiftName, Object payCode) {
        return buildKey(accountId, facilityTitle, shiftName) + String.valueOf(payCode);
    }

    /**
    * @description
    * Determines the rate value to populate by comparing existing
    * maximum clinician rate with client rate.
    * 
    * Logic:
    * - If shift type exists on Clinician Contract (existingMaxRate != null), use the Clinician rate
    * - If shift type doesn't exist on Clinician Contract (existingMaxRate == null), use the PO Contract rate
    *
    * @param existingMaxRate Existing maximum clinician rate for the shift type (null if shift type doesn't exist)
    * @param clientRate Client rate value from PO Contract
    * @return Rate to populate - Clinician rate if shift type exists, otherwise PO Contract rate
    */
    private static Decimal getRateToPopulate(Decimal existingMaxRate, Decimal clientRate) {
        // If shift type exists on Clinician Contract, use the Clinician rate
        // Otherwise, use the PO Contract rate
		//return (existingMaxRate != null && existingMaxRate > clientRate) ? existingMaxRate : clientRate;
        return (existingMaxRate != null) ? existingMaxRate : clientRate;
    }


    /**
    * @description
    * Determines whether a Rate Pay Code should be cloned to a Clinician PCA
    * based on Facility Rate and clone relationships.
    *
    * @param clinicianPCA Clinician PreventiveCareAgreement
    * @param payRateCode Client Rate Pay Code
    * @return True if the RPC should be cloned, otherwise false
    */
    private static Boolean shouldCloneRatePayCode(
        PreventiveCareAgreement clinicianPCA,
        Rate_Pay_Code__c payRateCode
    ) {
        // Case 1: Clinician PCA is cloned, Facility Rate is null
        if (clinicianPCA.Cloned_From__c != null 
            && clinicianPCA.Facility_Rate__c == null 
            && (clinicianPCA.Cloned_From__r.Facility_Rate__c == payRateCode.Preventive_Care_Agreement__c
                || clinicianPCA.Cloned_From__r.Facility_Rate__c == payRateCode.Preventive_Care_Agreement__r.Cloned_From__c)) {
            return true;
        }

        // Case 2: Clinician PCA has Facility Rate populated
        if (clinicianPCA.Facility_Rate__c != null
            && (clinicianPCA.Facility_Rate__c == payRateCode.Preventive_Care_Agreement__c
                || clinicianPCA.Facility_Rate__c == payRateCode.Preventive_Care_Agreement__r.Cloned_From__c)) {
            return true;
        }

        return false;
    }
    
    
    /**
     * @description Builds and returns an HPFUpdates__e platform event 
     *              populated with details from the given Contract Payment Agreement (CPA).
     *              The event captures key identifiers such as Contract, Facility, and Provider info.
     *
     * @param cpa The ContractPaymentAgreement record for which the HPF update event 
     *            needs to be created. It must have its related Provider_Network_Contract__r 
     *            and Healthcare_Practitioner_Facility__r relationships populated.
     *
     * @return HPFUpdates__e instance with relevant data from the CPA. 
     *         Returns null if required facility details are missing.
     *
     */
    public static HPFUpdates__e buildHPFUpdate(ContractPaymentAgreement cpa) {
        if (cpa.Provider_Network_Contract__r?.Healthcare_Practitioner_Facility__r == null) {return null;}
        
        HPFUpdates__e hpf = new HPFUpdates__e();
        hpf.ContractId__c = cpa.ContractId;
        hpf.GlobalFacilityId__c = String.isNotBlank(cpa.Provider_Network_Contract__r.Healthcare_Practitioner_Facility__r.Account.GlobalFacilityID__c)
            ? Integer.valueOf(cpa.Provider_Network_Contract__r.Healthcare_Practitioner_Facility__r.Account.GlobalFacilityID__c)
            : null;
        hpf.GlobalProviderId__c = String.isNotBlank(cpa.Provider_Network_Contract__r.Healthcare_Practitioner_Facility__r.Practitioner.Global_Provider_ID__c)? Integer.valueOf(cpa.Provider_Network_Contract__r.Healthcare_Practitioner_Facility__r.Practitioner.Global_Provider_ID__c): null;
        hpf.HPFId__c = cpa.Provider_Network_Contract__r.Healthcare_Practitioner_Facility__c;
        hpf.Type__c = RATE_OF_HPF;
        return hpf;
    }

    /**
    * @description
    * Filters HPF update events to include only those related to
    * successfully processed CPAs.
    *
    * @param updates Map of CPA Id to HPFUpdates__e
    * @param processedCPAIds Set of successfully processed CPA Ids
    * @return Filtered HPFUpdates__e map
    */
    private Map<Id, HPFUpdates__e> filterHPFUpdates(Map<Id, HPFUpdates__e> updates, Set<Id> processedCPAIds) {
        Map<Id, HPFUpdates__e> filtered = new Map<Id, HPFUpdates__e>();
        for (Id cpaId : updates.keySet()) {
            if (processedCPAIds.contains(cpaId)) {
                filtered.put(cpaId, updates.get(cpaId));
            }
        }
        return filtered;
    }
    
    /**
     * Result container for Rate Pay Code processing.
     * Aggregates the new PCAs/RPCs to insert as well as RPCs targeted for deletion,
     * and the necessary mappings to determine which CPA Ids were affected.
     */
    public class ClinicianCloneResult {
        public List<PreventiveCareAgreement> newPCAs;
        // CHANGE: Added pcasToUpdate list to capture existing records for update
        public List<PreventiveCareAgreement> pcasToUpdate;
        public List<Rate_Pay_Code__c> newRatePayCodes;
        public List<Rate_Pay_Code__c> clinicianRatePayCodesToDelete;
        public Map<Id,Id> pcaIdWithCPAId;
        public Map<Id,Id> rpcIdWithCPAId;
        
        public ClinicianCloneResult() {
            newPCAs = new List<PreventiveCareAgreement>();
            // CHANGE: Initialized pcasToUpdate
            pcasToUpdate = new List<PreventiveCareAgreement>();
            newRatePayCodes = new List<Rate_Pay_Code__c>();
            clinicianRatePayCodesToDelete = new List<Rate_Pay_Code__c>();
            pcaIdWithCPAId = new Map<Id,Id>();
            rpcIdWithCPAId = new Map<Id,Id>();
        }
    }
    
    
    /**
     * Wrapper class to hold shared context across execute scope processing.
     * Stores:
     * - clinicianCPAWithUpdateMap: CPA Id → HPFUpdates__e to publish for affected CPAs
     * - clinicianCPAMap: composite key (Account+FacilityTitle) → Clinician CPAs
     * - clinicianRatesByCPA: CPA Id → (composite key (Account+FacilityTitle+Shift) → max existing rate)
     * - clinicianRatesByShiftType: CPA Id → (shift type name → max existing rate) - fallback lookup by shift type only
     * - practiceOperationShifts: Set of composite keys (Account+FacilityTitle+Shift) representing shifts in Practice Operation Contracts
     * - clinicianShiftNamesByCPA: CPA Id → Set of shift names (e.g., "Day", "Night") that exist in clinician's contract
     */
    public class ClinicianCloneContext {
        public Map<Id, HPFUpdates__e> clinicianCPAWithUpdateMap;
        public Map<String,List<ContractPaymentAgreement>> clinicianCPAMap;
        public Map<Id, Map<String, Decimal>> clinicianRatesByCPA;
        public Map<Id, Map<String, Decimal>> clinicianRatesByShiftType;
        public Set<String> practiceOperationShifts;
        public Map<Id, Set<String>> clinicianShiftNamesByCPA;

        public ClinicianCloneContext() {
            clinicianCPAWithUpdateMap = new Map<Id, HPFUpdates__e>();
            clinicianCPAMap = new Map<String,List<ContractPaymentAgreement>>();
            clinicianRatesByCPA = new Map<Id, Map<String, Decimal>>();
            clinicianRatesByShiftType = new Map<Id, Map<String, Decimal>>();
            practiceOperationShifts = new Set<String>();
            clinicianShiftNamesByCPA = new Map<Id, Set<String>>();
        }
    }
    
}