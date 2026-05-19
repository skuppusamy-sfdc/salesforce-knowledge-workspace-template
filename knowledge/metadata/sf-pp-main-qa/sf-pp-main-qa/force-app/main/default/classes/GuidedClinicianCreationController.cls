/**
 * This class represents the controller for Guided Clinician
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
 * PR1050558-385	Harsh Gupta			07/08/2025			Replaced the Geographic_Preference__pc 
 * 															with Geographic_PreferenceM__pc
 * =================================================================================
 */
global class GuidedClinicianCreationController implements Callable {
        
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
        if(methodName == 'createClinician') {
            output.put('result', createClinician(inputs));
        }
        return true;
    }
    
    private Map<String, Object> createClinician(Map<String, Object> inputs) {
        try {
            Map<String, Object> result = new Map<String, Object>();
            Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
                .get('Clinician')
                .getRecordTypeId();
			Account acc = new Account();
            acc.RecordTypeId = recordTypeId;
            acc.FirstName = String.valueOf(inputs.get('FirstName'));
            acc.LastName = String.valueOf(inputs.get('LastName'));
            acc.MiddleName = String.valueOf(inputs.get('MiddleName'));
            acc.Suffix = String.valueOf(inputs.get('Suffix'));
            acc.Salutation = String.valueOf(inputs.get('Salutation'));
            acc.Professional_Title__pc = String.valueOf(inputs.get('ProfessionalTitle'));
            acc.PersonEmail = String.valueOf(inputs.get('Email'));
            acc.PersonMobilePhone = String.valueOf(inputs.get('Mobile'));
            acc.PersonLeadSource = String.valueOf(inputs.get('LeadSource'));
            acc.Geographic_PreferenceM__pc = String.valueOf(inputs.get('GeographicPreference'));
            acc.Comments__pc = String.valueOf(inputs.get('Comments'));
            Database.DMLOptions dml = new Database.DMLOptions(); 
            dml.DuplicateRuleHeader.allowSave = true;
            dml.DuplicateRuleHeader.runAsCurrentUser = true;
            Database.SaveResult sr = Database.insert(acc, dml);
            if (sr.isSuccess()) {
                result.put('clinicianId',acc.Id);
            }
            return result;
        } catch(Exception e) {            
            return new Map<String, Object>(); 
        }
    }
        
}