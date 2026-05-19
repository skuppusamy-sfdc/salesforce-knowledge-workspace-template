/**
 * @description Controller for clinical data management in agent workflows.
 * Provides invocable and AuraEnabled methods for retrieving, processing, and submitting clinical records.
 */
public with sharing class ClinicalManagerController {
    public static String accountId;
    public static String contractId;
    public static String practiceOperationChangeId;

    /** HPF statuses included when querying impacted clinicians */
    private static final Set<String> HPF_STATUSES = new Set<String>{
        'Active',
        'Waiting to be Scheduled',
        'WTBS Here-WRKG at Sister Site'
    };
    /**
     * @description Agentforce invocable method for clinical data management.
     * @param requests List of ClinicalManagerRequest objects.
     * @return List of ClinicalManagerResponse objects.
     */
    @InvocableMethod(
        label='Get Clinical Manager Data' 
        description='Retrieves clinical data for Agentforce with client-side pagination and selection capabilities'
        category='Clinical Management'
    )
    public static List<ClinicalManagerResponse> getClinicalDataForAgentforce(List<ClinicalManagerRequest> requests) {
        List<ClinicalManagerResponse> responses = new List<ClinicalManagerResponse>();
        // String strMessagingSessionId;  // DEAD: assigned but never used
        //for (ClinicalManagerRequest request : requests) {
        ClinicalManagerRequest request = requests[0];
            system.debug('request@@@@'+request);
            try {
                ClinicalManagerResponse response = new ClinicalManagerResponse();
                
                if (!String.isBlank(request.accId)) {
                    accountId = request.accId; 
                }
                
                if (!String.isBlank(request.contractId)) {
                    contractId = request.contractId; 
                } 
                
                if (!String.isBlank(request.practiceOperationChangeId)) {
                    practiceOperationChangeId = request.practiceOperationChangeId; 
                } 
                
                // strMessagingSessionId = request.messagingSessionId;  // DEAD: assigned but never used
                
                // Set default values if not provided
                if (String.isBlank(request.actionType)) {
                    request.actionType = 'GET_DATA';
                }
                
                // Validate accountId for actions that require it
                if (String.isBlank(accountId) && 
                    (request.actionType == 'GET_DATA' || request.actionType == 'GET_ALL_IDS' || request.actionType == 'GET_SUMMARY')) {
                    response.success = false;
                    response.message = 'Account ID is required to retrieve impacted clinicians.';
                    responses.add(response);
                    return responses;
                }
                
                // Handle different action types
                if (request.actionType == 'GET_DATA') {
                    // Get all data (client-side pagination)
                    ClinicalDataWrapper wrapper = getClinicalData();
                    response.success = true;
                    response.message = 'Successfully retrieved ' + wrapper.records.size() + ' impacted clinicians';
                    
                    // Populate the nested structure for Custom Lightning Type
                    response.clinicalDataList = new ClinicalManagerList();
                    response.clinicalDataList.clinicalRecords = wrapper.records;
                    response.clinicalDataList.totalRecords = wrapper.totalRecords;
                    
                    // Keep existing fields for backward compatibility
                    response.totalRecords = wrapper.totalRecords;
                    response.recordsJson = JSON.serialize(wrapper.records);
                    response.clinicalDataList.accId = accountId;
                    response.clinicalDataList.contractId = contractId;
                    
                } else if (request.actionType == 'GET_ALL_IDS') {
                    // Get all record IDs for selection (inline logic)
                    ClinicalDataWrapper wrapper = getClinicalData();
                    List<String> allIds = new List<String>();
                    for (ClinicalRecord record : wrapper.records) {
                        allIds.add(record.id);
                    }
                    response.success = true;
                    response.allRecordIds = allIds;
                    response.message = 'Successfully retrieved ' + allIds.size() + ' impacted clinician IDs';
                    
                } else if (request.actionType == 'GET_SUMMARY') {
                    // Get summary information
                    Integer totalRecords = [SELECT COUNT()
                                            FROM HealthcarePractitionerFacility
                                            WHERE AccountId = :accountId
                                            AND Status__c IN :HPF_STATUSES];
                    response.success = true;
                    response.totalRecords = totalRecords;
                    response.message = 'Total impacted clinicians available: ' + totalRecords;
                    
                } else if (request.actionType == 'SUBMIT_SELECTION') {
                    // Handle submission of selected records
                    response = processSubmittedRecords(request);
                    
                } else {
                    response.success = false;
                    response.message = 'Invalid action type. Supported actions: GET_DATA, GET_ALL_IDS, GET_SUMMARY, SUBMIT_SELECTION';
                }
                responses.add(response);   
            } catch (Exception e) {
                system.debug('Exception==='+e+'===line#===='+ e.getLineNumber());
                system.debug('Exception==='+'===Error message===='+ e.getMessage());
                ClinicalManagerResponse errorResponse = new ClinicalManagerResponse();
                errorResponse.success = false;
                errorResponse.message = 'Error processing request: ' + e.getMessage();
                responses.add(errorResponse);
            }
        //}
        return responses;
    }
    
    /**
     * @description Lightning-compatible method for LWC to call directly.
     * @param actionType Type of action to perform.
     * @param selectedRecordIds List of selected record IDs.
     * @param accountId Account ID for context.
     * @param lContractId Contract ID for context.
     * @param submissionDataJson Optional JSON metadata.
     * @return LightningResponse Lightning-serializable response.
     */
    @AuraEnabled(cacheable=false)
    public static LightningResponse processSelectedRecords(
        String actionType, 
        List<String> selectedRecordIds, 
        String accountId, 
        String lContractId,
        String submissionDataJson
    ) {
        try {
            // Set the static accountId for use in other methods
            ClinicalManagerController.accountId = accountId;
            
            // Create a request object to reuse existing logic
            ClinicalManagerRequest request = new ClinicalManagerRequest();
            request.actionType = actionType;
            request.selectedRecordIds = selectedRecordIds;
            request.accId = accountId;
            request.submissionDataJson = submissionDataJson;
            request.contractId = lContractId;
            // Call the existing processing method and convert to Lightning response
            ClinicalManagerResponse flowResponse = processSubmittedRecords(request);
            
            // Convert to Lightning-compatible response
            LightningResponse lightningResponse = new LightningResponse();
            lightningResponse.success = flowResponse.success;
            lightningResponse.message = flowResponse.message;
            lightningResponse.recordsJson = flowResponse.recordsJson;
            lightningResponse.totalRecords = flowResponse.totalRecords;
            lightningResponse.allRecordIds = flowResponse.allRecordIds;
            
            return lightningResponse;
            
        } catch (Exception e) {
            LightningResponse response = new LightningResponse();response.success = false;response.message = 'Error processing selected records: ' + e.getMessage();
            System.debug('Error in processSelectedRecords: ' + e.getMessage());
            return response;
        }
    }
    
    /**
     * @description Lightning-compatible response class for AuraEnabled methods (no @InvocableVariable annotations).
     */
    public class LightningResponse {
        @AuraEnabled public Boolean success;
        @AuraEnabled public String message;
        @AuraEnabled public String recordsJson;
        @AuraEnabled public List<String> allRecordIds;
        @AuraEnabled public Integer totalRecords;
        /** Default constructor initializing all fields */
        public LightningResponse() {
            this.success = false;
            this.message = '';
            this.recordsJson = '';
            this.allRecordIds = new List<String>();
            this.totalRecords = 0;
            
        }
    }
    
    // DEAD: getClinicalDataForLightning - not called from LWC (data comes from Agentforce via getClinicalDataForAgentforce)
    // /**
    // * @description Lightning-compatible method to get clinical data (bypasses @InvocableMethod issues)
    // * @param accountId Account ID for context
    // * @return LightningResponse containing clinical data
    // */
    // @AuraEnabled(cacheable=false)
    // public static LightningResponse getClinicalDataForLightning(String accountId) {
    //     try {
    //         ClinicalManagerController.accountId = accountId;
    //         ClinicalDataWrapper wrapper = getClinicalData();
    //         LightningResponse response = new LightningResponse();
    //         response.success = true;
    //         response.message = 'Successfully retrieved ' + wrapper.records.size() + ' clinical records';
    //         response.recordsJson = JSON.serialize(wrapper.records);
    //         response.totalRecords = wrapper.totalRecords;
    //         return response;
    //     } catch (Exception e) {
    //         LightningResponse response = new LightningResponse();
    //         response.success = false;
    //         response.message = 'Error retrieving clinical data: ' + e.getMessage();
    //         System.debug('Error in getClinicalDataForLightning: ' + e.getMessage());
    //         return response;
    //     }
    // }
    
    
    
    /**
     * @description Input class for Agentforce invocable method.
     */
    public class ClinicalManagerRequest {
        @InvocableVariable(label='account recId' description='stores id of account selected by user' required=false)
        public String accId;
        @InvocableVariable(label='Contract recId' description='stores id of user selected Contract' required=false)
        public String contractId;
        @InvocableVariable(label='Practice Operation Change recId' description='stores id of user selected practice operation change id' required=true)
        public String practiceOperationChangeId;
        @InvocableVariable(label='Action Type' description='Type of action to perform (GET_DATA, GET_ALL_IDS, GET_SUMMARY, SUBMIT_SELECTION). Default: GET_DATA' required=false)
        public String actionType;
        
        // DEAD: filterCriteria declared but never used in controller logic
        // @InvocableVariable(label='Filter Criteria' description='Optional filter criteria for records' required=false)
        // public String filterCriteria;
        
        @InvocableVariable(label='Selected Record IDs' description='List of selected record IDs for submission' required=false)
        public List<String> selectedRecordIds;
        
        @InvocableVariable(label='Submission Data JSON' description='JSON string containing submission metadata' required=false)
        public String submissionDataJson;
        
        @InvocableVariable(label='Messaging Session Id' required=false)
        public String messagingSessionId;
        
    }
    
    /**
     * @description Output class for Agentforce invocable method.
     */
    public class ClinicalManagerResponse {
        @InvocableVariable(label='Success' description='Whether the operation was successful')
        public Boolean success;
        
        @InvocableVariable(label='Message' description='Response message or error details')
        public String message;
        
        @InvocableVariable(label='Records JSON' description='JSON string containing clinical records')
        public String recordsJson;
        
        @InvocableVariable(label='All Record IDs' description='List of all record IDs for selection')
        public List<String> allRecordIds;
        
        @InvocableVariable(label='Total Records' description='Total number of records available')
        public Integer totalRecords;
        
        @InvocableVariable(label='Selected Clinician IDs' description='Value for selectedClinicianIds context variable')
        public String selectedClinicianIds;
        
        
        @InvocableVariable(label='Clinical Data List' description='Nested clinical data structure for Custom Lightning Types')
        public ClinicalManagerList clinicalDataList;
        
        @InvocableVariable(label='trigger URLs Generation' description='Flag for triggering the \'Get Contract File Links\' method when \'trigger URLs Generation\' is TRUE')
        public Boolean triggerURLGeneration = false;
        
        // DEAD: accId and contractId never set; clinicalDataList.accId/contractId used instead
        // @InvocableVariable(label='account recId' description='stores id of account selected by user' required=false)
        // public String accId;
        //
        // @InvocableVariable(label='Contract recId' description='stores id of user selected Contract' required=false)
        // public String contractId;
    }
    
    /**
     * @description Nested data structure for Custom Lightning Types.
     */
    public class ClinicalManagerList {
        @InvocableVariable(label='Clinical Records' description='List of clinical records')
        public List<ClinicalRecord> clinicalRecords;
        
        @InvocableVariable(label='Total Records' description='Total number of records')
        public Integer totalRecords;
        
        @InvocableVariable(label='Account Id' description='account id')
        public String accId;
        
        @InvocableVariable(label='Contract Id' description='contract id')
        public String contractId;
    }
    
    /**
     * @description Process submitted records from Agentforce.
     * @param request ClinicalManagerRequest containing submission data.
     * @return ClinicalManagerResponse with processing results.
     */
    private static ClinicalManagerResponse processSubmittedRecords(ClinicalManagerRequest request) {
        ClinicalManagerResponse response = new ClinicalManagerResponse();
        List<Id> lstSelectedClinicianIds = new List<Id>();
        try {
            List<String> selectedIds = request.selectedRecordIds;
            
            if (selectedIds == null || selectedIds.isEmpty()) {
                response.success = false;
                response.message = 'No records selected for submission';
                return response;
            }
            
            // Query the selected records
            List<HealthCarePractitionerFacility> selectedRecords = [
                SELECT 
                Id, 
                PractitionerId, 
                Practitioner.Name, 
                Account.Name
                FROM HealthCarePractitionerFacility 
                WHERE Id IN :selectedIds
            ];
            
            // Debug each selected record
            for (Integer i = 0; i < selectedRecords.size(); i++) {
                HealthCarePractitionerFacility record = selectedRecords[i];
                lstSelectedClinicianIds.add(record.PractitionerId);
            }
            
            // Convert List<Id> to List<String>
            List<String> selectedClinicianIdStrings = new List<String>();
            for (Id clinicianId : lstSelectedClinicianIds) {
                selectedClinicianIdStrings.add(clinicianId);
            }
            
            // Create a Map to hold the list under a specific key
            Map<String, List<String>> jsonBody = new Map<String, List<String>>();
            jsonBody.put('selectedClinicianIds', selectedClinicianIdStrings);
            
            // Serialize the map into a JSON string
            String jsonString = JSON.serialize(jsonBody);
            String finalJSON = convertToComplexClinicianFormat(jsonString);            
            jsonString = finalJSON;
            if (String.isNotBlank(jsonString)){
                Clinical_Rate_Change__c crc = RateChangeQueryService.getOpenRateChange(request.accId, request.contractId);
                if (crc == null){
                    Clinical_Rate_Change__c agData = new Clinical_Rate_Change__c();
                    agData.user_selected_Ids__c = jsonString;
                    agData.Service_Account_ID__c = request.accId;
                    agData.Contract_ID__c = request.contractId;
                    agData.Status__c = 'Open';
                    insert agData;
                } else {
                    crc.user_selected_Ids__c = jsonString;
                    update crc;
                }
                response.triggerURLGeneration = true;  
                response.selectedClinicianIds = jsonString;
            }     
            
            // DEAD: submissionDataJson parsed but result never used (only System.debug)
            // if (!String.isBlank(request.submissionDataJson)) {
            //     try {
            //         Map<String, Object> submissionData = (Map<String, Object>)
            //             JSON.deserializeUntyped(request.submissionDataJson);
            //         System.debug('Submission metadata: ' + submissionData);
            //     } catch (Exception jsonError) {
            //         System.debug('Error parsing submission JSON: ' + jsonError.getMessage());
            //     }
            // }
            
            // Successful processing
            response.success = true;
            response.message = 'Successfully processed ' + selectedRecords.size() + ' selected records';
            response.totalRecords = selectedRecords.size();
            
            // Optionally return processed data
            List<ClinicalRecord> processedRecords = new List<ClinicalRecord>();
            for (HealthCarePractitionerFacility record : selectedRecords) {
                ClinicalRecord clinicalRecord = new ClinicalRecord();
                clinicalRecord.id = record.Id;
                clinicalRecord.clinicianName = record.Practitioner.Name;
                clinicalRecord.facilityTitle = record.Account.Name;
                clinicalRecord.overrate = 'Processed'; // Mark as processed
                processedRecords.add(clinicalRecord);
            }
            
            response.recordsJson = JSON.serialize(processedRecords);
            
        } catch (Exception e) {
            System.debug('Error processing submitted records: ' + e.getMessage());
            response.success = false;
            response.message = 'Error processing submission: ' + e.getMessage();
        }
        system.debug('processSubmittedRecords ====Response=====>'+response);
        return response;
    }
    
    /**
     * @description Converts simple selectedClinicianIds JSON to complex format with selectId objects.
     * @param inputJSON JSON string with selectedClinicianIds array
     * @return JSON string with selectedClinicianIds as array of objects with selectId, or null on error
     */
    public static String convertToComplexClinicianFormat(String inputJSON) {
        try {
            // Parse the input JSON
            Map<String, Object> inputObject = (Map<String, Object>) JSON.deserializeUntyped(inputJSON);
            List<Object> selectedIds = (List<Object>) inputObject.get('selectedClinicianIds');
            
            // Bulkified approach - create all records at once
            List<Map<String, Object>> complexClinicianData = new List<Map<String, Object>>();
            
            // Process all IDs in bulk
            for (Object idObj : selectedIds) {
                String selectId = (String) idObj;
                
                Map<String, Object> clinicianRecord = new Map<String, Object>{
                    'selectId' => selectId/*,
                        'isProcessed' => false  // All marked as false*/
                        };
                            
                            complexClinicianData.add(clinicianRecord);
            }
            
            // Create the target JSON object
            Map<String, Object> targetJsonObject = new Map<String, Object>{
                'selectedClinicianIds' => complexClinicianData
                    };
                        
                        // Convert to JSON string and return
                        return JSON.serialize(targetJsonObject);
            
        } catch (Exception e) {
            System.debug('Error converting JSON: ' + e.getMessage());
            return null;
        }
    }
    
    // DEAD: determineProcessedStatus - never called from production code, only from test
    // /**
    //  * @description Determines if a clinician record has been processed (exists in Contact).
    //  * @param selectId Contact/Clinician Id to check
    //  * @return true if record exists, false otherwise
    //  */
    // @TestVisible private static Boolean determineProcessedStatus(String selectId) {
    //     List<Contact> existingContacts = [SELECT Id FROM Contact WHERE Id = :selectId LIMIT 1];
    //     if (!existingContacts.isEmpty()) {
    //         return true;
    //     }
    //     return false;
    // }
    
    /**
     * @description Internal method to retrieve all clinical records for Agentforce.
     * @return ClinicalDataWrapper containing all clinical records.
     */
    private static ClinicalDataWrapper getClinicalData() {
        try {
            // Get HPF IDs from Client_Change_Management__c with Process Type = Agent and Status = New (contractId required)
            if (String.isBlank(contractId)) {
                ClinicalDataWrapper emptyWrapper = new ClinicalDataWrapper();
                emptyWrapper.records = new List<ClinicalRecord>();
                emptyWrapper.totalRecords = 0;
                return emptyWrapper;
            }
            List<Client_Change_Management__c> ccmRecords = [
                SELECT Healthcare_Practitioner_Facility__c
                FROM Client_Change_Management__c
                WHERE Process_Type__c = 'Agent'
                  AND Status__c = 'New'
                  AND Healthcare_Practitioner_Facility__c != null
                  AND Healthcare_Practitioner_Facility__r.AccountId = :accountId
                  AND Contract__c = :contractId
                  AND Practice_Operation_Change__c = :practiceOperationChangeId
            ];
            Set<Id> hpfIds = new Set<Id>();
            for (Client_Change_Management__c ccm : ccmRecords) {
                hpfIds.add(ccm.Healthcare_Practitioner_Facility__c);
            }
            if (hpfIds.isEmpty()) {
                ClinicalDataWrapper emptyWrapper = new ClinicalDataWrapper();
                emptyWrapper.records = new List<ClinicalRecord>();
                emptyWrapper.totalRecords = 0;
                return emptyWrapper;
            }
            List<HealthcarePractitionerFacility> lstHCP = [
                SELECT Id, Practitioner.Id, Practitioner.Name, Account.Name,
                       Facility_Title__c, Facility_Title__r.Name
                FROM HealthcarePractitionerFacility
                WHERE Id IN :hpfIds
                AND Status__c IN :HPF_STATUSES
            ];

            // Get all clinician Ids
            List<Id> lstPractIdsFromHPF = new List<Id>();
            for (HealthcarePractitionerFacility hcp : lstHCP) {
                if(hcp.Practitioner != null && hcp.Practitioner.Id != null) {
                    lstPractIdsFromHPF.add(hcp.Practitioner.Id);
                }
            }

            List<Account> lstClinicianAccIDs = new List<Account>();            
            List<Contract> lstClinicianContracts = new List<Contract>();   
            Map<Id,Integer> mapPersonAccIdVsOverRate = new Map<Id,Integer>();
             
            if (!lstPractIdsFromHPF.isEmpty()) {
                lstClinicianAccIDs = [select id,PersonContactId 
                                      from Account 
                                      WHERE PersonContactId 
                                      IN :lstPractIdsFromHPF limit 100];
            }
            
            // Extract Account IDs for next query
            List<Id> lstAccountIds = new List<Id>();
            for(Account acc : lstClinicianAccIDs) {
                lstAccountIds.add(acc.Id);
            }
            
            if (!lstAccountIds.isEmpty()) {
                lstClinicianContracts = [SELECT Id,Account.Name 
                                         FROM Contract 
                                         where AccountId 
                                         IN: lstAccountIds 
                                         and Status = 'Executed'];
            }
            
            // Extract Contract IDs for next query
            List<Id> lstContractIds = new List<Id>();
            for(Contract con : lstClinicianContracts) {
                lstContractIds.add(con.Id);
            }
            
            if (!lstContractIds.isEmpty()) {
                for (PreventiveCareAgreement pca : [
                    SELECT
                        ContractPaymentAgreement.Contract.Account.PersonContactId
                    FROM PreventiveCareAgreement
                    WHERE ContractPaymentAgreement.ContractId IN :lstContractIds
                    AND Over_Rate__c = 1
                ]) {
                    mapPersonAccIdVsOverRate.put(pca.ContractPaymentAgreement.Contract.Account.PersonContactId, 1);
                }
            }
            // clinician wrapper
            List<ClinicalRecord> clinicalRecords = new List<ClinicalRecord>();
            for (HealthcarePractitionerFacility hcp : lstHCP) {
                ClinicalRecord record = new ClinicalRecord();
                record.id = hcp.Id;
                record.clinicianName = (hcp.Practitioner != null && hcp.Practitioner.Name != null) ? hcp.Practitioner.Name : 'N/A';
                //record.facilityTitle = (hcp.Account != null && hcp.Account.Name != null) ? hcp.Account.Name : 'N/A';
                record.facilityTitle = (hcp.Facility_Title__c != null && hcp.Facility_Title__r.Name != null) ? hcp.Facility_Title__r.Name : 'N/A';
                record.overrate = (hcp.Practitioner != null && mapPersonAccIdVsOverRate.containsKey(hcp.Practitioner.Id)) ? 'Yes' : 'No';                
                clinicalRecords.add(record);
            }

            // Create and return wrapper
            ClinicalDataWrapper wrapper = new ClinicalDataWrapper();
            wrapper.records = clinicalRecords;
            wrapper.totalRecords = clinicalRecords.size();
            return wrapper;
            
        } catch (Exception e) {
            System.debug('Error in getClinicalData: ' + e.getMessage());
            throw new AuraHandledException('Error retrieving impacted clinicians: ' + e.getMessage());
        }
    }
    
    /**
     * @description Internal wrapper class for clinical data retrieval results.
     */
    private class ClinicalDataWrapper {
        /** List of clinical records */
        public List<ClinicalRecord> records { get; set; }
        /** Total record count for pagination */
        public Integer totalRecords { get; set; }
    }
    
    
    /**
     * @description Clinical record data structure for agent workflows.
     */
    public class ClinicalRecord {
        /** Record ID (HealthCarePractitionerFacility Id) */
        @AuraEnabled public String id { get; set; }
        /** Clinician name from Practitioner */
        @AuraEnabled public String clinicianName { get; set; }
        /** Facility title from Facility_Title__r */
        @AuraEnabled public String facilityTitle { get; set; }
        /** Overrate indicator (Yes/No) */
        @AuraEnabled public String overrate { get; set; }
    }
    
}