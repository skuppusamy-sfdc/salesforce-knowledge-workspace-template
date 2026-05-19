/**
 * @description Test class for AccountDetails invocable action (getFormattedAccountDetails).
 */
@isTest
public class AccountDetailsTest {
    
    @TestSetup
    static void setupTestData() {
        // Create test Account using TestDataFactory
        TestDataFactory tdf = new TestDataFactory();
        Account testAccount = tdf.createServiceAccount('Test Healthcare Account', null, 'Service_Account', true);
        //testAccount.Name = 'Test Healthcare Account';
        //testAccount.Global_Facility_ID__c = 'GLOBAL123';
        //update testAccount;
    }
    
    @isTest
    static void testGetFormattedAccountDetailsSuccess() {
        // Get test data
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        
        // Create input using TestDataFactory
        AccountDetails.InvocableInput input = new AccountDetails.InvocableInput();
        input.AccountId = testAccount.Id;
        
        Test.startTest();
        List<AccountDetails.InvocableOutput> outputs = 
            AccountDetails.getFormattedAccountDetails(new List<AccountDetails.InvocableInput>{input});
        Test.stopTest();
        
        // Assertions
        System.assertEquals(1, outputs.size(), 'Should return one output');
        AccountDetails.InvocableOutput output = outputs[0];
        System.assertNotEquals(null, output.details, 'Details should not be null');
        System.assertEquals(testAccount.Id, output.returnedAccountId, 'Returned account ID should match');
        System.assert(output.details.contains('Account Details:'), 'Should contain account details header');
        System.assert(output.details.contains('Name: Test Healthcare Account'), 'Should contain account name');
    }
    
    @isTest
    static void testGetFormattedAccountDetailsWithNullFields() {
        // Create account with null fields
		TestDataFactory tdf = new TestDataFactory();
        Account testAccount = tdf.createServiceAccount('Test Healthcare Account', null, 'Service_Account', true);
        
        AccountDetails.InvocableInput input = new AccountDetails.InvocableInput();
        input.AccountId = testAccount.Id;
        
        Test.startTest();
        List<AccountDetails.InvocableOutput> outputs = 
            AccountDetails.getFormattedAccountDetails(new List<AccountDetails.InvocableInput>{input});
        Test.stopTest();
        
        // Assertions
        System.assertEquals(1, outputs.size(), 'Should return one output');
        AccountDetails.InvocableOutput output = outputs[0];
        //System.assert(output.details.contains('Global AccountID: null'), 'Should handle null global facility ID');
        System.assert(output.details.contains('Service Line:'), 'Should contain service line field');
    }
        
    @isTest
    static void testInnerClasses() {
        Account acc = [Select Id from Account limit 1];
        Test.startTest();
        // Test InvocableInput class
        AccountDetails.InvocableInput input = new AccountDetails.InvocableInput();
        input.AccountId = acc.Id;
        
        // Test InvocableOutput class
        AccountDetails.InvocableOutput output = new AccountDetails.InvocableOutput();
        output.details = 'Test details';
        output.returnedAccountId = acc.Id;
        Test.stopTest();
        
        // Assertions
        System.assertEquals(acc.Id, input.AccountId, 'Account ID should be set');
        System.assertEquals('Test details', output.details, 'Details should be set');
        System.assertEquals(acc.Id, output.returnedAccountId, 'Returned account ID should be set');
    }
    
    @isTest
    static void testGetFormattedAccountDetailsEdgeCases() {
        Account acc = [Select Id,Name from Account limit 1];
        // Test with non-existent account ID
        AccountDetails.InvocableInput input = new AccountDetails.InvocableInput();
        input.AccountId = acc.Name;
        
        Test.startTest();
        try {
            List<AccountDetails.InvocableOutput> outputs = 
                AccountDetails.getFormattedAccountDetails(new List<AccountDetails.InvocableInput>{input});
            // If we get here, the method handled the non-existent ID gracefully
            System.assertEquals(0, outputs.size(), 'Should return zero as output');
        } catch (Exception e) {
            // Expected behavior - the method doesn't handle non-existent IDs gracefully
            System.assert(e.getMessage().contains('List has no rows'), 'Should throw no rows error');
        }
        Test.stopTest();
    }
}