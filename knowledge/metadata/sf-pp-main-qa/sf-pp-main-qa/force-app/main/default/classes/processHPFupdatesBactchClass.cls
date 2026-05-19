/***************************************************************************************************************************
* Class Name    : processHPFupdatesBactchClass
* Description   : The batch class is used to upadte the Status, Contracting_Status__c and TerminationDate of 
					the HPF records based on the contracts to which they are linked to.
* Author        : Abhi Kondreddy
* Created Date  : 19-jan-2026
* Last Modified : 
***************************************************************************************************************************/
global class processHPFupdatesBactchClass implements Database.Batchable<SObject>, Database.Stateful {
 	global Set<Id> allContractIds = new Set<Id>();
    global Map<Id, String> failedHPFIds = new Map<Id, String>();
    global Map<Id, Id> HPFToClinicianMapping = new Map<Id, Id>();
    global Map<Id, List<Id>> practitionerToContractIds = new Map<Id, List<Id>>();
    @TestVisible
	private static Boolean forceHPFUpdateFailure = false;

    global Database.QueryLocator start(Database.BatchableContext bc) {
        Date todayDate = Date.today();
        String Query = 'SELECT Id, StartDate, AccountId ' +
                       'FROM Contract ' +
                       'WHERE StartDate <= :todayDate ' +
                       'AND Status = \'Executed\' ' +
            			'AND RecordType_DeveloperName__c = \'Clinician\''+
                       'AND Process_Previous_HPF_Inactivation__c = false';
        return Database.getQueryLocator(Query);      
    }
     global void execute(Database.BatchableContext bc, List<Contract> contracts) {
          if (contracts == null || contracts.isEmpty()) {
            return;
        }
        Set<Id> contractIds = new Set<Id>();
        Map<Id, Date> contractIdToStartDate = new Map<Id, Date>();
        Map<Id, List<Id>> practitionerToContractIds = new Map<Id, List<Id>>();
        for (Contract Con : contracts) {
            if(Con.AccountId != null){
                Id practitionerId = Con.AccountId;
                Id contractId     = Con.Id;
                allContractIds.add(Con.Id);
            
                if (!practitionerToContractIds.containsKey(practitionerId)) {
                    practitionerToContractIds.put(practitionerId, new List<Id>());
                }
                if (!practitionerToContractIds.get(practitionerId).contains(contractId)) {
                    practitionerToContractIds.get(practitionerId).add(contractId);
                }
            }
            if (Con.StartDate != null) {
            	contractIds.add(Con.Id);
            	contractIdToStartDate.put(Con.Id, Con.StartDate);
        	} 
        } 
        if (contractIds.isEmpty()) {
        	return;
    	} 
        List<ProviderNetworkContract> pncs = [ SELECT Id, ContractId, Healthcare_Practitioner_Facility__c 
                                               FROM ProviderNetworkContract 
                                               WHERE ContractId IN :contractIds 
                                              		AND Deleted__c = False];
        if (pncs.isEmpty()) {
        	return;
    	}
        Map<Id, Date> hpfIdToContractStartDate = new Map<Id, Date>();
        Set<Id> HPFIds = new Set<Id>();
        for (ProviderNetworkContract pnc : pncs) {
            if (pnc.Healthcare_Practitioner_Facility__c != null && contractIdToStartDate.containsKey(pnc.ContractId)) {
            	HPFIds.add(pnc.Healthcare_Practitioner_Facility__c);
            	hpfIdToContractStartDate.put(pnc.Healthcare_Practitioner_Facility__c,contractIdToStartDate.get(pnc.ContractId));
            }
        } 
        if (hpfIds.isEmpty()) {
        	return;
    	}        
        List<HealthcarePractitionerFacility> ActiveHealthcarePractitionerRecords = [SELECT Id, PractitionerId, AccountId 
                                                                                    FROM HealthcarePractitionerFacility 
                                                                                    WHERE Id IN :HPFIds];     
        Map<String, Date> practitionerAccountToContractStartDate = new Map<String, Date>();
        Set<Id> PractitionerIds = new Set<Id>();
		Set<Id> ServiceAccountIds = new Set<Id>();
		for (HealthcarePractitionerFacility hpf : ActiveHealthcarePractitionerRecords) {
            if (hpf.PractitionerId != null && hpf.AccountId != null) {
                String key = hpf.PractitionerId + '-' + hpf.AccountId;
            	PractitionerIds.add(hpf.PractitionerId);
            	ServiceAccountIds.add(hpf.AccountId);
        		practitionerAccountToContractStartDate.put(key,hpfIdToContractStartDate.get(hpf.Id));
            }
    	}
        if (practitionerAccountToContractStartDate.isEmpty()) {
        	return;
    	}
        List<HealthcarePractitionerFacility> AllRelatedHealthcarePractitionerRecords = [SELECT Id, PractitionerId, AccountId 
                                                                                    FROM HealthcarePractitionerFacility 
                                                                                    WHERE PractitionerId IN :PractitionerIds 
                                                                                        AND AccountId IN :ServiceAccountIds
                                                                                       	AND Status__c != 'Inactive'
                                                                                        AND EffectiveTo = Null
                                                                                        AND TerminationDate = Null
                                                                                       	AND Id NOT IN :HPFIds];
         
        if (AllRelatedHealthcarePractitionerRecords.isEmpty()) {
        	return;
    	}
         Map<Id, Id> HPFToclinicianMappingForUpdateRecords = new Map<Id, Id>();
         List<HealthcarePractitionerFacility> HpftoUpdate = new List<HealthcarePractitionerFacility>();
         For(HealthcarePractitionerFacility HpfRecord : AllRelatedHealthcarePractitionerRecords){
             String key = HpfRecord.PractitionerId + '-' + HpfRecord.AccountId;
             if (practitionerAccountToContractStartDate.containsKey(key)) {
                HPFToClinicianMapping.put(HpfRecord.Id, HpfRecord.PractitionerId);
               	Date contractStartDate = practitionerAccountToContractStartDate.get(key);
        		HpfRecord.Status__c = 'Inactive';
                HpfRecord.Contracting_Status__c = 'Terminated';
                HpfRecord.TerminationDate = contractStartDate.addDays(-1);
                if (test.isRunningTest() &&forceHPFUpdateFailure) {
                        HpfRecord.Contracting_Status__c = 'INVALID_VALUE';
                }
                HpftoUpdate.add(HpfRecord);
    		}
         }
         if (!HpftoUpdate.isEmpty()) {
            Database.SaveResult[] results = Database.update(HpftoUpdate, false);
            for (Integer i = 0; i < results.size(); i++) {
                if (!results[i].isSuccess()) {
                    Id failedHpfId = HpftoUpdate[i].Id;
                    String errorMessage = '';
                    for (Database.Error err : results[i].getErrors()) {
                        errorMessage += err.getMessage() + ' | ';
                    }
        
                    failedHPFIds.put(failedHpfId, errorMessage);
                    Error_Log__c log = new Error_Log__c();
                    log.Error_Message__c = errorMessage;
                    log.Error_Type__c = 'Apex'; 
                    log.Source_Component__c = 'ProcessHpfUpdatesBatchClass';
                    log.Error_Timestamp__c = System.now();
                    insert log;
                }
            }
        } 
     }
    
    global void finish(Database.BatchableContext bc) {
        Map<Id, List<Id>> practitionerContactToContractIds = new Map<Id, List<Id>>(); 
        List<contract> AllcontractList = [SELECT Id, AccountId, Account.PersonContactId
										FROM Contract
                                        Where Id in :allContractIds];
        For(contract Con :AllcontractList){
            id practitionerId = con.Account.PersonContactId;
            id contractId = con.id;
            if (!practitionerContactToContractIds.containsKey(practitionerId)) {
                    practitionerContactToContractIds.put(practitionerId, new List<Id>());
                }
                if (!practitionerContactToContractIds.get(practitionerId).contains(contractId)) {
                    practitionerContactToContractIds.get(practitionerId).add(contractId);
                }
        }
        Set<Id> failedPractitionerIds = new Set<Id>();        
        for (Id failedHpfId : failedHPFIds.keySet()) {
            if (HPFToClinicianMapping.containsKey(failedHpfId)) {
                failedPractitionerIds.add(HPFToClinicianMapping.get(failedHpfId));
            }
        }
		Set<Id> failedContractIds = new Set<Id>();
        for (Id failedPractId : failedPractitionerIds) {
            if (practitionerContactToContractIds.containsKey(failedPractId)) {
                failedContractIds.addAll(practitionerContactToContractIds.get(failedPractId));
            }
        }
        List<Contract> contractsToUpdate = new List<Contract>();
        for (Id failedContId : failedContractIds) {
            contractsToUpdate.add(new Contract(
                Id = failedContId,
                Process_Previous_HPF_Inactivation__c = false
            ));
        }
        for (Id contractId : allContractIds) {
            if (!failedContractIds.contains(contractId)) {
                contractsToUpdate.add(new Contract(
                    Id = contractId,
                    Process_Previous_HPF_Inactivation__c = true
                ));
            }
        }
        if (!contractsToUpdate.isEmpty()) {
            Database.SaveResult[] contractResults = Database.update(contractsToUpdate, false);
            Integer successCount = 0;
            Integer failCount = 0;
            for (Integer i = 0; i < contractResults.size(); i++) {
                if (contractResults[i].isSuccess()) {
                    successCount++;
                } else {
                    failCount++;
                    Id failedId = contractsToUpdate[i].Id;
                    String errorMsg = '';
                    
                    for (Database.Error err : contractResults[i].getErrors()) {
                        errorMsg += err.getMessage() + ' | ';
                    }
                    System.debug(LoggingLevel.ERROR, 'This is an error updating the Contract records, error : '+errorMsg);
                }
            }
        } 
    }
        
}