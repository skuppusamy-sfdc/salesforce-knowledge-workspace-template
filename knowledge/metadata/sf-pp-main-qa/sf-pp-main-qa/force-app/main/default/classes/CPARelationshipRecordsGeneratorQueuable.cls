/**
 * @description Queueable class to generate and update Collaborative Practice Agreement (CPA)
 * records based on Provider Network Contracts (PNCs). This class processes a given
 * Contract and identifies associated clinicians to create or update their CPAs.
 * @author Muskan Jain
 * @version 1.0
 * @see Queueable
 *  
 * 
 * Modification Logs
 * =================================================================================
 * StoryNumber		DeveloperName		ModifiedDate		Description
 * =================================================================================
 * PR1050558-146	Muskan Jain		08/26/2025			CPA creation logic changed
 * PR1050558-1655   Muskan Jain     08/26/2025          CPA creation logic changed
 * PR1050558-6062   Srishty Sharma  03/11/2026          Added Delete check on PNC Query                                                     
 * =================================================================================
 */
public without sharing class CPARelationshipRecordsGeneratorQueuable implements Queueable {

    private Id contractId;
    private static final String MD_STRING = 'MD';
    private static final String DO_STRING = 'DO';
    private static final String NP_STRING = 'NP';
    private static final String PA_STRING = 'PA';
    private static final String PHYSICIAN = 'Physician';
    private static final String PENDING = 'Pending';
    private String scenario;
    
    public CPARelationshipRecordsGeneratorQueuable(Id contractId) {
        this.contractId = contractId;
    }
    /**
     * @description The main execution method for the Queueable job. It queries PNC records
     * related to the Contract, determines the appropriate scenario (Physician or NP/PA),
     * and orchestrates the creation and/or update of CPA records.
     * @param context The QueueableContext provided by the Apex runtime.
     */
    public void execute(QueueableContext context) {
        Id clinicianId;
        List<Collaborative_Practice_Agreement__c> cpaRecordsToUpdate = new List<Collaborative_Practice_Agreement__c>();
        List<Collaborative_Practice_Agreement__c> cpaRecordsToInsert = new List<Collaborative_Practice_Agreement__c>();
        try {
            //Query all Provider Network Contracts related to the main contract
            List<ProviderNetworkContract> allPncList = [
                SELECT Id, ContractId, Healthcare_Practitioner_Facility__c,
                Healthcare_Practitioner_Facility__r.PractitionerId,
                Healthcare_Practitioner_Facility__r.AccountId,
                Contract.AccountId,
                Contract.Account.Professional_Title__pc,
                Contract.Clinician__c
                FROM ProviderNetworkContract
                WHERE ContractId = :contractId AND Deleted__c !=true
            ];
            

            if(allPncList != null && !allPncList.isEmpty()){
                //Map<AccountId, HPFId > AccountId - Service Account
                Map<Id, Id> contractingAccountIdHPFId = new Map<Id, Id>();
                for(ProviderNetworkContract pnc : allPncList) {
                    if(pnc.Healthcare_Practitioner_Facility__c != null && pnc.Healthcare_Practitioner_Facility__r.AccountId !=null){
                        contractingAccountIdHPFId.put(pnc.Healthcare_Practitioner_Facility__r.AccountId, pnc.Healthcare_Practitioner_Facility__c);
                    }
                }
                Set<Id> contractingAccountId = contractingAccountIdHPFId.keySet();
                
                if(allPncList[0].Healthcare_Practitioner_Facility__c != null && allPncList[0].Healthcare_Practitioner_Facility__r.PractitionerId !=null){
                    clinicianId = allPncList[0].Healthcare_Practitioner_Facility__r.PractitionerId;
                }

                String professionalTitle = allPncList[0]?.Contract?.Account?.Professional_Title__pc;

                if (professionalTitle != null) {
                    if(professionalTitle == MD_STRING || professionalTitle == DO_STRING) {
                            this.scenario = PHYSICIAN;
                    }
                    else if(professionalTitle == NP_STRING || professionalTitle == PA_STRING) {
                            this.scenario = 'NPPA';
                    }
                }

                if(contractingAccountId !=null && !contractingAccountId.isEmpty()){
                    List<Collaborative_Practice_Agreement__c> existingCPAs = this.retrieveExistingCPAs(clinicianId,contractingAccountId);
                    // Query all CPA records related to the clinician and contracting accounts
                    // Retrieve existing CPA records and update them.
                    cpaRecordsToUpdate = this.updateCPAs(existingCPAs,contractingAccountId,contractingAccountIdHPFId);
                    
                    Set<Id> otherCliniciansCPAsHPFsIdSet = this.getOtherCliniciansCPAsHPFsIdSet(existingCPAs);
                    // If there are still Service Accounts in the set, create new CPAs for them.
                    cpaRecordsToInsert = this.createCPAs(this.getServiceAccToOtherClinicianHPFids(contractingAccountId, otherCliniciansCPAsHPFsIdSet), contractingAccountIdHPFId);
                    
                    // Track which CPA IDs were updated BEFORE upsert
                    Set<Id> updatedCPAIds = new Set<Id>();
                    for (Collaborative_Practice_Agreement__c cpa : cpaRecordsToUpdate) {
                        if (cpa.Id != null) {
                            updatedCPAIds.add(cpa.Id);
                        }
                    }
                    
                    List<Collaborative_Practice_Agreement__c> cpaRecordsToUpsert = new List<Collaborative_Practice_Agreement__c>();
                    cpaRecordsToUpsert.addAll(cpaRecordsToUpdate);
                    cpaRecordsToUpsert.addAll(cpaRecordsToInsert);
                    
                    if(cpaRecordsToUpsert !=null && !cpaRecordsToUpsert.isEmpty() && clinicianId != null){
                        upsert cpaRecordsToUpsert;
                        
                        // Re-query full CPA records with all fields after upsert
                        Set<Id> allCPAIds = new Set<Id>();
                        for (Collaborative_Practice_Agreement__c cpa : cpaRecordsToUpsert) {
                            allCPAIds.add(cpa.Id);
                        }
                        
                        List<Collaborative_Practice_Agreement__c> fullCPARecords = [
                            SELECT Id, Physician_Healthcare_Facility__c, NP_PA_Healthcare_Practitioner_Facility__c,
                                   Supervision_Collaboration_Status__c
                            FROM Collaborative_Practice_Agreement__c
                            WHERE Id IN :allCPAIds
                        ];
                        
                        // Enqueue the next job to generate Case and CPA Review records.
                        if(!Test.isRunningTest()){
                            System.enqueueJob(new CPAReviewCaseGenerator(fullCPARecords, clinicianId, updatedCPAIds));
                        }
                        ErrorLogUtil.logException(
                            null,
                            'CPARelationshipRecordsGeneratorQueuable.execute',
                            String.valueOf(contractId),
                            null,
                            getLogContextJson(clinicianId, cpaRecordsToUpdate, cpaRecordsToInsert)
                        );
                    }
                }
            }
        } catch (Exception e) {
            ErrorLogUtil.logException(
                e,
                'CPARelationshipRecordsGeneratorQueuable.execute',
                String.valueOf(contractId),
                null,
                getLogContextJson(clinicianId, cpaRecordsToUpdate, cpaRecordsToInsert)
            );
            throw e;
        }
    }

    private String getLogContextJson(
        Id clinicianId,
        List<Collaborative_Practice_Agreement__c> cpaRecordsToUpdate,
        List<Collaborative_Practice_Agreement__c> cpaRecordsToInsert
    ) {
        return JSON.serialize(new Map<String, Object>{
            'contractId' => contractId,
            'clinicianId' => clinicianId,
            'scenario' => this.scenario,
            'cpaRecordsToUpdate' => cpaRecordsToUpdate,
            'cpaRecordsToInsert' => cpaRecordsToInsert
        });
    }

    private Set<Id> getOtherCliniciansCPAsHPFsIdSet(List<Collaborative_Practice_Agreement__c> existingCPAs){
        Set<Id> otherCliniciansCPAsHPFsIdSet = new Set<Id>();

        if(existingCPAs != null && !existingCPAs.isEmpty()){
            for (Collaborative_Practice_Agreement__c cpa : existingCPAs) {
                // set of  NP_PA_Healthcare_Practitioner_Facility__r or Physician_Healthcare_Facility__c based on scenario of other clinician
                if(this.scenario == PHYSICIAN){
                    otherCliniciansCPAsHPFsIdSet.add(cpa.NP_PA_Healthcare_Practitioner_Facility__c);
                }else{
                    otherCliniciansCPAsHPFsIdSet.add(cpa.Physician_Healthcare_Facility__c);
                }
            }
        }

        return otherCliniciansCPAsHPFsIdSet;
    }
        
    /**
     * @description Queries for existing CPA records related to the given Clinician and Service Accounts.
     * @param clinicianId The Id of the Clinician (Physician or NP/PA).
     * @param scenario The professional scenario ('Physician' or 'NPPA').
     * @param contractingAccountId A Set of Service Account Ids.
     * @return A List of existing Collaborative_Practice_Agreement__c records.
     */
    private List<Collaborative_Practice_Agreement__c> retrieveExistingCPAs(Id clinicianId,  Set<Id> contractingAccountId) {
        String cpaPractitionerFieldToQueryBy = ( this.scenario == PHYSICIAN )
            ? 'Physician_Healthcare_Facility__r.PractitionerId'
            : 'NP_PA_Healthcare_Practitioner_Facility__r.PractitionerId';
        
        String cpaQuery = 'SELECT Id, Physician_Healthcare_Facility__c, NP_PA_Healthcare_Practitioner_Facility__c, ' +
            '       Physician_Healthcare_Facility__r.AccountId, NP_PA_Healthcare_Practitioner_Facility__r.AccountId, ' +
            '       Physician_Healthcare_Facility__r.PractitionerId, NP_PA_Healthcare_Practitioner_Facility__r.PractitionerId ' +
            'FROM Collaborative_Practice_Agreement__c ' +
            'WHERE Physician_Healthcare_Facility__r.AccountId IN :contractingAccountId AND ' + cpaPractitionerFieldToQueryBy + ' = :clinicianId';
        List<Collaborative_Practice_Agreement__c> existingCPAs = Database.query(cpaQuery);
        
        return existingCPAs;
    }
	
    /**
     * @description Updates a list of existing CPA records with new HPF Ids if a change is detected.
     * @param existingCPAs A list of existing CPA records to check for updates.
     * @param scenario The professional scenario.
     * @param contractingAccountId A Set of Service Account Ids. This set is modified within the method.
     * @param contractingAccountIdHPFId A Map linking Service Account Ids to HPF Ids. This map is modified within the method.
     * @return A List of CPA records that need to be updated.
     */
    private List<Collaborative_Practice_Agreement__c> updateCPAs(List<Collaborative_Practice_Agreement__c> existingCPAs,  Set<Id> contractingAccountId, Map<Id, Id> contractingAccountIdHPFId) {
        List<Collaborative_Practice_Agreement__c> cpaRecordsToUpdate = new List<Collaborative_Practice_Agreement__c>();
        
        if(existingCPAs != null && !existingCPAs.isEmpty()){
            for (Collaborative_Practice_Agreement__c cpa : existingCPAs) {
                // this can be NP_PA_Healthcare_Practitioner_Facility__r or Physician_Healthcare_Facility__c as both have same accountId/Service Account
                Id serviceAccountId =  cpa.NP_PA_Healthcare_Practitioner_Facility__r?.AccountId ;
                Id currentHPFIdInCPA = (this.scenario == PHYSICIAN) ? cpa.Physician_Healthcare_Facility__c : cpa.NP_PA_Healthcare_Practitioner_Facility__c;
                
                if(serviceAccountId != null){
                    Id newHPFIdFromPNC = contractingAccountIdHPFId.get(serviceAccountId);
					// If a change in HPF is detected, prepare the record for update.
                    if(newHPFIdFromPNC != currentHPFIdInCPA){
                        Collaborative_Practice_Agreement__c cpaToUpdate = new Collaborative_Practice_Agreement__c(Id = cpa.Id);
                        cpaToUpdate.Supervision_Collaboration_Status__c = 'Pending';
                        if (this.scenario == PHYSICIAN) {
                            cpaToUpdate.Physician_Healthcare_Facility__c = newHPFIdFromPNC;
                        } else {
                            cpaToUpdate.NP_PA_Healthcare_Practitioner_Facility__c = newHPFIdFromPNC;
                            cpaToUpdate.Physician_Healthcare_Facility__c = cpa.Physician_Healthcare_Facility__c;
                        }
                        cpaRecordsToUpdate.add(cpaToUpdate);
                    }
                }
            }
        }
        
        return cpaRecordsToUpdate;
    }

    /**
     * @description Queries for HPFs of other clinicians (not in the primary scenario)
     * that are associated with the given Service Accounts.
     * @param contractingAccountId A Set of Service Account Ids to query against.
     * @param scenario The professional scenario of the primary clinician.
     * @return A Map linking Service Account Ids to a list of other clinicians' HPF Ids.
     */
    private  Map<Id, List<Id>> getServiceAccToOtherClinicianHPFids(Set<Id> contractingAccountId, Set<Id> otherCliniciansCPAsHPFsIdSet) {
        Map<Id, List<Id>> serviceAccToOtherClinicianHPFidsMap = new Map<Id, List<Id>>();
        Map<Id, Id> hpfIdToOtherAccountIdMap = new Map<Id, Id>();
        if(!contractingAccountId.isEmpty()) {
            // Determine the titles of the other clinicians based on the scenario.
            Set<String> otherPractitionerTitles = (this.scenario == PHYSICIAN) ? new Set<String>{NP_STRING, PA_STRING} : new Set<String>{MD_STRING, DO_STRING};
            
            // Query for PNCs of the other type of clinician.
            List<ProviderNetworkContract> otherPNCs = [
                SELECT Healthcare_Practitioner_Facility__c, Healthcare_Practitioner_Facility__r.AccountId, Contract.StartDate
                FROM ProviderNetworkContract
                WHERE Healthcare_Practitioner_Facility__r.Practitioner.Professional_Title__c IN :otherPractitionerTitles
                  AND Contract.Status = 'Executed' AND Healthcare_Practitioner_Facility__r.Status__c IN ('Prospect', 'Candidate', 'Waiting to be Scheduled', 'Active', 'WTBS Here-WRKG at Sister Site')
                  AND Healthcare_Practitioner_Facility__r.AccountId IN :contractingAccountId AND Healthcare_Practitioner_Facility__c NOT IN : otherCliniciansCPAsHPFsIdSet
                  AND Deleted__c = False
                ORDER BY Contract.StartDate ASC
            ];
            
            // Map the HPF Ids to their corresponding Service Account Ids.
            for (ProviderNetworkContract pnc : otherPNCs) {
                hpfIdToOtherAccountIdMap.put(pnc.Healthcare_Practitioner_Facility__c, pnc.Healthcare_Practitioner_Facility__r.AccountId);
            }
        }
		
        // Group the HPF Ids by their Service Account Id.
        if(hpfIdToOtherAccountIdMap != null && !hpfIdToOtherAccountIdMap.isEmpty()){
            for(Id hpfId : hpfIdToOtherAccountIdMap.keySet()){
                // Initialize the list for the Service Account if it doesn't exist.
                if (!serviceAccToOtherClinicianHPFidsMap.containsKey(hpfIdToOtherAccountIdMap.get(hpfId))) {
                    serviceAccToOtherClinicianHPFidsMap.put(hpfIdToOtherAccountIdMap.get(hpfId), new List<Id>());
                }
                serviceAccToOtherClinicianHPFidsMap.get(hpfIdToOtherAccountIdMap.get(hpfId)).add(hpfId);
            }
        }
        return serviceAccToOtherClinicianHPFidsMap;
    }

    /**
     * @description Creates new CPA records for the remaining unmatched HPFs.
     * @param serviceAccToOtherClinicianHPFidsMap A map of Service Account Ids to other clinician HPF Ids.
     * @param scenario The professional scenario of the primary clinician.
     * @param contractingAccountIdHPFIdMap A map of Service Account Ids to the primary clinician's HPF Ids.
     * @return A List of new CPA records to be inserted.
     */
    private List<Collaborative_Practice_Agreement__c> createCPAs(Map<Id, List<Id>> serviceAccToOtherClinicianHPFidsMap, Map<Id, Id> contractingAccountIdHPFId) {
        List<Collaborative_Practice_Agreement__c> cpaRecordsToInsert = new List<Collaborative_Practice_Agreement__c>();
        if(serviceAccToOtherClinicianHPFidsMap != null && !serviceAccToOtherClinicianHPFidsMap.isEmpty()){
            for(Id accountId : serviceAccToOtherClinicianHPFidsMap.keySet()){
                List<Id> otherClinicianHPFidsList = serviceAccToOtherClinicianHPFidsMap.get(accountId);
                Id contractingHPFId = contractingAccountIdHPFId.get(accountId);
                if(otherClinicianHPFidsList != null && !otherClinicianHPFidsList.isEmpty()){
                    for(Id otherHPFId : otherClinicianHPFidsList) {
                        Collaborative_Practice_Agreement__c newCpa = new Collaborative_Practice_Agreement__c();
                        if (this.scenario == PHYSICIAN) {
                            newCpa.Physician_Healthcare_Facility__c = contractingHPFId;
                            newCpa.NP_PA_Healthcare_Practitioner_Facility__c = otherHPFId;
                        } else {
                            newCpa.Physician_Healthcare_Facility__c = otherHPFId;
                            newCpa.NP_PA_Healthcare_Practitioner_Facility__c = contractingHPFId;
                        }
                        newCpa.Supervision_Collaboration_Status__c = PENDING;
                        cpaRecordsToInsert.add(newCpa);
                    }
                }
            }
        }
        return cpaRecordsToInsert;
    }
    
}