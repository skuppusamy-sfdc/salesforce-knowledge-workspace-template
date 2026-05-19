@isTest
private class OmniUtilityTest {
    
    @isTest
    static void testCall_ConvertMethod() {
        // Test the 'call' method when action is 'convert'
        OmniUtility controller = new OmniUtility();

        Map<String, Object> inputMap = new Map<String, Object>();
        inputMap.put('VLOCITY-FORMULA-LIST', new List<Object>{'Value1', 'Value2', 'Value3'});

        List<Object> arguments = new List<Object>{inputMap, 'TestKey'};

        Map<String, Object> inputs = new Map<String, Object>();
        inputs.put('arguments', arguments);

        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        Map<String, Object> args = new Map<String, Object>();
        args.put('input', inputs);
        args.put('output', output);
        args.put('options', options);

        Test.startTest();
            Object result = controller.call('convert', args);
        Test.stopTest();

        // Assertions
        System.assert(result instanceof Boolean, 'Expected result to be a Boolean');
        System.assertEquals(true, (Boolean)result, 'Expected call method to return true for successful invocation');

        List<Map<String, Object>> convertedResult = (List<Map<String, Object>>)output.get('result');
        System.assertEquals(3, convertedResult.size(), 'Expected 3 elements in the converted list');
        System.assertEquals('Value1', convertedResult[0].get('TestKey'), 'First element conversion incorrect');
        System.assertEquals('Value2', convertedResult[1].get('TestKey'), 'Second element conversion incorrect');
        System.assertEquals('Value3', convertedResult[2].get('TestKey'), 'Third element conversion incorrect');
    }
    
    

    @isTest
    static void testInvokeMethod_Convert() {
        OmniUtility controller = new OmniUtility();

        Map<String, Object> inputMap = new Map<String, Object>();
        inputMap.put('VLOCITY-FORMULA-LIST', new List<Object>{'ItemA', 'ItemB'});

        List<Object> arguments = new List<Object>{inputMap, 'ProductKey'};

        Map<String, Object> inputs = new Map<String, Object>();
        inputs.put('arguments', arguments);

        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        Test.startTest();
            Boolean success = controller.invokeMethod('convert', inputs, output, options);
        Test.stopTest();

        System.assertEquals(true, success, 'invokeMethod should return true for convert');
        List<Map<String, Object>> convertedResult = (List<Map<String, Object>>)output.get('result');
        System.assertEquals(2, convertedResult.size(), 'Expected 2 elements after conversion');
        System.assertEquals('ItemA', convertedResult[0].get('ProductKey'), 'First item not converted correctly');
    }
    

    @isTest
    static void testInvokeMethod_InvalidMethod() {
        OmniUtility controller = new OmniUtility();

        Map<String, Object> inputs = new Map<String, Object>();
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        Test.startTest();
            Boolean success = controller.invokeMethod('someInvalidMethod', inputs, output, options);
        Test.stopTest();

        System.assertEquals(true, success, 'invokeMethod should still return true even for invalid method');
        // No change expected in output map for an unhandled method
        System.assert(output.isEmpty(), 'Output map should be empty for an unhandled method');
    }

    @isTest
    static void testConvert_ExceptionHandling() {
        OmniUtility controller = new OmniUtility();

        // Simulate an invalid argument type to trigger an exception
        List<Object> arguments = new List<Object>{'InvalidType', 'Key'}; // Expected Map<String, Object> as first arg

        Map<String, Object> inputs = new Map<String, Object>();
        inputs.put('arguments', arguments);

        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> options = new Map<String, Object>();

        Test.startTest();
            // Directly call invokeMethod to test exception handling in convert
            Boolean success = controller.invokeMethod('convert', inputs, output, options);
        Test.stopTest();

        System.assertEquals(true, success, 'invokeMethod should still return true');
        List<Map<String, Object>> convertedResult = (List<Map<String, Object>>)output.get('result');
        System.assertEquals(0, convertedResult.size(), 'Expected an empty list on exception');
    }

    @IsTest
    private static void testLogErrorMethodOnInvokeMethod(){
        OmniUtility controller = new OmniUtility();
        Boolean errBool = false;
        Map<String, Object> inputs = new Map<String, Object>();
        inputs.put('Err_RunningContext', 'ErrorOS:ErrorIP');
        inputs.put('Err_CtxId', '001XXXXXXXXXXXX');
        inputs.put('Err_ProcessType', 'IP');

        Test.startTest();
        errBool = controller.invokeMethod('logerror', inputs, new Map<String, Object>(), new Map<String, Object>());
        Test.stopTest();
                
        Error_Log__c errorLogRecord = [SELECT Id,Record_Id__c FROM Error_Log__c WITH SYSTEM_MODE LIMIT 01];
        System.Assert.areEqual(true, errBool, 'Error Logged Successfully');
        System.Assert.areEqual(true, errorLogRecord.Record_Id__c == (String)inputs.get('Err_CtxId'), 'Record Id Matched');
    }
    
    
    
    @testSetup
    static void setupData() {
        // Create Test Account
        Account acc = new Account(Name = 'Test HPF Account');
        insert acc;

        // Get Record Type ID for Practice Operations
        Id rtId = Schema.SObjectType.Contract.getRecordTypeInfosByName()
                  .get('Practice Operations').getRecordTypeId();

        // Create various contracts to test filtering logic
        List<Contract> testContracts = new List<Contract>();
        
        // 1. Valid Executed Contract (The one we expect to find)
        testContracts.add(new Contract(
            AccountId = acc.Id,
            StartDate = Date.today().addDays(-10),
            Status = 'Draft', // Draft first to allow insert, then update to Executed
            RecordTypeId = rtId
        ));

        // 2. An older Superseded Contract
        testContracts.add(new Contract(
            AccountId = acc.Id,
            StartDate = Date.today().addDays(-20),
            Status = 'Draft',
            RecordTypeId = rtId
        ));

        insert testContracts;

        // Contracts usually require 'Activated' or specific status transitions. 
        // We update them to Executed/Superseded as per your logic.
        testContracts[0].Status = 'Executed';
        testContracts[1].Status = 'Superseded';
        update testContracts;
    }

    @isTest
    static void testFindPOContracts_Success() {
        Account acc = [SELECT Id FROM Account LIMIT 1];
        
        Map<String, Object> inputs = new Map<String, Object>();
        inputs.put('hpfAccountIds', new List<String>{acc.Id});
        inputs.put('clinicianContractStartDate', String.valueOf(Date.today()));

        Test.startTest();
        Map<String, Object> result = GetPOContractByClinicianStartDate.findPOContracts(inputs);
        Test.stopTest();

        // Verify Outer Structure
        System.assertEquals(true, result.get('success'), 'Operation should be successful');
        System.assertNotEquals(null, result.get('poContracts'));

        // Verify Serialized Data
        String jsonResult = (String)result.get('poContracts');
        List<Object> resultsList = (List<Object>)JSON.deserializeUntyped(jsonResult);
        System.assertEquals(1, resultsList.size(), 'Should return one result for the account');
        
        Map<String, Object> firstResult = (Map<String, Object>)resultsList[0];
        System.assertEquals(true, firstResult.get('found'), 'Contract should be found');
        System.assertEquals('Executed', firstResult.get('status'), 'Should pick Executed over Superseded');
    }

    @isTest
    static void testFindPOContracts_NoResults() {
        // Create an account with no contracts
        Account emptyAcc = new Account(Name = 'Empty Account');
        insert emptyAcc;

        Map<String, Object> inputs = new Map<String, Object>();
        inputs.put('hpfAccountIds', new List<String>{emptyAcc.Id});
        
        Test.startTest();
        Map<String, Object> result = GetPOContractByClinicianStartDate.findPOContracts(inputs);
        Test.stopTest();

        String jsonResult = (String)result.get('poContracts');
        // Check deserialized "found" property
        System.assert(jsonResult.contains('"found":false'), 'Result should indicate no contract found');
    }

    @isTest
    static void testFindPOContracts_PriorityLogic() {
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Id rtId = Schema.SObjectType.Contract.getRecordTypeInfosByName()
                  .get('Practice Operations').getRecordTypeId();

        // Create two contracts with same StartDate: one Superseded, one Executed
        // To test: c.Status == 'Executed' priority logic
        Date sameDate = Date.today().addDays(-5);
        
        Contract c1 = new Contract(AccountId = acc.Id, StartDate = sameDate, Status = 'Draft', RecordTypeId = rtId);
        Contract c2 = new Contract(AccountId = acc.Id, StartDate = sameDate, Status = 'Draft', RecordTypeId = rtId);
        insert new List<Contract>{c1, c2};
        
        c1.Status = 'Superseded';
        c2.Status = 'Executed';
        update new List<Contract>{c1, c2};

        Map<String, Object> inputs = new Map<String, Object>{
            'hpfAccountIds' => new List<String>{acc.Id},
            'clinicianContractStartDate' => String.valueOf(Date.today())
        };

        Map<String, Object> result = GetPOContractByClinicianStartDate.findPOContracts(inputs);
        String jsonStr = (String)result.get('poContracts');
        
        System.assert(jsonStr.contains('"status":"Executed"'), 'Should prioritize Executed over Superseded on same date');
    }

    /*@isTest
    static void testFindPOContracts_Exception() {
        // Passing null to trigger the catch block (since inp.hpfAccountIds will be null)
        Test.startTest();
        Map<String, Object> result = GetPOContractByClinicianStartDate.findPOContracts(null);
        Test.stopTest();

        System.assertEquals(false, result.get('success'));
        System.assert(((String)result.get('errorMessage')).contains('Error querying PO Contracts'));
    }*/
    
    @IsTest
    private static void testfindPOContractsMethodOnInvokeMethod(){
        
        Account acc = [SELECT Id FROM Account LIMIT 1];
        OmniUtility controller = new OmniUtility();
        Boolean errBool = false;
        List<String> hpfAccountIds = new List<String>{acc.Id, '001XXXXXXXXXXXXBBB', '001XXXXXXXXXXXXCCC'};
        Map<String, Object> inputs = new Map<String, Object>();
        inputs.put('clinicianContractStartDate', '2026-08-14');
        inputs.put('hpfAccountIds', hpfAccountIds);
        inputs.put('Err_ProcessType', 'IP');

        Test.startTest();
        errBool = controller.invokeMethod('findPOContracts', inputs, new Map<String, Object>(), new Map<String, Object>());
        Test.stopTest();
    }
    
    @isTest
    static void testInvokeMethod_GenerateNPPAOptions() {
        OmniUtility utility = new OmniUtility();
        
        // Input with duplicates and '0'
        List<Object> values = new List<Object>{'2', '1', '2', '0', '3'};
        Map<String, Object> inputs = new Map<String, Object>{'values' => values};
        Map<String, Object> output = new Map<String, Object>();

        Test.startTest();
        utility.invokeMethod('generateNPPAOptions', inputs, output, new Map<String, Object>());
        Test.stopTest();

        // Verify options (sorted, unique, '0' removed)
        List<Map<String, String>> options = (List<Map<String, String>>)output.get('options');
        System.assertEquals(3, options.size(), 'Should filter 0 and duplicates');
        System.assertEquals('1', options[0].get('value'));
        System.assertEquals('Tier 1', options[0].get('label'));
        System.assertEquals('3', options[2].get('value'));
    }
}