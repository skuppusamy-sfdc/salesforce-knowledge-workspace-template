@isTest
private class GuidedClinicianCreationControllerTest {

    
    @isTest
    static void testCall_CreateClinicianMethod() {
        // Test the 'call' method when action is 'createClinician'
        GuidedClinicianCreationController controller = new GuidedClinicianCreationController();

        Map<String, Object> inputs = new Map<String, Object>();
        inputs.put('FirstName', 'John');
        inputs.put('LastName', 'Doe');
        inputs.put('Suffix', 'Jr.');
        inputs.put('Salutation', 'Mr.');
        inputs.put('ProfessionalTitle', 'Dr.');
        inputs.put('Email', 'john.doe@example.com');
        inputs.put('Mobile', '1234567890');
        inputs.put('LeadSource', 'Web');
        inputs.put('GeographicPreference', 'Alaska');
        inputs.put('Comments', 'Test comments for clinician.');

        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        Map<String, Object> args = new Map<String, Object>();
        args.put('input', inputs);
        args.put('output', output);
        args.put('options', options);

        Test.startTest();
            Object result = controller.call('createClinician', args);
        Test.stopTest();

        // Assertions
        System.assert(result instanceof Boolean, 'Expected result to be a Boolean');
        System.assertEquals(true, (Boolean)result, 'Expected call method to return true for successful invocation');
    }
    
    @isTest
    static void testInvokeMethod_CreateClinician() {
        GuidedClinicianCreationController controller = new GuidedClinicianCreationController();

        Map<String, Object> inputs = new Map<String, Object>();
        inputs.put('FirstName', 'Jane');
        inputs.put('LastName', 'Smith');
        inputs.put('Email', 'jane.smith@example.com');

        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        Test.startTest();
            Boolean success = controller.invokeMethod('createClinician', inputs, output, options);
        Test.stopTest();

        System.assertEquals(true, success, 'invokeMethod should return true for createClinician');
        Map<String, Object> clinicianResult = (Map<String, Object>)output.get('result');
        System.assert(clinicianResult.containsKey('clinicianId'), 'Result should contain clinicianId');
        System.assertNotEquals(null, clinicianResult.get('clinicianId'), 'Clinician Id should not be null');

        // Verify the created account
        Account createdAcc = [SELECT Id, FirstName, LastName FROM Account WHERE Id = : (Id)clinicianResult.get('clinicianId')];
        System.assertEquals('Jane', createdAcc.FirstName, 'First name mismatch');
        System.assertEquals('Smith', createdAcc.LastName, 'Last name mismatch');
    }

}