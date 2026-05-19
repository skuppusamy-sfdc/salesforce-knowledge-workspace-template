public with sharing class CongaAgreementServiceHelper {
    
   public static final Id serviceAccRTId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Service_Account').getRecordTypeId();
   public static final Id corpEntAccRTId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Corporate_Entity').getRecordTypeId();
   public static final Id clinicianAccRTId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Clinician').getRecordTypeId();


   public static List<Apttus__APTS_Agreement__c> congaServiceHelpCombined(List<Apttus__APTS_Agreement__c> agreeRecs){
       	Map<Id,Apttus__APTS_Agreement__c> agreeQueryMap = new Map<Id,Apttus__APTS_Agreement__c>(agreeRecs);
       	Set<Id> agreeQueryIds = agreeQueryMap.keySet();
        List<String> agreeFlds = new List<String>(Apttus__APTS_Agreement__c.SObjectType.getDescribe().fields.getMap().keySet());
        String agreeQueryStr = 'SELECT ' + String.join(agreeFlds,',') + ',Contract__r.AccountId FROM Apttus__APTS_Agreement__c WHERE Id IN :agreeQueryIds';
        agreeRecs = (List<Apttus__APTS_Agreement__c>)Database.query(agreeQueryStr);
        Map<Id,Apttus__APTS_Agreement__c> agreementMap = new Map<Id,Apttus__APTS_Agreement__c>();
		Map<Id,Apttus__APTS_Agreement__c> updateAgreeMap = new Map<Id,Apttus__APTS_Agreement__c>();
        Map<Id,Set<Id>> contIdToAgreeIdMap = new Map<Id,Set<Id>>();
        Map<Id,Set<Id>> accIdToAgreeIdMap = new Map<Id,Set<Id>>();
        for (Apttus__APTS_Agreement__c agreeRec : agreeRecs){
            agreementMap.put(agreeRec.Id,agreeRec);
            if (!contIdToAgreeIdMap.containsKey(agreeRec.Contract__c)){
                contIdToAgreeIdMap.put(agreeRec.Contract__c,new Set<Id>());
            }
            contIdToAgreeIdMap.get(agreeRec.Contract__c).add(agreeRec.Id);
            if (!accIdToAgreeIdMap.containsKey(agreeRec.Contract__r.AccountId)){
                accIdToAgreeIdMap.put(agreeRec.Contract__r.AccountId,new Set<Id>());
            }
            accIdToAgreeIdMap.get(agreeRec.Contract__r.AccountId).add(agreeRec.Id);
        }
       
		Map<Id,Set<Id>> hpfAccIdToAgreeIdMap = new Map<Id,Set<Id>>(); //map of service accounts to agreements
        Map<Id,HealthcarePractitionerFacility> allHPFMap = new Map<Id,HealthcarePractitionerFacility>();
        Map<Id,AccountAccountRelation> allAARMap = new Map<Id,AccountAccountRelation>();
        Map<Id,Map<String,Set<Id>>> personAccToSLToHPFMap = new Map<Id,Map<String,Set<Id>>>();
		Set<String> serviceLineMultiSet = new Set<String>{'CC','HM'};
        Set<String> serviceLineMultiSet2 = new Set<String>{'EM','ICP'};
        for (Account personAccRec : [SELECT Id,(SELECT Id,AccountId,Account.RecordTypeId,Account.Service_Line__r.Name,PractitionerId,Practitioner.AccountId,Facility_Title__r.Name,Contracting_Corporate_Entity__c,No_of_Hours_Anticipated_to_Work__c FROM PersonHealthcarePractitionerFacilities WHERE Exclude_On_Agreement__c = false) FROM Account WHERE Id IN :accIdToAgreeIdMap.keySet()]){
            Map<Id,HealthcarePractitionerFacility> hpfMap = new Map<Id,HealthcarePractitionerFacility>((List<HealthcarePractitionerFacility>)personAccRec.PersonHealthcarePractitionerFacilities);
            for (HealthcarePractitionerFacility hpfRec : hpfMap.values()){
                if (String.isNotBlank(hpfRec.Account.Service_Line__r.Name)){
                    if (!personAccToSLToHPFMap.containsKey(personAccRec.Id)){
                        personAccToSLToHPFMap.put(personAccRec.Id,new Map<String,Set<Id>>());
                    }
                    if (!personAccToSLToHPFMap.get(personAccRec.Id).containsKey(hpfRec.Account.Service_Line__r.Name)){
                        personAccToSLToHPFMap.get(personAccRec.Id).put(hpfRec.Account.Service_Line__r.Name,new Set<Id>());
                    }
                    personAccToSLToHPFMap.get(personAccRec.Id).get(hpfRec.Account.Service_Line__r.Name).add(hpfRec.Id);
                }
            }
            allHPFMap.putAll(hpfMap);
        }

        for (Id hpfId : allHPFMap.keySet()){
            HealthcarePractitionerFacility hpfRec = allHPFMap.get(hpfId);
            if (hpfRec != null){
                for (Id agreeId : accIdToAgreeIdMap.get(hpfRec.Practitioner.AccountId)){	
                    Apttus__APTS_Agreement__c agreeRec = agreementMap.get(agreeId);
                    if (hpfRec.Account.RecordTypeId == serviceAccRTId && hpfRec.Practitioner.AccountId == agreeRec.Contract__r.AccountId && agreeRec.Corporate_Entity__c == hpfRec.Contracting_Corporate_Entity__c){
                        if (personAccToSLToHPFMap.get(hpfRec.Practitioner.AccountId) != null 
                            && ((personAccToSLToHPFMap.get(hpfRec.Practitioner.AccountId).keySet().containsAll(serviceLineMultiSet) && hpfRec.Account.Service_Line__r.Name == 'HM') 
                            || (personAccToSLToHPFMap.get(hpfRec.Practitioner.AccountId).keySet().containsAll(serviceLineMultiSet2) && hpfRec.Account.Service_Line__r.Name == 'ICP'))){
                            break;
                        }
                        if (!hpfAccIdToAgreeIdMap.containsKey(hpfRec.AccountId)){
                            hpfAccIdToAgreeIdMap.put(hpfRec.AccountId,new Set<Id>());
                        }
                        hpfAccIdToAgreeIdMap.get(hpfRec.AccountId).add(agreeId);
                        agreeRec.Clinician_Facility_Association__c = hpfRec.AccountId; //matches
                        agreeRec.Facility_Title__c = hpfRec.Facility_Title__r.Name; //flip Facility_Title__c field
                        //agreeRec.No_of_Hours_Anticipated_to_Work__c = String.valueOf(hpfRec.No_of_Hours_Anticipated_to_Work__c); //flip No_of_Hours_Anticipated_to_Work__c field
                    }
                    updateAgreeMap.put(agreeRec.Id,agreeRec);
             	}
            }
        }
        
		Map<Id,Set<Id>> contIdToPCAIdMap = new Map<Id,Set<Id>>();
        Map<Id,Set<Id>> conIdToContIdMap = new Map<Id,Set<Id>>();
        Map<Id,Shift__c> allShiftMap = new Map<Id,Shift__c>();
        Map<Id,PreventiveCareAgreement> allPCAMap = new Map<Id,PreventiveCareAgreement>();
       	Map<Id,Contract> contRecs = new Map<Id,Contract>([SELECT Id,AccountId,Account.FirstName,Account.LastName,Account.PersonContactId,Account.Professional_Title__pc,Account.Name,Employment_Type__c,Time_Type__c,Contracting_Corporate_Entity__c,StartDate,EndDate,(SELECT Id,Contract__c,Type__c,Shift_Name__r.Name FROM Shifts__r),(SELECT Id,Type__c,Contract.Contracting_Corporate_Entity__c,(SELECT Id,Time_Type__c,RVU_Metric_Type__c,Type__c,Type__r.Name,Type__r.Code_Set_Sub_Type__c,Type__r.Code,Type__r.CodeSetType,FacilityTitle__c,FacilityTitle__r.Name,FacilityTitle__r.Code_Set_Sub_Type__c,Rate__c,Duration_Months__c,Work_Commitment_per_Month__c,Work_Commitment_Frequency__c,Unit_of_Measure__c,Shift__r.Name,Shift__r.Shift_Name__c,Shift__r.Shift_Name__r.Name,Shift__r.Shift_Name__r.Code,Shift__r.Shift_Full_Name__c,Repayment_Terms__c,Admin_Hours__c,Stipend_Tier__c,Payroll_Cycle__c,ContractPaymentAgreement.Type__c,ContractPaymentAgreement.ContractId,ContractPaymentAgreement.Provider_Network_Contract__r.Healthcare_Practitioner_Facility__r.Contracting_Corporate_Entity__c,Facility_Rate__c,Facility_Rate__r.RVU_Metric_Type__c,ContractPaymentAgreement.Contract.Employment_Type__c,ContractPaymentAgreement.Contract.Contracting_Corporate_Entity__c FROM PreventiveCareAgreements) FROM ContractPaymentAgreements) FROM Contract WHERE Id IN :contIdToAgreeIdMap.keySet()]);
        for (Contract contRec : contRecs.values()){ //can't do two levels deep in for loop SOQL //Type__r.Shift_Type__c
            for (ContractPaymentAgreement cpaRec : contRec.ContractPaymentAgreements){
                Map<Id,PreventiveCareAgreement> pcaMap = new Map<Id,PreventiveCareAgreement>((List<PreventiveCareAgreement>)cpaRec.PreventiveCareAgreements);
                allPCAMap.putAll(pcaMap);
                if (!contIdToPCAIdMap.containsKey(contRec.Id)){
                    contIdToPCAIdMap.put(contRec.Id,new Set<Id>());
                }
                contIdToPCAIdMap.get(contRec.Id).addAll(pcaMap.keySet());
            }

            if (contRec.Employment_Type__c == 'Independent Contractor'){
                if (!conIdToContIdMap.containsKey(contRec.Account.PersonContactId)){
                    conIdToContIdMap.put(contRec.Account.PersonContactId,new Set<Id>());
                }
                conIdToContIdMap.get(contRec.Account.PersonContactId).add(contRec.Id);
            }
            
            for (Id agreeId : contIdToAgreeIdMap.get(contRec.Id)){
                Apttus__APTS_Agreement__c agreeRec = agreementMap.get(agreeId);
                agreeRec.Time_Type__c = String.valueOf(contRec.Time_Type__c);
                if (contRec.Employment_Type__c != 'Independent Contractor'){
                    agreeRec.Provider_Signature_Box__c = contRec.Account.FirstName +  ' ' + contRec.Account.LastName + ', ' + contRec.Account.Professional_Title__pc; //flip Provider_Signature_Box__c field
                    if (contRec.Employment_Type__c == 'Employee'){
                        agreeRec.Clinician_Contracting_With__c = contRec.Account.Name; //flip Clinician_Contracting_With__c field
                    }
                }
                updateAgreeMap.put(agreeRec.Id,agreeRec);
            }
            Map<Id,Shift__c> shiftMap = new Map<Id,Shift__c>((List<Shift__c>)contRec.Shifts__r);
            allShiftMap.putAll(shiftMap);
        }
        
        // Query ProviderNetworkContract to check Can_Have_Leadership_Incentive__c and collect facility AccountIds
        Map<Id,Set<Id>> contractIdToAccountIdsMap = new Map<Id,Set<Id>>();
       	Set<Id> pncServiceAccIds = new Set<Id>();
       	Set<Id> accSLPIds = new Set<Id>();
        // NEW: (ContractId + ':' + CorporateEntityId) → Set of facility AccountIds (for CE-specific facility names)
        Map<String,Set<Id>> contractCEToAccountIdsMap = new Map<String,Set<Id>>();
       	Map<Id,Map<Id,Integer>> contIdToCCEIdtoHrsMap = new Map<Id,Map<Id,Integer>>(); //Map of Contract Ids to Corporate Entity Ids to List of No of Anticipated Hours to Work values
		Map<Id,List<ProviderNetworkContract>> contIdToPNCMap = new Map<Id,List<ProviderNetworkContract>>();
        for (ProviderNetworkContract pncRec : [SELECT Id,ContractId,Contract.Employment_Type__c,Contract.Contracting_Corporate_Entity__c,Healthcare_Practitioner_Facility__c,Healthcare_Practitioner_Facility__r.Facility_Title__c,Healthcare_Practitioner_Facility__r.Facility_Title__r.Can_Have_Leadership_Incentive__c,Healthcare_Practitioner_Facility__r.AccountId,Healthcare_Practitioner_Facility__r.Account.Service_Line_Parent__c,Healthcare_Practitioner_Facility__r.Contracting_Corporate_Entity__c,Healthcare_Practitioner_Facility__r.No_of_Hours_Anticipated_to_Work__c FROM ProviderNetworkContract WHERE ContractId IN :contIdToAgreeIdMap.keySet() AND Healthcare_Practitioner_Facility__r.Exclude_On_Agreement__c = false]){
            if (String.isNotBlank(pncRec.Healthcare_Practitioner_Facility__c)){
                if (String.isNotBlank(pncRec.Healthcare_Practitioner_Facility__r.AccountId)){
                	pncServiceAccIds.add(pncRec.Healthcare_Practitioner_Facility__r.AccountId);
                }
           		if (String.isNotBlank(pncRec.Healthcare_Practitioner_Facility__r.Contracting_Corporate_Entity__c) && pncRec.Healthcare_Practitioner_Facility__r.No_of_Hours_Anticipated_to_Work__c != null){
                    Id cceId = (pncRec.Contract.Employment_Type__c == 'Employee') ? pncRec.Contract.Contracting_Corporate_Entity__c : pncRec.Healthcare_Practitioner_Facility__r.Contracting_Corporate_Entity__c;
                    if (!contIdToCCEIdtoHrsMap.containsKey(pncRec.ContractId)){
                        contIdToCCEIdtoHrsMap.put(pncRec.ContractId,new Map<Id,Integer>());
                    }
                    if (!contIdToCCEIdtoHrsMap.get(pncRec.ContractId).containsKey(cceId)){
						contIdToCCEIdtoHrsMap.get(pncRec.ContractId).put(cceId,0);
                    }
                    Integer totalNoHrsWork = contIdToCCEIdtoHrsMap.get(pncRec.ContractId).get(cceId);
                    totalNoHrsWork += Integer.valueOf(pncRec.Healthcare_Practitioner_Facility__r.No_of_Hours_Anticipated_to_Work__c);
                    contIdToCCEIdtoHrsMap.get(pncRec.ContractId).put(cceId,totalNoHrsWork);
                }
                // Check Can_Have_Leadership_Incentive__c
                if (pncRec.Healthcare_Practitioner_Facility__r.Facility_Title__r != null && pncRec.Healthcare_Practitioner_Facility__r.Facility_Title__r.Can_Have_Leadership_Incentive__c == true){
                    for (Id agreeId : contIdToAgreeIdMap.get(pncRec.ContractId)){
                        Apttus__APTS_Agreement__c agreeRec = agreementMap.get(agreeId);
                        if (agreeRec.Corporate_Entity__c == pncRec.Healthcare_Practitioner_Facility__r.Contracting_Corporate_Entity__c){
                            agreeRec.Can_Have_Leadership_Incentive__c = true;
                            updateAgreeMap.put(agreeRec.Id,agreeRec);
                        }
                    }
                }
            }
            
            // Collect AccountIds from HealthcarePractitionerFacility for facility names
            if (pncRec.Healthcare_Practitioner_Facility__c != null){                
            	if (pncRec.Healthcare_Practitioner_Facility__r.AccountId != null){
                    if (!contractIdToAccountIdsMap.containsKey(pncRec.ContractId)){
                        contractIdToAccountIdsMap.put(pncRec.ContractId,new Set<Id>());
                    }
                    contractIdToAccountIdsMap.get(pncRec.ContractId).add(pncRec.Healthcare_Practitioner_Facility__r.AccountId);
                    if (String.isNotBlank(pncRec.Healthcare_Practitioner_Facility__r.Facility_Title__c) && pncRec.Healthcare_Practitioner_Facility__r.Facility_Title__r.Can_Have_Leadership_Incentive__c && String.isNotBlank(pncRec.Healthcare_Practitioner_Facility__r.Account.Service_Line_Parent__c)){
                        accSLPIds.add(pncRec.Healthcare_Practitioner_Facility__r.AccountId);
                    }
                    // NEW: Also track by (Contract + Contracting Corporate Entity) for CE-specific facility names
                    Id ceId = (pncRec.Contract.Employment_Type__c == 'Employee') ? pncRec.Contract.Contracting_Corporate_Entity__c : pncRec.Healthcare_Practitioner_Facility__r.Contracting_Corporate_Entity__c;
                    if (ceId != null) {
                        String ceKey = String.valueOf(pncRec.ContractId) + ':' + String.valueOf(ceId);
                        if (!contractCEToAccountIdsMap.containsKey(ceKey)) {
                            contractCEToAccountIdsMap.put(ceKey, new Set<Id>());
                        }
                        contractCEToAccountIdsMap.get(ceKey).add(pncRec.Healthcare_Practitioner_Facility__r.AccountId);
                    }
                }
                if (pncRec.Healthcare_Practitioner_Facility__r.Contracting_Corporate_Entity__c != null){
                    if (!contIdToPNCMap.containsKey(pncRec.ContractId)){
                        contIdToPNCMap.put(pncRec.ContractId,new List<ProviderNetworkContract>());
                    }
                    contIdToPNCMap.get(pncRec.ContractId).add(pncRec);
                }
            }
        }
       
       	Set<Id> accChristusIdSet = new Set<Id>();
		for (Account accRec : [SELECT Id,Name,Client_Owner_Type__c,Service_Line__r.Name,Service_Line_Parent__c,(SELECT Id,AccountId,Account.Name,RelatedAccountId,RelatedAccount.Name,PartyRoleRelationId,PartyRoleRelation.Name,PartyRoleRelation.RoleName FROM AARAccounts),(SELECT Id,AccountId,Account.Name,RelatedAccountId,RelatedAccount.Name,PartyRoleRelationId,PartyRoleRelation.Name,PartyRoleRelation.RoleName FROM AARRelatedAccounts) FROM Account WHERE Id IN :hpfAccIdToAgreeIdMap.keySet() AND Id IN :pncServiceAccIds]){
            Map<Id,AccountAccountRelation> aarMap = new Map<Id,AccountAccountRelation>((List<AccountAccountRelation>)accRec.AARAccounts);
            Map<Id,AccountAccountRelation> aarRelatedMap = new Map<Id,AccountAccountRelation>((List<AccountAccountRelation>)accRec.AARRelatedAccounts);
            allAARMap.putAll(aarMap);
            allAARMap.putAll(aarRelatedMap);
        	for (Id agreeId : hpfAccIdToAgreeIdMap.get(accRec.Id)){
				Apttus__APTS_Agreement__c agreeRec = agreementMap.get(agreeId);
                agreeRec.Service_Account_Name__c = String.valueOf(accRec.Name);
                agreeRec.Service_Line__c = String.valueOf(accRec.Service_Line__r.Name);
                agreeRec.Service_Line_Parent__c = String.valueOf(accRec.Service_Line_Parent__c);
            	if (accRec.Client_Owner_Type__c == 'Christus JV'){
                    if (!accChristusIdSet.contains(accRec.Id)){
						accChristusIdSet.add(accRec.Id);                        
                    }
                    agreeRec.Christus_JV__c = Boolean.valueOf(accRec.Client_Owner_Type__c == 'Christus JV');
                }
				updateAgreeMap.put(agreeRec.Id,agreeRec);
            }
        }
       
		for (Opportunity opp : [SELECT Id,AccountId,Christus_JV__c FROM Opportunity WHERE AccountId IN :hpfAccIdToAgreeIdMap.keySet() AND AccountId NOT IN :accChristusIdSet AND Christus_JV__c = true]){
            for (Id agreeId : hpfAccIdToAgreeIdMap.get(opp.AccountId)){
                Apttus__APTS_Agreement__c agreeRec = agreementMap.get(agreeId);
                agreeRec.Christus_JV__c = Boolean.valueOf(opp.Christus_JV__c);
                updateAgreeMap.put(agreeRec.Id,agreeRec);
            }
		}
       
		for (Id aarId : allAARMap.keySet()){
			AccountAccountRelation aarRec = allAARMap.get(aarId);
			if (aarRec.PartyRoleRelation.RoleName == 'Locums Company'){
                Boolean useRelatedAccount = Boolean.valueOf(hpfAccIdToAgreeIdMap.get(aarRec.RelatedAccountId) != null);
				Set<Id> agreeIdSet = (useRelatedAccount) ? hpfAccIdToAgreeIdMap.get(aarRec.RelatedAccountId) : hpfAccIdToAgreeIdMap.get(aarRec.AccountId);
				for (Id agreeId : agreeIdSet){
                   Apttus__APTS_Agreement__c agreeRec = agreementMap.get(agreeId);
                   agreeRec.Locums_Company__c = (useRelatedAccount) ? String.valueOf(aarRec.RelatedAccount.Name) : String.valueOf(aarRec.Account.Name); //flip Locums_Company__c field
                   updateAgreeMap.put(agreeRec.Id,agreeRec);
				}
			}
		}
       
		for (Id agreeId : agreementMap.keySet()){
            Apttus__APTS_Agreement__c agreeRec = agreementMap.get(agreeId);
            Contract contRec = contRecs.get(agreeRec.Contract__c);
            Id cceId = (contRec.Employment_Type__c == 'Employee') ? contRec.Contracting_Corporate_Entity__c : agreeRec.Corporate_Entity__c;
            if (cceId != null && contIdToCCEIdtoHrsMap.get(agreeRec.Contract__c) != null && contIdToCCEIdtoHrsMap.get(agreeRec.Contract__c).get(cceId) != null){
				agreeRec.No_of_Hours_Anticipated_to_Work__c = String.valueOf(contIdToCCEIdtoHrsMap.get(agreeRec.Contract__c).get(cceId));
            	updateAgreeMap.put(agreeRec.Id,agreeRec);
            }
		}
        
        // Query Account records separately to get Account Names
        Set<Id> allAccountIds = new Set<Id>();
        for (Set<Id> accountIdSet : contractIdToAccountIdsMap.values()){
            allAccountIds.addAll(accountIdSet);
        }
        
        Map<Id, Account> accountMap = new Map<Id, Account>();
        if (!allAccountIds.isEmpty()) {
            accountMap = new Map<Id,Account>([SELECT Id,Name,Service_Line_Parent__c FROM Account WHERE Id IN :allAccountIds]);
        }
        
        // Build facility names map by (Contract + Corporate Entity) using Account Names
        // Key format: '<ContractId>:<CorporateEntityId>'
		Map<String,Set<String>> contractCEToFacilityNamesMap = new Map<String,Set<String>>();
       	Map<String,Map<String,Set<String>>> contractCEToSLPFacilityNamesMap = new Map<String,Map<String,Set<String>>>();
		for (String ceKey : contractCEToAccountIdsMap.keySet()){
            Set<Id> ceAccountIds = contractCEToAccountIdsMap.get(ceKey);
            if (ceAccountIds == null || ceAccountIds.isEmpty()) {
                continue;
            }
            if (!contractCEToFacilityNamesMap.containsKey(ceKey)){
                contractCEToFacilityNamesMap.put(ceKey,new Set<String>());
            }
            if (!contractCEToSLPFacilityNamesMap.containsKey(ceKey)){
                contractCEToSLPFacilityNamesMap.put(ceKey,new Map<String,Set<String>>());
            }
            Set<String> nameSet = contractCEToFacilityNamesMap.get(ceKey);
            Map<String,Set<String>> nameMap = contractCEToSLPFacilityNamesMap.get(ceKey);
            for (Id accountId : ceAccountIds) {
                if (accountMap.containsKey(accountId) && String.isNotBlank(accountMap.get(accountId).Name)){
                    Account accRec = accountMap.get(accountId);
                    nameSet.add(accRec.Name);
                    if (accSLPIds.contains(accountId)){
                        if (!nameMap.containsKey(accRec.Service_Line_Parent__c)){
                            nameMap.put(accRec.Service_Line_Parent__c,new Set<String>());
                        }
                    	nameMap.get(accRec.Service_Line_Parent__c).add(accRec.Name);
                    }
                }
            }
        }
        
        // NEW: Agreement-centric update of Facility_Names__c
        // Only include facility names for HPFs whose Contracting Corporate Entity matches the Agreement's CE
        for (Apttus__APTS_Agreement__c agreeRec : agreementMap.values()){
            if (agreeRec.Contract__c == null || agreeRec.Corporate_Entity__c == null) {
                continue;
            }
            Contract contRec = contRecs.get(agreeRec.Contract__c);
            String ceKey = String.valueOf(agreeRec.Contract__c) + ':';
            ceKey += (contRec.Employment_Type__c == 'Employee') ? String.valueOf(contRec.Contracting_Corporate_Entity__c) : String.valueOf(agreeRec.Corporate_Entity__c);
            Set<String> facilityNameSet = contractCEToFacilityNamesMap.get(ceKey);
            Map<String,Set<String>> facilityNameSLPMap = contractCEToSLPFacilityNamesMap.get(ceKey);
            if (facilityNameSet != null && !facilityNameSet.isEmpty()){
                List<String> facilityNames = new List<String>(facilityNameSet);
                agreeRec.Facility_Names__c = String.join(facilityNames, ', ');
                updateAgreeMap.put(agreeRec.Id,agreeRec);
            }
            if (facilityNameSLPMap != null && !facilityNameSLPMap.isEmpty()){
                Set<String> facilityNameSLPSet = facilityNameSLPMap.get(agreeRec.Service_Line_Parent__c);
                if (facilityNameSLPSet != null && !facilityNameSLPSet.isEmpty()){
                    List<String> facilitySLPNames = new List<String>(facilityNameSLPSet);
                    agreeRec.Service_Line_Parent_Facility_Names__c = String.join(facilitySLPNames, ', ');
                    updateAgreeMap.put(agreeRec.Id,agreeRec);
                }
            }
        }
       	
		Set<String> stipendTierSLSet = new Set<String>{'Tier 1','Tier 2','Tier 3','Tier 4','Legacy'};
		Set<String> stipendTierNPPASet = new Set<String>{'NPPA','Flat NPPA'};
        for (Id pcaId : allPCAMap.keySet()){
            PreventiveCareAgreement pcaRec = allPCAMap.get(pcaId);
            String codeSetSubType = pcaRec.FacilityTitle__r.Code_Set_Sub_Type__c;
            Boolean cpaBonusType = Boolean.valueOf(pcaRec.ContractPaymentAgreement.Type__c == 'Bonus');
            Boolean cpaLeadershipType = Boolean.valueOf(pcaRec.ContractPaymentAgreement.Type__c == 'Leadership Incentives');
            Boolean cpaStipendType = Boolean.valueOf(pcaRec.ContractPaymentAgreement.Type__c == 'Stipend');
            Boolean cpaVariableType = Boolean.valueOf(pcaRec.ContractPaymentAgreement.Type__c == 'Variable');
            Boolean hasAdministrativeStipendPCA = Boolean.valueOf(pcaRec.Type__r.CodeSetType == 'Stipend');
			Boolean hasLIStipendTier = false;            
            for (Id agreeId : contIdToAgreeIdMap.get(pcaRec.ContractPaymentAgreement.ContractId)){
                Apttus__APTS_Agreement__c agreeRec = agreementMap.get(agreeId);
                if (pcaRec.ContractPaymentAgreement.Contract.Employment_Type__c == 'Employee' || 
                (pcaRec.ContractPaymentAgreement.Contract.Employment_Type__c == 'Independent Contractor'  && agreeRec.Corporate_Entity__c == pcaRec.ContractPaymentAgreement.Provider_Network_Contract__r.Healthcare_Practitioner_Facility__r.Contracting_Corporate_Entity__c)){
                    if (cpaBonusType){
                        agreeRec.Bonus_Type__c = String.valueOf(pcaRec.Type__r.Name);
                        agreeRec.Duration_Months__c = String.valueOf(pcaRec.Duration_Months__c);
                        agreeRec.Half_Bonus_Amount__c = String.valueOf(pcaRec.Rate__c/2);
                        agreeRec.Payroll_Cycle__c = String.valueOf(pcaRec.Payroll_Cycle__c);
                        agreeRec.Rate__c = String.valueOf(pcaRec.Rate__c);
                        agreeRec.Repayment_Terms__c = String.valueOf(pcaRec.Repayment_Terms__c);
                        agreeRec.Work_Commitment_per_Month__c = String.valueOf(pcaRec.Work_Commitment_per_Month__c);
                        agreeRec.Work_Commitment_Frequency__c = String.valueOf(pcaRec.Work_Commitment_Frequency__c); 
                    }
                    if (cpaLeadershipType){
                    	agreeRec.Leadership_Incentive__c = String.valueOf(pcaRec.Rate__c);
                        if (pcaRec.Type__r.Name == 'Variable Monthly Stipend'){
                        	agreeRec.Stipend_Tier__c = String.valueOf(pcaRec.Stipend_Tier__c);
                            hasLIStipendTier = true;
                        }
                    }
                    if (cpaStipendType){
                        agreeRec.Stipend_Tier__c = (!hasLIStipendTier) ? String.valueOf(pcaRec.Stipend_Tier__c) : agreeRec.Stipend_Tier__c;
                        agreeRec.Stipend_Amount__c = String.valueOf(pcaRec.Rate__c);
                        agreeRec.Admin_Hours__c = Integer.valueOf(pcaRec.Admin_Hours__c);
                        if (stipendTierSLSet.contains(agreeRec.Stipend_Tier__c)){
                            if (agreeRec.Service_Line_Parent__c == 'EM'){
                            	agreeRec.Stipend_Position__c = 'Medical Director';
                            } else if (agreeRec.Service_Line_Parent__c == 'HM'){
                                agreeRec.Stipend_Position__c = 'Hospital Medicine Program Director';
                            }
                        } else if (agreeRec.Stipend_Tier__c == 'Flat'){
                            agreeRec.Stipend_Position__c = 'Assistant Medical Director';
                        } else if (stipendTierNPPASet.contains(agreeRec.Stipend_Tier__c)){
                            agreeRec.Stipend_Position__c = 'Advanced Practitioner Lead';
                        }
                    }
                    if (cpaVariableType){
                        agreeRec.Variable_Type__c = String.valueOf(pcaRec.Type__r.Name);
                        agreeRec.Exhibit_A_Long__c = pcaRec.Type__r.Name; //hasEncounterPCA ? 'Refer to Variable Compensation Exhibit for details' : null;
                        if(agreeRec.Legacy_Encounter__c == false){
                            agreeRec.Legacy_Encounter__c = Boolean.valueOf(pcaRec.Type__r.Name == 'Legacy Encounter');
                        }
                        agreeRec.Requested_Amount__c = String.valueOf(pcaRec.Rate__c);
                        if(pcaRec.Facility_Rate__c != null && pcaRec.Facility_Rate__r.RVU_Metric_Type__c != null){
                            if(pcaRec.Facility_Rate__r.RVU_Metric_Type__c == 'RVU'){
                                agreeRec.RVU_Metric_Type__c = String.valueOf(pcaRec.Facility_Rate__r.RVU_Metric_Type__c);
                            }
                            if(agreeRec.wRVU__c == false){
                                agreeRec.wRVU__c = Boolean.valueOf(cpaVariableType && pcaRec.Facility_Rate__r.RVU_Metric_Type__c == 'wRVU');
                            }
                        }
                        Boolean hasEncounterPCA = Boolean.valueOf(cpaVariableType && pcaRec.Type__r.Name == 'Encounter');
                        if(agreeRec.Encounter__c == false){
                            agreeRec.Encounter__c = hasEncounterPCA;
                        }
                        Boolean hasQPIPCA = Boolean.valueOf(cpaVariableType && pcaRec.Type__r.Name == 'QPI');
                        if(agreeRec.QPI__c == false){
                            agreeRec.QPI__c = hasQPIPCA;
                        }
                        Boolean hasNPPAPCA = Boolean.valueOf(cpaVariableType && pcaRec.Type__r.Name == 'NPPA Encounter');
                        if(agreeRec.NPPA_Encounter__c == false){
                            agreeRec.NPPA_Encounter__c = hasNPPAPCA;
                        }
                        Boolean hasTELEPCA = Boolean.valueOf(cpaVariableType && pcaRec.Type__r.Name == 'Tele Encounter');
                        if(agreeRec.Tele_Encounter__c == false){
                            agreeRec.Tele_Encounter__c = hasTELEPCA;
                        }
                    }
                    if (hasAdministrativeStipendPCA){
                    	agreeRec.Administrative_Stipend__c = pcaRec.Type__r.Name;
                    }
                    String codeSetShiftType = agreeRec.Shift_Type__c;
                    Boolean nppaFlag = Boolean.valueOf(codeSetShiftType == 'NP/PA' && codeSetSubType == 'Employee');
                    //agreeRec.EE_NPPA__c = nppaFlag;           
                    //agreeRec.Full_Time_NPPA__c = Boolean.valueOf(codeSetShiftType == 'NP/PA' && pcaRec.Time_Type__c == 'Full Time');
                    agreeRec.Night_Shift_Bonus__c = (pcaRec.Shift__r.Shift_Name__r.Name == 'Shift Bonus' || pcaRec.Shift__r.Shift_Name__r.Code == 'Shift Bonus') ? String.valueOf(pcaRec.Rate__c) : agreeRec.Night_Shift_Bonus__c;
                    // NEW: Set Night_Shift_Bonus_Full_Name__c to true if Shift Bonus and Rate > 0, but only if not already true (one-way flag)
                    if (agreeRec.Night_Shift_Bonus_Full_Name__c != true) {
                        Boolean isShiftBonus = false;
                        if (pcaRec.Shift__r != null && pcaRec.Shift__r.Shift_Name__r != null) {
                            isShiftBonus = (pcaRec.Shift__r.Shift_Name__r.Name == 'Shift Bonus');
                        }
                        Boolean hasValidRate = (pcaRec.Rate__c != null && pcaRec.Rate__c > 0);
                        if (isShiftBonus && hasValidRate) {
                            agreeRec.Night_Shift_Bonus_Full_Name__c = true;
                        }
                    }
                    agreeRec.Requested_Rate__c = (String.isNotBlank(pcaRec.Shift__c) && pcaRec.Rate__c != null && pcaRec.Rate__c > 0) ? String.valueOf(pcaRec.Rate__c) : agreeRec.Requested_Rate__c;                                        
                    agreeRec.Time_Type__c = (String.isBlank(agreeRec.Time_Type__c)) ? String.valueOf(pcaRec.Time_Type__c) : agreeRec.Time_Type__c;
                    agreeRec.Unit_of_Measure__c = String.valueOf(pcaRec.Unit_of_Measure__c);
                    if (!agreeRec.Display_Addendum_A__c){
                    	agreeRec.Display_Addendum_A__c = Boolean.valueOf((agreeRec.RVU_Metric_Type__c == 'RVU') || (String.isNotBlank(agreeRec.Requested_Rate__c) && (Decimal.valueOf(agreeRec.Requested_Rate__c) > 0)) || (agreeRec.Night_Shift_Bonus_Count__c) || (agreeRec.Encounter__c));
                    }
                    if (!agreeRec.Display_Addendum_A_2__c){
                    	agreeRec.Display_Addendum_A_2__c = Boolean.valueOf((agreeRec.Bonus_Type__c == 'Sign On Bonus') || (agreeRec.Bonus_Type__c == 'Commencement Bonus') || (agreeRec.Bonus_Type__c == 'Relocation Bonus') || (agreeRec.Bonus_Type__c == 'New Grad Bonus') || (agreeRec.Bonus_Type__c == 'Retention Bonus') || (agreeRec.Bonus_Type__c == 'Locums Buyout') || (agreeRec.Bonus_Type__c == 'Other Bonus'));
                    }
                    if (!agreeRec.Display_Addendum_B__c){
                    	agreeRec.Display_Addendum_B__c = Boolean.valueOf((String.isNotBlank(agreeRec.Administrative_Stipend__c)) || (String.isNotBlank(agreeRec.Leadership_Incentive__c) && (Decimal.valueOf(agreeRec.Leadership_Incentive__c) > 0)));                   
                    }
                    updateAgreeMap.put(agreeRec.Id,agreeRec);
                }
            }
        }
        
		Set<Id> ctiClinicianSet = new Set<Id>();
        Map<Id,Set<Id>> conIdToAgreeIdMap = new Map<Id,Set<Id>>();
		Map<Id,Boolean> clinicianToUseCorpNameMap = new Map<Id,Boolean>();
        for (Corporation_and_Tax_Information__c corpTaxRec : [SELECT Id,Clinician__c,Corporation_Name__c,Effective_Date__c,Expiration_Date__c,Status__c,Type__c,Clinician__r.Name,Clinician__r.FirstName,Clinician__r.LastName,Clinician__r.Professional_Title__c FROM Corporation_and_Tax_Information__c WHERE Clinician__c IN :conIdToContIdMap.keySet()]){
            Boolean isCTIActive = false;
            if (!clinicianToUseCorpNameMap.containsKey(corpTaxRec.Clinician__c)){
            	clinicianToUseCorpNameMap.put(corpTaxRec.Clinician__c,false);
            }
            Boolean useCorpName = clinicianToUseCorpNameMap.get(corpTaxRec.Clinician__c);
            ctiClinicianSet.add(corpTaxRec.Clinician__c);
            if (!conIdToAgreeIdMap.containsKey(corpTaxRec.Clinician__c)){
                Set<Id> allAgreeIdSet = new Set<Id>();
                for (Id contId : conIdToContIdMap.get(corpTaxRec.Clinician__c)){
                    allAgreeIdSet.addAll(contIdToAgreeIdMap.get(contId));
                }
                conIdToAgreeIdMap.put(corpTaxRec.Clinician__c,allAgreeIdSet);
            }
            for (Id agreeId : conIdToAgreeIdMap.get(corpTaxRec.Clinician__c)){
                Set<String> activeCTIStatusSet = new Set<String>{'Verified','Executed'};
                Apttus__APTS_Agreement__c agreeRec = agreementMap.get(agreeId);
                Contract contRec = contRecs.get(agreeRec.Contract__c);
                if (!useCorpName && !isCTIActive && corpTaxRec.Type__c == 'Business Entity' && corpTaxRec.Effective_Date__c != null && activeCTIStatusSet.contains(corpTaxRec.Status__c)){
                    isCTIActive = Boolean.valueOf((corpTaxRec.Expiration_Date__c != null && contRec.StartDate >= corpTaxRec.Effective_Date__c && contRec.StartDate <= corpTaxRec.Expiration_Date__c) || (corpTaxRec.Expiration_Date__c == null && contRec.StartDate >= corpTaxRec.Effective_Date__c));
                }
                if (isCTIActive){
                    useCorpName = true;
                    clinicianToUseCorpNameMap.put(corpTaxRec.Clinician__c,useCorpName);
                }
                useCorpName = clinicianToUseCorpNameMap.get(corpTaxRec.Clinician__c);
                agreeRec.Clinician_Contracting_With__c = (useCorpName) ? ((isCTIActive) ? corpTaxRec.Corporation_Name__c : agreeRec.Clinician_Contracting_With__c) : corpTaxRec.Clinician__r.Name; //flip Clinician_Contracting_With__c field
                agreeRec.Provider_Signature_Box__c = (useCorpName) ? ((isCTIActive) ? corpTaxRec.Corporation_Name__c : agreeRec.Provider_Signature_Box__c) : corpTaxRec.Clinician__r.FirstName +  ' ' + corpTaxRec.Clinician__r.LastName + ', ' + corpTaxRec.Clinician__r.Professional_Title__c; //flip Provider_Signature_Box__c field
                agreeRec.Business_Entity__c = useCorpName;
                updateAgreeMap.put(agreeRec.Id,agreeRec);
            }
        }
       
		//add Clinician Contracting With and Provider Signature Box on Contracts with IC Employment Types without CTIs
		Map<Id,Set<Id>> conIdToContIdNoCTIMap = new Map<Id,Set<Id>>(conIdToContIdMap);
		conIdToContIdNoCTIMap.keySet().removeAll(ctiClinicianSet);
		Set<Id> noCTIContSet = new Set<Id>();
		Set<Id> agreeIdNoCTISet = new Set<Id>();
		for (Id conId : conIdToContIdNoCTIMap.keySet()){
			noCTIContSet.addAll(conIdToContIdNoCTIMap.get(conId));
		}
		for (Id contId : noCTIContSet){
			agreeIdNoCTISet.addAll(contIdToAgreeIdMap.get(contId));
		}
		for (Id agreeId : agreeIdNoCTISet){
			Apttus__APTS_Agreement__c agreeRec = agreementMap.get(agreeId);
			agreeRec.Clinician_Contracting_With__c = agreeRec.Clinician_First_Name__c + ' ' + agreeRec.Clinician_Last_Name__c;
			agreeRec.Provider_Signature_Box__c = agreeRec.Clinician_First_Name__c +  ' ' + agreeRec.Clinician_Last_Name__c + ', ' + agreeRec.Professional_Title__c;
			updateAgreeMap.put(agreeRec.Id,agreeRec);
		}
        
		for (Id shiftId : allShiftMap.keySet()){
            Shift__c shiftRec = allShiftMap.get(shiftId);
            if (shiftRec.Type__c == 'NP/PA' || shiftRec.Shift_Name__r.Name == 'Shift Bonus'){
                for (Id agreeId : contIdToAgreeIdMap.get(shiftRec.Contract__c)){
                    Apttus__APTS_Agreement__c agreeRec = agreementMap.get(agreeId);
                	if (shiftRec.Shift_Name__r.Name == 'Shift Bonus'){               
                        agreeRec.Night_Shift_Bonus_Count__c = true; //Look at Shift_Type__c.Name = Shift Bonus???
                        updateAgreeMap.put(agreeRec.Id,agreeRec);
                    }
                    if (shiftRec.Type__c == 'NP/PA'){
                        Boolean employeeSubType = false;
                        Boolean employeeFullTime = false;
                        for (Id pcaId : contIdToPCAIdMap.get(shiftRec.Contract__c)){
                            PreventiveCareAgreement pcaRec = allPCAMap.get(pcaId);
                            if (agreeRec.Corporate_Entity__c == pcaRec.ContractPaymentAgreement.Provider_Network_Contract__r.Healthcare_Practitioner_Facility__r.Contracting_Corporate_Entity__c){
                                if (pcaRec.Type__r.Code_Set_Sub_Type__c == 'Employee'){
                                    employeeSubType = true;
                                }
                                if (pcaRec.Time_Type__c == 'Full Time'){
                                    employeeFullTime = true;
                                }
                                if(employeeSubType && employeeFullTime){
                                    break;
                                }
                            }
                        }
                        if (employeeSubType || employeeFullTime){
                            if(employeeSubType){
                                agreeRec.NPPA_EE_Flag__c = true;
                                agreeRec.EE_NPPA__c = true;
                            }
                            if (employeeFullTime){
                        	    agreeRec.Full_Time_NPPA__c = true;
                            }                        	
                            updateAgreeMap.put(agreeRec.Id,agreeRec);
                        }
                    }
                }
            }
        }
		if (!CongaAgreementServiceHelperTest.updateAgreements){
			return updateAgreeMap.values();
        } else {
            if (Test.isRunningTest()){
               List<Database.SaveResult> agreeSRList = Database.update(updateAgreeMap.values(),false);
               for (Database.SaveResult agreeSR : agreeSRList){
                   if (!agreeSR.isSuccess()){
                       for (Database.Error errorRec : agreeSR.getErrors()){
                           System.debug(LoggingLevel.INFO,errorRec.getMessage());   
                       }
                   }
               }
            }
           return null;
        }
    }
}