/**
* This class takes Fetches Provider Network Records Related to Service Account for Pagination Purpose
* 
* @author Salesforce Services
* @version 1.0
* @since 15/12/2025
* 
* Modification Logs
* =================================================================================
* StoryNumber      DeveloperName       ModifiedDate        Description
* =================================================================================
* PR1050558-4203   Gagandeep Singh     15/12/2025          Created this class    
* 
* =================================================================================
*/
global with sharing class GetProviderNetworkController implements Callable {
    /*
* input  - arguments - List<Object> of arguments passed to the function
* output - result    - The function supports single Object values, List<Object>,
*                      or Map<String, Object>
*/
    private final String CANCELED = 'Canceled';
    private final String DESCSTRING = 'DESC';
    private final String ASCSTRING = 'ASC';
    private final String NULLVALUESTRING = 'nullValues';
    private final String SORTORDERSTRING = 'sortOrder';
    private final String SELECTEDACTIONSTRING = 'selectedAction';
    private final Integer LIMITVALUE = 20;
    public Object call(String action, Map<String, Object> args) {
        Map<String, Object> input = (Map<String, Object>) args.get('input');
        Map<String, Object> output = (Map<String, Object>) args.get('output');
        Map<String, Object> options = (Map<String, Object>) args.get('options');
        return invokeMethod(action, input, output, options);
    }
    
    global Boolean invokeMethod(String methodName, Map<String, Object> inputs,Map<String, Object> output, Map<String, Object> options) {
        if (methodName == 'getPNC') {
            getPNCRecords(inputs, output, options);
        }
        return true;
    }
    private void getPNCRecords(Map<String, Object> input,Map<String, Object> output,Map<String, Object> options){
        
        String recordId = (String) input.get('ContextId');
        Integer totalRecords = Database.countQuery('Select COUNT() FROM ProviderNetworkContract WHERE Contract.Status !=: CANCELED AND Healthcare_Practitioner_Facility__r.AccountId =: recordId');
        Boolean disablePrev;
        Boolean disableNext;
        String sortOrder;
        String nullValues = String.isBlank((String)input.get(NULLVALUESTRING)) ? '' : (String)input.get(NULLVALUESTRING);
        if(String.isBlank((String)input.get(SORTORDERSTRING)))
        {
            sortOrder = ASCSTRING;
        }
        else if((String)input.get(SORTORDERSTRING) == ASCSTRING && (String)input.get('reverseOrder') == 'true'){
            sortOrder = DESCSTRING;
        }
        else if((String)input.get(SORTORDERSTRING) == DESCSTRING && (String)input.get('reverseOrder') == 'true'){
            sortOrder = ASCSTRING;
        }
        else{
            sortOrder = (String)input.get(SORTORDERSTRING);
        }
        String sortRow = String.isBlank((String)input.get('sortRow')) ? 'contract.account.name' : (String)input.get('sortRow');
        Integer currentOffsetValue = String.isBlank((String)input.get('currentOffsetValue')) ? 0 :Integer.valueOf(input.get('currentOffsetValue'));
        if((String) input.get(SELECTEDACTIONSTRING) == 'next'){
            currentOffsetValue +=LIMITVALUE;
        }
        else if((String) input.get(SELECTEDACTIONSTRING) == 'prev'){
            currentOffsetValue -=LIMITVALUE;
        }
        String query = 'SELECT contract.account.name, contract.startdate, healthcare_practitioner_facility__r.accountid, contract.contractnumber,contract.employment_type__c, contractid, contract.status, contract.enddate, id FROM ProviderNetworkContract WHERE Contract.Status !=: CANCELED AND Healthcare_Practitioner_Facility__r.AccountId =: recordId Order By '+ sortRow+ ' '+sortOrder +' '+nullValues+' LIMIT: LIMITVALUE OFFSET: currentOffsetValue'; 
        List<ProviderNetworkContract> pncList = Database.query(query);
        If(currentOffsetValue == 0){
            disablePrev = true;
        }
        else{
            disablePrev = false;
        }
        If(totalRecords < LIMITVALUE || totalRecords - currentOffsetValue <= LIMITVALUE){
            disableNext = true;
        }
        else{
            disableNext = false;
        }
        output.put('pncRecords',pncList);
        output.put('currentOffsetValue',currentOffsetValue);
        output.put('disablePrev',disablePrev);
        output.put('disableNext',disableNext);
        output.put(SORTORDERSTRING,sortOrder);
        output.put('sortRow',sortRow);
        
    }
    
}