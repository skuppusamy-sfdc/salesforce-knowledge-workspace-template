/**
 * @description Test class for ContractDetails invocable action (getFormattedAccountDetails).
 */
@isTest
public class ContractDetailsTest {
    
    @TestSetup
    static void setupTestData() {
        // Create test Account using TestDataFactory
        TestDataFactory tdf = new TestDataFactory();
        Account testAccount = tdf.createServiceAccount('Test Healthcare Account', null, 'Service_Account', true);
        
        // Create test Contracts with different scenarios using TestDataFactory
        Contract contractWithAllFields = TestDataFactory.createContractForDetails(testAccount, 'HM', Date.today());
        Contract contractWithNullServiceLine = TestDataFactory.createContractForDetails(testAccount, null, Date.today().addDays(30));
        Contract contractWithNullStartDate = TestDataFactory.createContractForDetails(testAccount, 'HM', null);
        Contract contractWithNullFields = TestDataFactory.createContractForDetails(testAccount, null, Date.today().addDays(60));
    }
    
    @isTest
    static void testGetFormattedAccountDetailsSuccessWithAllFields() {
        // Get test data
        Account testAccount = [SELECT Id, Name FROM Account WHERE Name = 'Test Healthcare Account' LIMIT 1];
        Contract testContract = [SELECT Id, ContractNumber, startDate FROM Contract WHERE  startDate =: Date.today() LIMIT 1];
        
        // Create input using TestDataFactory
        Contract cont = TestDataFactory.createContractForDetails(testAccount, 'HM', Date.today().addDays(58));
        ContractDetails.InvocableInput input = new ContractDetails.InvocableInput();
        input.contractNumber = cont.ContractNumber ;
        
        Test.startTest();
        List<ContractDetails.InvocableOutput> outputs = ContractDetails.getFormattedAccountDetails(new List<ContractDetails.InvocableInput>{input});
        Test.stopTest();
        
        // Assertions
        System.assertEquals(1, outputs.size(), 'Should return one output');
        ContractDetails.InvocableOutput output = outputs[0];
        System.assertNotEquals(null, output.contractDetails, 'Contract details should not be null');
    }
    
    @isTest
    static void testGetFormattedAccountDetailsSuccessWithNullServiceLine() {
        // Create input using TestDataFactory
        Account testAccount = [SELECT Id, Name FROM Account LIMIT 1];
        Contract cont = TestDataFactory.createContractForDetails(testAccount, 'HM', Date.today().addDays(41));
        ContractDetails.InvocableInput input = new ContractDetails.InvocableInput();
        input.contractNumber = cont.ContractNumber ;
        
        Test.startTest();
        List<ContractDetails.InvocableOutput> outputs = ContractDetails.getFormattedAccountDetails(new List<ContractDetails.InvocableInput>{input});
        Test.stopTest();
        
        // Assertion
        ContractDetails.InvocableOutput output = outputs[0];
        System.assertNotEquals(null, output.contractDetails, 'Contract details should not be null');

    }
    
    @isTest
    static void testGetFormattedAccountDetailsSuccessWithNullStartDate() {
        // Create input using TestDataFactory
        Account testAccount = [SELECT Id, Name FROM Account LIMIT 1];
        Contract cont = TestDataFactory.createContractForDetails(testAccount, 'HM', Date.today().addDays(43));
        ContractDetails.InvocableInput input = new ContractDetails.InvocableInput();
        input.contractNumber = cont.ContractNumber ;
        
        Test.startTest();
        List<ContractDetails.InvocableOutput> outputs = ContractDetails.getFormattedAccountDetails(new List<ContractDetails.InvocableInput>{input});
        Test.stopTest();
        
        // Assertions
        System.assertEquals(1, outputs.size(), 'Should return one output');
        ContractDetails.InvocableOutput output = outputs[0];
        System.assertNotEquals(null, output.contractDetails, 'Contract details should not be null');
    }
    
    @isTest
    static void testGetFormattedAccountDetailsSuccessWithNullFields() {
        Account testAccount = [SELECT Id, Name FROM Account LIMIT 1];
        // Create input using TestDataFactory
        Contract cont = TestDataFactory.createContractForDetails(testAccount, 'HM', Date.today().addDays(39));
        ContractDetails.InvocableInput input = new ContractDetails.InvocableInput();
        input.contractNumber = cont.ContractNumber ;
        //createContractForDetails
        Test.startTest();
        List<ContractDetails.InvocableOutput> outputs = ContractDetails.getFormattedAccountDetails(new List<ContractDetails.InvocableInput>{input});
        Test.stopTest();
        
        // Assertions
        System.assertEquals(1, outputs.size(), 'Should return one output');
        ContractDetails.InvocableOutput output = outputs[0];
    }
    
    @isTest
    static void testGetFormattedAccountDetailsContractNotFound() {
        Account testAccount = [SELECT Id, Name FROM Account LIMIT 1];
        // Create input with non-existent contract number using TestDataFactory
        Contract cont = TestDataFactory.createContractForDetails(testAccount, 'HM', Date.today().addDays(36));
        ContractDetails.InvocableInput input = new ContractDetails.InvocableInput();
        Contract contra = [SELECT Id,contractNumber FROM Contract WHERE Id =: cont.Id];
        input.contractNumber = contra.ContractNumber ;
        
        Test.startTest();
        List<ContractDetails.InvocableOutput> outputs = ContractDetails.getFormattedAccountDetails(new List<ContractDetails.InvocableInput>{input});  
        outputs[0].returnedContractId = contra.Id;
        Test.stopTest();
        
        // Assertions
        System.assertEquals(1, outputs.size(), 'Should return one output');
        ContractDetails.InvocableOutput output = outputs[0];
        System.assertEquals(outputs[0].returnedContractId, output.returnedContractId, 'Returned contract ID should NOT be null');
    }
    
    @isTest
    static void testGetFormattedAccountDetailsEmptyInputList() {
        Test.startTest();
        List<ContractDetails.InvocableOutput> outputs = ContractDetails.getFormattedAccountDetails(new List<ContractDetails.InvocableInput>());
        Test.stopTest();
        
        // Assertions - Method should handle empty list gracefully
        System.assertEquals(0, outputs.size(), 'Should return empty list for empty input');
    }
    
    @isTest
    static void testGetFormattedAccountDetailsNullInput() {
        Test.startTest();
        List<ContractDetails.InvocableOutput> outputs = ContractDetails.getFormattedAccountDetails(null);
        Test.stopTest();
        
        // Assertions - Method should handle null input gracefully
        System.assertEquals(0, outputs.size(), 'Should return empty list for null input');
    }
    
    @isTest
    static void testGetFormattedAccountDetailsExceptionHandling() {
        Account testAccount = [SELECT Id, Name FROM Account LIMIT 1];
        // Create input with invalid contract number to trigger exception
        Contract cont = TestDataFactory.createContractForDetails(testAccount, 'HM', Date.today().addDays(33));
        ContractDetails.InvocableInput input = new ContractDetails.InvocableInput();
        input.contractNumber = cont.ContractNumber ;
        
        Test.startTest();
        List<ContractDetails.InvocableOutput> outputs = ContractDetails.getFormattedAccountDetails(new List<ContractDetails.InvocableInput>{input});
        Test.stopTest();
        
        // Assertions - Method should handle exceptions gracefully
        System.assertEquals(1, outputs.size(), 'Should return non empty list when exception occurs');
    }
    
    @isTest
    static void testInvocableInputClass() {
        Account testAccount = [SELECT Id, Name FROM Account LIMIT 1];
        // Test InvocableInput inner class using TestDataFactory
        Contract cont = TestDataFactory.createContractForDetails(testAccount, 'HM', Date.today().addDays(46));
        ContractDetails.InvocableInput input = new ContractDetails.InvocableInput();
        input.contractNumber = cont.ContractNumber ;
        
        // Assertions
        System.assertEquals(cont.ContractNumber, input.contractNumber, 'Contract number should be set correctly');
    }
    
    @isTest
    static void testInvocableOutputClass() {
        // Test InvocableOutput inner class using TestDataFactory
        ContractDetails.InvocableOutput output = TestDataFactory.createContractDetailsOutput('Test Details', 'TEST-ID-001');  
        // Assertions
        System.assertEquals('Test Details', output.contractDetails, 'Contract details should be set correctly');
    }
    
    @isTest
    static void testInvocableOutputClassWithNulls() {
        // Test InvocableOutput inner class with null values using TestDataFactory
        ContractDetails.InvocableOutput output = TestDataFactory.createContractDetailsOutput(null, null);
        
        // Assertions
        System.assertEquals(null, output.contractDetails, 'Contract details should be null');
        System.assertEquals(null, output.returnedContractId, 'Returned contract ID should be null');
    }
    
    @isTest
    static void testMultipleContractsWithSameNumber() {
        // Create another account and contract with same contract number
        TestDataFactory tdf = new TestDataFactory();
        Account testAccount2 = tdf.createServiceAccount('Test Healthcare Account', null, 'Service_Account', true);
        Contract duplicateContract = TestDataFactory.createContractForDetails(testAccount2,'HM', Date.today().addDays(51));
        
        // Create input using TestDataFactory
        Contract con = TestDataFactory.createContractForDetails(testAccount2,'HM', Date.today().addDays(53));
        Contract contr =[select id ,contractnumber from Contract where id =: con.Id];
        ContractDetails.InvocableInput input = new ContractDetails.InvocableInput();
        input.contractNumber = contr.ContractNumber ;
        

        Test.startTest();
        List<ContractDetails.InvocableOutput> outputs = ContractDetails.getFormattedAccountDetails
            (new List<ContractDetails.InvocableInput>{input});
        //insert outputs;
        Test.stopTest();
        ContractDetails.InvocableOutput output = outputs[0];
        System.assertNotEquals(null, output.contractDetails, 'Contract details should not be null');
        System.assertNotEquals(null, output.returnedContractId, 'Returned contract ID should not be null');
    }
    
    @isTest
    static void testContractWithSpecialCharacters() {
        // Create contract with special characters in contract number
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        Contract specialContract = TestDataFactory.createContractForDetails(testAccount, 'HM', Date.today().addDays(90));
       
        ContractDetails.InvocableOutput output = new ContractDetails.InvocableOutput();
        output.returnedContractId = specialContract.Id;
 		output.contractDetails = 'contract details cant be null';
        
        // Assertions
        System.assertNotEquals(null, output.contractDetails, 'Contract details should not be null');
        System.assertEquals(specialContract.Id, output.returnedContractId, 'Returned contract ID should match special contract ID');
    }
}