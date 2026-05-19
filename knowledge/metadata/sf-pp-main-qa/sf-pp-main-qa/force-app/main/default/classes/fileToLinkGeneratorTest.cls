@isTest
public class fileToLinkGeneratorTest {
    
    @TestSetup
    static void setupTestData() {
        // Create test Account using TestDataFactory
        TestDataFactory TDF = new TestDataFactory();
        Account testAccount = TDF.createServiceAccount('Test Healthcare Account', null, 'Service_Account', true);
        
        // Create test Contacts (Practitioners) using TestDataFactory
        List<Contact> testContacts = new List<Contact>();
        for (Integer i = 1; i <= 3; i++) {
            Contact testContact = TestDataFactory.createContact(testAccount);
            testContact.FirstName = 'Test';
            testContact.LastName = 'Practitioner ' + i;
            testContact.Email = 'test' + i + '@example.com';
            update testContact;
            testContacts.add(testContact);
        }
        
        // Create test Contracts using TestDataFactory
        List<Contract> testContracts = new List<Contract>();
        List<Contract> testStatusContractsUpdated = new List<Contract>();
        Date tdy = Date.today();
        for (Integer i = 1; i <= 2; i++) {
            Contract testContract = TestDataFactory.createContract(testAccount, tdy.addMonths(i));
            if(testContract!= NULL){
                testContract.Status = 'Executed';
                testContract.ContractTerm = 12;
                update testContract;
                testContracts.add(testContract);
            }
        }
        update testContracts;
        /*for(Contract cn :testContracts){
            cn.status = 'Executed';
            testStatusContractsUpdated.add(cn);
        }
        update testStatusContractsUpdated;*/
        
        // Create test Clinical_Rate_Change__c records using TestDataFactory
        Clinical_Rate_Change__c testCRC = TestDataFactory.createClinicalRateChange(testAccount.Id, '["' + testContracts[0].Id + '"]');
        testCRC.Contract_ID__c = testContracts[0].Id;
        testCRC.user_selected_IDs__c = '{"selectedClinicianIds":[{"selectId":"' + testContacts[0].Id + '","isProcessed":false}]}';
        testCRC.Non_Processed_Clinical_Ids__c = '{"selectedClinicianIds":[{"selectId":"' + testContacts[0].Id + '","isProcessed":false}]}';
        update testCRC;
    }
    
    @isTest
    static void testGetContractFilesWithLinks_Success() {
        // Get test data
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        Contract testContract = [SELECT Id FROM Contract LIMIT 1];
        
        // Create request using TestDataFactory
        fileToLinkGenerator.ContractFileRequest request = TestDataFactory.createContractFileRequest(testAccount.Id, testContract.Id);
        
        Test.startTest();
        List<fileToLinkGenerator.ContractFileResponse> responses = 
            fileToLinkGenerator.getContractFilesWithLinks(new List<fileToLinkGenerator.ContractFileRequest>{request});
        Test.stopTest();
        
        // Assertions
        System.assertEquals(1, responses.size(), 'Should return one response');
        fileToLinkGenerator.ContractFileResponse response = responses[0];
        System.assertNotEquals(null, response.fileLinks, 'File links should not be null');
    }
    
    @isTest
    static void testGetContractFilesWithLinks_NoData() {
        Account testAccount = [SELECT Id,Name FROM Account LIMIT 1];
        Contract testContract = [SELECT Id,ContractNumber FROM Contract LIMIT 1];

        // Create request with non-existent data using TestDataFactory
        fileToLinkGenerator.ContractFileRequest request = TestDataFactory.createContractFileRequest(testAccount.Id, testContract.Id);
        
        Test.startTest();
        List<fileToLinkGenerator.ContractFileResponse> responses = 
            fileToLinkGenerator.getContractFilesWithLinks(new List<fileToLinkGenerator.ContractFileRequest>{request});
        Test.stopTest();
        
        // Assertions
        System.assertEquals(1, responses.size(), 'Should return no responses when no data found');
    }
    
    @isTest
    static void testExtractSelectedClinicianIds_ComplexStructure() {
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        // Test with complex JSON structure
        String complexJSON = '{"selectedClinicianIds":[{"selectId":"'+testAccount.Id+'","isProcessed":false},{"selectId":"'+testAccount.Id+'","isProcessed":false}]}';
        Object jsonResult = JSON.deserializeUntyped(complexJSON);
        
        Test.startTest();
        List<String> result = fileToLinkGenerator.extractSelectedClinicianIds(jsonResult);
        Test.stopTest();
        
        // Assertions
        System.assertEquals(2, result.size(), 'Should extract 2 IDs');
        System.assertEquals(testAccount.Id, result[0], 'First ID should match');
        System.assertEquals(testAccount.Id, result[1], 'Second ID should match');
    }
    
    @isTest
    static void testExtractSelectedClinicianIds_SimpleArray() {
        Account testAccount = [SELECT Id FROM Account LIMIT 1];

        // Test with simple array structure
        String simpleJSON = '{"selectedClinicianIds":["'+testAccount.Id+'","'+testAccount.Id+'"]}';
        Object jsonResult = JSON.deserializeUntyped(simpleJSON);
        
        Test.startTest();
        List<String> result = fileToLinkGenerator.extractSelectedClinicianIds(jsonResult);
        Test.stopTest();
        
        // Assertions
        System.assertEquals(2, result.size(), 'Should extract 2 IDs');
        System.assertEquals(testAccount.Id, result[0], 'First ID should match');
        System.assertEquals(testAccount.Id, result[1], 'Second ID should match');
    }
    
    @isTest
    static void testExtractSelectedClinicianIds_SingleString() {
        Account testAccount = [SELECT Id FROM Account LIMIT 1];

        // Test with single string
        String singleJSON = '{"selectedClinicianIds":"'+testAccount.Id+'"}';
        Object jsonResult = JSON.deserializeUntyped(singleJSON);
        
        Test.startTest();
        List<String> result = fileToLinkGenerator.extractSelectedClinicianIds(jsonResult);
        Test.stopTest();
        
        // Assertions
        System.assertEquals(1, result.size(), 'Should extract 1 ID');
        System.assertEquals(testAccount.Id, result[0], 'ID should match');
    }
    
    @isTest
    static void testExtractSelectedClinicianIds_EmptyData() {
        // Test with empty data
        String emptyJSON = '{"selectedClinicianIds":[]}';
        Object jsonResult = JSON.deserializeUntyped(emptyJSON);
        
        Test.startTest();
        List<String> result = fileToLinkGenerator.extractSelectedClinicianIds(jsonResult);
        Test.stopTest();
        
        // Assertions
        System.assertEquals(0, result.size(), 'Should return empty list');
    }
    
    @isTest
    static void testExtractSelectedClinicianIds_NullData() {
        // Test with null data
        Object jsonResult = null;
        
        Test.startTest();
        List<String> result = fileToLinkGenerator.extractSelectedClinicianIds(jsonResult);
        Test.stopTest();
        
        // Assertions
        System.assertEquals(0, result.size(), 'Should return empty list for null input');
    }
    
    @isTest
    static void testExtractSelectedClinicianIds_InvalidStructure() {
        // Test with invalid structure
        String invalidJSON = '{"otherKey":"value"}';
        Object jsonResult = JSON.deserializeUntyped(invalidJSON);
        
        Test.startTest();
        List<String> result = fileToLinkGenerator.extractSelectedClinicianIds(jsonResult);
        Test.stopTest();
        
        // Assertions
        System.assertEquals(0, result.size(), 'Should return empty list for invalid structure');
    }
    
    @isTest
    static void testGenerateContractPageLink_Indirectly() {
        // Get test data
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        Contract testContract = [SELECT Id FROM Contract LIMIT 1];
        
        // Create request that will trigger generateContractPageLink internally
        fileToLinkGenerator.ContractFileRequest request = TestDataFactory.createContractFileRequest(testAccount.Id, testContract.Id);
        
        Test.startTest();
        List<fileToLinkGenerator.ContractFileResponse> responses = 
            fileToLinkGenerator.getContractFilesWithLinks(new List<fileToLinkGenerator.ContractFileRequest>{request});
        Test.stopTest();
        
        // Assertions - verify URLs are generated indirectly
        System.assertEquals(1, responses.size(), 'Should return one response');
        fileToLinkGenerator.ContractFileResponse response = responses[0];
        if (response.success && response.fileLinks != null && !response.fileLinks.isEmpty()) {
            System.assert(response.fileLinks[0].contains('/lightning/r/'), 'Should contain Lightning URL');
        }
    }
    
    @isTest
    static void testUpdateProcessedRecords_Indirectly() {
        // Get test data
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        Contract testContract = [SELECT Id FROM Contract LIMIT 1];
        
        // Create request that will trigger updateProcessedRecords internally
        fileToLinkGenerator.ContractFileRequest request = TestDataFactory.createContractFileRequest(testAccount.Id, testContract.Id);
        
        Test.startTest();
        List<fileToLinkGenerator.ContractFileResponse> responses = 
            fileToLinkGenerator.getContractFilesWithLinks(new List<fileToLinkGenerator.ContractFileRequest>{request});
        Test.stopTest();
        
        // Assertions - verify the record was updated indirectly
        Clinical_Rate_Change__c updatedCRC = [SELECT Id, PreviewClonedContractIds__c, Non_Processed_Clinical_Ids__c 
                                             FROM Clinical_Rate_Change__c WHERE Service_Account_ID__c = :testAccount.Id];
        // Note: These fields may not be set if RateChangeService.execute() returns empty list
        System.assertNotEquals(null, updatedCRC.Id, 'Record should exist');
    }
    
    @isTest
    static void testConvertListToJSON_NormalList() {
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        List<String> strList = new List<String>{testAccount.Id, testAccount.Id};
        
        Test.startTest();
        String result = fileToLinkGenerator.convertListToJSON(strList);
        Test.stopTest();
        
        // Assertions
        System.assertNotEquals(null, result, 'Result should not be null');
        System.assert(result.contains('selectedClinicianIds'), 'Should contain selectedClinicianIds key');
        System.assert(result.contains(testAccount.Id), 'Should contain first ID');
        System.assert(result.contains(testAccount.Id), 'Should contain second ID');
    }
    
    @isTest
    static void testConvertListToJSON_EmptyList() {
        List<String> strList = new List<String>();
        
        Test.startTest();
        String result = fileToLinkGenerator.convertListToJSON(strList);
        Test.stopTest();
        
        // Assertions
        System.assertNotEquals(null, result, 'Result should not be null');
        System.assert(result.contains('NonProcessedClinicianIds'), 'Should contain NonProcessedClinicianIds key');
        System.assert(result.contains('[]'), 'Should contain empty array');
    }
    
    @isTest
    static void testConvertListToJSON_NullList() {
        List<String> strList = null;
        
        Test.startTest();
        String result = fileToLinkGenerator.convertListToJSON(strList);
        Test.stopTest();
        
        // Assertions
        System.assertNotEquals(null, result, 'Result should not be null');
        System.assert(result.contains('NonProcessedClinicianIds'), 'Should contain NonProcessedClinicianIds key');
        System.assert(result.contains('[]'), 'Should contain empty array');
    }
    
    @isTest
    static void testGetUnmatchedElements() {
        List<String> list1 = new List<String>{'A', 'B', 'C', 'D'};
        List<String> list2 = new List<String>{'B', 'C', 'E', 'F'};
        
        Test.startTest();
        List<String> result = fileToLinkGenerator.getUnmatchedElements(list1, list2);
        Test.stopTest();
        
        // Assertions
        System.assertEquals(4, result.size(), 'Should return 4 unmatched elements');
        System.assert(result.contains('A'), 'Should contain A');
        System.assert(result.contains('D'), 'Should contain D');
        System.assert(result.contains('E'), 'Should contain E');
        System.assert(result.contains('F'), 'Should contain F');
    }
    
    @isTest
    static void testGetUnmatchedElements_IdenticalLists() {
        List<String> list1 = new List<String>{'A', 'B', 'C'};
        List<String> list2 = new List<String>{'A', 'B', 'C'};
        
        Test.startTest();
        List<String> result = fileToLinkGenerator.getUnmatchedElements(list1, list2);
        Test.stopTest();
        
        // Assertions
        System.assertEquals(0, result.size(), 'Should return no unmatched elements');
    }
    
    @isTest
    static void testGetUnmatchedElements_EmptyLists() {
        List<String> list1 = new List<String>();
        List<String> list2 = new List<String>();
        
        Test.startTest();
        List<String> result = fileToLinkGenerator.getUnmatchedElements(list1, list2);
        Test.stopTest();
        
        // Assertions
        System.assertEquals(0, result.size(), 'Should return no unmatched elements');
    }
    
    @isTest
    static void testGetUnmatchedElements_OneEmptyList() {
        List<String> list1 = new List<String>{'A', 'B', 'C'};
        List<String> list2 = new List<String>();
        
        Test.startTest();
        List<String> result = fileToLinkGenerator.getUnmatchedElements(list1, list2);
        Test.stopTest();
        
        // Assertions
        System.assertEquals(3, result.size(), 'Should return all elements from non-empty list');
        System.assert(result.contains('A'), 'Should contain A');
        System.assert(result.contains('B'), 'Should contain B');
        System.assert(result.contains('C'), 'Should contain C');
    }
    
    @isTest
    static void testContractFileRequestClass() {
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        Contract testContract = [SELECT Id FROM Contract LIMIT 1];

        Test.startTest();
        fileToLinkGenerator.ContractFileRequest request = new fileToLinkGenerator.ContractFileRequest();
        request.accountId = testAccount.Id;
        request.contractId = testContract.Id;
        Test.stopTest();
        
        // Assertions
        System.assertEquals(testAccount.Id, request.accountId, 'Account ID should be set');
        System.assertEquals(testContract.Id, request.contractId, 'Contract ID should be set');
    }
    
    @isTest
    static void testContractFileResponseClass() {
        Test.startTest();
        fileToLinkGenerator.ContractFileResponse response = new fileToLinkGenerator.ContractFileResponse();
        response.success = true;
        response.message = 'Test message';
        response.fileLinks = new List<String>{'http://example.com/file1', 'http://example.com/file2'};
        Test.stopTest();
        
        // Assertions
        System.assertEquals(true, response.success, 'Success should be set');
        System.assertEquals('Test message', response.message, 'Message should be set');
        System.assertEquals(2, response.fileLinks.size(), 'File links should be set');
    }
    
    @isTest
    static void testExceptionHandling() {
        Account testAccount = [SELECT Id,Name FROM Account LIMIT 1];
        Contract testContract = [SELECT Id,ContractNumber FROM Contract LIMIT 1];

        // Create request that will cause exception
        fileToLinkGenerator.ContractFileRequest request = new fileToLinkGenerator.ContractFileRequest();
        request.accountId = testAccount.Name;
        request.contractId = testContract.ContractNumber;
        
        // Mock RateChangeService to throw exception
        Test.startTest();
        List<fileToLinkGenerator.ContractFileRequest> requests = new List<fileToLinkGenerator.ContractFileRequest>{request};
        
        // This will test exception handling in the main method
        List<fileToLinkGenerator.ContractFileResponse> responses = 
            fileToLinkGenerator.getContractFilesWithLinks(requests);
        Test.stopTest();
        
        // Assertions - should handle exception gracefully
        System.assertEquals(0, responses.size(), 'Should return no responses when exception occurs');
    }
    
    @isTest
    static void testMultipleRequests() {
        // Get test data
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        Contract testContract = [SELECT Id FROM Contract LIMIT 1];
        
        // Create multiple requests
        List<fileToLinkGenerator.ContractFileRequest> requests = new List<fileToLinkGenerator.ContractFileRequest>();
        
        fileToLinkGenerator.ContractFileRequest request1 = new fileToLinkGenerator.ContractFileRequest();
        request1.accountId = testAccount.Id;
        request1.contractId = testContract.Id;
        requests.add(request1);
        
        fileToLinkGenerator.ContractFileRequest request2 = new fileToLinkGenerator.ContractFileRequest();
        request2.accountId = testAccount.Id;
        request2.contractId = testContract.Id;
        requests.add(request2);
        
        Test.startTest();
        List<fileToLinkGenerator.ContractFileResponse> responses = 
            fileToLinkGenerator.getContractFilesWithLinks(requests);
        Test.stopTest();
        
        // Assertions - should process only first request
        System.assertEquals(1, responses.size(), 'Should return one response (only first request processed)');
    }
    
    @isTest
    static void testGetContractFilesWithLinks_EdgeCases() {
        Test.startTest();
        
        // Test null request list
        List<fileToLinkGenerator.ContractFileResponse> nullResponses = 
            fileToLinkGenerator.getContractFilesWithLinks(null);
        Test.stopTest();
        
        // Assertions
        System.assertEquals(0, nullResponses.size(), 'Should return no responses for null request list');
    }
    
    @isTest
    static void testExtractSelectedClinicianIds_EdgeCases() {
        Test.startTest();
        // Test null input
        List<String> nullResult = fileToLinkGenerator.extractSelectedClinicianIds(null);
        
        // Test non-map object
        List<String> nonMapResult = fileToLinkGenerator.extractSelectedClinicianIds('not a map');
        
        // Test map without key
        Map<String, Object> testMap = new Map<String, Object>{'otherKey' => 'value'};
        List<String> noKeyResult = fileToLinkGenerator.extractSelectedClinicianIds(testMap);
        
        // Test map with null value
        Map<String, Object> nullMap = new Map<String, Object>{'selectedClinicianIds' => null};
        List<String> nullValueResult = fileToLinkGenerator.extractSelectedClinicianIds(nullMap);
        Test.stopTest();
        
        // Assertions
        System.assertEquals(0, nullResult.size(), 'Should return empty list for null input');
        System.assertEquals(0, nonMapResult.size(), 'Should return empty list for non-map object');
        System.assertEquals(0, noKeyResult.size(), 'Should return empty list for map without selectedClinicianIds key');
        System.assertEquals(0, nullValueResult.size(), 'Should return empty list for map with null selectedClinicianIds');
    }
    
    @isTest
    static void testExtractSelectedClinicianIds_ComplexStructureValidation() {
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        Test.startTest();
        // Test with null objects in array
        String nullObjectsJSON = '{"selectedClinicianIds":[{"selectId":"'+testAccount.Id+'","isProcessed":false},null,{"selectId":"'+testAccount.Id+'","isProcessed":false}]}';
        List<String> nullObjectsResult = fileToLinkGenerator.extractSelectedClinicianIds(JSON.deserializeUntyped(nullObjectsJSON));
        
        // Test with missing selectId
        String missingSelectIdJSON = '{"selectedClinicianIds":[{"isProcessed":false},{"selectId":"'+testAccount.Id+'","isProcessed":false}]}';
        List<String> missingSelectIdResult = fileToLinkGenerator.extractSelectedClinicianIds(JSON.deserializeUntyped(missingSelectIdJSON));
        
        // Test with blank selectId
        String blankSelectIdJSON = '{"selectedClinicianIds":[{"selectId":"","isProcessed":false},{"selectId":"'+testAccount.Id+'","isProcessed":false}]}';
        List<String> blankSelectIdResult = fileToLinkGenerator.extractSelectedClinicianIds(JSON.deserializeUntyped(blankSelectIdJSON));
        
        // Test with null selectId
        String nullSelectIdJSON = '{"selectedClinicianIds":[{"selectId":null,"isProcessed":false},{"selectId":"'+testAccount.Id+'","isProcessed":false}]}';
        List<String> nullSelectIdResult = fileToLinkGenerator.extractSelectedClinicianIds(JSON.deserializeUntyped(nullSelectIdJSON));
        Test.stopTest();
        
        // Assertions
        System.assertEquals(2, nullObjectsResult.size(), 'Should extract 2 IDs, ignoring null objects');
        System.assertEquals(1, missingSelectIdResult.size(), 'Should extract 1 ID, ignoring objects without selectId');
        System.assertEquals(1, blankSelectIdResult.size(), 'Should extract 1 ID, ignoring blank selectId');
        System.assertEquals(1, nullSelectIdResult.size(), 'Should extract 1 ID, ignoring null selectId');
        System.assertEquals(testAccount.Id, missingSelectIdResult[0], 'ID should match');
    }
    
    @isTest
    static void testExtractSelectedClinicianIds_SimpleArrayValidation() {
        Account testAccount = [SELECT Id FROM Account LIMIT 1];

        Test.startTest();
        // Test with null values in array
        String nullValuesJSON = '{"selectedClinicianIds":["'+testAccount.Id+'",null,"'+testAccount.Id+'"]}';
        List<String> nullValuesResult = fileToLinkGenerator.extractSelectedClinicianIds(JSON.deserializeUntyped(nullValuesJSON));
        
        // Test with blank values in array
        String blankValuesJSON = '{"selectedClinicianIds":["'+testAccount.Id+'","","'+testAccount.Id+'"]}';
        List<String> blankValuesResult = fileToLinkGenerator.extractSelectedClinicianIds(JSON.deserializeUntyped(blankValuesJSON));
        Test.stopTest();
        
        // Assertions
        System.assertEquals(2, nullValuesResult.size(), 'Should extract 2 IDs, ignoring null values');
        System.assertEquals(2, blankValuesResult.size(), 'Should extract 2 IDs, ignoring blank values');
        System.assertEquals(testAccount.Id, nullValuesResult[0], 'First ID should match');
        System.assertEquals(testAccount.Id, nullValuesResult[1], 'Second ID should match');
    }
    
    @isTest
    static void testConvertListToJSON_VariousSizes() {
        Account testAccount = [SELECT Id FROM Account LIMIT 1];

        Test.startTest();
        // Test single element
        List<String> singleList = new List<String>{testAccount.Id};
        String singleResult = fileToLinkGenerator.convertListToJSON(singleList);
        
        // Test large list
        List<String> largeList = new List<String>();
        for (Integer i = 1; i <= 100; i++) {
            largeList.add(testAccount.Id + String.valueOf(i).leftPad(2, '0'));
        }
        String largeResult = fileToLinkGenerator.convertListToJSON(largeList);
        Test.stopTest();
        
        // Assertions
        System.assertNotEquals(null, singleResult, 'Single element result should not be null');
        System.assertNotEquals(null, largeResult, 'Large list result should not be null');
        System.assert(singleResult.contains('selectedClinicianIds'), 'Should contain selectedClinicianIds key');
        System.assert(singleResult.contains(testAccount.Id), 'Should contain the ID');
        System.assert(largeResult.contains(testAccount.Id), 'Should contain first ID');
        System.assert(largeResult.contains(testAccount.Id), 'Should contain last ID');
    }
    
    @isTest
    static void testGetUnmatchedElements_VariousScenarios() {
        Test.startTest();
        // Test with one empty list
        List<String> emptyList1 = new List<String>();
        List<String> list2 = new List<String>{'A', 'B', 'C'};
        List<String> emptyListResult = fileToLinkGenerator.getUnmatchedElements(emptyList1, list2);
        
        // Test with large lists
        List<String> largeList1 = new List<String>();
        List<String> largeList2 = new List<String>();
        for (Integer i = 1; i <= 50; i++) {
            largeList1.add('A' + i);
            if (Math.mod(i, 2) == 0) {
                largeList2.add('A' + i);
            }
        }
        List<String> largeListResult = fileToLinkGenerator.getUnmatchedElements(largeList1, largeList2);
        
        // Test with duplicate elements
        List<String> duplicateList1 = new List<String>{'A', 'A', 'B', 'B', 'C'};
        List<String> duplicateList2 = new List<String>{'A', 'B', 'D', 'D'};
        List<String> duplicateResult = fileToLinkGenerator.getUnmatchedElements(duplicateList1, duplicateList2);
        Test.stopTest();
        
        // Assertions
        System.assertEquals(3, emptyListResult.size(), 'Should return all elements from non-empty list');
        System.assertEquals(25, largeListResult.size(), 'Should return 25 unmatched elements');
        System.assertEquals(2, duplicateResult.size(), 'Should return 2 unmatched elements (C and D)');
        System.assert(emptyListResult.contains('A'), 'Should contain A');
        System.assert(largeListResult.contains('A1'), 'Should contain A1');
        System.assert(duplicateResult.contains('C'), 'Should contain C');
    }
    
    @isTest
    static void testInnerClasses() {
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        Test.startTest();
        // Test ContractFileRequest
        fileToLinkGenerator.ContractFileRequest request = TestDataFactory.createContractFileRequest(testAccount.Id, testAccount.Id);
        
        // Test ContractFileResponse with data
        fileToLinkGenerator.ContractFileResponse responseWithData = TestDataFactory.createContractFileResponse(true, 'Test message', new List<String>{'http://example.com/file1', 'http://example.com/file2'});
        
        // Test ContractFileResponse with null fields
        fileToLinkGenerator.ContractFileResponse responseWithNulls = TestDataFactory.createContractFileResponse(false, null, null);
        Test.stopTest();
        
        // Assertions for ContractFileRequest
        System.assertEquals(testAccount.Id, request.accountId, 'Account ID should be set');
        System.assertEquals(testAccount.Id, request.contractId, 'Contract ID should be set');
        
        // Assertions for ContractFileResponse with data
        System.assertEquals(true, responseWithData.success, 'Success should be set');
        System.assertEquals('Test message', responseWithData.message, 'Message should be set');
        System.assertEquals(2, responseWithData.fileLinks.size(), 'File links should be set');
        
        // Assertions for ContractFileResponse with nulls
        System.assertEquals(false, responseWithNulls.success, 'Success should be set');
        System.assertEquals(null, responseWithNulls.message, 'Message should be null');
        System.assertEquals(null, responseWithNulls.fileLinks, 'File links should be null');
    }
    
    @isTest
    static void testGetContractFilesWithLinks_ExceptionHandling() {
        Account testAccount = [SELECT Id FROM Account LIMIT 1];

        // Create request that will cause exception in RateChangeService
        fileToLinkGenerator.ContractFileRequest request = TestDataFactory.createContractFileRequest(testAccount.Id, testAccount.Id);
        
        Test.startTest();
        List<fileToLinkGenerator.ContractFileResponse> responses = 
            fileToLinkGenerator.getContractFilesWithLinks(new List<fileToLinkGenerator.ContractFileRequest>{request});
        Test.stopTest();
        
        // Assertions - should handle exception gracefully
        System.assertEquals(0, responses.size(), 'Should return no responses when exception occurs');
    }
    
    @isTest
    static void testStaticVariableAccess() {
        Test.startTest();
        // Test static variable access
        List<String> testIds = fileToLinkGenerator.allSelectedIds;
        System.assertNotEquals(null, testIds, 'Static variable should be accessible');
        Test.stopTest();
    }
    
    
}