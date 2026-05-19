/**
 * @description
 * Service class responsible for handling clinician rate change processing.
 * This includes cloning contracts and related agreements, generating documents,
 * sending notification emails, and performing post-processing such as task
 * creation and summary notifications.
 */
public class RateChangeService{
    /**
    * @description
    * Stores the Org-Wide Email Address Id used for sending rate change notifications.
    */
    private Id orgWideEmailId;
    //private Map<Id, PreventiveCareAgreement> oldToNewPcaMap = new Map<Id, PreventiveCareAgreement>();
    private Map<Id, List<PreventiveCareAgreement>> oldToNewPcaMap = new Map<Id, List<PreventiveCareAgreement>>();

    /**
    * @description
    * Initializes the service by fetching the Org-Wide Email Address
    * with display name "No Reply".
    */
    public RateChangeService() {
        // Query OrgWideEmailAddress once
        OrgWideEmailAddress[] owea = [
            SELECT Id 
            FROM OrgWideEmailAddress 
            WHERE DisplayName = 'No Reply'
            LIMIT 1
        ];
        
        if (!owea.isEmpty()) {
            orgWideEmailId = owea[0].Id;
        }
        
    }
    
    /**
    * @description
    * Returns the Org-Wide Email Address Id used for outbound emails.
    *
    * @return Org-Wide Email Address Id
    */
    public Id getOrgWideEmailId() {
        return orgWideEmailId;
    }
    
    /**
    * @description
    * Executes clinician rate change processing in preview or non-preview mode.
    * Handles contract cloning, document generation, email dispatch,
    * and async processing when required.
    *
    * @param clinicianIds List of clinician Contact Ids
    * @param isPreview Indicates whether execution is in preview mode
    * @param clientContractId Client contract Id
    * @param clinicalRateChangeRec Clinical Rate Change records
    * @return List of newly created Contract Ids (preview mode only)
    */
    public List<Id> execute(
        List<Id> clinicianIds,
        Boolean isPreview,
        String clientContractId,
        List<Clinical_Rate_Change__c> clinicalRateChangeRec
    ) {
        List<Id> newContractIds = new List<Id>();
        try {
            //Prepare data from Clinical_Rate_Change__c
            String serviceAccountId;
            String nonProcessedClinicalIds;
            String createdByPerson;
            List<Id> previewContractIds = new List<Id>();
            
            if (clinicalRateChangeRec != null && !clinicalRateChangeRec.isEmpty()) {
                Clinical_Rate_Change__c firstRecord = clinicalRateChangeRec[0];
                createdByPerson = firstRecord.CreatedById;
                serviceAccountId = firstRecord.Service_Account_ID__c;
                nonProcessedClinicalIds = firstRecord.Non_Processed_Clinical_Ids__c;
                
                if (!String.isBlank(firstRecord.PreviewClonedContractIds__c)) {
                    previewContractIds.addAll(
                        (List<Id>) JSON.deserialize(
                            JSON.serialize(firstRecord.PreviewClonedContractIds__c.split(',')),
                            List<Id>.class
                        )
                    );
                }
            }
            
            //Handle case where clinicianIds are empty ---
            if (clinicianIds == null || clinicianIds.isEmpty()) {
                if (!previewContractIds.isEmpty()) {
                    handlePostProcessing(previewContractIds, serviceAccountId, orgWideEmailId, createdByPerson);
                }
                return new List<Id>();
            }
            
            //Fetch contacts + related accounts ---
            List<Contact> lstContacts = [
                SELECT Id, AccountId, Account.Professional_Title__pc
                FROM Contact
                WHERE Id IN :clinicianIds
                AND AccountId != null
            ];
            
            Map<Id, String> hpaMap = getHpaRecordsForClinicians(clinicianIds, serviceAccountId);
            
            List<Id> npPaClinicianIds = new List<Id>();
            List<Id> otherClinicianIds = new List<Id>();
            
            for (Contact con : lstContacts) {
                String timeType = hpaMap.get(con.Id);
                Boolean isNPPA = (con.Account.Professional_Title__pc == 'NP' || con.Account.Professional_Title__pc == 'PA');
                if (isNPPA && timeType == 'Full Time') {
                    npPaClinicianIds.add(con.Id);
                } else {
                    otherClinicianIds.add(con.Id);
                }
            }
            
            //Process cloning
            List<Id> lstClientContractId = new List<Id>();
            
            if (isPreview) {
                // Process NP/PA contracts synchronously
                if (!npPaClinicianIds.isEmpty()) {
                    List<Id> firstNPPA = new List<Id>{npPaClinicianIds[0]};List<Id> nppaClonedContractIds = this.cloneContracts(firstNPPA, clientContractId);
                    
                    if (!nppaClonedContractIds.isEmpty()) {
                        // Pass only the newly cloned contracts to generateAndAttachLetter
                        this.generateAndAttachLetter(nppaClonedContractIds, clinicalRateChangeRec, false); newContractIds.addAll(nppaClonedContractIds);
                    }
                }
                
                // Process Other contracts synchronously
                if (!otherClinicianIds.isEmpty()) {
                    List<Id> firstOther = new List<Id>{otherClinicianIds[0]};
                        List<Id> otherClonedContractIds = this.cloneContracts(firstOther, clientContractId);
                    
                    if (!otherClonedContractIds.isEmpty()) {
                        // Pass only the newly cloned contracts to generateAndAttachLetter
                        this.generateAndAttachLetter(otherClonedContractIds, clinicalRateChangeRec, false);
                        newContractIds.addAll(otherClonedContractIds);
                    }
                }
                
                return newContractIds;
                
            } else {
                // Non-preview mode → process all asynchronously                
                if (!clinicianIds.isEmpty()) {
                    System.enqueueJob(new CloneAndDocumentQueueable(clinicianIds, clientContractId, clinicalRateChangeRec));
                } else {
                    // No records → send email immediately
                    sendEmailBatch(clinicianIds,clientContractId, orgWideEmailId);                    
                }
                return new List<Id>();
            }
            
        } catch (Exception e) {
            logError('RateChangeService.execute', null, e);return new List<Id>();
        }
    }
    
    /**
    * @description
    * Performs post-processing after contract cloning including
    * email notifications, task creation, and contract finalization.
    *
    * @param newContractIds Newly created contract Ids
    * @param serviceAccountId Service Account Id
    * @param orgWideEmailId Org-Wide Email Address Id
    * @param createdByPerson User Id who initiated the process
    */
    private void handlePostProcessing(
        List<Id> newContractIds,
        String serviceAccountId,
        String orgWideEmailId,
        String createdByPerson      
    ) {
        if (newContractIds.isEmpty()){ return; }
        
        sendEmailBatch(newContractIds, serviceAccountId, orgWideEmailId);
        Map<String, Integer> resultMap = new Map<String, Integer>{
            'Success' => newContractIds.size()
                };
 
        // Update old contracts, create tasks, send summary email
        finalize(newContractIds, serviceAccountId, resultMap, createdByPerson);
    }
    
    /**
    * @description
    * Clones clinician contracts and all related agreements including
    * PNCs, CPAs, PCAs, and Rate Pay Codes.
    *
    * @param clinicianContractIds Clinician contract Ids
    * @param clientContractId Client contract Id
    * @return List of newly created contract Ids
    */
    public List<Id> cloneContracts(List<Id> clinicianContractIds, String clientContractId) {
        List<Id> newlyCreatedContractIds = new List<Id>();
        
        if (clinicianContractIds == null || clinicianContractIds.isEmpty()) {
            return newlyCreatedContractIds;
        }

        // Track for cleanup if failures occur
        List<Contract> contractsToDelete = new List<Contract>();
        List<ProviderNetworkContract> pncsToDelete = new List<ProviderNetworkContract>();
        List<ContractPaymentAgreement> cpasToDelete = new List<ContractPaymentAgreement>();
        List<PreventiveCareAgreement> pcasToDelete = new List<PreventiveCareAgreement>();
        List<Rate_Pay_Code__c> ratePayCodesToDelete = new List<Rate_Pay_Code__c>();
        
        try {
            //Get Client Contract if provided
            Contract clientContract = !String.isBlank(clientContractId)
                ? getClientContractData(clientContractId) : null;

            //Fetch and clone Contracts
           // List<Contract> originalContracts = fetchOriginalContracts(clinicianContractIds);
            
            Map<Id, Contract> latestContractByAccount = new Map<Id, Contract>();
            for (Contract c : fetchOriginalContracts(clinicianContractIds)) {
                
                if (!latestContractByAccount.containsKey(c.AccountId)) {
                    latestContractByAccount.put(c.AccountId, c);
                }
            }
            
             List<Contract> originalContracts = latestContractByAccount.values();
            
            if (originalContracts.isEmpty()){ return newlyCreatedContractIds; }
            
            Map<Id, Contract> successfulContractClones =
                cloneAndInsertContracts(originalContracts, clientContract, contractsToDelete, newlyCreatedContractIds);

            if (successfulContractClones.isEmpty()){ return newlyCreatedContractIds;}
            
            //Clone Provider Network Contracts (PNCs)
            Map<Id, ProviderNetworkContract> successfulPNCClones =
                cloneAndInsertPNCs(successfulContractClones, pncsToDelete, contractsToDelete);

            //Build ID maps for CPA/PCA
            Map<Id, Id> contractIdMap = buildIdMap(successfulContractClones);
            Map<Id, Id> pncIdMap = buildIdMap(successfulPNCClones);
            
            //Clone CPA/PCA records
            createCPAandPCA(contractIdMap, pncIdMap, contractsToDelete, pncsToDelete, cpasToDelete, pcasToDelete, clientContractId);

            //Cleanup failures
            cleanupFailedRecords(contractsToDelete, pncsToDelete, cpasToDelete, pcasToDelete, ratePayCodesToDelete);
            
            return newlyCreatedContractIds;
            
        } catch (Exception ex) {
            logError('RateChangeService.cloneContracts', null, ex);return newlyCreatedContractIds;
        }
    }
    
    /**
    * @description
    * Fetches original clinician contracts for cloning.
    *
    * @param clinicianContractIds Clinician contract Ids
    * @return List of original Contract records
    */
    private List<Contract> fetchOriginalContracts(List<Id> clinicianContractIds) {
        return (List<Contract>) QueryHelper.fetchAllFields(
            Contract.SObjectType,
            new Set<Id>(clinicianContractIds),
            'Account.PersonContactId',
            new Set<String>{ 'Account.Name' }
        );
    }
    
    /**
    * @description
    * Clones and inserts Contract records.
    *
    * @param originalContracts Original contracts
    * @param clientContract Client contract reference
    * @param contractsToDelete Cleanup list
    * @param newlyCreatedContractIds Output list
    * @return Map of original Contract Id to cloned Contract
    */
    private Map<Id, Contract> cloneAndInsertContracts(
        List<Contract> originalContracts,
        Contract clientContract,
        List<Contract> contractsToDelete,
        List<Id> newlyCreatedContractIds
    ) {
        List<Contract> clonedContracts = new List<Contract>();
        Map<Id, Contract> originalToCloneMap = new Map<Id, Contract>();

        for (Contract original : originalContracts) {
            Date startDate = (clientContract != null && clientContract.StartDate != null)
                ? clientContract.StartDate : Date.today();
            startDate = Test.isRunningTest() ? Date.today() + 120 : startDate;
            Map<String, Object> overrides = new Map<String, Object>{
                'Name' => (original.Account.Name != null ? original.Account.Name : 'Clone') + ' ' + startDate,
                    'Status' => 'Draft',
                    'StartDate' => startDate,
                    'PreviousContractId' => original.Id,
                    'RecordTypeId' => original.RecordTypeId,
                    'Base_Agreement_Date__c' => original.StartDate,
                    'CompanySignedDate' => System.today(),
                    'Contract_Trigger_Ack__c' => false
                    };
                        
                        if (original.AccountId != null){ overrides.put('AccountId', original.AccountId);}
            if (original.Pricebook2Id != null){ overrides.put('Pricebook2Id', original.Pricebook2Id);}
            if (original.ContractTerm != null){ overrides.put('ContractTerm', original.ContractTerm);}
            
            Contract clone = (Contract) CloneHelper.dynamicClone(original, new List<String>{ 'Id' }, overrides);
            clonedContracts.add(clone);
            originalToCloneMap.put(original.Id, clone);

        }
        
        Map<Id, Contract> successfulContractClones = new Map<Id, Contract>();
        Database.SaveResult[] results = Database.insert(clonedContracts, false);
        
        for (Integer i = 0; i < results.size(); i++) {
            if (results[i].isSuccess()) {
                successfulContractClones.put(originalContracts[i].Id, clonedContracts[i]);
                newlyCreatedContractIds.add(clonedContracts[i].Id);              
            } else {
                System.debug('Error ::'+results[i].getErrors());
                logError('Contract Insert Failed', originalContracts[i].Id, results[i].getErrors()); contractsToDelete.add(clonedContracts[i]);
            }
        }

        return successfulContractClones;
    }
    
    /**
    * @description
    * Clones and inserts Provider Network Contracts (PNCs).
    *
    * @param successfulContractClones Map of successful contract clones
    * @param pncsToDelete Cleanup list
    * @param contractsToDelete Cleanup list
    * @return Map of original PNC Id to cloned PNC
    */
    private Map<Id, ProviderNetworkContract> cloneAndInsertPNCs(
        Map<Id, Contract> successfulContractClones,
        List<ProviderNetworkContract> pncsToDelete,
        List<Contract> contractsToDelete
    ) {
        Map<Id, ProviderNetworkContract> successfulPNCClones = new Map<Id, ProviderNetworkContract>();
        if (successfulContractClones.isEmpty()) {return successfulPNCClones;}
        
        Set<Id> successfulContractIds = successfulContractClones.keySet();
        List<ProviderNetworkContract> originalPNCs = (List<ProviderNetworkContract>) QueryHelper.fetchAllFields(
            ProviderNetworkContract.SObjectType,
            successfulContractIds,
            'ContractId'
        );
        
        if (originalPNCs.isEmpty()) {return successfulPNCClones;}
        
        List<ProviderNetworkContract> clonedPNCs = new List<ProviderNetworkContract>();
        for (ProviderNetworkContract pnc : originalPNCs) {
            Contract clonedContract = successfulContractClones.get(pnc.ContractId);
            if (clonedContract == null) continue;
            
            Date startDate = clonedContract.StartDate != null ? clonedContract.StartDate : Date.today();
            Date endDate = (clonedContract.EndDate == null || clonedContract.EndDate < startDate)
                ? startDate.addMonths(12) : clonedContract.EndDate;
            
            Map<String, Object> overrides = new Map<String, Object>{
                'ContractId' => clonedContract.Id,
                    'StartDate' => startDate,
                    'EndDate' => endDate
                    };
                        
                        if (pnc.HealthcarePayerNetworkId != null){ overrides.put('HealthcarePayerNetworkId', pnc.HealthcarePayerNetworkId);}
            if (pnc.HealthcareProviderId != null){overrides.put('HealthcareProviderId', pnc.HealthcareProviderId);}
            if (pnc.Healthcare_Practitioner_Facility__c != null){ overrides.put('Healthcare_Practitioner_Facility__c', pnc.Healthcare_Practitioner_Facility__c);}
            if (pnc.Number_of_Anticipate_Hours__c != null){ overrides.put('Number_of_Anticipate_Hours__c', pnc.Number_of_Anticipate_Hours__c);}
            
            ProviderNetworkContract clone = (ProviderNetworkContract) CloneHelper.dynamicClone(
                pnc,
                new List<String>{ 'Id', 'ContractId' },
                overrides
            );
            clonedPNCs.add(clone);
        }
        
        Database.SaveResult[] pncResults = Database.insert(clonedPNCs, false);
        for (Integer i = 0; i < pncResults.size(); i++) {
            if (pncResults[i].isSuccess()) {
                successfulPNCClones.put(originalPNCs[i].Id, clonedPNCs[i]);
            } else {
                logError('PNC Insert Failed', originalPNCs[i].Id, pncResults[i].getErrors()); pncsToDelete.add(clonedPNCs[i]);
                // Rollback related contract if needed
                Id failedContractId = originalPNCs[i].ContractId;
                if (successfulContractClones.containsKey(failedContractId)) {
                    contractsToDelete.add(successfulContractClones.get(failedContractId)); successfulContractClones.remove(failedContractId);
                }
            }
        }
        return successfulPNCClones;
    }
    
    /**
    * @description
    * Builds a mapping between old and new record Ids.
    *
    * @param cloneMap Map of old Id to cloned SObject
    * @return Map of old Id to new Id
    */
    private Map<Id, Id> buildIdMap(Map<Id, SObject> cloneMap) {
        Map<Id, Id> idMap = new Map<Id, Id>();
        for (Id oldId : cloneMap.keySet()) {
            idMap.put(oldId, cloneMap.get(oldId).Id);
        }
        return idMap;
    }
    
    /**
    * @description
    * Deletes partially created records when failures occur.
    *
    * @param contractsToDelete Contracts to delete
    * @param pncsToDelete PNCs to delete
    * @param cpasToDelete CPAs to delete
    * @param pcasToDelete PCAs to delete
    * @param ratePayCodesToDelete Rate Pay Codes to delete
    */
    private void cleanupFailedRecords(
        List<Contract> contractsToDelete,
        List<ProviderNetworkContract> pncsToDelete,
        List<ContractPaymentAgreement> cpasToDelete,
        List<PreventiveCareAgreement> pcasToDelete,
        List<Rate_Pay_Code__c> ratePayCodesToDelete
    ) {
        try {
            if (!ratePayCodesToDelete.isEmpty()) {delete ratePayCodesToDelete;}
            if (!pcasToDelete.isEmpty()) {delete pcasToDelete;}
            if (!cpasToDelete.isEmpty()) {delete cpasToDelete;}
            if (!pncsToDelete.isEmpty()) {delete pncsToDelete;}
            if (!contractsToDelete.isEmpty()) {delete contractsToDelete;}
        } catch (DmlException cleanupEx) {
            logError('Cleanup Failed', null, cleanupEx);
        }
    }
    
    /**
    * @description
    * Creates and clones Contract Payment Agreements (CPA)
    * and Preventive Care Agreements (PCA).
    *
    * @param oldToNewContractMap Contract Id mapping
    * @param oldToNewPNCMap PNC Id mapping
    * @param contractsToDelete Cleanup list
    * @param pncsToDelete Cleanup list
    * @param cpasToDelete Cleanup list
    * @param pcasToDelete Cleanup list
    * @param clientContractId Client contract Id
    */
    private void createCPAandPCA(
        Map<Id, Id> oldToNewContractMap,
        Map<Id, Id> oldToNewPNCMap,
        List<Contract> contractsToDelete,
        List<ProviderNetworkContract> pncsToDelete,
        List<ContractPaymentAgreement> cpasToDelete,
        List<PreventiveCareAgreement> pcasToDelete,
        String clientContractId
    ) {
        try {

            if (oldToNewContractMap.isEmpty()) {
                System.debug('No contract mappings found, skipping CPA/PCA cloning.');
                return;
            }
            
            Map<Id, Contract> newContractMap = fetchNewContracts(oldToNewContractMap.values());
            Map<Id, Account> accountMap = fetchAccounts(newContractMap.values());
            List<ContractPaymentAgreement> originalCPAs = fetchOriginalCPAs(oldToNewContractMap.keySet());
            if (originalCPAs.isEmpty()) {return;}
            
            Map<Id, ProviderNetworkContract> pncMap = fetchPNCsForCPAs(originalCPAs);
            
            // Clone CPAs
            Map<Id, Id> oldCPAtoNewCPA = cloneCPAs(
                originalCPAs,
                oldToNewContractMap,
                oldToNewPNCMap,
                newContractMap,
                accountMap,
                contractsToDelete,
                cpasToDelete
            );
            if (oldCPAtoNewCPA.isEmpty()) {return;}
            
            List<Rate_Pay_Code__c> ratePayCodesToDelete = new List<Rate_Pay_Code__c>();
            // Clone PCAs
            //List<PreventiveCareAgreement> clonedPCAs = clonePCAs(oldCPAtoNewCPA, pcasToDelete);           
            Map<Id, List<PreventiveCareAgreement>> oldToNewPcaMap = clonePCAs(oldCPAtoNewCPA, pcasToDelete);

            //Clone Rate Pay code Records
            //cloneRatePayCodesForPCAs(oldToNewPcaMap, ratePayCodesToDelete);
            cloneRatePayCodesForPCAs(oldToNewPcaMap, ratePayCodesToDelete);

            List<PreventiveCareAgreement> allClonedPCAs = new List<PreventiveCareAgreement>();
            for (List<PreventiveCareAgreement> pcaList : oldToNewPcaMap.values()) {
                allClonedPCAs.addAll(pcaList);
            }
            
            // Adjust rates if clientContractId is provided and there are cloned PCAs
            if (!allClonedPCAs.isEmpty() && !String.isBlank(clientContractId)) {
                adjustShiftRates(allClonedPCAs, clientContractId);
            }
        } catch (Exception ex) {
            logError('RateChangeService.createCPAandPCA', null, ex);
        }
    }
    
    /**
    * @description
    * Clones Rate Pay Codes for newly created PCAs.
    *
    * @param oldToNewPcaMap PCA Id mapping
    * @param ratePayCodesToDelete Cleanup list
    */
    public void cloneRatePayCodesForPCAs(Map<Id, List<PreventiveCareAgreement>> oldToNewPcaMap, List<Rate_Pay_Code__c> ratePayCodesToDelete) {
        if (oldToNewPcaMap.isEmpty()) return;
        system.debug('oldToNewPcaMap@@@'+oldToNewPcaMap);
        // Get all old PCA Ids to query children
        Set<Id> oldPcaIds = oldToNewPcaMap.keySet();
        
        // Query original Rate_Pay_Code__c records linked to old PCAs
        List<Rate_Pay_Code__c> originalRatePayCodes = (List<Rate_Pay_Code__c>) QueryHelper.fetchAllFields(
            Rate_Pay_Code__c.SObjectType,
            oldPcaIds,
            'Preventive_Care_Agreement__c'
        );
        system.debug('originalRatePayCodes@@@@'+originalRatePayCodes);
        List<Rate_Pay_Code__c> clones = new List<Rate_Pay_Code__c>();
        
       for (Rate_Pay_Code__c original : originalRatePayCodes) {
           // Get the list of new PCAs cloned from the original PCA
           List<PreventiveCareAgreement> newPcas = oldToNewPcaMap.get(original.Preventive_Care_Agreement__c);
           if (newPcas == null || newPcas.isEmpty()) continue;
           
           for (PreventiveCareAgreement newPca : newPcas) {
               // Set new PCA Id as the parent
               Map<String, Object> overrides = new Map<String, Object>{
                   'Preventive_Care_Agreement__c' => newPca.Id
                       };
                           
                           // Clone Rate Pay Code with updated parent
                           Rate_Pay_Code__c clone = (Rate_Pay_Code__c) CloneHelper.dynamicClone(
                               original,
                               new List<String>{ 'Id', 'Preventive_Care_Agreement__c' },
                               overrides
                           );
               clones.add(clone);
               System.debug('Cloned Rate Pay Code: ' + clone);
           }
       }
      
        if (!clones.isEmpty()) {
            Database.SaveResult[] saveResults = Database.insert(clones, false);
            for (Integer i = 0; i < saveResults.size(); i++) {
                if (!saveResults[i].isSuccess()) {
                    logError('RatePayrec Insert Failed', null, saveResults[i].getErrors()); if (clones[i].Id != null) ratePayCodesToDelete.add(clones[i]);
                }
                else{
                    system.debug('saveResults[i] @@@@'+saveResults[i]);
                }
            }
        }

    }


    //fetchNewContracts
    private Map<Id, Contract> fetchNewContracts(List<Id> newContractIds) {
        return new Map<Id, Contract>([
            SELECT Id, ContractNumber, AccountId, StartDate 
            FROM Contract 
            WHERE Id IN :newContractIds
        ]);
    }
    
    /**
    * @description
    * Fetches Account records related to the given list of Contracts.
    * Only contracts with a non-null AccountId are considered.
    *
    * @param contracts List of Contract records
    * @return Map of Account Id to Account record
    */
    private Map<Id, Account> fetchAccounts(List<Contract> contracts) {
        Set<Id> accountIds = new Set<Id>();
        for (Contract c : contracts) if (c.AccountId != null) accountIds.add(c.AccountId);
        if (accountIds.isEmpty()) return new Map<Id, Account>();
        
        return new Map<Id, Account>([
            SELECT Id, Global_Provider_ID__pc, Name 
            FROM Account 
            WHERE Id IN :accountIds
        ]);
    }
    
  	/**
    * @description
    * Fetches original Contract Payment Agreements (CPAs) associated
    * with the given set of Contract Ids, including additional related fields.
    *
    * @param contractIds Set of Contract Ids
    * @return List of ContractPaymentAgreement records
    */
    private List<ContractPaymentAgreement> fetchOriginalCPAs(Set<Id> contractIds) {
        Set<string> extraFieldSet = new Set<string>{'Provider_Network_Contract__r.Healthcare_Practitioner_Facility__r.Name'};
        return (List<ContractPaymentAgreement>) QueryHelper.fetchAllFields(
            ContractPaymentAgreement.SObjectType,
            contractIds,
            'ContractId',
            extraFieldSet
        );
    }
    
    /**
    * @description
    * Retrieves Provider Network Contract (PNC) records associated
    * with the provided CPAs.
    *
    * @param cpas List of ContractPaymentAgreement records
    * @return Map of PNC Id to ProviderNetworkContract record
    */
	private Map<Id, ProviderNetworkContract> fetchPNCsForCPAs(List<ContractPaymentAgreement> cpas) {
        Set<Id> pncIds = new Set<Id>();
        for (ContractPaymentAgreement cpa : cpas)
            if (cpa.Provider_Network_Contract__c != null) pncIds.add(cpa.Provider_Network_Contract__c);
        if (pncIds.isEmpty()) return new Map<Id, ProviderNetworkContract>();
        
        return new Map<Id, ProviderNetworkContract>([
            SELECT Id, Healthcare_Practitioner_Facility__r.Account.Global_Facility_ID__c
            FROM ProviderNetworkContract
            WHERE Id IN :pncIds
        ]);
    }
    
  	/**
    * @description
    * Clones Contract Payment Agreements (CPAs) for newly created contracts,
    * applies required field overrides, and handles partial DML failures.
    *
    * @param originalCPAs List of original CPAs to clone
    * @param oldToNewContractMap Map of old Contract Id to new Contract Id
    * @param oldToNewPNCMap Map of old PNC Id to new PNC Id
    * @param newContractMap Map of new Contract Id to Contract record
    * @param accountMap Map of Account Id to Account record
    * @param contractsToDelete List of Contracts to clean up on failure
    * @param cpasToDelete List of CPAs to clean up on failure
    * @return Map of original CPA Id to newly created CPA Id
    */
    private Map<Id, Id> cloneCPAs(
        List<ContractPaymentAgreement> originalCPAs,
        Map<Id, Id> oldToNewContractMap,
        Map<Id, Id> oldToNewPNCMap,
        Map<Id, Contract> newContractMap,
        Map<Id, Account> accountMap,
        List<Contract> contractsToDelete,
        List<ContractPaymentAgreement> cpasToDelete
    ) {
        List<ContractPaymentAgreement> clonedCPAs = new List<ContractPaymentAgreement>();
        Map<Id, Id> oldCPAtoNewCPA = new Map<Id, Id>();
        
        for (ContractPaymentAgreement cpa : originalCPAs) {
            if (!oldToNewContractMap.containsKey(cpa.ContractId)) continue;
            
            Contract newContract = newContractMap.get(oldToNewContractMap.get(cpa.ContractId));
            String uniqueName = buildCPAUniqueName(cpa, newContract, accountMap.get(newContract.AccountId));
            
            Map<String, Object> overrides = new Map<String, Object>{
                'ContractId' => oldToNewContractMap.get(cpa.ContractId),
                    'Provider_Network_Contract__c' => oldToNewPNCMap.get(cpa.Provider_Network_Contract__c),
                    'Status' => 'Draft',
                    'Name' => uniqueName,
                    'ContractPaymentAgreementKey' => null,
                    'StartDateTime' => DateTime.newInstance(newContract.StartDate.year(),
                                                            newContract.StartDate.month(),
                                                            newContract.StartDate.day(), 
                                                            15, 0, 0)
                    };
                        
                        clonedCPAs.add((ContractPaymentAgreement) CloneHelper.dynamicClone(
                            cpa, new List<String>{'Id','ContractId','Provider_Network_Contract__c','Status','Name'}, overrides));
        }
        
        Database.SaveResult[] cpaResults = Database.insert(clonedCPAs, false);
        for (Integer i = 0; i < cpaResults.size(); i++) {
            if (cpaResults[i].isSuccess()) {
                oldCPAtoNewCPA.put(originalCPAs[i].Id, cpaResults[i].getId());
            } else {
                logError('CPA Insert Failed', null, cpaResults[i].getErrors()); if (clonedCPAs[i].Id != null) cpasToDelete.add(clonedCPAs[i]);
                Id parentContractId = oldToNewContractMap.get(originalCPAs[i].ContractId); if (parentContractId != null) contractsToDelete.add(new Contract(Id = parentContractId));
            }
        }
        return oldCPAtoNewCPA;
    }
    
    /**
    * @description
    * Clones Preventive Care Agreements (PCAs) for newly created CPAs
    * and builds a mapping between original and cloned PCA records.
    *
    * @param oldCPAtoNewCPA Map of original CPA Id to new CPA Id
    * @param pcasToDelete List of PCAs to delete if insertion fails
    * @return Map of original PCA Id to list of cloned PCA records
    */
    private Map<Id, List<PreventiveCareAgreement>> clonePCAs(
        Map<Id, Id> oldCPAtoNewCPA,
        List<PreventiveCareAgreement> pcasToDelete
    ) {
        List<PreventiveCareAgreement> originalPCAs = (List<PreventiveCareAgreement>) QueryHelper.fetchAllFields(
            PreventiveCareAgreement.SObjectType,
            oldCPAtoNewCPA.keySet(),
            'ContractPaymentAgreementId'
        );
        
        List<PreventiveCareAgreement> clonedPCAs = new List<PreventiveCareAgreement>();
       
        for (PreventiveCareAgreement pca : originalPCAs) {
            Id newCpaId = oldCPAtoNewCPA.get(pca.ContractPaymentAgreementId);
        	if (newCpaId == null) continue;
            
            Map<String, Object> overrides = new Map<String, Object>{
                'ContractPaymentAgreementId' => oldCPAtoNewCPA.get(pca.ContractPaymentAgreementId)
                    };
                     /*   clonedPCAs.add((PreventiveCareAgreement) CloneHelper.dynamicClone(
                            pca, new List<String>{'Id','ContractPaymentAgreementId'}, overrides));*/ //Updated code below
            PreventiveCareAgreement clonedPca = (PreventiveCareAgreement) CloneHelper.dynamicClone(
            pca, new List<String>{'Id', 'ContractPaymentAgreementId'}, overrides
        	);
        
        	clonedPCAs.add(clonedPca);
            
            // Add to return map
            if (!oldToNewPcaMap.containsKey(pca.Id)) {
                oldToNewPcaMap.put(pca.Id, new List<PreventiveCareAgreement>());
            }
            oldToNewPcaMap.get(pca.Id).add(clonedPca);
        }
        
        Database.SaveResult[] pcaResults = Database.insert(clonedPCAs, false);
        for (Integer i = 0; i < pcaResults.size(); i++) {
            if (!pcaResults[i].isSuccess()) {
                logError('PCA Insert Failed', null, pcaResults[i].getErrors()); if (clonedPCAs[i].Id != null) pcasToDelete.add(clonedPCAs[i]);
            }
        }
        return oldToNewPcaMap;
    }
    
    /**
    * @description
    * Builds a unique name for a Contract Payment Agreement using
    * contract number, account identifier, facility name, and CPA type.
    *
    * @param cpa Original ContractPaymentAgreement
    * @param newContract Newly created Contract
    * @param acc Related Account record
    * @return Generated unique CPA name
    */
    private String buildCPAUniqueName(ContractPaymentAgreement cpa, Contract newContract, Account acc) {
        String globalOrAccount = acc != null && acc.Global_Provider_ID__pc != null ? String.valueOf(acc.Global_Provider_ID__pc) : (acc != null ? acc.Name : 'NA');
                
                return (newContract.ContractNumber != null ? newContract.ContractNumber : 'NA')
                + '-' + globalOrAccount
            	+ '-' + cpa.Provider_Network_Contract__r.Healthcare_Practitioner_Facility__r.Name
                + '-' + (cpa.Type__c != null ? cpa.Type__c : 'NA');
    }
    
    /**
    * @description
    * Logs DML or runtime errors into Error_Log__c records
    * with contextual and stack trace information.
    *
    * @param context Source context or method name
    * @param recordId Related record Id
    * @param err Error object (Database.Error[], Exception, or other)
    */
    public void logError(String context, String recordId, Object err) {
        if (err == null) return; // Nothing to log, avoid unnecessary allocations
        
        List<Error_Log__c> logs = new List<Error_Log__c>();
        
        if (err instanceof Database.Error[]) {
            for (Database.Error dbErr : (Database.Error[]) err) {
                logs.add(new Error_Log__c(Source_Component__c = context,Record_Id__c = recordId,Error_Message__c = dbErr.getMessage(),Stack_Trace__c = dbErr.getStatusCode() != null ? dbErr.getStatusCode().name() : 'No Status Code'
                ));
            }
        } else if (err instanceof Exception) {
            Exception ex = (Exception) err;
            logs.add(new Error_Log__c(
                Source_Component__c = context,
                Record_Id__c = recordId,
                Error_Message__c = ex.getMessage(),
                Stack_Trace__c = ex.getStackTraceString()
            ));
        } else {
            // Fallback: convert unknown object to string
            logs.add(new Error_Log__c(Source_Component__c = context,Record_Id__c = recordId,Error_Message__c = String.valueOf(err),Stack_Trace__c = 'No stack trace available'
            ));
        }
        
        if (!logs.isEmpty()) {
            try {
                insert logs;
            } catch (Exception e) {
                // Avoid recursion: just debug log if error logging fails
                System.debug(LoggingLevel.ERROR, 
                             'Failed to insert Error_Log__c: ' + e.getMessage());
            }
        }
    }
    
    /**
    * @description
    * Wrapper class holding client contract and related identifiers
    * used during document generation processing.
    */
    public class ClientContractWrapper {
        public Contract contract;
        public String serviceAccountId;
        public String clinicalContractId;
    }
    
   	/**
    * @description
    * Generates and attaches rate change notice documents to clinician contracts.
    * Supports preview mode and optional batch-based document generation.
    *
    * @param clinicianContractIds List of clinician Contract Ids
    * @param previewedContracts List of Clinical Rate Change records
    * @param useBatchProcess Indicates whether batch processing should be used
    * @return True if document generation was initiated successfully
    */
    public Boolean generateAndAttachLetter(
        List<Id> clinicianContractIds,
        List<Clinical_Rate_Change__c> previewedContracts,
        Boolean useBatchProcess
    ) {
        if (clinicianContractIds == null || clinicianContractIds.isEmpty()) return false;        
        
        try {
            
            ClientContractWrapper wrapper = fetchClientContractData(previewedContracts);
            
            Map<Id, String> hpaMap = fetchHpaMapping(previewedContracts, wrapper.serviceAccountId);
            
            List<Contract> contracts = fetchContracts(clinicianContractIds);
            if (contracts.isEmpty()) return false;
            
            Map<String, Id> templateMap = fetchTemplates();
            
            // Skip actual document generation during tests
            if (Test.isRunningTest()) {
                System.debug('Skipping document generation in test context.');
                return true; 
            }
            
            DocGenerationBatchProcess batchProcess = useBatchProcess ? createBatchProcess(previewedContracts, wrapper.serviceAccountId, wrapper.clinicalContractId) : null;
            
            Map<String, List<Object>> facilityShiftTable = getFacilityRateData(clinicianContractIds);
            
            List<DocumentGenerationProcess> dgpList = new List<DocumentGenerationProcess>();
            for (Contract contract : contracts) {
                DocumentGenerationProcess dgp = buildDGP(contract, wrapper.contract, hpaMap, templateMap, facilityShiftTable, batchProcess);
                if (dgp != null) dgpList.add(dgp);
            }
            
            if (!dgpList.isEmpty()) {
                insert dgpList; if (batchProcess != null) { batchProcess.Status = 'InProgress'; update batchProcess; }
            }
            
            return !dgpList.isEmpty();
            
        } catch (Exception e) {
            System.debug('Error generating documents: ' + e.getMessage());
            return false;
        }
    }
    
    
    /**
    * @description
    * Fetches client contract details and related identifiers from
    * the previewed Clinical Rate Change records.
    *
    * @param previewedContracts List of Clinical_Rate_Change__c records
    * @return ClientContractWrapper containing contract and related Ids
    */
    public ClientContractWrapper fetchClientContractData(List<Clinical_Rate_Change__c> previewedContracts) {
        ClientContractWrapper wrapper = new ClientContractWrapper();
        if (!previewedContracts.isEmpty()) {
            wrapper.serviceAccountId   = previewedContracts[0].Service_Account_ID__c;
            wrapper.clinicalContractId = previewedContracts[0].Contract_ID__c;
            if (!String.isBlank(wrapper.serviceAccountId)) {
                wrapper.contract = getClientContractData(wrapper.clinicalContractId);
            }
        }
        return wrapper;
    }
    
    /**
    * @description
    * Retrieves Healthcare Practitioner Assignment (HPA) mapping
    * for selected clinicians based on service account.
    *
    * @param previewedContracts List of Clinical_Rate_Change__c records
    * @param serviceAccountId Service Account Id
    * @return Map of Clinician Contact Id to time type
    */
    public  Map<Id, String> fetchHpaMapping(List<Clinical_Rate_Change__c> previewedContracts, String serviceAccountId) {
        List<Id> selectedClinicians = previewedContracts.isEmpty() ? new List<Id>() : getSelectedClinicianIds(previewedContracts);
        return getHpaRecordsForClinicians(selectedClinicians, serviceAccountId);
    } 
    
    /**
    * @description
    * Fetches document template content version Ids required
    * for rate change notice generation.
    *
    * @return Map of template name to ContentVersion Id
    */
    public Map<String, Id> fetchTemplates() {
        Map<String, Id> templateMap = new Map<String, Id>();
        for (DocumentTemplateContentDoc doc : [ SELECT LatestContentVersionId, DocumentTemplate.Name FROM DocumentTemplateContentDoc WHERE DocumentTemplate.Name IN ('RateChangeNoticeEEFTNPPA', 'RateChangeNoticeEEFMD')]) {
            templateMap.put(doc.DocumentTemplate.Name, doc.LatestContentVersionId);
        }
        return templateMap;
    }
    
    /**
    * @description
    * Fetches Contract records for the given list of Contract Ids
    * along with required Account and rate-related fields.
    *
    * @param contractIds List of Contract Ids
    * @return List of Contract records
    */
    public List<Contract> fetchContracts(List<Id> contractIds) {
        return [
            SELECT Id, Name,
            Account.FirstName, Account.LastName, Account.Name, AccountId,
            Account.Service_Line__r.Name, Account.Professional_Title__pc, Account.PersonContactId,
            NPPA_Tier__c, EE_NP_PA_Full_Time_Monthly_Blended__c, EE_NP_PA_Full_Time_Overage_Rate__c,
            Contracting_Corporate_Entity__r.Name, StartDate
            FROM Contract
            WHERE Id IN :contractIds
        ];
    }
    
    
    /**
    * @description
    * Create a batch process record and link it to Clinical_Rate_Change__c
    * it to related Clinical Rate Change records.
    *
    * @param previewedContracts List of Clinical_Rate_Change__c records
    * @param serviceAccountId Service Account Id
    * @param clinicalContractId Clinical Contract Id
    * @return Created DocGenerationBatchProcess record
    */
    public DocGenerationBatchProcess createBatchProcess(List<Clinical_Rate_Change__c> previewedContracts, String serviceAccountId, String clinicalContractId) {
        if (previewedContracts.isEmpty()) return null;
        
        DocGenerationBatchProcess batchProcess = new DocGenerationBatchProcess(
            Description = previewedContracts[0].PreviewClonedContractIds__c,
            Category    = 'RateChangeProcess'            
        );
        insert batchProcess;
        
        List<Clinical_Rate_Change__c> toUpdate = [
            SELECT Id
            FROM Clinical_Rate_Change__c
            WHERE Service_Account_ID__c = :serviceAccountId
            AND Contract_ID__c = :clinicalContractId
            and Status__c = 'Open'
        ];
        for (Clinical_Rate_Change__c rec : toUpdate) {
            rec.DocGenerationBatchProcessId__c = batchProcess.Id;
        }
        if (!toUpdate.isEmpty()) update toUpdate;
        
        return batchProcess;
    }
    
    /**
    * @description
    * Builds a DocumentGenerationProcess record for a clinician contract
    * using rate, facility, and template data.
    *
    * @param contract Clinician Contract record
    * @param clientContract Client Contract record
    * @param hpaMap Map of clinician Contact Id to time type
    * @param templateMap Map of template name to ContentVersion Id
    * @param facilityShiftTable Facility and shift rate data
    * @param batchProcess Optional batch process reference
    * @return DocumentGenerationProcess record or null if not applicable
    */
    @TestVisible
    private DocumentGenerationProcess buildDGP(
        Contract contract,
        Contract clientContract,
        Map<Id, String> hpaMap,
        Map<String, Id> templateMap,
        Map<String, List<Object>> facilityShiftTable,
        DocGenerationBatchProcess batchProcess
    ) {
        String title = contract.Account.Professional_Title__pc;
        String timeType = hpaMap.get(contract.Account.PersonContactId);
        String templateName = ((title == 'NP' || title == 'PA') && 'Full Time'.equals(timeType))
            ? 'RateChangeNoticeEEFTNPPA'
            : 'RateChangeNoticeEEFMD';
        
        String contentVersionId = templateMap.get(templateName);
        if (String.isBlank(contentVersionId)) return null;
        
        Decimal salaryAmount = contract.EE_NP_PA_Full_Time_Monthly_Blended__c != null ? contract.EE_NP_PA_Full_Time_Monthly_Blended__c : 0.0;
        Decimal overageRate  = contract.EE_NP_PA_Full_Time_Overage_Rate__c != null ? contract.EE_NP_PA_Full_Time_Overage_Rate__c : 0.0;
        Date startDate = clientContract != null && clientContract.StartDate != null ? clientContract.StartDate : Date.today();
        string serviceLineName = (clientContract != null && clientContract.Account.Service_Line__c != null && clientContract.Account.Service_Line__r.Name != null) ? clientContract.Account.Service_Line__r.Name : '';
        
        Map<String, Object> tokenData = buildTokenData(contract, startDate, salaryAmount, overageRate, facilityShiftTable, timeType, serviceLineName);
        
        String docTitle = contract.Account.Name + '-' + contract.Contracting_Corporate_Entity__r.Name +
            ' - Compensation Change Notice Letter – ' + startDate;
        
        DocumentGenerationProcess dgp = new DocumentGenerationProcess(
            Type                 = 'GenerateAndConvert',
            TokenData            = JSON.serialize(tokenData),
            RequestText          = '{"keepIntermediate":false,"title":"' + docTitle + '","templateContentVersionId":"' + contentVersionId + '"}',
            ReferenceObject      = contract.Id,
            Status               = 'InProgress',
            DocGenApiVersionType = 'Advanced'
        );
        
        if (batchProcess != null) {
            dgp.DocGenerationBatchProcessId = batchProcess.Id;
        }
        
        return dgp;
    }
    
    /**
    * @description
    * Builds token data used for document generation by evaluating
    * clinician type, rate data, and service line information.
    *
    * @param contract Clinician Contract record
    * @param startDate Effective start date
    * @param salaryAmount Blended salary amount
    * @param overageRate Overage rate amount
    * @param facilityShiftTable Facility and shift rate data
    * @param timeType Clinician time type
    * @param serviceLineName Service line name
    * @return Token data map for document generation
    */
    public Map<String, Object> buildTokenData(
        Contract contract,
        Date startDate,
        Decimal salaryAmount,
        Decimal overageRate,
        Map<String, List<Object>> facilityShiftTable,
        String timeType,
        String serviceLineName
    ) {
        Map<String, Object> tokenData = new Map<String, Object>{
            'DateNotice'            => String.valueOf(System.today()),
                'RequestedEffectiveDate'=> String.valueOf(startDate),
                'ClinicianFirstName'    => contract.Account.FirstName,
                'ClinicianLastName'     => contract.Account.LastName
                };
                    system.debug(JSON.serialize(contract));
                    if ('NP'.equals(contract.Account.Professional_Title__pc) || 'PA'.equals(contract.Account.Professional_Title__pc) && 'Full Time'.equals(timeType)) {
                        tokenData.put('BlendedSalaryAmount', String.valueOf(salaryAmount.setScale(2)));
                        tokenData.put('WorkshiftOverage', String.valueOf(overageRate.setScale(2)));
                    } else {
                        tokenData.put('FacilityShiftTable', facilityShiftTable.get(contract.Id));
                    }
                        tokenData.put('ServiceLine', serviceLineName);
        system.debug(JSON.serialize(tokenData));
        return tokenData;
    }
    
    /**
    * @description
    * Retrieves facility and shift rate data for contracts and prepares
    * token data used in document generation.
    *
    * @param contractIds List of Contract Ids
    * @return Map of Contract Id to facility shift token data
    */
    @TestVisible
    private Map<String,List<Object>> getFacilityRateData(List<Id> contractIds){
        Map<String,List<Object>> facilityTokenData = new Map<String,List<Object>>();
        for(PreventiveCareAgreement pca : [Select Id,
                                           ContractPaymentAgreement.ContractId,
                                           ContractPaymentAgreement.Provider_Network_Contract__r.Healthcare_Practitioner_Facility__r.Contracting_Corporate_Entity__r.Name,
                                           ContractPaymentAgreement.Provider_Network_Contract__r.Healthcare_Practitioner_Facility__r.Name,
                                           ContractPaymentAgreement.Provider_Network_Contract__r.Healthcare_Practitioner_Facility__r.Account.Name,
                                           Shift__r.Shift_Full_Name__c,
                                           Rate__c,
                                           Unit_of_Measure__c,
										   EE_NP_PA_Hourly_Blended__c 
                                           from PreventiveCareAgreement 
                                           where ContractPaymentAgreement.ContractId IN :contractIds 
                                           and ContractPaymentAgreement.Type__c = 'Shift']){
                                               
                                               Decimal requestedRate = pca.EE_NP_PA_Hourly_Blended__c != 0 ? pca.EE_NP_PA_Hourly_Blended__c : pca.Rate__c;
                                               
                                               Map<String,Object> row = new Map<String,Object>{
                                                   'ContractingEntity' => pca?.ContractPaymentAgreement?.Provider_Network_Contract__r?.Healthcare_Practitioner_Facility__r?.Contracting_Corporate_Entity__r?.Name,
                                                       'FacilityName' =>pca?.ContractPaymentAgreement?.Provider_Network_Contract__r?.Healthcare_Practitioner_Facility__r?.Account?.Name,
                                                       'ShiftName' => pca?.Shift__r?.Shift_Full_Name__c,
                                                       'RequestedRate' => '$'+String.valueOf(requestedRate.setScale(2))+' '+pca.Unit_of_Measure__c    
                                                       };
                                                           
                                                           if(facilityTokenData.containskey(pca?.ContractPaymentAgreement?.ContractId)){
                                                               List<Object> rows = facilityTokenData.get(pca?.ContractPaymentAgreement?.ContractId);
                                                               rows.add(row);
                                                           }else{
                                                               
                                                               List<Object> rows = new List<Object>();
                                                               rows.add(row);
                                                               facilityTokenData.put(pca?.ContractPaymentAgreement?.ContractId,rows);
                                                               
                                                           }                                
                                           }
        
        return facilityTokenData;
        
    }
    
    /**
    * @description
    * Sends compensation change notification emails in batches
    * and tracks success and failure counts.
    *
    * @param clinicianContractIds List of Contract Ids
    * @param serviceAccountId Service Account Id
    * @param orgWideEmailId Org-Wide Email Address Id
    * @return Map containing email success and failure counts
    */
    public Map<String, Integer> sendEmailBatch(List<Id> clinicianContractIds, Id serviceAccountId, Id orgWideEmailId) {
        
        Map<String, Integer> resultMap = new Map<String, Integer>{'Success' => 0, 'Failure' => 0};
            if (clinicianContractIds.isEmpty()) return resultMap;
        
        Map<Id, Contract> contractMap = fetchContractsWithAccounts(clinicianContractIds);       
        Map<Id, ContentVersion> contractDocs = fetchLatestContractDocuments(clinicianContractIds);
        List<Messaging.SingleEmailMessage> emails = buildEmailMessages(contractMap, contractDocs, serviceAccountId, orgWideEmailId);
        sendEmailsInBatches(emails, resultMap, 10);
        
        return resultMap;
    }
    
    /**
    * @description
    * Fetches Contract records with Account and contact details
    * required for email processing.
    *
    * @param contractIds List of Contract Ids
    * @return Map of Contract Id to Contract record
    */
    public Map<Id, Contract> fetchContractsWithAccounts(List<Id> contractIds) {
        return new Map<Id, Contract>([
            SELECT Id, AccountId, Account.Name, Account.PersonEmail, Account.PersonContactId
            FROM Contract
            WHERE Id IN :contractIds
        ]);
    }
    
    /**
    * @description
    * Retrieves the latest document versions linked to clinician
    * contracts for email attachment.
    *
    * @param contractIds List of Contract Ids
    * @return Map of Contract Id to latest ContentVersion
    */
    public Map<Id, ContentVersion> fetchLatestContractDocuments(List<Id> contractIds) {
        // Map contractId -> list of ContentDocumentLink
        Map<Id, List<ContentDocumentLink>> docLinksByContract = new Map<Id, List<ContentDocumentLink>>();
        for (ContentDocumentLink link : [
            SELECT ContentDocumentId, LinkedEntityId
            FROM ContentDocumentLink
            WHERE LinkedEntityId IN :contractIds
        ]) {
            if (!docLinksByContract.containsKey(link.LinkedEntityId)) {
                docLinksByContract.put(link.LinkedEntityId, new List<ContentDocumentLink>());
            }
            docLinksByContract.get(link.LinkedEntityId).add(link);
        }
        
        // Collect all ContentDocument Ids
        Set<Id> contentDocIds = new Set<Id>();
        for (List<ContentDocumentLink> links : docLinksByContract.values()) {
            for (ContentDocumentLink link : links) {
                contentDocIds.add(link.ContentDocumentId);
            }
        }
        
        // Fetch latest versions
        Map<Id, ContentVersion> latestVersions = new Map<Id, ContentVersion>();
        if (!contentDocIds.isEmpty()) {
            for (ContentVersion version : [ SELECT Id, Title, VersionData, ContentDocumentId FROM ContentVersion WHERE ContentDocumentId IN :contentDocIds AND IsLatest = true ]) {
                latestVersions.put(version.ContentDocumentId, version);
            }
        }
        
        // Map contractId -> latest ContentVersion
        Map<Id, ContentVersion> contractDocMap = new Map<Id, ContentVersion>();
        for (Id contractId : docLinksByContract.keySet()) {
            for (ContentDocumentLink link : docLinksByContract.get(contractId)) {
                if (latestVersions.containsKey(link.ContentDocumentId)) {
                    contractDocMap.put(contractId, latestVersions.get(link.ContentDocumentId)); break; // take first document
                }
            }
        }
        system.debug(JSON.serialize(contractDocMap));
        return contractDocMap;
    }
    
   /**
    * @description
    * Builds email messages for clinician contracts with optional
    * document attachments.
    *
    * @param contractMap Map of Contract Id to Contract
    * @param contractDocs Map of Contract Id to ContentVersion
    * @param serviceAccountId Service Account Id
    * @param orgWideEmailId Org-Wide Email Address Id
    * @return List of SingleEmailMessage objects
    */
    public List<Messaging.SingleEmailMessage> buildEmailMessages(
        Map<Id, Contract> contractMap,
        Map<Id, ContentVersion> contractDocs,
        Id serviceAccountId,
        Id orgWideEmailId
    ) {
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

        String templateName = System.Label.ClinicianCompensationIncreaseNoticeTemplate;
        EmailTemplate template = [
            SELECT Id
            FROM EmailTemplate
            WHERE DeveloperName = :templateName
            LIMIT 1
        ];
        for (Contract contract : contractMap.values()) {
            if (contract.AccountId == null || String.isBlank(contract.Account.PersonEmail)) continue;
            
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setTemplateId(template.Id);
            email.setSaveAsActivity(true);
            email.setWhatId(contract.Id);
            email.setToAddresses(new List<String>{contract.Account.PersonEmail});
            email.setTargetObjectId(contract.Account.PersonContactId);
            if (orgWideEmailId != null) {
                email.setOrgWideEmailAddressId(orgWideEmailId);
            }

            // Attach document if available
            if (contractDocs.containsKey(contract.Id)) {
                ContentVersion doc = contractDocs.get(contract.Id);
                Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
                attachment.setFileName(doc.Title + '.pdf');
                attachment.setBody(doc.VersionData);
                attachment.setContentType('application/pdf');
                email.setFileAttachments(new Messaging.EmailFileAttachment[]{attachment});
            }
            emails.add(email);
        }
        
        return emails;
    }
    
    /**
    * @description
    * Sends emails in configurable batch sizes and updates
    * result counts based on send outcomes.
    *
    * @param emails List of email messages
    * @param resultMap Map tracking success and failure counts
    * @param batchSize Number of emails per batch
    */
    public void sendEmailsInBatches(
        List<Messaging.SingleEmailMessage> emails,
        Map<String, Integer> resultMap,
        Integer batchSize
    ) {
        List<Messaging.SingleEmailMessage> batch = new List<Messaging.SingleEmailMessage>();
        
        for (Integer i = 0; i < emails.size(); i++) {
            batch.add(emails[i]);
            
            // If batch is full OR last email reached, send it
            if (batch.size() == batchSize || i == emails.size() - 1) {
                Messaging.SendEmailResult[] results = sendEmailBatch(batch);
                updateResultMap(results, resultMap);
                batch.clear();
            }
        }
    }

    /**
    * @description
    * Sends a batch of email messages using Messaging.sendEmail.
    *
    * @param batch List of SingleEmailMessage objects
    * @return Array of SendEmailResult
    */
    public Messaging.SendEmailResult[] sendEmailBatch( List<Messaging.SingleEmailMessage> batch){
        Messaging.SendEmailResult[] results = Messaging.sendEmail(batch, false);
        return results;
    }
    
    /**
    * @description
    * Updates success and failure counts based on email send results.
    *
    * @param results Array of SendEmailResult
    * @param resultMap Map tracking success and failure counts
    */
    public void updateResultMap(Messaging.SendEmailResult[] results, Map<String, Integer> resultMap) {
        for (Messaging.SendEmailResult res : results) {
            if (res.isSuccess()) {
                resultMap.put('Success', resultMap.get('Success') + 1);
            } else {
                resultMap.put('Failure', resultMap.get('Failure') + 1);
                System.debug('Email send error: ' + res.getErrors());
            }
        }
    }
    
    /**
    * @description
    * Finalizes rate change processing by updating contract status,
    * creating tasks, and sending summary emails.
    *
    * @param newContractIds New contract Ids
    * @param serviceAccountId Service Account Id
    * @param resultMap Email result counts
    * @param createdByPerson Initiating user Id
    */
    public void finalize(List<Id> newContractIds, String serviceAccountId, Map<String, Integer> resultMap, String createdByPerson) {
        try {
            if (newContractIds.isEmpty()) return;
            
            Map<Id, Date> previousContractStartDates = new Map<Id, Date>();
            List<Contract> newContracts = fetchNewContracts(newContractIds, previousContractStartDates);
            
            //deactivatePreviousContracts(previousContractStartDates);           
            updateContractsStatus(newContracts, 'Executed');           
            List<Task> tasksToCreate = createTasksForNewContracts(newContracts, createdByPerson);          
            Account serviceAccount = getSrviceAccountData(serviceAccountId);
            
            //Send summary email
            sendRateChangeSummaryEmail(
                newContracts.size(),
                newContracts.size(), // assuming email sent = number of new contracts
                tasksToCreate.size(),
                serviceAccount,
                resultMap,
                createdByPerson
            );
            
            List<Clinical_Rate_Change__c> rateChanges = [SELECT Id,Status__c 
                                                         from Clinical_Rate_Change__c 
                                                         where Service_Account_ID__c = :serviceAccountId and Status__c = 'Open'];
            for(Clinical_Rate_Change__c crc : rateChanges){
                crc.Status__c = 'Closed';
            }
            if(rateChanges.size()>0) update rateChanges;
            
        } catch (Exception e) {
            logError('RateChangeService.finalize', null, e);
        }
    }
    
    //Fetch new contracts and collect previous contract start dates
    public List<Contract> fetchNewContracts(List<Id> newContractIds, Map<Id, Date> previousContractStartDates) {
        List<Contract> newContracts = [
            SELECT Id, PreviousContractId, StartDate, Status, AccountId
            FROM Contract
            WHERE Id IN :newContractIds
        ];
        
        for (Contract c : newContracts) {
            if (c.PreviousContractId != null) {
                previousContractStartDates.put(c.PreviousContractId, c.StartDate);
            }
        }
        return newContracts;
    }
    
    //Deactivate previous contracts by setting Status and EndDate
   /* public void deactivatePreviousContracts(Map<Id, Date> previousContractStartDates) {
        if (previousContractStartDates.isEmpty()) return;
        
        List<Contract> contractsToDeactivate = [
            SELECT Id, Status, EndDate, Cancel_Reason__c,StartDate
            FROM Contract
            WHERE Id IN :previousContractStartDates.keySet()
        ];
        
        for (Contract c : contractsToDeactivate) {
            c.Status = 'Canceled';
            c.Cancel_Reason__c = 'Superseded';
            c.EndDate = previousContractStartDates.get(c.Id) == c.StartDate || c.StartDate > previousContractStartDates.get(c.Id) ? c.StartDate : previousContractStartDates.get(c.Id).addDays(-1);
        }
        
        if (!contractsToDeactivate.isEmpty()) {
            update contractsToDeactivate;
        }
    }*/
    
    //Update status for a list of contracts
    public void updateContractsStatus(List<Contract> contracts, String status) {
        for (Contract c : contracts) {
            c.Status = status;
        }
        if (!contracts.isEmpty()) update contracts;
    }
    
    //Create tasks for each new contract
    public List<Task> createTasksForNewContracts(List<Contract> newContracts, String createdByPerson) {
        List<Task> tasks = new List<Task>();
        
        for (Contract c : newContracts) {
            if (c.AccountId != null) {
                tasks.add(new Task(
                    Subject = 'Contract Cloned',
                    Status = 'Not Started',
                    Priority = 'Normal',
                    Description = 'A new contract has been cloned for this clinician.',
                    WhatId = c.Id,
                    //OwnerId = createdByPerson
                    OwnerId = createdByPerson != null ? createdByPerson : UserInfo.getUserId()
                ));
            }
        }
        
        if (!tasks.isEmpty()) insert tasks;
        return tasks;
    }
    
    //Adjust shift Rates
    public void adjustShiftRates(List<PreventiveCareAgreement> clonedPCAs, Id clientContractId) {
        if (clonedPCAs.isEmpty() || clientContractId == null) return;
        
        try {
            // Step 1: Fetch client PCA shifts (from client contract)
            List<PreventiveCareAgreement> clientShiftPCAs = [
                SELECT Id,
                FacilityTitle__r.Name,
                Shift__r.Shift_Full_Name__c,
                Rate__c,
                Unit_of_Measure__c,Time_Type__c,
                ContractPaymentAgreement.Type__c,
                //ContractPaymentAgreement.Provider_Network_Contract__r.Healthcare_Practitioner_Facility__r.Account.Global_Facility_ID__c
                ContractPaymentAgreement.Contract.Account.Global_Facility_ID__c
                FROM PreventiveCareAgreement
                WHERE ContractPaymentAgreement.ContractId = :clientContractId
                AND ContractPaymentAgreement.Type__c = 'Shift'
            ];
            
            Map<String, PreventiveCareAgreement> clientShiftPcaMap = new Map<String, PreventiveCareAgreement>();
            for (PreventiveCareAgreement pca : clientShiftPCAs) {
                if (pca.Shift__r != null && pca.FacilityTitle__r != null) {
                    string globalFacilityId = pca.ContractPaymentAgreement.Contract.Account.Global_Facility_ID__c != null  ? String.valueOf(pca.ContractPaymentAgreement.Contract.Account.Global_Facility_ID__c)
                        : '';
                    String key = pca.Shift__r.Shift_Full_Name__c + '_' + globalFacilityId + '_' + pca.FacilityTitle__r.Name + '_' + pca.Time_Type__c;
                    clientShiftPcaMap.put(key, pca);
                }
            }
            
            if (clientShiftPcaMap.isEmpty()) return; // No reference rates to copy
            
            //Cloned PCAs with required fields
            List<PreventiveCareAgreement> reloadedClonedPCAs = [
                SELECT Id,
                FacilityTitle__r.Name,
                Shift__r.Shift_Full_Name__c,
                ContractPaymentAgreement.Type__c,Time_Type__c,
                ContractPaymentAgreement.Provider_Network_Contract__r.Healthcare_Practitioner_Facility__r.Account.Global_Facility_ID__c
                FROM PreventiveCareAgreement
                WHERE Id IN :clonedPCAs
            ];
            
            List<PreventiveCareAgreement> pcasToUpdate = new List<PreventiveCareAgreement>();
            for (PreventiveCareAgreement clonedPca : reloadedClonedPCAs) {
                try {
                    if (clonedPca.ContractPaymentAgreement.Type__c == 'Shift' &&
                        clonedPca.Shift__r != null &&
                        clonedPca.FacilityTitle__r != null) {
                            string globalFacilityId = clonedPca.ContractPaymentAgreement.Provider_Network_Contract__r != null 
                                && clonedPca.ContractPaymentAgreement.Provider_Network_Contract__r.Healthcare_Practitioner_Facility__r != null 
                                && clonedPca.ContractPaymentAgreement.Provider_Network_Contract__r.Healthcare_Practitioner_Facility__r.Account.Global_Facility_ID__c != null
                                ? String.valueOf(clonedPca.ContractPaymentAgreement.Provider_Network_Contract__r.Healthcare_Practitioner_Facility__r.Account.Global_Facility_ID__c)
                                : '';
                            String key = clonedPca.Shift__r.Shift_Full_Name__c + '_' + globalFacilityId + '_' + clonedPca.FacilityTitle__r.Name + '_' + clonedPca.Time_Type__c;
                            if (clientShiftPcaMap.containsKey(key)) {
                                PreventiveCareAgreement clientPca = clientShiftPcaMap.get(key);
                                PreventiveCareAgreement cloneToUpdate = new PreventiveCareAgreement(
                                    Id = clonedPca.Id,
                                    Rate__c = clientPca.Rate__c,
                                    Unit_of_Measure__c = clientPca.Unit_of_Measure__c
                                );
                                pcasToUpdate.add(cloneToUpdate);
                            }
                        }
                } catch (Exception innerEx) {
                    logError('Shift PCA mapping failed for PCA ' + clonedPca.Id, null, innerEx);
                }
            }
            
            if (!pcasToUpdate.isEmpty()) {
                update pcasToUpdate;
            }
            
        } catch (Exception ex) {
            logError('adjustShiftRates failed', null, ex);
        }
    }
    
    //To get all PractitionerIDs 
    public static List<Id> getSelectedClinicianIds(List<Clinical_Rate_Change__c> previewedContractRecs) {
        List<Id> selectedClinicianIdSet = new List<Id>();
        
        for (Clinical_Rate_Change__c crcc : previewedContractRecs) {
            if (String.isNotBlank(crcc.user_selected_IDs__c)) {
                try {
                    // Parse the JSON string into a Map
                    Map<String, Object> jsonMap = 
                        (Map<String, Object>) JSON.deserializeUntyped(crcc.user_selected_IDs__c);
                    
                    if (jsonMap.containsKey('selectedClinicianIds')) {
                        List<Object> clinicianList = 
                            (List<Object>) jsonMap.get('selectedClinicianIds');
                        
                        for (Object obj : clinicianList) {
                            Map<String, Object> clinicianMap = 
                                (Map<String, Object>) obj;
                            
                            if (clinicianMap.containsKey('selectId')) {
                                selectedClinicianIdSet.add((Id) clinicianMap.get('selectId'));
                            }
                        }
                    }
                } catch (Exception e) {
                    System.debug('Failed to parse user_selected_IDs__c for Clinical_Rate_Change__c: ' 
                                 + crcc.Id + ' - ' + e.getMessage());
                }
            }
        }
        return selectedClinicianIdSet;
    }
    
    //Get all HPA records for assocaited clinicians
    public Map<Id, String> getHpaRecordsForClinicians(List<Id> clinicianIds, String serviceaccountID) {
        Map<Id, String> clinicianToTimeTypeMap = new Map<Id, String>();
        
        if (clinicianIds.isEmpty()) return clinicianToTimeTypeMap;
        
        List<HealthcarePractitionerFacility> hpaList = [
            SELECT Id, PractitionerId, Time_Type__c
            FROM HealthcarePractitionerFacility
            WHERE PractitionerId IN :clinicianIds
            AND AccountId = :serviceaccountID
        ];
        
        for (HealthcarePractitionerFacility hpa : hpaList) {
            clinicianToTimeTypeMap.put(hpa.PractitionerId, hpa.Time_Type__c);
        }
        
        return clinicianToTimeTypeMap;
    }
    
    //Extract Serviceaccount/clientContractId Data
    Public Contract getClientContractData (string ClientContractId)
    {
        Contract con = [SELECT Id,StartDate, Account.Service_Line__r.Name FROM Contract where Id = :ClientContractId];
        return con;
    }
    
    //Extract Serviceaccount Data
    Public Account getSrviceAccountData (string serviceAccountId)
    {
        Account acc = [SELECT Id,Name  FROM Account where Id = :serviceAccountId];
        return acc;
    }
    
    /**
    * @description
    * Sends a summary email after rate change processing completes.
    *
    * @param totalContracts Total contracts created
    * @param totalEmailsSent Total emails sent
    * @param totalTasksCreated Total tasks created
    * @param AccRec Service Account record
    * @param resultMap Email result counts
    * @param createdByPerson Initiating user Id
    */
    public void sendRateChangeSummaryEmail(Integer totalContracts,Integer totalEmailsSent, Integer totalTasksCreated, Account AccRec, Map<String, Integer> resultMap,String createdByPerson) {
        try {            
            User usertonotify = [Select Id, email from User where Id = :createdByPerson limit 1];
            List<String> toAddresses = new List<String>{usertonotify.email};            
                Integer successCount = resultMap.containsKey('Success') ? resultMap.get('Success') : 0;
            Integer failureCount = resultMap.containsKey('Failure') ? resultMap.get('Failure') : 0;
            Integer totalEmails = successCount + failureCount;
            
            // Build email body
            String emailBody = 'Please see the following outcome from your recent clinician facility rate change notice initiation request.<br/><br/>';
            emailBody += 'Request Date: ' + Date.today() + '<br/>';
            emailBody += 'Impacted Service Account(s): ' + (AccRec != null ? AccRec.Name : 'N/A') + '<br/>';         
            emailBody += 'Total Impacted Clinicians: ' + totalContracts + '<br/>';
            emailBody += 'Total Emails Sent: ' + successCount + ' / Total (' + totalEmails + ')<br/>';       
            emailBody += 'Total Contracts Created: ' + totalContracts + '<br/>';
            
            // Send email
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            if (orgWideEmailId != null) {
                mail.setOrgWideEmailAddressId(orgWideEmailId);
            }
            mail.setToAddresses(toAddresses);
            mail.setSubject('Clinician Facility Rate Change Notice Update - ' + (AccRec != null ? AccRec.Name : ''));    
            mail.setHtmlBody(emailBody);
            
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });
            
        } catch (Exception e) {
            logError('RateChangeService.sendRateChangeSummaryEmail', null, e);
        }
    }    
    
}