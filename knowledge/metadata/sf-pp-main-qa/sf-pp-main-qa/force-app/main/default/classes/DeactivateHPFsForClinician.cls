/**
* This class takes all the HPF and deactive if it inactive for long period of time
* 
* @author Salesforce Services
* @version 1.0
* @since 30/03/2026
* 
* Modification Logs
* =================================================================================
* StoryNumber      DeveloperName       ModifiedDate        Description
* =================================================================================
* PR1050558-5641   Tapas               30/03/2026          Created this utility    
* 
* =================================================================================
*/
global class DeactivateHPFsForClinician implements Database.Batchable<SObject>, Database.Stateful {
    
    Set<String> hpfStatus = new Set<String>{'Prospect', 'Candidate', 'Superseded', 'Inactive'};
        Date todayDate = System.today();
    private Set<Id> accountIdsForEmail = new Set<Id>();
    private Set<Id> inactiveHpfIds = new Set<Id>();
    private Set<Id> warningHpfIds = new Set<Id>();
    private Final Integer hpf270DeadlineDate = 270;
    private Final Integer hpf365DeadlineDate = 365;
    
    // Start method: defines the scope of records
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator(
            'Select Id, AccountId From Contact WHERE ID IN ( Select PractitionerId FROM HealthcarePractitionerFacility WHERE Status__c  NOT IN: hpfStatus)'
        );
    }
    // Execute method: processes each batch of records
    global void execute(Database.BatchableContext bc, List<Contact> scope) {
        try {
            Set<Id> HPFId = new Set<Id>();
            Set<Id> practitionerIds = new Set<Id>();
            List<Account> practionerToUpdate = new List<Account>();
            Set<Id> accIds = new Set<Id>();
            Set<Id> caseId = new Set<Id>();
            
            Map<String, Date> ClinicianToSisterSiteGrpToLWD = new Map<String, Date>();
            Map<String, Date> ClinicianToSisterSiteGrpToPNSD = new Map<String, Date>();
            Map<String, Date> ClinicianToSisterSiteGrpToHPD = new Map<String, Date>();
            Map<String, Date> ClinicianToCntrctInitialEffDate = new Map<String, Date>();
            
            
            SisterSiteGroupingUtility.GroupingResult sisterSisteResults = new SisterSiteGroupingUtility.GroupingResult();
            Map<Id, String> accountIdToName = new Map<Id, String>();
            Map<Id, String> accountIdToGroup = new Map<Id, String>();
            
            List <HealthcarePractitionerFacility> finalListToUpdate = new List<HealthcarePractitionerFacility>();
            List <HealthcarePractitionerFacility> finalListToUpdatePermanent = new List<HealthcarePractitionerFacility>();
            Map<Id, Id> hpfIdToAccountId = new Map<Id, Id>();
            Set<Id>hpfIdToTerminate = new Set<Id>();
            List <HealthcarePractitionerFacility> hpfForScope = new List<HealthcarePractitionerFacility>();
            
            sisterSisteResults = SisterSiteGroupingUtility.getSisterSiteGroups();
            //get the Map of service Account to Name eg.0017x0000176IKHAA2=LLM Hospital
            accountIdToName = sisterSisteResults.accountIdToName;
            //get the Map of Service Acct to SisterSiste e.g 0017x0000176IKHAA2=SisterSite1, 0017x000017KgM0AAK=SisterSite2,..
            accountIdToGroup = sisterSisteResults.accountIdToGroup;
            
            hpfForScope = [Select Id, PractitionerId, Status__c, AccountId, Last_Date_Worked__c, 
                                                       Hospital_Privileged_Date__c,Practitioner.AccountId,Employment_Type__c,
                                                       Provider_Next_Scheduled_Date__c, EffectiveTo FROM 
                                                       HealthcarePractitionerFacility WHERE
                                                      PractitionerId IN: Scope AND 
                                                       Status__c NOT IN: hpfStatus];
            
            if (! hpfForScope.isEmpty()) {
                for (HealthcarePractitionerFacility hpf : hpfForScope)
                {
                    HPFId.add(hpf.Id);
                    if (accountIdToName.keySet().contains(hpf.AccountId))//defines that this Service has sister Site 
                    {
                        String sisterSite = accountIdToGroup.get(hpf.AccountId);
                        String key = hpf.Practitioner.AccountId +';'+sisterSite;
                        //Form a map with Clinican and sister site with LWD [e.g- c1,s1->08-09-2022]
                        //check if the clinician is already added to Map
                        if (ClinicianToSisterSiteGrpToLWD.containsKey(key)) {
                            Date LWD = ClinicianToSisterSiteGrpToLWD.get(key);
                            if (hpf.Last_Date_Worked__c != null && hpf.Last_Date_Worked__c > LWD) {
                                // if the key already exist it will replace the with the most recent ones
                                ClinicianToSisterSiteGrpToLWD.put(key, hpf.Last_Date_Worked__c);
                            }
                        } else {
                            ClinicianToSisterSiteGrpToLWD.put(key, hpf.Last_Date_Worked__c);
                        }
                        //Form a map with Clinican and sister site with PSND [e.g- c1,s1->08-09-2022]
                        if (ClinicianToSisterSiteGrpToPNSD.containsKey(key)) {
                            Date PSND = ClinicianToSisterSiteGrpToPNSD.get(key);
                            if (hpf.Provider_Next_Scheduled_Date__c != null && hpf.Provider_Next_Scheduled_Date__c >PSND) {
                                ClinicianToSisterSiteGrpToPNSD.put(key, hpf.Provider_Next_Scheduled_Date__c);
                            }
                        } else {
                            ClinicianToSisterSiteGrpToPNSD.put(key, hpf.Provider_Next_Scheduled_Date__c);
                        }
                        
                        ////Form a map with Clinican and sister site with HPF [e.g- c1,s1->08-09-2022]
                        if (ClinicianToSisterSiteGrpToHPD.containsKey(key)) {
                            Date HPD = ClinicianToSisterSiteGrpToHPD.get(key);
                            if (hpf.Hospital_Privileged_Date__c != null && hpf.Hospital_Privileged_Date__c >HPD) {
                                ClinicianToSisterSiteGrpToHPD.put(key, hpf.Hospital_Privileged_Date__c);
                            }
                        } else {
                            ClinicianToSisterSiteGrpToHPD.put(key, hpf.Hospital_Privileged_Date__c);
                        }
                    }
                }
                
            }
            
            
            for (AggregateResult ar : [Select Contract.AccountId accId, Contract.Employment_Type__c emptype, 
                                       MIN (contract.Initial_Effective_Date__c) minContrctDate 
                                       FROM ProviderNetworkContract Where 
                                       Contract.RecordType_DeveloperName__c = 'Clinician'  AND 
                                       Healthcare_Practitioner_Facility__c IN: HPFId
                                       GROUP BY Contract.AccountId, Contract.Employment_Type__c ])
            {
                String clinicianId = (String) ar.get('accId');
                String empType = (String)ar.get('emptype');
                Date initialEffDate = (Date)ar.get('minContrctDate');
                ClinicianToCntrctInitialEffDate.put(clinicianId+';'+empType, initialEffDate);
            }
            
            
            if (! hpfForScope.isEmpty()) {
                for (HealthcarePractitionerFacility hpf : hpfForScope)
                {
                    Date lastDateWorked = null;
                    Date cntctInitialEffDate = null;
                    Date hospitalPrvldDate = null;
                    Date providerNextScheduleDate = null;
                    
                    String key = accountIdToName.keySet().contains(hpf.AccountId)?
                        hpf.Practitioner.AccountId+';'+accountIdToGroup.get(hpf.AccountId) : '';
                    String Conkey = hpf.Practitioner.AccountId+';'+hpf.Employment_Type__c;//used to compare Contrct Initial effctive date
                    
                    // 365 days inactivaty
                    if (hpf.EffectiveTo == null) {
                        Date effectiveTo = null;
                        Boolean inLWDpassed365 = false;
                        Boolean isInitialEffDate365passed = false;
                        Boolean hospitalPrvldDatepassed365 = false;
                        
                        
                        if (! accountIdToName.keySet().contains(hpf.AccountId)) {
                            lastDateWorked = hpf.Last_Date_Worked__c;
                            hospitalPrvldDate = hpf.Hospital_Privileged_Date__c;
                        } else {
                            lastDateWorked = ClinicianToSisterSiteGrpToLWD.containsKey(key) ?
                                ClinicianToSisterSiteGrpToLWD.get(key) : null;
                            hospitalPrvldDate = ClinicianToSisterSiteGrpToHPD.containsKey(key) ?
                                ClinicianToSisterSiteGrpToHPD.get(key) : null;
                        }
                        
                        inLWDpassed365 = lastDateWorked != null ? checkValidity(lastDateWorked, todayDate, hpf365DeadlineDate): false;
                        effectiveTo = lastDateWorked != null ? lastDateWorked.addDays(hpf365DeadlineDate): null;
                        
                        if (lastDateWorked == null) {
                            cntctInitialEffDate = ClinicianToCntrctInitialEffDate.containsKey(Conkey)?
                                ClinicianToCntrctInitialEffDate.get(Conkey) : null;
                            isInitialEffDate365passed = cntctInitialEffDate != null ?
                                checkValidity(cntctInitialEffDate, todayDate, hpf365DeadlineDate): false;
                            
                            effectiveTo = cntctInitialEffDate != null ? cntctInitialEffDate.addDays(365): null;
                            if (cntctInitialEffDate == null) {
                                hospitalPrvldDatepassed365 =  hospitalPrvldDate!= null ?
                                    checkValidity(hospitalPrvldDate, todayDate, hpf365DeadlineDate):false;
                                effectiveTo = hospitalPrvldDate!= null ?hospitalPrvldDate.addDays(365): null;
                            }
                        }
                        
                        if (inLWDpassed365 || isInitialEffDate365passed || hospitalPrvldDatepassed365) {
                            HealthcarePractitionerFacility hpfToUpdatePerm = new HealthcarePractitionerFacility(
                                Id = hpf.Id, Status__c = 'Inactive', Contracting_Status__c = 'Terminated', TerminationDate = todayDate,
                                Inactive_Reason__c = 'Provider Inactivity >12 Months', EffectiveTo = effectiveTo, 
                                Credentialling_Status__c = 'Inactive');
                            finalListToUpdatePermanent.add(hpfToUpdatePerm);
                            hpfIdToTerminate.add(hpf.Id);
                            practitionerIds.add(hpf.PractitionerId);
                            if (hpf.AccountId != null) {
                                hpfIdToAccountId.put(hpf.Id, hpf.AccountId);
                            }
                        }
                    }
                    
                    /***************************************************************************************************************/
                    
                    //270 days inactivity
                    //first check whether the same Id is added for 365 days inactivity
                    
                    if ((! hpfIdToTerminate.contains(hpf.Id)) && hpf.EffectiveTo == null) {
                        Boolean isSisterSite = false;
                        Integer aging = 0;
                        Boolean inLWDpassed270 = false;
                        Boolean pnsdpassed365withLWD = false;
                        Boolean contractInitialDateValid = false;
                        Boolean hopsitalPrvdateValid = false;
                        
                        
                        if (hpf.Last_Date_Worked__c != null) {
                            // it is a independent hpf without any sister site
                            if (! accountIdToName.keySet().contains(hpf.AccountId)) {
                                lastDateWorked = hpf.Last_Date_Worked__c;
                                providerNextScheduleDate = hpf.Provider_Next_Scheduled_Date__c;
                            } else {
                                lastDateWorked = ClinicianToSisterSiteGrpToLWD.containsKey(key) ?
                                    ClinicianToSisterSiteGrpToLWD.get(key): null;
                                providerNextScheduleDate = ClinicianToSisterSiteGrpToPNSD.containsKey(key)?
                                    ClinicianToSisterSiteGrpToPNSD.get(key) : null;
                                isSisterSite = true;
                            }
                            inLWDpassed270 = lastDateWorked != null? checkValidity(lastDateWorked,todayDate, hpf270DeadlineDate): false;
                            aging = lastDateWorked != null? calculateAging(lastDateWorked): null;
                            
                            //if LWD is 270 past and Provider_Next_Scheduled_Date__c is blank
                            if (inLWDpassed270 && providerNextScheduleDate == null) {
                                HealthcarePractitionerFacility hpfToUpdate = new HealthcarePractitionerFacility
                                    (Id = hpf.Id, Inactivity_Qualified_270__c = true, Aging_Days_Left__c = aging,
                                     isSisterSiteLocation__c = isSisterSite);
                                finalListToUpdate.add(hpfToUpdate);
                                if (hpf.AccountId != null) {
                                    hpfIdToAccountId.put(hpf.Id, hpf.AccountId);
                                }
                                continue;
                            }
                            //if Provider_Next_Scheduled_Date__c is populated
                            if (inLWDpassed270 && providerNextScheduleDate != null) {
                                pnsdpassed365withLWD = checkValidity(lastDateWorked, providerNextScheduleDate, hpf365DeadlineDate);
                                //pnsdpassed365withLWD = checkValidity(providerNextScheduleDate, lastDateWorked, hpf365DeadlineDate);
                                aging = calculateAging(providerNextScheduleDate);
                                
                            }
                            if (pnsdpassed365withLWD) {
                                // recontract if the Provider_Next_Scheduled_Date__c falls within 365 day from LWD
                                HealthcarePractitionerFacility hpfToUpdate = new HealthcarePractitionerFacility
                                    (Id = hpf.Id, Re_Contract__c  = true, Aging_Days_Left__c = aging, 
                                     Inactivity_Qualified_270__c = true, isSisterSiteLocation__c = isSisterSite);
                                finalListToUpdate.add(hpfToUpdate);
                                hpfIdToAccountId.put(hpf.Id, hpf.AccountId);
                            } 
                            //if PNSD is populated but falls within 365 days with Last Worked Date
                            if (providerNextScheduleDate != null && !pnsdpassed365withLWD) {
                                HealthcarePractitionerFacility hpfToUpdate = new HealthcarePractitionerFacility
                                    (Id = hpf.Id, Inactivity_Qualified_270__c = false);
                                finalListToUpdate.add(hpfToUpdate);
                            }
                        }//when LWD is blank 
                        else {
                            // this date will be same for independent and sister site
                            cntctInitialEffDate = ClinicianToCntrctInitialEffDate.containsKey(Conkey) ?
                                ClinicianToCntrctInitialEffDate.get(Conkey) : null;
                            
                            contractInitialDateValid = cntctInitialEffDate != null ?
                                checkValidity(cntctInitialEffDate, todayDate, hpf270DeadlineDate): false;
                            aging = cntctInitialEffDate != null? calculateAging(cntctInitialEffDate):null;
                            
                            if (cntctInitialEffDate == null) {
                                if (! accountIdToName.keySet().contains(hpf.AccountId)) {
                                    hospitalPrvldDate = hpf.Hospital_Privileged_Date__c;
                                } else {
                                    isSisterSite = true;
                                    hospitalPrvldDate = ClinicianToSisterSiteGrpToHPD.containsKey(key)?
                                        ClinicianToSisterSiteGrpToHPD.get(key) : null;
                                }
                                
                                hopsitalPrvdateValid = hospitalPrvldDate != null ? 
                                    checkValidity(hospitalPrvldDate, todayDate,hpf270DeadlineDate) : false;
                                aging = hospitalPrvldDate != null? calculateAging(hospitalPrvldDate): null;
                            }
                            
                            if (contractInitialDateValid || hopsitalPrvdateValid) {
                                HealthcarePractitionerFacility hpfToUpdate = new HealthcarePractitionerFacility
                                    (Id = hpf.Id, Inactivity_Qualified_270__c = true, isSisterSiteLocation__c =isSisterSite,
                                     Aging_Days_Left__c = aging);
                                finalListToUpdate.add(hpfToUpdate);
                                if (hpf.AccountId != null) {
                                    hpfIdToAccountId.put(hpf.Id, hpf.AccountId);
                                }
                            }
                        }
                    }
                    
                }
                
            }
            
            // check if there are no other HPF belonging to same practitioner in active status
            // if we found any hpf other those added in list of terminate, remove those practionerId from set
            for (HealthcarePractitionerFacility hpfs : [Select Id,name,PractitionerId FROM HealthcarePractitionerFacility 
                                                        WHERE PractitionerId IN: practitionerIds AND
                                                        Status__c != 'Inactive' AND Id NOT IN: hpfIdToTerminate])
            {
                practitionerIds.remove(hpfs.PractitionerId);
            }
            
            //now we have the practioner where there are no other hpf with active status
            for (Account acc: [Select Id, E_Verify_Status__pc From Account where PersonContactId IN: practitionerIds])
            {
                Account accToUpdate = new Account(Id = acc.Id, E_Verify_Status__pc = '');
                practionerToUpdate.add(accToUpdate);
                accIds.add(acc.Id);
            }
            
            if (! finalListToUpdatePermanent.isEmpty()) {
                Database.SaveResult[] results1 = Database.update(finalListToUpdatePermanent, false);
                for (Integer i = 0; i < results1.size(); i++) {
                    Id updatedHpfId = finalListToUpdatePermanent[i].Id;
                    if (results1[i].isSuccess()) {
                        inactiveHpfIds.add(updatedHpfId);
                        if (hpfIdToAccountId.containsKey(updatedHpfId)) {
                            accountIdsForEmail.add(hpfIdToAccountId.get(updatedHpfId));
                        }
                    }
                }
            }
            
            if (! finalListToUpdate.isEmpty()) {
                Database.SaveResult[] results2 = Database.update(finalListToUpdate, false);
                for (Integer i = 0; i < results2.size(); i++) {
                    if (results2[i].isSuccess() && finalListToUpdate[i].Inactivity_Qualified_270__c == true) {
                        Id warningHpfId = finalListToUpdate[i].Id;
                        warningHpfIds.add(warningHpfId);
                        if (hpfIdToAccountId.containsKey(warningHpfId)) {
                            accountIdsForEmail.add(hpfIdToAccountId.get(warningHpfId));
                        }
                    }
                }
            }
            
            
            
            // Query all open case and related child cases
            List <Case> caseList = new List <Case>();
            for (Case cse:[Select Id, Status From Case WHERE (AccountId IN: accIds OR
                                                                       ContactId IN: practitionerIds)
                           AND Status !='Closed'])
            {
                cse.Status = 'Closed';
                cse.Closed_Reason__c = 'Canceled';
                caseId.add(cse.Id);
                caseList.add(cse);
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
            List <Task>taskList = [Select Id, Status From Task Where (AccountId IN: accIds OR WhatId IN: caseId) 
                                   AND Status ='Open' ];
            
            
            //update task status to Completed
            if (!taskList.isEmpty()) {
                for (Task tsk : taskList) {
                    tsk.Status = 'Completed';
                }
                update taskList;
            }
            
            //update case status to Closed
            if (!caseList.isEmpty()) {
                update caseList;
            }
            //update practitonerList
            if (!practionerToUpdate.isEmpty()) {
                update practionerToUpdate;
            }
            
        } Catch (Exception e) {
            ErrorLogUtil.logException(e, 'DeactivateHPFsForClinician::execute', null);
        }
        
        
    }
    global void finish(Database.BatchableContext bc) {
        try {
            HPFReportEmailUtil.sendHPFReportEmail(accountIdsForEmail, inactiveHpfIds, warningHpfIds);
        } catch (Exception e) {
            ErrorLogUtil.logException(e, 'DeactivateHPFsForClinician::finish email', null);
        }
    }
    
    //this method receives date and duraction and check whether the date has surpassed the duration from presnt date
    global Boolean checkValidity(Date concernedDate, Date dateToCompare, Integer duration) {
        Boolean isInactive = false;
        
        if (concernedDate.daysBetween(dateToCompare) >= duration) {
            isInactive = true;
        } else {
            isInactive = false;
        }
        
        return isInactive;
    }
    // this method clalculates inactivity days of hpf
    global Integer calculateAging(Date concernedDate) {
        Integer diffFromToday = concernedDate.daysBetween(todayDate);
        Integer aging = 365 - diffFromToday;
        return aging;
    } 
    
}