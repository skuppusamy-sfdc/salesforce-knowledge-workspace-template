/***************************************************************************************************************************
* Class Name    : CreateClientChangeManagementQueueable
* Description   : Queueable class that creates Client Change Management (CCM) records based on Practice Operation Change
*                 records and Healthcare Practitioner Facilities. Matches facilities with contracts and determines
*                 CCM status based on existing Provider Network Contract relationships.
* Author        : Srishty Sharma
* Created Date  : 22-Oct-2025
* Last Modified : 
***************************************************************************************************************************/
public with sharing class CreateClientChangeManagementQueueable implements Queueable {
    
    // Status constants
    private static final String INACTIVE_STATUS = 'Inactive';
    private static final String NEW_STATUS = 'New';
    private static final String CANCELLED_STATUS = 'Canceled';
    
    // Error messages
    private static final String CCM_INSERT_ERROR = 'Error inserting Client Change Management records: ';
    
    private List<Id> contractIds;
    private List<Id> practiceOperationChangeIds;

    /**
     * Constructor for CreateClientChangeManagementQueueable
     * @param contractIds List of Contract IDs to process for CCM creation
     * @param pocIds List of Practice Operation Change IDs to process (can be null)
     */
    public CreateClientChangeManagementQueueable(List<Id> contractIds, List<Id> pocIds) {
        this.contractIds = contractIds;
        this.practiceOperationChangeIds = pocIds != null ? pocIds : new List<Id>();
    }

    /**
     * Executes the queueable job to create Client Change Management records.
     * 
     * This method performs the following operations:
     * 1. Queries Practice Operation Change records based on provided IDs
     * 2. Collects facility title keys for matching with Healthcare Practitioner Facilities
     * 3. Queries Healthcare Practitioner Facilities for matching accounts and facility titles
     * 4. Determines existing Provider Network Contract relationships
     * 5. Creates Client Change Management records with appropriate status assignments
     * 6. Chains ClinicianContractSyncQueueable to synchronize Clinician Contracts
     * 
     * Status Assignment Logic:
     * - 'New': When HPF has existing Provider Network Contract relationship
     * - 'Cancelled': When HPF has no existing Provider Network Contract relationship
     * 
     * @param ctx The QueueableContext provided by the platform
     */
    public void execute(QueueableContext ctx) {
        if (practiceOperationChangeIds.isEmpty()) return;

        // Step 1: Query Practice Operation Change records
        List<Practice_Operation_Change__c> pocs = queryPracticeOperationChanges();
        
        // Step 2: Collect facility title keys and create mapping
        Map<String, List<Practice_Operation_Change__c>> facToPocs = createFacilityToPocMapping(pocs);
        Set<String> facilityTitleKeys = facToPocs.keySet();
        
        if (facilityTitleKeys.isEmpty()) return;
        
        // Step 3: Get account IDs from contracts
        Set<Id> accountIds = getAccountIdsFromContracts();
        
        // Step 4: Query matching Healthcare Practitioner Facilities
        List<HealthcarePractitionerFacility> hpfList = queryHealthcarePractitionerFacilities(accountIds, facilityTitleKeys);
        
        // Step 5: Determine existing Provider Network Contract relationships
        Set<Id> contractExistForHPF = getExistingProviderNetworkContracts(hpfList);
        
        // Step 6: Create Client Change Management records
        List<Client_Change_Management__c> ccmToInsert = createClientChangeManagementRecords(hpfList, facToPocs, contractExistForHPF);
        
        // Step 7: Insert records with error handling
        insertClientChangeManagementRecords(ccmToInsert);
        
        // Step 8: Chain ClinicianContractSyncQueueable job
        // This is chained here to avoid "Too many queueable jobs" governor limit
        enqueueClinicianContractSyncJob();
    }
    
    /**
     * Queries Practice Operation Change records based on the provided IDs.
     * 
     * @return List of Practice Operation Change records
     */
    private List<Practice_Operation_Change__c> queryPracticeOperationChanges() {
        return [
            SELECT Id, Facility_Title__c, Process_Type__c, Contract__c, Contract__r.AccountId
            FROM Practice_Operation_Change__c
            WHERE Id IN :practiceOperationChangeIds
        ];
    }
    
    /**
     * Creates a mapping from facility title to Practice Operation Change record.
     * 
     * @param pocs List of Practice Operation Change records
     * @return Map of facility title to Practice Operation Change record
     */
    private Map<String, List<Practice_Operation_Change__c>> createFacilityToPocMapping(List<Practice_Operation_Change__c> pocs) {
        Map<String, List<Practice_Operation_Change__c>> facToPocs = new Map<String, List<Practice_Operation_Change__c>>();
        for (Practice_Operation_Change__c p : pocs) {
            if(p.Facility_Title__c == null){
                continue;
            }
            if(!facToPocs.containsKey(p.Facility_Title__c)){
                 facToPocs.put(p.Facility_Title__c, new List<Practice_Operation_Change__c>());
            }
            facToPocs.get(p.Facility_Title__c).add(p);
        }
        return facToPocs;
    }
    
    /**
     * Gets account IDs from the provided contract IDs.
     * 
     * @return Set of account IDs
     */
    private Set<Id> getAccountIdsFromContracts() {
        Set<Id> accountIds = new Set<Id>();
        for(Contract cont : [SELECT Id, AccountId FROM Contract WHERE Id IN :contractIds]){
            accountIds.add(cont.AccountId);
        }
        return accountIds;
    }
    
    /**
     * Queries Healthcare Practitioner Facilities for matching accounts and facility titles.
     * 
     * @param accountIds Set of account IDs to filter by
     * @param facilityTitleKeys Set of facility title keys to filter by
     * @return List of matching Healthcare Practitioner Facilities
     */
    private List<HealthcarePractitionerFacility> queryHealthcarePractitionerFacilities(Set<Id> accountIds, Set<String> facilityTitleKeys) {
        return [
            SELECT Id, AccountId, Facility_Title__c, Status__c
            FROM HealthcarePractitionerFacility 
            WHERE AccountId IN :accountIds
              AND Status__c != :INACTIVE_STATUS
              AND Facility_Title__c IN :facilityTitleKeys
        ];
    }
    
    /**
     * Determines which Healthcare Practitioner Facilities have existing Provider Network Contract relationships.
     * 
     * @param hpfList List of Healthcare Practitioner Facilities to check
     * @return Set of HPF IDs that have existing Provider Network Contract relationships
     */
    private Set<Id> getExistingProviderNetworkContracts(List<HealthcarePractitionerFacility> hpfList) {
        Set<Id> contractExistForHPF = new Set<Id>();
        for(ProviderNetworkContract pnc : [
            SELECT Id, Healthcare_Practitioner_Facility__c 
            FROM ProviderNetworkContract 
            WHERE Healthcare_Practitioner_Facility__r.Status__c != :INACTIVE_STATUS 
              AND ContractId != null 
              AND Healthcare_Practitioner_Facility__c IN :hpfList 
            ORDER BY Healthcare_Practitioner_Facility__c
        ]) {
            contractExistForHPF.add(pnc.Healthcare_Practitioner_Facility__c);
        }
        return contractExistForHPF;
    }
    
    /**
     * Creates Client Change Management records based on HPF and POC matching.
     * 
     * @param hpfList List of Healthcare Practitioner Facilities
     * @param facToPoc Map of facility title to Practice Operation Change record
     * @param contractExistForHPF Set of HPF IDs with existing Provider Network Contract relationships
     * @return List of Client Change Management records to insert
     */
    private List<Client_Change_Management__c> createClientChangeManagementRecords(
        List<HealthcarePractitionerFacility> hpfList,
        Map<String, List<Practice_Operation_Change__c>> facToPocs,
        Set<Id> contractExistForHPF) {
        
        List<Client_Change_Management__c> ccmToInsert = new List<Client_Change_Management__c>();
        
        for (HealthcarePractitionerFacility hpf : hpfList) {
            for(Practice_Operation_Change__c matchingPoc : facToPocs.get(hpf.Facility_Title__c)){
                if (matchingPoc.Contract__r.AccountId != hpf.AccountId) continue;
                
                Client_Change_Management__c ccm = new Client_Change_Management__c();
                ccm.Contract__c = matchingPoc.Contract__c;
                ccm.Healthcare_Practitioner_Facility__c = hpf.Id;
                ccm.Process_Type__c = matchingPoc.Process_Type__c;
                ccm.Status__c = contractExistForHPF.contains(hpf.Id) ? NEW_STATUS : CANCELLED_STATUS;
                ccm.Practice_Operation_Change__c = matchingPoc.Id;
                ccmToInsert.add(ccm);
            }
            
        }
        
        return ccmToInsert;
    }
    
    /**
     * Inserts Client Change Management records with error handling.
     * 
     * @param ccmToInsert List of Client Change Management records to insert
     */
    private void insertClientChangeManagementRecords(List<Client_Change_Management__c> ccmToInsert) {
        if (!ccmToInsert.isEmpty()) {
            try {
                insert ccmToInsert;
            } catch (DmlException de) {
                System.debug(CCM_INSERT_ERROR + de.getMessage());
                PracticeOperationChangeUtil.logDmlException(de, 'CreateClientChangeManagementQueueable','insertClientChangeManagementRecords');
            }
        }
    }
    
    /**
     * Enqueues the ClinicianContractSyncQueueable job to synchronize Clinician Contracts.
     * This is chained from CreateClientChangeManagementQueueable to avoid governor limits.
     */
    private void enqueueClinicianContractSyncJob() {
        if (!contractIds.isEmpty() && !Test.isRunningTest()) {
            System.enqueueJob(new ClinicianContractSyncQueueable(contractIds));
        }
    }
}