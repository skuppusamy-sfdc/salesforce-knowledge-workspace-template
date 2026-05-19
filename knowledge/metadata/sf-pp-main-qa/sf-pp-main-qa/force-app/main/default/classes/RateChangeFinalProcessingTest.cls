@isTest
public class RateChangeFinalProcessingTest {
    
    @TestSetup
    static void setupTestData() {
        // Create test Account using TestDataFactory
        TestDataFactory TDF = new TestDataFactory();
        Account testAccount = TDF.createServiceAccount('Test Healthcare Account', null, 'Service_Account', true);
        
        // Create test Contacts using TestDataFactory
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
        Date tdy = Date.today();
        for (Integer i = 1; i <= 2; i++) {
            Contract testContract = TestDataFactory.createContract(testAccount, tdy.addMonths(i));
            testContract.Status = 'Executed';
            testContract.ContractTerm = 12;
            update testContract;
            testContracts.add(testContract);
        }
        
        // Create test Clinical_Rate_Change__c records using TestDataFactory
        Clinical_Rate_Change__c testCRC = TestDataFactory.createClinicalRateChange(testAccount.Id, '["' + testContracts[0].Id + '"]');
        testCRC.Contract_ID__c = testContracts[0].Id;
        testCRC.user_selected_IDs__c = '{"selectedClinicianIds":[{"selectId":"' + testContacts[0].Id + '","isProcessed":false}]}';
        testCRC.Non_Processed_Clinical_Ids__c = '{"selectedClinicianIds":[{"selectId":"' + testContacts[0].Id + '","isProcessed":false}]}';
        update testCRC;
    }
    
    @isTest
    static void testFinalProcessRateChange_SuccessScenarios() {
        // Get test data
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        Contract testContract = [SELECT Id FROM Contract LIMIT 1];
        
        // Test with user consent = true
        RateChangeFinalProcessing.FinalInput request1 = new RateChangeFinalProcessing.FinalInput();
        request1.userConsent = true;
        request1.accountId = testAccount.Id;
        request1.contractId = testContract.Id;
        
        Test.startTest();
        List<RateChangeFinalProcessing.FinalOutput> responses1 = 
            RateChangeFinalProcessing.finalProcessRateChange(new List<RateChangeFinalProcessing.FinalInput>{request1});
        
        // Test with user consent = false
        RateChangeFinalProcessing.FinalInput request2 = new RateChangeFinalProcessing.FinalInput();
        request2.userConsent = false;
        request2.accountId = testAccount.Id;
        request2.contractId = testContract.Id;
        
        List<RateChangeFinalProcessing.FinalOutput> responses2 = 
            RateChangeFinalProcessing.finalProcessRateChange(new List<RateChangeFinalProcessing.FinalInput>{request2});
        Test.stopTest();
        
        // Assertions
        System.assertEquals(1, responses1.size(), 'Should return one response');
        System.assertEquals(true, responses1[0].isSuccess, 'Response should be successful');
        System.assertEquals('Successfully executed', responses1[0].message, 'Message should match');
        
        System.assertEquals(1, responses2.size(), 'Should return one response');
        System.assertEquals(true, responses2[0].isSuccess, 'Response should be successful');
    }
    
    @isTest
    static void testFinalProcessRateChange_EdgeCases() {
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        Contract testContract = [SELECT Id FROM Contract LIMIT 1];
        // Test with non-existent data
        RateChangeFinalProcessing.FinalInput request1 = new RateChangeFinalProcessing.FinalInput();
        request1.userConsent = true;
        request1.accountId = testAccount.Id;
        request1.contractId = testContract.Id;
        
        Test.startTest();
        List<RateChangeFinalProcessing.FinalOutput> responses1 = 
            RateChangeFinalProcessing.finalProcessRateChange(new List<RateChangeFinalProcessing.FinalInput>{request1});
        Test.stopTest();
        
        // Assertions - The method should handle non-existent data gracefully
        System.assertEquals(1, responses1.size(), 'Should return one response even with no data');
        System.assertEquals(true, responses1[0].isSuccess, 'Response should be successful');
    }
    
    @isTest
    static void testFinalProcessRateChange_JSONScenarios() {
        // Get test data
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        Contract testContract = [SELECT Id FROM Contract LIMIT 1];
        List<Contact> testContacts = [SELECT Id FROM Contact LIMIT 2];
        
        // Test with complex JSON
        Clinical_Rate_Change__c testCRC = [SELECT Id FROM Clinical_Rate_Change__c LIMIT 1];
        String complexJSON = '{"selectedClinicianIds":[{"selectId":"' + testContacts[0].Id + '","isProcessed":false},{"selectId":"' + testContacts[1].Id + '","isProcessed":false}]}';
        testCRC.Non_Processed_Clinical_Ids__c = complexJSON;
        update testCRC;
        
        RateChangeFinalProcessing.FinalInput request = new RateChangeFinalProcessing.FinalInput();
        request.userConsent = true;
        request.accountId = testAccount.Id;
        request.contractId = testContract.Id;
        
        Test.startTest();
        List<RateChangeFinalProcessing.FinalOutput> responses = 
            RateChangeFinalProcessing.finalProcessRateChange(new List<RateChangeFinalProcessing.FinalInput>{request});
        Test.stopTest();
        
        // Assertions
        System.assertEquals(1, responses.size(), 'Should return one response');
        System.assertEquals(true, responses[0].isSuccess, 'Response should be successful');
    }
    
    @isTest
    static void testFinalProcessRateChange_NullAndEmptyJSON() {
        // Get test data
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        Contract testContract = [SELECT Id FROM Contract LIMIT 1];
        
        // Test with null JSON
        Clinical_Rate_Change__c testCRC1 = [SELECT Id FROM Clinical_Rate_Change__c LIMIT 1];
        testCRC1.Non_Processed_Clinical_Ids__c = null;
        update testCRC1;
        
        RateChangeFinalProcessing.FinalInput request1 = new RateChangeFinalProcessing.FinalInput();
        request1.userConsent = true;
        request1.accountId = testAccount.Id;
        request1.contractId = testContract.Id;
        
        Test.startTest();
        List<RateChangeFinalProcessing.FinalOutput> responses1 = 
            RateChangeFinalProcessing.finalProcessRateChange(new List<RateChangeFinalProcessing.FinalInput>{request1});
        
        // Test with empty JSON
        Clinical_Rate_Change__c testCRC2 = [SELECT Id FROM Clinical_Rate_Change__c LIMIT 1];
        testCRC2.Non_Processed_Clinical_Ids__c = '{"selectedClinicianIds":[]}';
        update testCRC2;
        
        List<RateChangeFinalProcessing.FinalOutput> responses2 = 
            RateChangeFinalProcessing.finalProcessRateChange(new List<RateChangeFinalProcessing.FinalInput>{request1});
        Test.stopTest();
        
        // Assertions
        System.assertEquals(1, responses1.size(), 'Should return one response');
        System.assertEquals(1, responses2.size(), 'Should return one response');
    }
    
    
    @isTest
    static void testInnerClasses() {
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        Contract testContract = [SELECT Id FROM Contract LIMIT 1];

        Test.startTest();
        // Test FinalInput class
        RateChangeFinalProcessing.FinalInput input = new RateChangeFinalProcessing.FinalInput();
        input.userConsent = true;
        input.accountId = testAccount.Id;
        input.contractId = testContract.Id;
        
        // Test FinalOutput class
        RateChangeFinalProcessing.FinalOutput output = new RateChangeFinalProcessing.FinalOutput();
        output.message = 'Test message';
        output.isSuccess = true;
        Test.stopTest();
        
        // Assertions
        System.assertEquals(true, input.userConsent, 'User consent should be set');
        System.assertEquals(testAccount.Id, input.accountId, 'Account ID should be set');
        System.assertEquals(testContract.Id, input.contractId, 'Contract ID should be set');
        System.assertEquals('Test message', output.message, 'Message should be set');
        System.assertEquals(true, output.isSuccess, 'Success should be set');
    }
}