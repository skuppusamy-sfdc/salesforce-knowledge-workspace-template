/**
 * @description Queueable class to generate new Case records and related CPA Review records.
 * This class processes a list of Collaborative Practice Agreement records, groups them
 * by their Healthcare Practitioner Facility, creates a single Case for each unique
 * facility, and then inserts a CPA Review record to link each CPA to its new Case.
 * 
 * @author : Muskan Jain
 * @version 1.0
 * @see Queueable
 * 
 *  * Modification Logs
 * ================================================================================================================
 * StoryNumber		DeveloperName		ModifiedDate		Description
 * ================================================================================================================
 * PR1050558-6062   Srishty Sharma      11-Mar-2026         Fixed Duplicate Case bug
 *                                                          HPF will be populated on CPA Case
 *                                                          When CPA updates happen then new Case will be created
 * 
 * ================================================================================================================
 */

 public without sharing class CPAReviewCaseGenerator implements Queueable {
    // Instance variables to store the data passed to the constructor.
    private List<Collaborative_Practice_Agreement__c> cpaRecordsToProcess;
    private Id clinicianId;
    private Set<Id> updatedCPAIds;
    
    /**
     * @description Initializes the Queueable job with the CPA records and Clinician Id.
     * @param cpaRecords The list of Collaborative_Practice_Agreement__c records to be processed.
     * @param clinicianId The Id of the clinician (PersonAccount ContactId) associated with these agreements.
     */
    public CPAReviewCaseGenerator(List<Collaborative_Practice_Agreement__c> cpaRecords, Id clinicianId) {
        this.cpaRecordsToProcess = cpaRecords;
        this.clinicianId = clinicianId;
        this.updatedCPAIds = new Set<Id>();
    }
    
    /**
     * @description Initializes the Queueable job with the CPA records, Clinician Id, and updated CPA IDs.
     * @param cpaRecords The list of Collaborative_Practice_Agreement__c records to be processed.
     * @param clinicianId The Id of the clinician (PersonAccount ContactId) associated with these agreements.
     * @param updatedCPAIds Set of CPA IDs that were updated (not newly created).
     */
    public CPAReviewCaseGenerator(List<Collaborative_Practice_Agreement__c> cpaRecords, Id clinicianId, Set<Id> updatedCPAIds) {
        this.cpaRecordsToProcess = cpaRecords;
        this.clinicianId = clinicianId;
        this.updatedCPAIds = updatedCPAIds != null ? updatedCPAIds : new Set<Id>();
    }
    
    /**
     * @description The main execution method for the Queueable job. It orchestrates the creation of Case and
     * CPA Review records in a bulk-safe manner.
     * @param context The QueueableContext provided by the Apex runtime.
     */
    public void execute(QueueableContext context) {
        List<Case> listCPACase = new List<Case>();
        List<CPA_Review__c> cpaReviewsToInsert = new List<CPA_Review__c>();
        try {
            if (cpaRecordsToProcess == null || cpaRecordsToProcess.isEmpty() || clinicianId == null) {
                return;
            }
            
            Set<Id> allHPFIds = new Set<Id>();
            for (Collaborative_Practice_Agreement__c cpa : cpaRecordsToProcess) {
                if (cpa.Physician_Healthcare_Facility__c != null) {
                    allHPFIds.add(cpa.Physician_Healthcare_Facility__c);
                }
                if (cpa.NP_PA_Healthcare_Practitioner_Facility__c != null) {
                    allHPFIds.add(cpa.NP_PA_Healthcare_Practitioner_Facility__c);
                }
            }
            
            // No need to query existing CPA Reviews - we'll create new ones for all CPAs (updated and new)
            
            Map<Id, HealthcarePractitionerFacility> hpfMap = new Map<Id, HealthcarePractitionerFacility>([
                SELECT Id, AccountId, Account.Name, PractitionerId
                FROM HealthcarePractitionerFacility
                WHERE Id IN :allHPFIds
            ]);
            
            Set<Id> allFacilityAccountIds = new Set<Id>();
            for (HealthcarePractitionerFacility hpf : hpfMap.values()) {
                if (hpf.AccountId != null) {
                    allFacilityAccountIds.add(hpf.AccountId);
                }
            }
            
            Map<Id, Id> accountIdToCaseOwnerMap = new Map<Id, Id>();
            if (!allFacilityAccountIds.isEmpty()) {
                List<AccountTeamMember> accountTeamMembers = [
                    SELECT AccountId, UserId
                    FROM AccountTeamMember
                    WHERE TeamMemberRole = 'Medical Staff Liaison - CPA'
                    AND AccountId IN :allFacilityAccountIds
                ];
                for (AccountTeamMember atm : accountTeamMembers) {
                    accountIdToCaseOwnerMap.put(atm.AccountId, atm.UserId);
                }
            }
            
            Map<Id, Set<Id>> mapCPACase = new Map<Id, Set<Id>>();
            Map<Id, Case> facilityIdToCaseMap = new Map<Id, Case>();
            Map<Id, Id> serviceAccountToClinicianHPFMap = new Map<Id, Id>();
            
            for (Collaborative_Practice_Agreement__c cpa : cpaRecordsToProcess) {
                Id hpfId = cpa.Physician_Healthcare_Facility__c;
                
                if (hpfId == null || !hpfMap.containsKey(hpfId)) continue;
                
                HealthcarePractitionerFacility hpf = hpfMap.get(hpfId);
                Id serviceAccountId = hpf.AccountId;
                
                // Identify which HPF belongs to the clinician
                if (!serviceAccountToClinicianHPFMap.containsKey(serviceAccountId)) {
                    HealthcarePractitionerFacility physicianHPF = hpfMap.get(cpa.Physician_Healthcare_Facility__c);
                    HealthcarePractitionerFacility nppaHPF = hpfMap.get(cpa.NP_PA_Healthcare_Practitioner_Facility__c);
                    
                    if (physicianHPF != null && physicianHPF.PractitionerId == this.clinicianId) {
                        serviceAccountToClinicianHPFMap.put(serviceAccountId, cpa.Physician_Healthcare_Facility__c);
                    } else if (nppaHPF != null && nppaHPF.PractitionerId == this.clinicianId) {
                        serviceAccountToClinicianHPFMap.put(serviceAccountId, cpa.NP_PA_Healthcare_Practitioner_Facility__c);
                    }
                }
                
                if (facilityIdToCaseMap.containsKey(serviceAccountId)) {
                    mapCPACase.get(serviceAccountId).add(cpa.Id);
                } else {
                    Case newCase = new Case();
                    newCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Collaborative Practice Agreement').getRecordTypeId();
                    newCase.Subject = 'Collaborative Practice Agreement - ' + (hpf.Account?.Name != null ? hpf.Account.Name : '');
                    newCase.Type = 'Collaborative Practice Agreement';
                    newCase.Status = 'Not Started';
                    newCase.Priority = 'Medium';
                    newCase.ContactId = this.clinicianId;
                    newCase.AccountId = serviceAccountId;
                    newCase.Healthcare_Practitioner_Facility__c = serviceAccountToClinicianHPFMap.get(serviceAccountId);
                    
                    if (accountIdToCaseOwnerMap.containsKey(serviceAccountId)) {
                        newCase.OwnerId = accountIdToCaseOwnerMap.get(serviceAccountId);
                    }
                    
                    listCPACase.add(newCase);
                    facilityIdToCaseMap.put(serviceAccountId, newCase);
                    
                    Set<Id> cpaIdSet = new Set<Id>();
                    cpaIdSet.add(cpa.Id);
                    mapCPACase.put(serviceAccountId, cpaIdSet);
                }
            }
            
            if (!listCPACase.isEmpty()) {
                insert listCPACase;
                
                // Add a temporary map to link the newly created Case ID back to the Service Account ID
                Map<Id, Id> caseIdToServiceAccountIdMap = new Map<Id, Id>();
                for(Id serviceAccountId : facilityIdToCaseMap.keySet()) {
                    Case insertedCase = facilityIdToCaseMap.get(serviceAccountId);
                    // Explicitly check for null before accessing the Id
                    if (insertedCase != null && insertedCase.Id != null) {
                        caseIdToServiceAccountIdMap.put(insertedCase.Id, serviceAccountId);
                    }
                }
                
                // This loop can safely use the list of cases that were successfully inserted
                for (Case c : listCPACase) {
                    // Check if the case was successfully inserted and added to the map
                    if (caseIdToServiceAccountIdMap.containsKey(c.Id)) {
                        Id serviceAccountId = caseIdToServiceAccountIdMap.get(c.Id);
                        Set<Id> cpaIds = mapCPACase.get(serviceAccountId);
                        if (cpaIds != null) {
                            for (Id cpaId : cpaIds) {
                                // CREATE new CPA Review for all CPAs (both updated and new)
                                cpaReviewsToInsert.add(new CPA_Review__c(
                                    Collaborative_Practice_Agreement__c = cpaId,
                                    Case__c = c.Id
                                ));
                            }
                        }
                    }
                }
                
                if (!cpaReviewsToInsert.isEmpty()) {
                    insert cpaReviewsToInsert;
                }
                ErrorLogUtil.logException(
                    null,
                    'CPAReviewCaseGenerator.execute ',
                    String.valueOf(clinicianId),
                    null,
                    getLogContextJson(listCPACase, cpaReviewsToInsert)
                );
            }
        } catch(Exception e) {
            ErrorLogUtil.logException(e,'CPAReviewCaseGenerator.execute',String.valueOf(clinicianId),
                                      null,getLogContextJson(listCPACase, cpaReviewsToInsert));
            throw e;
        }
    }

    private String getLogContextJson(
        List<Case> listCPACase,
        List<CPA_Review__c> cpaReviewsToInsert
    ) {
        return JSON.serialize(new Map<String, Object>{
            'clinicianId' => clinicianId,
            'caseRecordsToInsert' => listCPACase,
            'cpaReviewRecordsToInsert' => cpaReviewsToInsert
        });
    }
}