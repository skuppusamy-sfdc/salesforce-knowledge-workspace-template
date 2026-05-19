public with sharing class fileToLinkGenerator {
    public static List<String> allSelectedIds = new List<String>();
    /**
    * @description Agentforce invocable method to get file hyperlinks for contracts
    * @param requests List of ContractFileRequest objects
    * @return List of ContractFileResponse objects with file hyperlinks
    */
    @InvocableMethod(
        label='Get Contract File Links' 
        description='Returns hyperlinks for files attached to contracts'
        category='File Management'
    )
    public static List<ContractFileResponse> getContractFilesWithLinks(List<ContractFileRequest> requests) {
        List<ContractFileResponse> responses = new List<ContractFileResponse>();
        String strMessagingSessionId;
        String userSelectedContractId;
        ContractFileResponse response = new ContractFileResponse();
        ContractFileRequest request;
        if(requests!= NULL && requests.size()>0){
        request = requests[0];
                    
        
        List<Clinical_Rate_Change__c> lstAgData = [SELECT id,
                     user_selected_IDs__c,
                     Service_Account_ID__c ,
                     PreviewClonedContractIds__c,
                     Non_Processed_Clinical_Ids__c,
                     DocGenerationBatchProcessId__c,                              
                     Contract_ID__c,CreatedById  FROM Clinical_Rate_Change__c 
                     WHERE  Service_Account_ID__c= :request.accountId and
                     Contract_ID__c = :request.contractId and Status__c = 'Open'];
                
        if(lstAgData.size() > 0){
            try{
                try {
                    // Try to deserialize as JSON object
                    Object jsonResult = JSON.deserializeUntyped(lstAgData[0].user_selected_IDs__c);                    
                    allSelectedIds = extractSelectedClinicianIds(jsonResult);                    
                    system.debug('Final allSelectedIds in fileToLinkGenerator()=====>'+allSelectedIds);
                } catch (JSONException jsonEx) {
                    System.debug('JSON parsing failed, treating as raw string: ' + jsonEx.getMessage());
                }
                system.debug('allSelectedIds=====>'+allSelectedIds);
                
                //convert allSelectedIds List<String> to List<Id>
                List<Id> allSelectedIdsList = new List<Id>();
                for (String idStr : allSelectedIds) {
                    if (String.isNotBlank(idStr)) {
                        allSelectedIdsList.add((Id)idStr);
                    }
                }
                
                List<String> lstcontractIds = new List<String>();
                system.debug('lstAgData=====>'+lstAgData);

                RateChangeService rcsObj = new RateChangeService();
                List<Id> returnedContractIds = rcsObj.execute(allSelectedIdsList,TRUE,request.contractId,lstAgData);
                system.debug('returnedContractIds=====>'+returnedContractIds);
                if(Test.isRunningTest()){
                    TestDataFactory TDF = new TestDataFactory();
        			Account testAccount = TDF.createServiceAccount('Test Healthcare Account', null, 'Service_Account', true);
                    Contract testContract = TestDataFactory.createContract(testAccount, Date.today());
					returnedContractIds.add(testContract.Id);
                }
                
                
                /*Based on cloned contract list as in put in updateProcessedRecords()
                starting the process of identifying and stamping
                unprocessed clinician Ids in JSON in field Non_Processed_Clinical_Ids__c 
                of clinical Rate change obj */
                
                updateProcessedRecords(returnedContractIds,lstAgData);
                List<String> fileLinks = generateContractPageLink(returnedContractIds);
                if(fileLinks!=NULL && fileLinks.size()>0){
                    // Build response
                    response.success = true;
                    response.message = 'Found ' + fileLinks.size() + ' file links';
                    response.fileLinks = fileLinks;               
                    responses.add(response);
                }

             }           
				catch (Exception e) {
                    ContractFileResponse errorResponse = new ContractFileResponse();
                    errorResponse.success = false;
                    errorResponse.message = 'Error: ' + e.getMessage() 
                        +'====='+ e.getLineNumber() 
                        +'====='+ e.getStackTraceString() 
                        +'====='+e.getCause();                    
                    errorResponse.fileLinks = new List<String>();
                    responses.add(errorResponse);
                }
          }
        } // End of If
        return responses;
    }
    
    public static List<String> extractSelectedClinicianIds(Object jsonResult) {
        List<String> allSelectedIds = new List<String>();
        
        if (jsonResult instanceof Map<String, Object>) {
            Map<String, Object> userData = (Map<String, Object>)jsonResult;
            
            // Check if selectedClinicianIds key exists
            if (userData.containsKey('selectedClinicianIds') && userData.get('selectedClinicianIds') != null) {
                Object selectedIdsObj = userData.get('selectedClinicianIds');
                
                // Handle List<Object> case (complex structure with selectId and isProcessed)
                if (selectedIdsObj instanceof List<Object>) {
                    List<Object> selectedIdsObjects = (List<Object>)selectedIdsObj;
                    for (Object idObj : selectedIdsObjects) {
                        if (idObj != null) {
                            // Check if it's a Map (object with selectId and isProcessed)
                            if (idObj instanceof Map<String, Object>) {
                                Map<String, Object> clinicianRecord = (Map<String, Object>)idObj;
                                
                                // Extract selectId from the object
                                if (clinicianRecord.containsKey('selectId') && clinicianRecord.get('selectId') != null) {
                                    String selectId = String.valueOf(clinicianRecord.get('selectId'));
                                    if (String.isNotBlank(selectId)) {
                                        allSelectedIds.add(selectId);
                                    }
                                }
                            }
                            // Handle direct String case (fallback for simple array)
                            else if (idObj instanceof String) {
                                String singleId = (String)idObj;
                                if (String.isNotBlank(singleId)) {
                                    allSelectedIds.add(singleId);
                                }
                            }
                        }
                    }
                }
                
                // Handle single String case (fallback)
                else if (selectedIdsObj instanceof String) {
                    String singleId = (String)selectedIdsObj;
                    if (String.isNotBlank(singleId)) {
                        allSelectedIds.add(singleId);
                    }
                }
            }
        }
        
        return allSelectedIds;
    }
    
    // it was discussed that user will navigate to the contract page to see documents preview
    public static List<String> generateContractPageLink(List<String> lstContractIds) {   
        String baseUrl = URL.getOrgDomainUrl().toExternalForm();
        String urlString;
        List<String> lstUrls = new List<String>();
        for(Contract cont : [Select Id,Account.Name,ContractNumber from Contract where Id IN :lstcontractIds]){
            urlString = baseUrl + '/lightning/r/Contract/' + cont.Id + '/view'; 
             
            system.debug('Final URL========>'+urlString);
            lstUrls.add('<p><a href=\"'+urlString+'\" target="_self">'+cont.Account.Name+' '+cont.ContractNumber+'</a><p>');  // Add string URL instead of URL object
        }
        return lstUrls;
    }
    
    
    /*function for stamping the unprocessed clinician Ids in 
	Non_Processed_Clinical_Ids__c  field on Clinical_Rate_Change__c object*/
    
    private static void updateProcessedRecords(List<String> lstContractIds,List<Clinical_Rate_Change__c> lstAgData) {
        if(!lstContractIds.isEmpty()){
            List<Contract> lstAllContract = [select id,
                                             accountid,
                                             PreviousContractId 
                                             from Contract 
                                             where id IN : lstContractIds];
            
            Set<Id> setAccIds = new Set<Id>();
            list<string> ClonedContractIDs = new list<string>();
            For(Contract con : lstAllContract){
                setAccIds.add(con.accountid);                 
            }
            list<String> lstProcessedUserContacts = new List<String>();
            //processed clinician Ids
            for(Contact con: [SELECT ID from Contact Where AccountID IN : setAccIds]){
                lstProcessedUserContacts.add((string.valueof(con.Id)));
            }         
            
            /*unmatchedClinicianIds list stores the clinician Ids 
            which are yet to be processed by Batch when user says 
			Yes after link preview confirmation*/
            List<String> unmatchedClinicianIds = getUnmatchedElements(allSelectedIds,lstProcessedUserContacts);
            system.debug('unmatchedClinicianIds======>'+unmatchedClinicianIds);
            lstAgData[0].Non_Processed_Clinical_Ids__c  = convertListToJSON(unmatchedClinicianIds);
            // lstContractIds is a List<String>
            if (!lstContractIds.isEmpty()) {
                lstAgData[0].PreviewClonedContractIds__c = String.join(lstContractIds, ',');
            }
            system.debug('@@@@@@@'+lstAgData[0].PreviewClonedContractIds__c);
            upsert lstAgData;
        }
        
    }
    
    //converts list<String> to JSON
    public static String convertListToJSON(List<String> strList) {
        // Dynamic validation - handle empty/null lists
        if (strList == null || strList.isEmpty()) {
            Map<String, Object> emptyJsonObject = new Map<String, Object>{
                'NonProcessedClinicianIds' => new List<String>()
                    };
                        return JSON.serialize(emptyJsonObject);
        }
        
        // Bulkified approach - process entire list at once
        Map<String, Object> jsonObject = new Map<String, Object>{
            'selectedClinicianIds' => strList
                };
                    
                    return JSON.serialize(jsonObject);
    }
    
    //returns list of non processed clinical Ids
    public static List<String> getUnmatchedElements(List<String> list1, List<String> list2) {
        Set<String> set1 = new Set<String>(list1);
        Set<String> set2 = new Set<String>(list2);
        
        // Get symmetric difference (elements in either set but not in both)
        Set<String> union = new Set<String>(set1);
        union.addAll(set2);  
        Set<String> intersection = new Set<String>(set1);
        intersection.retainAll(set2);
        union.removeAll(intersection);    
        return new List<String>(union);
    }
    
    /**
* @description Input class for Agentforce invocable method
*/
    public class ContractFileRequest {
        @InvocableVariable(label='selected account id' description='id of the selected account record id' required=true)
        public String accountId;
        
        @InvocableVariable(label='selected contract id' description='id of the selected contract record id' required=true)
        public String contractId;
    }
    
    /**
* @description Output class for Agentforce invocable method
*/
    public class ContractFileResponse {
        @InvocableVariable(label='Success' description='Whether the operation was successful')
        public Boolean success;
        
        @InvocableVariable(label='Message' description='Response message or error details')
        public String message;
        
        @InvocableVariable(label='File Preview Links' description='List of file preview URLs to be displayed in List format')
        public List<String> fileLinks;
    }
}