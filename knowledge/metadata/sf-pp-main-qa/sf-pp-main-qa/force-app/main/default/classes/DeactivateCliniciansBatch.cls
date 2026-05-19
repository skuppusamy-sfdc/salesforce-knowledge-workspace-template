/**
 * This class takes all the HPF and deactive if it inactive for long period of time
 * 
 * @author Salesforce Services
 * @version 1.0
 * @since 22/08/2025
 * 
 * Modification Logs
 * =================================================================================
 * StoryNumber      DeveloperName       ModifiedDate        Description
 * =================================================================================
 * PR1050558-1580   Tapas               22/08/2025          Created this utility    
 * 
 * =================================================================================
 */
global class DeactivateCliniciansBatch implements Database.Batchable<SObject>, Schedulable {
    
    Set<String> HPFStatus = new Set<String>{'Prospect', 'Candidate', 'Inactive'};
    Date todayDate = System.today();
    private Final String EXECUTED_STATUS = 'Executed';
    private Final String INACTIVE_STATUS = 'Inactive';
    private Final Integer HpfDeadlineDate = Integer.valueOf(System.Label.HpfDeadlineDurationInMonths);
    
    //Schedule the batch
    global void execute(SchedulableContext sc) {
        DeactivateCliniciansBatch batchJob = new DeactivateCliniciansBatch();
        Database.executeBatch(batchJob);
    }
    
    // Start method: defines the scope of records
    global Database.QueryLocator start(Database.BatchableContext bc) {
        
        return Database.getQueryLocator(
            //'Select Id, PersonContactId from Account where PersonContactId IN (Select PractitionerId FROM HealthcarePractitionerFacility Where Status__c NOT IN: HPFStatus)'
            //'Select Id, Status__c, AccountId, Last_Date_Worked__c, Hospital_Privileged_Date__c,Practitioner.AccountId FROM HealthcarePractitionerFacility Where Status__c NOT IN: HPFStatus '
            'Select Id, AccountId From Contact WHERE ID IN ( Select PractitionerId FROM HealthcarePractitionerFacility WHERE Status__c  NOT IN: HPFStatus)'
        );
    }
    
    // Execute method: processes each batch of records
    global void execute(Database.BatchableContext bc, List<Contact> scope) {
        try {
            
            Set<Id> AccountIds = new Set<Id>();
            Set<Id> practionerId = new Set <Id>();
            List <HealthcarePractitionerFacility> sisterSistesHPF;
            List <Contract> sisterSistesContract;
            Map <String, List<HealthcarePractitionerFacility>> AccIdtoHPFMap = new Map <String, List<HealthcarePractitionerFacility>>();
            Set<Id> relatedAccountId = new Set<Id>();
            Map<Id, Set<Id>> accIdAndRelatedAccId = new Map<Id, Set<Id>>();
            Map<String, List<Contract>> AccIdToRltdContractMap = new Map<String, List<Contract>>();
            Map<String, List<Contract>> AccIdToSisContractMap = new Map<String, List<Contract>>();
            Set<Id> caseId = new Set<Id>();
            Map<Id, List<String>> clinicianWithServiceAccIdMap = new Map<Id, List<String>>();
            
            List <HealthcarePractitionerFacility> finalHPFListTpUpdate = new List <HealthcarePractitionerFacility>();
            
            List<Id> relatedAccIdToUpdate = new List<Id>();
            Set <Id> practionerIdToUpdate = new Set <Id>();
            
            List <Account> clinicianLst = new List<Account>();
            
            Integer LWDmonthsDifference ;
            
           
            for (HealthcarePractitionerFacility hpf : [Select Id, Status__c, AccountId, Last_Date_Worked__c, 
                                                       Hospital_Privileged_Date__c,Practitioner.AccountId FROM 
                                                       HealthcarePractitionerFacility WHERE PractitionerId IN: Scope
                                                      AND Status__c NOT IN: HPFStatus]) 
            {
                AccountIds.add(hpf.AccountId);
                practionerId.add(hpf.Practitioner.AccountId);
                if (clinicianWithServiceAccIdMap.containsKey(hpf.Practitioner.AccountId)) {
                    clinicianWithServiceAccIdMap.get(hpf.Practitioner.AccountId).add(hpf.AccountId);
                } else {
                    clinicianWithServiceAccIdMap.put(hpf.Practitioner.AccountId, new List<string>{hpf.AccountId});
                }
                
            }  
            
            //query all sister sites 
            for (AccountAccountRelation aar: [select Id, AccountId,Account.Name, RelatedAccountId, RelatedAccount.Name 
                                              FROM AccountAccountRelation 
                                                WHERE (AccountId IN:AccountIds OR RelatedAccountId IN:AccountIds) 
                                              AND PartyRoleRelation.Name = 'Sister-Sister-AAR' AND IsActive = true]) 
            {
                
                for (String clinicianId : clinicianWithServiceAccIdMap.keySet()) {
                    List <String> listOfServiceAccount = clinicianWithServiceAccIdMap.get(clinicianId);
                    if (listOfServiceAccount.contains(aar.AccountId)) {
                            if (accIdAndRelatedAccId.containskey(aar.AccountId)) {
                                Set <Id> relatedAccId = accIdAndRelatedAccId.get(aar.AccountId);
                                relatedAccId.add((Id)aar.RelatedAccountId);
                                accIdAndRelatedAccId.put(aar.AccountId, relatedAccId);
                                //accIdAndRelatedAccId.put(aar.AccountId, accIdAndRelatedAccId.get(aar.AccountId).add(aar.RelatedAccountId));
                                relatedAccountId.add(aar.RelatedAccountId);
                            } else {
                                accIdAndRelatedAccId.put(aar.AccountId, new Set<Id>{aar.RelatedAccountId});
                                relatedAccountId.add(aar.RelatedAccountId);
                            }
                        }
                    if (listOfServiceAccount.contains(aar.RelatedAccountId)){
                            if (accIdAndRelatedAccId.containskey(aar.RelatedAccountId)) {
                                Set <Id> relatedAccId = accIdAndRelatedAccId.get(aar.RelatedAccountId);
                                relatedAccId.add((Id)aar.AccountId);
                                
                                accIdAndRelatedAccId.put(aar.RelatedAccountId, relatedAccId);
                                //accIdAndRelatedAccId.put(aar.RelatedAccountId, accIdAndRelatedAccId.get(aar.RelatedAccountId).add(aar.AccountId));
                                relatedAccountId.add(aar.AccountId);
                            } else {
                                accIdAndRelatedAccId.put(aar.RelatedAccountId, new Set<Id>{aar.AccountId});
                                relatedAccountId.add(aar.AccountId);
                                
                            }
                        }       
                }
            }
            
            
            //query all sister sites HPF
            for (HealthcarePractitionerFacility sisSiteHPF : [Select id, Status__c, AccountId, Last_Date_Worked__c,
                                                              Hospital_Privileged_Date__c, Practitioner.AccountId
                                                              FROM HealthcarePractitionerFacility 
                                                              Where AccountId IN: relatedAccountId AND 
                                                              Practitioner.AccountId IN: practionerId AND
                                                             Status__c NOT IN: HPFStatus ]) 
                
            {
                String key = sisSiteHPF.AccountId + ':' + sisSiteHPF.Practitioner.AccountId;
                if (AccIdtoHPFMap.containsKey(key)) {
                    AccIdtoHPFMap.get(key).add(sisSiteHPF);
                } else {
                    //String key = sisSiteHPF.AccountId + ':' + sisSiteHPF.Practitioner.AccountId;
                    AccIdtoHPFMap.put(key, new list<HealthcarePractitionerFacility>{sisSiteHPF});
                }
            }
                
            // fetch all the related contract and Sister Sites Contracts
            for (ProviderNetworkContract pnc : [select Id, Contract.Name, Healthcare_Practitioner_Facility__r.Practitioner.AccountId, 
                                                Contract.status, Contract.AccountId, Contract.CompanySignedDate, 
                                                Healthcare_Practitioner_Facility__r.AccountId 
                                                FROM ProviderNetworkContract 
                                                WHERE Contract.RecordType.Name ='Clinician' AND 
                                                Contract.AccountId IN: practionerId AND 
                                                (Healthcare_Practitioner_Facility__r.AccountId IN: relatedAccountId OR
                                                 Healthcare_Practitioner_Facility__r.AccountId IN: AccountIds)
                                                AND Healthcare_Practitioner_Facility__c != null
                                                AND contract.Status =: EXECUTED_STATUS
                                               AND Contract.CompanySignedDate != null]) 
            {
                //fetch all Contracts from parent HPF as well sister Sites HPF
                //create a Map of practioner+serviceAcc with Contract
                String key = pnc.Healthcare_Practitioner_Facility__r.Practitioner.AccountId+':'+pnc.Healthcare_Practitioner_Facility__r.AccountId;
                if(AccountIds.contains(pnc.Healthcare_Practitioner_Facility__r.AccountId)) {
                    if (AccIdToRltdContractMap.containsKey(key)) {
                        AccIdToRltdContractMap.get(key).add(pnc.Contract);
                    } else {
                        AccIdToRltdContractMap.put(key,new list<Contract>{pnc.Contract});
                    }
                }
                if (relatedAccountId.contains(pnc.Healthcare_Practitioner_Facility__r.AccountId)){
                    if (AccIdToSisContractMap.containsKey(key)) {
                        AccIdToSisContractMap.get(key).add(pnc.Contract);
                    } else {
                        AccIdToSisContractMap.put(key,new List<Contract>{pnc.Contract});
                    }
                }
            }
            
            //query for HPF to check condition
            for (HealthcarePractitionerFacility hpf : [Select Id, Name, Status__c, AccountId, Last_Date_Worked__c, 
                                                       Hospital_Privileged_Date__c,Practitioner.AccountId,
                                                       PractitionerId FROM 
                                                       HealthcarePractitionerFacility WHERE PractitionerId IN: Scope
                                                      AND Status__c NOT IN: HPFStatus ]) 
            {
                
                //Scenario 1: last worked date on HPF is not blank and is not active for 12 month 
                if (hpf.Last_Date_Worked__c != null) {
                    sisterSistesHPF = new List <HealthcarePractitionerFacility>();
                    LWDmonthsDifference = (hpf.Last_Date_Worked__c).monthsBetween(todayDate);
                    if (LWDmonthsDifference >= HpfDeadlineDate) {
                        //check for LWD of all sister sites HPF
                        
                        // get the List of sister sites Account
                        Set<Id>sisterSitesAccId = accIdAndRelatedAccId.containsKey(hpf.accountId)?accIdAndRelatedAccId.get(hpf.AccountId):new Set<Id>();
                        //get all SisterSites HPF
                        if (! sisterSitesAccId.IsEmpty()) {
                            
                            for (Id accId : sisterSitesAccId) {
                                String key = accId +':'+hpf.Practitioner.AccountId;
                                if (AccIdtoHPFMap.containsKey(key)) {
                                    sisterSistesHPF.addAll(AccIdtoHPFMap.get(key));
                                }
                                    
                            }
                            
                        }
                        
                        Boolean isInactive = true;
                        if (! sisterSistesHPF.IsEmpty()) {
                            isInactive = checkLWDForSisterSites(sisterSistesHPF);
                        }
                        
                        if (isInactive) {
                            finalHPFListTpUpdate.add(hpf);
                        }
                    } 
                }
                /*Scenario 2: If lWD is blank, then check Company Signed Date for All clinician contract 
                     as well for Sister Sites Contracts as well*/
                
                else if (hpf.Last_Date_Worked__c == null) {
                    List <Contract> relatedContracts = new List <Contract>();
                     sisterSistesContract = new List <Contract>();
                    //check the Company signed date is 12 month for related account
                    Boolean isContractInactive = false;
                    String parentKey = hpf.Practitioner.AccountId +':'+hpf.AccountId;
                    relatedContracts = AccIdToRltdContractMap.containsKey(parentKey) ? AccIdToRltdContractMap.get(parentKey):new List <Contract>();
                    //isContractInactive = AccIdToRltdContractMap.containsKey(parentKey) ? checkLWDForClinicianContracts(AccIdToRltdContractMap.get(parentKey)):false;
                    isContractInactive = (!relatedContracts.IsEmpty()) ? checkLWDForClinicianContracts(relatedContracts) :false;
                    Boolean isSisSideContractInactive = true;
                    if(isContractInactive) {
                        // get the List of sister sites Account
                        Set<Id>sisterSitesAccId = accIdAndRelatedAccId.containsKey(hpf.accountId)?accIdAndRelatedAccId.get(hpf.AccountId):new Set<Id>();
                        // get the List of sister sites Contracts
                        for (Id accId : sisterSitesAccId) {
                            String sisterSitekey = hpf.Practitioner.AccountId +':'+ accId;
                            if (AccIdToSisContractMap.containsKey(sisterSitekey))
                                sisterSistesContract.addAll(AccIdToSisContractMap.get(sisterSitekey));
                        }
                        //check the Company signed date is 12 month for sister site account
                        if (!sisterSistesContract.IsEmpty()) {
                            isSisSideContractInactive = checkLWDForClinicianContracts(sisterSistesContract);
                        }
                        
                        if (isSisSideContractInactive) {
                            finalHPFListTpUpdate.add(hpf);
                        }
                    } else if (relatedContracts.isEmpty() ){
                        sisterSistesHPF = new List <HealthcarePractitionerFacility>();
                        // Scenario 3: If LWD if blank and all contract having Company Signed Date not more than 12 months
                        // check for Hospital Priviledge date
                        Boolean isHPFInactive = false;
                        if (hpf.Hospital_Privileged_Date__c != null && (hpf.Hospital_Privileged_Date__c).monthsBetween(todayDate) >=12) {
                            isHPFInactive = true; 
                            // get the List of sister sites Account
                            Set<Id>sisterSitesAccId = accIdAndRelatedAccId.containsKey(hpf.accountId)?accIdAndRelatedAccId.get(hpf.AccountId):new Set<Id>();
                            //get all SisterSites HPF
                            for (Id accId : sisterSitesAccId) {
                                String key = accId +':'+hpf.Practitioner.AccountId;
                                if (AccIdtoHPFMap.containsKey(key))
                                    sisterSistesHPF.addAll(AccIdtoHPFMap.get(key));
                            }
                            
                        }
                        
                        if (! sisterSistesHPF.IsEmpty()) {
                            isHPFInactive = checkHPDForSisterSites(sisterSistesHPF);
                        }
                        if (isHPFInactive) {
                            finalHPFListTpUpdate.add(hpf);
                        }
                    }
                    
                }
            }
            //Update HPF Status to Inactive
            if (!finalHPFListTpUpdate.isEmpty()) {
                for (HealthcarePractitionerFacility hpf : finalHPFListTpUpdate) {
                    hpf.Status__c = INACTIVE_STATUS;
                    hpf.Credentialling_Status__c = INACTIVE_STATUS;
                    hpf.TerminationDate = hpf.Last_Date_Worked__c;
                    Account acc = new Account(Id=hpf.Practitioner.AccountId, I9_Status__pc = '');
                    if (! relatedAccIdToUpdate.contains(hpf.Practitioner.AccountId))
                        clinicianLst.add(acc);
                        
                    relatedAccIdToUpdate.add(hpf.Practitioner.AccountId);
                    practionerIdToUpdate.add(hpf.PractitionerId);
                }
            }
            if (!finalHPFListTpUpdate.IsEmpty())
                update finalHPFListTpUpdate;
                
            if (!clinicianLst.IsEmpty())
                update clinicianLst;
                
            // Query all open case and related child cases
            List <Case> caseList = [Select Id, Status From Case WHERE (AccountId IN: relatedAccIdToUpdate OR
                                                                       ContactId IN: practionerIdToUpdate)
                                                                       AND Status !='Closed'];
            
            //update case status to Closed
            if (!caseList.isEmpty()) {
                for (Case cse : caseList) {
                    cse.Status = 'Closed';
                    caseId.add(cse.Id);
                }
                update caseList;
            }
            
            //get the child case where accountId is not populated but has parent case
            List<Case> childCaseList = [Select Id, Status From Case WHERE ParentId IN: caseId AND Status !='Closed'];
            if (!childCaseList.isEmpty()) {
                for (Case chCase : childCaseList) {
                    if (! caseId.contains(chCase.Id)) {
                        chCase.Status = 'Closed';
                        caseId.add(chCase.Id);// adding child case Id to set as well
                    }
                }
                update childCaseList;
            }
            
            
            //Query all task related to Clinican, cases, child cases
            List <Task>taskList = [Select Id, Status From Task Where (AccountId IN: relatedAccIdToUpdate 
                                                                      OR WhatId IN: caseId)
                                                                      AND Status ='Open' ];
            
            
            //update task status to Completed
            if (!taskList.isEmpty()) {
                for (Task tsk : taskList) {
                    tsk.Status = 'Completed';
                }
                update taskList;
            }
             
        } Catch (Exception e) {
            System.debug('Exception occured at '+e.getLineNumber()+'--'+e.getMessage());
        }
        
        
    }
    
    /* this method check if all Sister Sites HPF are having LWD more than 12 months*/
    global Boolean checkLWDForSisterSites(List<HealthcarePractitionerFacility> hpfList) {
        Boolean isAllSSHpfInactive = false;
        for (HealthcarePractitionerFacility hpf : hpfList) {
            if (hpf.Last_Date_Worked__c != null && (hpf.Last_Date_Worked__c).monthsBetween(todayDate) >= 12) {
                isAllSSHpfInactive = true;
            } else {
                isAllSSHpfInactive = false;
                break;
            }
        }
        return isAllSSHpfInactive;
    }
    
    /* this method check if all Sister Sites HPF are having Hospital Privileged Date more than 12 months*/
    global Boolean checkHPDForSisterSites(List<HealthcarePractitionerFacility> hpfList) {
        Boolean isAllSSHpfInactive = false;
        for (HealthcarePractitionerFacility hpf : hpfList) {
            if (hpf.Hospital_Privileged_Date__c != null && (hpf.Hospital_Privileged_Date__c).monthsBetween(todayDate) >= HpfDeadlineDate) {
                isAllSSHpfInactive = true;
            } else {
                isAllSSHpfInactive = false;
                break;
            }
        }
        return isAllSSHpfInactive;
    }
    
    
    /* this method check if all contracts are having Company Signed Date more than 12 months*/
    global Boolean checkLWDForClinicianContracts(List<Contract> contrctsList) {
        Boolean isAllContrctsInactive = false;
        for (Contract cntrcts : contrctsList) {
            if (cntrcts.CompanySignedDate != null && (cntrcts.CompanySignedDate).monthsBetween(todayDate) >= HpfDeadlineDate) {
                isAllContrctsInactive = true;
            } else {
                isAllContrctsInactive = false;
                break;
            }
        }
        return isAllContrctsInactive;
    }
    
    
    // Finish method: post-processing logic
    global void finish(Database.BatchableContext bc) {
        
    }
}