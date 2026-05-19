/**
 * This Utility contains the custom functions
 * which can not be done by OOB through Omnistudio
 * 
 * @author Salesforce Services
 * @version 1.0
 * @since 06/11/2025
 * 
 * Modification Logs
 * =================================================================================
 * StoryNumber		DeveloperName		ModifiedDate		Description
 * =================================================================================
 * PR1050558-123	Harsh Gupta			06/11/2025			Created this utility	
 * PR1050558-370    Soomjeet Sahoo      06/27/2025          Implemented logError method
 * PR1050558-6506   Nawal Bedmutha      04/30/2026          Implemented findPOContracts in invoke method
 * 
 * 
 * =================================================================================
 */
global class OmniUtility implements Callable {
        
    /*
     * input  - arguments - List<Object> of arguments passed to the function
     * output - result    - The function supports single Object values, List<Object>,
     *                      or Map<String, Object>
     */

    public Object call(String action, Map<String, Object> args) {
        Map<String, Object> input = (Map<String, Object>) args.get('input');
        Map<String, Object> output = (Map<String, Object>) args.get('output');
        Map<String, Object> options = (Map<String, Object>) args.get('options');
        return invokeMethod(action, input, output, options);
    }
        
    global Boolean invokeMethod(String methodName, Map<String, Object> inputs,
        Map<String, Object> output, Map<String, Object> options) {
        if (methodName == 'convert') {
            List<Object> arguments = (List<Object>) inputs.get('arguments');
            output.put('result', convert(arguments));
        }
        else if (methodName == 'logerror') {
            insertErrorLog(inputs);
        }
        else if(methodName == 'generateNPPAOptions'){
            output.putAll(generateNPPAOptions(inputs));
        }
        else if(methodName == 'findPOContracts'){
            output.putAll(GetPOContractByClinicianStartDate.findPOContracts(inputs));
        }


        return true;
    }
        
    private LIST<Map<String, Object>> convert(List<Object> arguments) {
        try {
            LIST<Map<String, Object>> result = new LIST<Map<String, Object>>();
            Map<String, Object> inputlist = (Map<String, Object>) arguments[0];
            String key = (String) arguments[1];
            List<Object> listofElements = (List<Object>) inputlist.get('VLOCITY-FORMULA-LIST');
            for (Object str : listofElements) {
                result.add(new Map<String, Object>{key => str});
            }
            return result;
        } catch(Exception e) {
            return new LIST<Map<String, Object>>(); 
        }
    }

    /**
    * @description : Inserts an Error_Log__c record based on Input Map.
    * @author soomjeet.sahoo | 06-27-2025 
    * @param inputs 
    * @return Error_Log__c 
    **/
    private Error_Log__c insertErrorLog(Map<String,Object> inputs) {
        Error_Log__c errorLogRecord = new Error_Log__c();
        try {
            errorLogRecord = createErrorLogInstance(inputs);
            Database.insert(errorLogRecord,true,System.AccessLevel.SYSTEM_MODE);
            return errorLogRecord;
        } catch (Exception exp) {
            return new Error_Log__c();
        }        
    }

    /**
    * @description : Creates an Error_Log__c record based on Input Map.
    * @author soomjeet.sahoo | 06-27-2025 
    * @param inputs 
    * @return Error_Log__c 
    **/
    private Error_Log__c createErrorLogInstance(Map<String,Object> inputs){
        Error_Log__c errorLogRecord = new Error_Log__c();
        errorLogRecord.Source_Component__c = returnNullIfValueIsEmpty('Err_RunningContext',inputs);
        errorLogRecord.Record_Id__c = returnNullIfValueIsEmpty('Err_CtxId',inputs);
        errorLogRecord.Type__c = returnNullIfValueIsEmpty('Err_ProcessType',inputs);
        errorLogRecord.Error_Timestamp__c = Datetime.now();
        errorLogRecord.Context_JSON__c = JSON.serialize(inputs);
        return errorLogRecord;
    }

    /**
    * @description : Checks for key and returns blank if value is empty.
    * @author soomjeet.sahoo | 06-27-2025 
    * @param key 
    * @param inputs 
    * @return String 
    **/
    private String returnNullIfValueIsEmpty(String key, Map<String,Object> inputs){
        String value = '';
        if(inputs.containsKey(key) && inputs.get(key) != null){
            value = (String) inputs.get(key);
        }
        return value;
    }

    private Map<String, Object> generateNPPAOptions(Map<String, Object> args) {
        // Get input array
        List<Object> inputValues = (List<Object>) args.get('values');
        
        // Handle empty input
        if (inputValues == null || inputValues.isEmpty()) {
            return new Map<String, Object>{'options' => new List<Object>()};
        }
        
        // Remove duplicates
        Set<String> uniqueValues = new Set<String>();
        for (Object val : inputValues) {
            if (val != null && !String.valueOf(val).equalsIgnoreCase('0')) {
                uniqueValues.add(String.valueOf(val));
            }
        }
        
        // Convert to sorted list
        List<String> sortedValues = new List<String>(uniqueValues);
        sortedValues.sort();
        
        // Create options
        List<Map<String, String>> options = new List<Map<String, String>>();
        
        for (String value : sortedValues) {
            options.add(new Map<String, String>{
                'value' => value,
                'label' => getLabel(value)
            });
        }
        
        // Return in expected format
        return new Map<String, Object>{'options' => options};
    }
    
    /**
     * Helper method to format labels
     */
    private String getLabel(String value) {
        if (value == '0' || String.isBlank(value)) {
            return 'None';
        }
        return 'Tier ' + value;
    }
}