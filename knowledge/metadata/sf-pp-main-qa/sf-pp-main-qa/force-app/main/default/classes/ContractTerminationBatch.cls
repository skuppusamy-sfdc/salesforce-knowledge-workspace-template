/**
 * @description
 * Batch class to process Contract terminations. This batch implements the logic from
 * Contract_Termination_Scheduled_Flow directly in Apex and can be scheduled to run daily.
 *
 * Flow Logic Converted:
 * 1. Find Contracts ending today with IC employment type and Clinician record type (NP/PA)
 * 2. Get all HPFs (Healthcare Practitioner Facilities) for the contract
 * 3. Check if HPFs are part of extending contracts
 * 4. Determine cancel reason (Terminated vs Superseded)
 * 5. Check if clinician has active HPFs elsewhere
 * 6. Create SCP Offboarding Case if no active HPFs
 * 7. Update Contract status to Canceled
 * 8. Inactivate HPFs
 * 9. Create Facility Offboarding Cases for each HPF
 * 10. Cancel related Tasks
 *
 * @author Salesforce Developer
 * @date 2026-02-03
 * @since 1.0
 */
public class ContractTerminationBatch implements Database.Batchable<sObject>, Database.Stateful {
    
    private Integer totalProcessed = 0;
    private Integer totalSuccess = 0;
    private Integer totalFailed = 0;
    private List<String> errorMessages = new List<String>();
    
    // Cache for RecordType to avoid repeated queries
    private static Id clinicianOffboardingRecordTypeId = null;
    
    /**
     * @description
     * Start method that queries Contracts matching the flow criteria:
     * - EndDate = TODAY
     * - Employment_Type__c = 'Independent Contractor'
     * - RecordType.DeveloperName = 'Clinician'
     * - Account.Professional_Title__pc = 'NP' OR 'PA'
     *
     * @param bc BatchableContext
     * @return Database.QueryLocator Query locator for Contracts
     */
    public Database.QueryLocator start(Database.BatchableContext bc) {
        Date today = Date.today();
        
        String query = 'SELECT Id, AccountId, Account.PersonContactId, Account.Professional_Title__pc, ' +
                      'RecordType.DeveloperName, EndDate ' +
                      'FROM Contract ' +
                      'WHERE EndDate = :today ' +
                      'AND Employment_Type__c = \'Independent Contractor\' ' +
                      'AND RecordType.DeveloperName = \'Clinician\' ' +
                      'AND (Account.Professional_Title__pc = \'NP\' OR Account.Professional_Title__pc = \'PA\')';
        
        return Database.getQueryLocator(query);
    }
    
    /**
     * @description
     * Execute method that processes each batch of Contracts by implementing the flow logic.
     *
     * @param bc BatchableContext
     * @param scope List of Contract records to process
     */
    public void execute(Database.BatchableContext bc, List<sObject> scope) {
        List<Contract> contractList = new List<Contract>();
        
        // Cast sObjects to Contracts
        for (sObject obj : scope) {
            contractList.add((Contract)obj);
        }
        
        if (contractList.isEmpty()) {
            return;
        }
        
        // Get RecordType (cache it)
        if (clinicianOffboardingRecordTypeId == null) {
            clinicianOffboardingRecordTypeId = getClinicianOffboardingRecordTypeId();
        }
        
        // Collect all Contract IDs and Contact IDs for bulk queries
        Set<Id> contractIds = new Set<Id>();
        Set<Id> contactIds = new Set<Id>();
        Map<Id, Contract> contractMap = new Map<Id, Contract>();
        
        for (Contract contract : contractList) {
            contractIds.add(contract.Id);
            if (contract.Account.PersonContactId != null) {
                contactIds.add(contract.Account.PersonContactId);
            }
            contractMap.put(contract.Id, contract);
        }
        
        // OPTIMIZATION 1: Bulk query all ProviderNetworkContracts for all contracts
        Map<Id, List<ProviderNetworkContract>> contractToPNCMap = new Map<Id, List<ProviderNetworkContract>>();
        Map<Id, Set<Id>> contractToHPFIdsMap = new Map<Id, Set<Id>>();
        Set<Id> allHPFIds = new Set<Id>();
        
        List<ProviderNetworkContract> allPNCs = [
            SELECT Id, Healthcare_Practitioner_Facility__c, ContractId
            FROM ProviderNetworkContract
            WHERE ContractId IN :contractIds
        ];
        
        for (ProviderNetworkContract pnc : allPNCs) {
            if (pnc.Healthcare_Practitioner_Facility__c != null) {
                if (!contractToPNCMap.containsKey(pnc.ContractId)) {
                    contractToPNCMap.put(pnc.ContractId, new List<ProviderNetworkContract>());
                    contractToHPFIdsMap.put(pnc.ContractId, new Set<Id>());
                }
                contractToPNCMap.get(pnc.ContractId).add(pnc);
                contractToHPFIdsMap.get(pnc.ContractId).add(pnc.Healthcare_Practitioner_Facility__c);
                allHPFIds.add(pnc.Healthcare_Practitioner_Facility__c);
            }
        }
        
        // OPTIMIZATION 2: Bulk query all extending contracts for all HPFs
        Date today = Date.today();
        Map<Id, Set<Id>> hpfToExtendingHPFIdsMap = new Map<Id, Set<Id>>();
        
        if (!allHPFIds.isEmpty()) {
            List<ProviderNetworkContract> extendingPNCs = [
                SELECT Id, Healthcare_Practitioner_Facility__c, Contract.StartDate, Contract.Status, Contract.Employment_Type__c
                FROM ProviderNetworkContract
                WHERE Healthcare_Practitioner_Facility__c IN :allHPFIds
                AND Contract.StartDate > :today
                AND Contract.Status = 'Executed'
                AND Contract.Employment_Type__c = 'Independent Contractor'
            ];
            
            for (ProviderNetworkContract pnc : extendingPNCs) {
                if (pnc.Healthcare_Practitioner_Facility__c != null) {
                    if (!hpfToExtendingHPFIdsMap.containsKey(pnc.Healthcare_Practitioner_Facility__c)) {
                        hpfToExtendingHPFIdsMap.put(pnc.Healthcare_Practitioner_Facility__c, new Set<Id>());
                    }
                    hpfToExtendingHPFIdsMap.get(pnc.Healthcare_Practitioner_Facility__c).add(pnc.Healthcare_Practitioner_Facility__c);
                }
            }
        }
        
        // OPTIMIZATION 3: Bulk query all active HPFs for all contacts
        Map<Id, Set<Id>> contactToActiveHPFIdsMap = new Map<Id, Set<Id>>();
        
        if (!contactIds.isEmpty()) {
            List<HealthcarePractitionerFacility> allActiveHPFs = [
                SELECT Id, PractitionerId
                FROM HealthcarePractitionerFacility
                WHERE PractitionerId IN :contactIds
                AND Status__c != 'Inactive'
            ];
            
            for (HealthcarePractitionerFacility hpf : allActiveHPFs) {
                if (!contactToActiveHPFIdsMap.containsKey(hpf.PractitionerId)) {
                    contactToActiveHPFIdsMap.put(hpf.PractitionerId, new Set<Id>());
                }
                contactToActiveHPFIdsMap.get(hpf.PractitionerId).add(hpf.Id);
            }
        }
        
        // OPTIMIZATION 4: Bulk query all HPFs that need to be updated 
        Set<Id> allHPFIdsToUpdate = new Set<Id>();
        Map<Id, HealthcarePractitionerFacility> allHPFsMap = new Map<Id, HealthcarePractitionerFacility>();
        Map<Id, Contract> contractToCancelReasonMap = new Map<Id, Contract>();
        
        if (!allHPFIds.isEmpty()) {
            allHPFsMap = new Map<Id, HealthcarePractitionerFacility>([
                SELECT Id, Name, AccountId, Status__c, EffectiveTo, TerminationDate
                FROM HealthcarePractitionerFacility
                WHERE Id IN :allHPFIds
            ]);
        }
        
        // Process each contract
        for (Contract contract : contractList) {
            try {
                totalProcessed++;
                
                Set<Id> hpfIds = contractToHPFIdsMap.get(contract.Id);
                
                if (hpfIds == null || hpfIds.isEmpty()) {
                    // No HPFs found, skip this contract
                    continue;
                }
                
                // Determine which HPFs are extending
                Set<Id> hpfIdsForExtendingContracts = new Set<Id>();
                for (Id hpfId : hpfIds) {
                    if (hpfToExtendingHPFIdsMap.containsKey(hpfId)) {
                        hpfIdsForExtendingContracts.add(hpfId);
                    }
                }
                
                // Determine which HPFs to update and cancel reason
                Set<Id> hpfIdsToUpdate = new Set<Id>();
                String cancelReason = 'Terminated'; // Default
                
                if (hpfIdsForExtendingContracts.isEmpty()) {
                    // No extending contracts - add all HPFs with 'Terminated'
                    hpfIdsToUpdate.addAll(hpfIds);
                    cancelReason = 'Terminated';
                } else {
                    // Some HPFs are extending - only add non-extending HPFs with 'Superseded'
                    for (Id hpfId : hpfIds) {
                        if (!hpfIdsForExtendingContracts.contains(hpfId)) {
                            hpfIdsToUpdate.add(hpfId);
                            cancelReason = 'Superseded';
                        }
                    }
                }
                
                if (hpfIdsToUpdate.isEmpty()) {
                    continue;
                }
                
                allHPFIdsToUpdate.addAll(hpfIdsToUpdate);
                
                // Check if clinician has active HPFs elsewhere
                Set<Id> activeHPFIds = contactToActiveHPFIdsMap.get(contract.Account.PersonContactId);
                Boolean hasActiveHPF = (activeHPFIds != null && !activeHPFIds.isEmpty());
                
                // Remove HPFs that are being terminated from active HPF check
                if (hasActiveHPF) {
                    Set<Id> remainingActiveHPFs = new Set<Id>(activeHPFIds);
                    remainingActiveHPFs.removeAll(hpfIds);
                    hasActiveHPF = !remainingActiveHPFs.isEmpty();
                }
                
                // Store contract update info
                contract.Status = 'Canceled';
                contract.Cancel_Reason__c = cancelReason;
                contractToCancelReasonMap.put(contract.Id, contract);
                
                totalSuccess++;
                
            } catch (Exception e) {
                totalFailed++;
                String errorMsg = 'Contract Id: ' + contract.Id + ' - Error: ' + e.getMessage();
                errorMessages.add(errorMsg);
                System.debug(LoggingLevel.ERROR, errorMsg);
                System.debug(LoggingLevel.ERROR, e.getStackTraceString());
            }
        }
        
        // Now process all the data we've collected to create Cases
        List<Case> scpCasesToInsert = new List<Case>();
        List<Case> facilityCasesToInsert = new List<Case>();
        List<Contract> contractsToUpdate = new List<Contract>();
        List<HealthcarePractitionerFacility> hpfsToUpdate = new List<HealthcarePractitionerFacility>();
        List<Task> facilityTasksToUpdate = new List<Task>();
        List<Task> scpTasksToUpdate = new List<Task>();
        Set<Id> allCaseIds = new Set<Id>();
        Set<Id> scpCaseIds = new Set<Id>();
        Set<Id> facilityCaseIds = new Set<Id>();
        
        // Create Cases for contracts that need processing
        for (Contract contract : contractToCancelReasonMap.values()) {
            Set<Id> hpfIds = contractToHPFIdsMap.get(contract.Id);
            if (hpfIds != null && !hpfIds.isEmpty()) {
                // Determine which HPFs to update
                Set<Id> hpfIdsForExtendingContracts = new Set<Id>();
                for (Id hpfId : hpfIds) {
                    if (hpfToExtendingHPFIdsMap.containsKey(hpfId)) {
                        hpfIdsForExtendingContracts.add(hpfId);
                    }
                }
                
                Set<Id> hpfIdsToUpdate = new Set<Id>();
                if (hpfIdsForExtendingContracts.isEmpty()) {
                    hpfIdsToUpdate.addAll(hpfIds);
                } else {
                    for (Id hpfId : hpfIds) {
                        if (!hpfIdsForExtendingContracts.contains(hpfId)) {
                            hpfIdsToUpdate.add(hpfId);
                        }
                    }
                }
                
                if (!hpfIdsToUpdate.isEmpty()) {
                    // Check if clinician has active HPFs elsewhere
                    Set<Id> activeHPFIds = contactToActiveHPFIdsMap.get(contract.Account.PersonContactId);
                    Boolean hasActiveHPF = (activeHPFIds != null && !activeHPFIds.isEmpty());
                    
                    if (hasActiveHPF) {
                        Set<Id> remainingActiveHPFs = new Set<Id>(activeHPFIds);
                        remainingActiveHPFs.removeAll(hpfIds);
                        hasActiveHPF = !remainingActiveHPFs.isEmpty();
                    }
                    
                    // Create SCP Offboarding Case if no active HPF
                    if (!hasActiveHPF) {
                        Case scpCase = createSCPOffboardingCase(contract);
                        scpCasesToInsert.add(scpCase);
                    }
                    
                    // Create Facility Offboarding Cases for each HPF
                    for (Id hpfId : hpfIdsToUpdate) {
                        
                        HealthcarePractitionerFacility hpf = allHPFsMap.get(hpfId);
                        System.debug('Hpf--->'+hpf);
                        Case facilityCase = createFacilityOffboardingCase(hpf, contract);
                        facilityCasesToInsert.add(facilityCase);
                    }
                }
            }
        }
        
        // Add contracts to update list
        contractsToUpdate.addAll(contractToCancelReasonMap.values());
        
        // Update HPF fields for inactivation
        if (!allHPFIdsToUpdate.isEmpty()) {
            for (Id hpfId : allHPFIdsToUpdate) {
                HealthcarePractitionerFacility hpf = allHPFsMap.get(hpfId);
                if (hpf != null) {
                    hpf.Status__c = 'Inactive';
                    hpf.EffectiveTo = today;
                    hpf.TerminationDate = today;
                    hpfsToUpdate.add(hpf);
                }
            }
        }
        // Insert Scp Cases
        if (!scpCasesToInsert.isEmpty()) {
            try {
                insert scpCasesToInsert;
                
                // Collect Case IDs for Task updates
                for (Case c : scpCasesToInsert) {
                    scpCaseIds.add(c.Id);
                }
            } catch (Exception e) {
                String errorMsg = 'Error inserting scp Cases: ' + e.getMessage();
                errorMessages.add(errorMsg);
                System.debug(LoggingLevel.ERROR, errorMsg);
            }
        }
        // Insert facility Cases
        if (!facilityCasesToInsert.isEmpty()) {
            try {
                insert facilityCasesToInsert;
                
                // Collect Case IDs for Task updates
                for (Case c : facilityCasesToInsert) {
                    facilityCaseIds.add(c.Id);
                }
            } catch (Exception e) {
                String errorMsg = 'Error inserting facility Cases: ' + e.getMessage();
                errorMessages.add(errorMsg);
                System.debug(LoggingLevel.ERROR, errorMsg);
            }
        }
        
        // Update Contracts
        if (!contractsToUpdate.isEmpty()) {
            try {
                update contractsToUpdate;
            } catch (Exception e) {
                String errorMsg = 'Error updating Contracts: ' + e.getMessage();
                errorMessages.add(errorMsg);
                System.debug(LoggingLevel.ERROR, errorMsg);
            }
        }
        
        // Update HPFs
        if (!hpfsToUpdate.isEmpty()) {
            try {
                update hpfsToUpdate;
            } catch (Exception e) {
                String errorMsg = 'Error updating HPFs: ' + e.getMessage();
                errorMessages.add(errorMsg);
                System.debug(LoggingLevel.ERROR, errorMsg);
            }
        }
        
        //Update Facility task
		try {
                List<Task> tasks = [
                    SELECT Id, Status
                    FROM Task
                    WHERE WhatId IN :facilityCaseIds
                ];
                
                for (Task t : tasks) {
                    t.Status = 'Canceled';
                    facilityTasksToUpdate.add(t);
                }
                
                if (!facilityTasksToUpdate.isEmpty()) {
                    update facilityTasksToUpdate;
                }
            } catch (Exception e) {
                String errorMsg = 'Error updating facility Tasks: ' + e.getMessage();
                errorMessages.add(errorMsg);
                System.debug(LoggingLevel.ERROR, errorMsg);
            }
        //Update scp task
		try {
                List<Task> tasks = [
                    SELECT Id, Status
                    FROM Task
                    WHERE WhatId IN :scpCaseIds
                ];
                
                for (Task t : tasks) {
                    t.Status = 'Canceled';
                    scpTasksToUpdate.add(t);
                }
                
                if (!scpTasksToUpdate.isEmpty()) {
                    update scpTasksToUpdate;
                }
            } catch (Exception e) {
                String errorMsg = 'Error updating scp Tasks: ' + e.getMessage();
                errorMessages.add(errorMsg);
                System.debug(LoggingLevel.ERROR, errorMsg);
            }
    }
    
    
    /**
     * @description
     * Creates SCP Offboarding Case for a Contract.
     *
     * @param contract The Contract record
     * @return Case Case record to insert
     */
    private Case createSCPOffboardingCase(Contract contract) {
        Date today = Date.today();
        
        Case scpCase = new Case();
        scpCase.RecordTypeId = clinicianOffboardingRecordTypeId;
        scpCase.Type = 'SCP';
        scpCase.Subject = 'SCP Offboarding';
        scpCase.AccountId = contract.AccountId;
        scpCase.ContactId = contract.Account.PersonContactId;
        scpCase.Contract__c = contract.Id;
        scpCase.Date_Termination_Received__c = today;
        scpCase.Last_Day__c = today;
        scpCase.Pay_Through_Date__c = today;
        scpCase.Reason_for_Termination__c = 'Contract Termination';
        scpCase.Termination_Request_Date__c = today;
        
        return scpCase;
    }
    
    /**
     * @description
     * Creates Facility Offboarding Case for an HPF.
     *
     * @param hpf The Healthcare Practitioner Facility record
     * @param contract The Contract record
     * @return Case Case record to insert
     */
    private Case createFacilityOffboardingCase(HealthcarePractitionerFacility hpf, Contract contract) {
        Date today = Date.today();
        Case facilityCase = new Case();
        facilityCase.RecordTypeId = clinicianOffboardingRecordTypeId;
        facilityCase.Type = 'Facility';
        facilityCase.AccountId = hpf.AccountId;
        facilityCase.Subject = 'Facility Offboarding-' + hpf.Name;
        facilityCase.ContactId = contract.Account.PersonContactId;
        facilityCase.Date_Termination_Received__c = today;
        facilityCase.Reason_for_Termination__c = 'Contract Termination';
        facilityCase.Last_Day__c = today;
        facilityCase.Pay_Through_Date__c = today;
        facilityCase.Termination_Request_Date__c = today;
        facilityCase.Healthcare_Practitioner_Facility__c = hpf.Id;
        System.debug('facilityCase--->'+facilityCase);
        return facilityCase;
    }
    
    
    /**
     * @description
     * Gets the Clinician Offboarding Case RecordType ID.
     *
     * @return Id RecordType ID, or null if not found
     */
    private Id getClinicianOffboardingRecordTypeId() {
        try {
            List<RecordType> recordTypes = [
                SELECT Id
                FROM RecordType
                WHERE SobjectType = 'Case'
                AND DeveloperName = 'Clinician_Offboarding'
                LIMIT 1
            ];
            
            return recordTypes.isEmpty() ? null : recordTypes[0].Id;
        } catch (Exception e) {
            System.debug(LoggingLevel.WARN, 'Error getting Clinician Offboarding RecordType: ' + e.getMessage());
            return null;
        }
    }
    
    /**
     * @description
     * Finish method that logs the batch execution summary.
     *
     * @param bc BatchableContext
     */
    public void finish(Database.BatchableContext bc) {
        System.debug('=== Contract Termination Batch Summary ===');
        System.debug('Total Processed: ' + totalProcessed);
        System.debug('Total Success: ' + totalSuccess);
        System.debug('Total Failed: ' + totalFailed);
        
        if (!errorMessages.isEmpty()) {
            System.debug('Errors:');
            for (String error : errorMessages) {
                System.debug(error);
            }
        }
    }
}