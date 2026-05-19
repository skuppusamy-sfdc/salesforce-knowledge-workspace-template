/**
 * @description Test class for ClinicalManagerController (getClinicalDataForAgentforce, processSelectedRecords).
 */
@isTest
public class ClinicalManagerControllerTest {
    
    @TestSetup
    static void setupTestData() {
 
        TestDataFactory tdf = new TestDataFactory();
        Account testAccount = tdf.createServiceAccount('Test Service Account', null, 'Service_Account', true);
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
        
        
        List<HealthcarePractitionerFacility> testHPF = new List<HealthcarePractitionerFacility>();
        Account acc = tdf.createServiceAccount('Test Service Account 1','Last name', 'Clinician', true);
        Account corporateEntity = tdf.createServiceAccount('Test Corporate Entity',null, 'Corporate_Entity', true);
        Contact con = tdf.getOrCreateContact(acc,'Test ContactPreview');
        Contract contract = tdf.createClinicianContract(acc, true);
        
        HealthcarePayerNetwork hpn = tdf.createHealthcarePayerNetwork('Test Payer Network', corporateEntity.Id, true);
        HealthcareProvider hp = tdf.createHealthcareProvider( 'Physician Provider',  con.id,  true);
        
        HealthcarePractitionerFacility hpf = tdf.createHealthcarePractitionerFacility('NP HPF', con.id, testAccount.id, corporateEntity.Id, true);
        hpf.Status__c = 'Active';
        update hpf;
        
        testHPF.add(hpf);
        //insert testHPF;
        ProviderNetworkContract pnc = tdf.createPNC(contract.Id, hp.Id, hpn.Id, hpf.Id, true);
        ContractPaymentAgreement cpa = tdf.createCPA('Test ContactPreview', contract.Id, pnc.Id, true);
        PreventiveCareAgreement pca = tdf.createPCA(cpa.Id, true);
        
        // Create Client_Change_Management__c so getClinicalData returns records (Process_Type=Agent, Status=New)
        Client_Change_Management__c ccm = new Client_Change_Management__c(
            Contract__c = testContracts[0].Id,
            Healthcare_Practitioner_Facility__c = hpf.Id,
            Process_Type__c = 'Agent',
            Status__c = 'New'
        );
        insert ccm;
        
        // Create test Clinical_Rate_Change__c using TestDataFactory
        Clinical_Rate_Change__c testCRC = TestDataFactory.createClinicalRateChange(testAccount.Id, '["' + testContracts[0].Id + '"]');
        testCRC.Contract_ID__c = testContracts[0].Id;
        testCRC.user_selected_IDs__c = '{"selectedClinicianIds":[{"selectId":"' + testContacts[0].Id + '","isProcessed":false}]}';
        update testCRC;
    }
    
    @isTest
    static void testGetClinicalDataForAgentforceAllActionTypes() {
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        Contract testContract = [SELECT Id FROM Contract LIMIT 1];
        List<HealthCarePractitionerFacility> testHPF = [SELECT Id FROM HealthCarePractitionerFacility LIMIT 2];
        
        // Test GET_DATA action (with contractId to cover request.contractId assignment)
        ClinicalManagerController.ClinicalManagerRequest request1 = new ClinicalManagerController.ClinicalManagerRequest();
        request1.accId = testAccount.Id;
        request1.contractId = testContract.Id;
        request1.actionType = 'GET_DATA';
        
        // Test GET_ALL_IDS action (contractId required for getClinicalData)
        ClinicalManagerController.ClinicalManagerRequest request2 = new ClinicalManagerController.ClinicalManagerRequest();
        request2.accId = testAccount.Id;
        request2.contractId = testContract.Id;
        request2.actionType = 'GET_ALL_IDS';
        
        // Test GET_SUMMARY action
        ClinicalManagerController.ClinicalManagerRequest request3 = new ClinicalManagerController.ClinicalManagerRequest();
        request3.accId = testAccount.Id;
        request3.contractId = testContract.Id;
        request3.actionType = 'GET_SUMMARY';
        
        // Test SUBMIT_SELECTION action
        ClinicalManagerController.ClinicalManagerRequest request4 = new ClinicalManagerController.ClinicalManagerRequest();
        request4.accId = testAccount.Id;
        request4.contractId = testContract.Id;
        request4.actionType = 'SUBMIT_SELECTION';
        system.debug('testHPF[0].Id====>'+testHPF[0].Id);
         
        request4.selectedRecordIds = new List<String>{testHPF[0].Id};
        
        Test.startTest();
        List<ClinicalManagerController.ClinicalManagerResponse> responses1 = 
            ClinicalManagerController.getClinicalDataForAgentforce(new List<ClinicalManagerController.ClinicalManagerRequest>{request1});
        List<ClinicalManagerController.ClinicalManagerResponse> responses2 = 
            ClinicalManagerController.getClinicalDataForAgentforce(new List<ClinicalManagerController.ClinicalManagerRequest>{request2});
        List<ClinicalManagerController.ClinicalManagerResponse> responses3 = 
            ClinicalManagerController.getClinicalDataForAgentforce(new List<ClinicalManagerController.ClinicalManagerRequest>{request3});
        List<ClinicalManagerController.ClinicalManagerResponse> responses4 = 
            ClinicalManagerController.getClinicalDataForAgentforce(new List<ClinicalManagerController.ClinicalManagerRequest>{request4});
        Test.stopTest();
        
        System.assertEquals(true, responses1[0].success, 'GET_DATA should succeed');
        System.assertNotEquals(null, responses1[0].clinicalDataList, 'GET_DATA should return clinicalDataList');
        System.assertEquals(responses1[0].totalRecords, responses1[0].clinicalDataList.totalRecords, 'totalRecords should match');
        System.assertEquals(testAccount.Id, responses1[0].clinicalDataList.accId, 'accId should be set');
        System.assertEquals(testContract.Id, responses1[0].clinicalDataList.contractId, 'contractId should be set');

        System.assertEquals(true, responses2[0].success, 'GET_ALL_IDS should succeed');
        System.assertNotEquals(null, responses2[0].allRecordIds, 'GET_ALL_IDS should return allRecordIds');

        System.assertEquals(true, responses3[0].success, 'GET_SUMMARY should succeed');
        System.assertNotEquals(null, responses3[0].totalRecords, 'GET_SUMMARY should return totalRecords');

        System.assertEquals(true, responses4[0].success, 'SUBMIT_SELECTION should succeed');
    }

    @isTest
    static void testSubmitSelectionUpdatesExistingCRC() {
        Account testAccount = [SELECT Id FROM Account WHERE Name = 'Test Service Account' LIMIT 1];
        Contract testContract = [SELECT Id FROM Contract WHERE AccountId = :testAccount.Id LIMIT 1];
        List<HealthCarePractitionerFacility> testHPF = [
            SELECT Id FROM HealthCarePractitionerFacility WHERE AccountId = :testAccount.Id LIMIT 1
        ];
        System.assert(!testHPF.isEmpty(), 'Test requires HPF for account');

        // Create Open CRC so SUBMIT_SELECTION hits update path (crc != null)
        Clinical_Rate_Change__c openCRC = new Clinical_Rate_Change__c(
            Service_Account_ID__c = testAccount.Id,
            Contract_ID__c = testContract.Id,
            Status__c = 'Open'
        );
        insert openCRC;

        ClinicalManagerController.ClinicalManagerRequest request = new ClinicalManagerController.ClinicalManagerRequest();
        request.accId = testAccount.Id;
        request.contractId = testContract.Id;
        request.actionType = 'SUBMIT_SELECTION';
        request.selectedRecordIds = new List<String>{testHPF[0].Id};

        Test.startTest();
        List<ClinicalManagerController.ClinicalManagerResponse> responses =
            ClinicalManagerController.getClinicalDataForAgentforce(new List<ClinicalManagerController.ClinicalManagerRequest>{request});
        Test.stopTest();

        System.assertEquals(true, responses[0].success, 'SUBMIT_SELECTION with existing CRC should succeed');
        System.assertEquals(true, responses[0].triggerURLGeneration, 'triggerURLGeneration should be set');
    }
    
    @isTest
    static void testGetClinicalDataForAgentforceBlankActionTypeDefaultsToGetData() {
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        Contract testContract = [SELECT Id FROM Contract LIMIT 1];
        ClinicalManagerController.ClinicalManagerRequest request = new ClinicalManagerController.ClinicalManagerRequest();
        request.accId = testAccount.Id;
        request.contractId = testContract.Id;
        request.actionType = null;  // blank - should default to GET_DATA

        Test.startTest();
        List<ClinicalManagerController.ClinicalManagerResponse> responses =
            ClinicalManagerController.getClinicalDataForAgentforce(new List<ClinicalManagerController.ClinicalManagerRequest>{request});
        Test.stopTest();

        System.assertEquals(true, responses[0].success, 'Blank actionType should default to GET_DATA and succeed');
    }

    @isTest
    static void testGetClinicalDataForAgentforceMissingAccountIdValidation() {
        ClinicalManagerController.accountId = null;  // ensure static is not set from prior test

        ClinicalManagerController.ClinicalManagerRequest requestGetData = new ClinicalManagerController.ClinicalManagerRequest();
        requestGetData.actionType = 'GET_DATA';

        ClinicalManagerController.ClinicalManagerRequest requestGetAllIds = new ClinicalManagerController.ClinicalManagerRequest();
        requestGetAllIds.actionType = 'GET_ALL_IDS';

        ClinicalManagerController.ClinicalManagerRequest requestGetSummary = new ClinicalManagerController.ClinicalManagerRequest();
        requestGetSummary.actionType = 'GET_SUMMARY';

        Test.startTest();
        List<ClinicalManagerController.ClinicalManagerResponse> resp1 =
            ClinicalManagerController.getClinicalDataForAgentforce(new List<ClinicalManagerController.ClinicalManagerRequest>{requestGetData});
        List<ClinicalManagerController.ClinicalManagerResponse> resp2 =
            ClinicalManagerController.getClinicalDataForAgentforce(new List<ClinicalManagerController.ClinicalManagerRequest>{requestGetAllIds});
        List<ClinicalManagerController.ClinicalManagerResponse> resp3 =
            ClinicalManagerController.getClinicalDataForAgentforce(new List<ClinicalManagerController.ClinicalManagerRequest>{requestGetSummary});
        Test.stopTest();

        System.assertEquals(false, resp1[0].success, 'GET_DATA without accountId should fail');
        System.assertEquals('Account ID is required to retrieve impacted clinicians.', resp1[0].message);

        System.assertEquals(false, resp2[0].success, 'GET_ALL_IDS without accountId should fail');
        System.assertEquals(false, resp3[0].success, 'GET_SUMMARY without accountId should fail');
    }

    @isTest
    static void testGetClinicalDataForAgentforceErrorScenarios() {
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        
        // Test invalid action type
        ClinicalManagerController.ClinicalManagerRequest request1 = new ClinicalManagerController.ClinicalManagerRequest();
        request1.accId = testAccount.Id;
        request1.actionType = 'INVALID_ACTION';
        
        // Test empty selection
        ClinicalManagerController.ClinicalManagerRequest request2 = new ClinicalManagerController.ClinicalManagerRequest();
        request2.accId = testAccount.Id;
        request2.actionType = 'SUBMIT_SELECTION';
        request2.selectedRecordIds = new List<String>();
        
        Test.startTest();
        List<ClinicalManagerController.ClinicalManagerResponse> responses1 = 
            ClinicalManagerController.getClinicalDataForAgentforce(new List<ClinicalManagerController.ClinicalManagerRequest>{request1});
        List<ClinicalManagerController.ClinicalManagerResponse> responses2 = 
            ClinicalManagerController.getClinicalDataForAgentforce(new List<ClinicalManagerController.ClinicalManagerRequest>{request2});
        Test.stopTest();
        
        // Single assertion per test
        System.assertEquals(false, responses1[0].success, 'Invalid action should fail');
        System.assertEquals(false, responses2[0].success, 'Empty selection should fail');
    }
    
     @isTest
    static void testGetClinicalDataForAgentforceExceptions() {
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        
        // Test invalid action type
        ClinicalManagerController.ClinicalManagerRequest request1 = null;
        
        Test.startTest();
        List<ClinicalManagerController.ClinicalManagerResponse> responses1 = 
            ClinicalManagerController.getClinicalDataForAgentforce(new List<ClinicalManagerController.ClinicalManagerRequest>{request1});
        Test.stopTest();
        
        // Single assertion per test
        System.assertEquals(false, responses1[0].success, 'Invalid action should fail');
    }
    
    @isTest
    static void testProcessSelectedRecords() {
        Account testAccount = [SELECT Id FROM Account LIMIT 1];
        Contract testContract = [SELECT Id FROM Contract LIMIT 1];
        List<HealthCarePractitionerFacility> testHPF = [SELECT Id FROM HealthCarePractitionerFacility LIMIT 2];
        
        Test.startTest();
        ClinicalManagerController.LightningResponse response = 
            ClinicalManagerController.processSelectedRecords(
                'SUBMIT_SELECTION',
                new List<String>{testHPF[0].Id},
                testAccount.Id,
                testContract.Id,
                '{"test": "data"}'
            );
        Test.stopTest();
        
        System.assertEquals(true, response.success, 'Process selected records should succeed');
    }
    
    @isTest
    static void testProcessSelectedRecordsException() {
       
        Clinical_Rate_Change__c testCRC = [SELECT Id FROM Clinical_Rate_Change__c LIMIT 1];
        delete testCRC;
        
        Account testAccount = [SELECT Id FROM Account where Name = 'Test Service Account' LIMIT 1];
        Contract testContract = [SELECT Id FROM Contract LIMIT 1];
        List<HealthCarePractitionerFacility> testHPF = [SELECT Id FROM HealthCarePractitionerFacility where AccountId = :testAccount.ID LIMIT 2];
        
        Test.startTest();
        ClinicalManagerController.LightningResponse response = 
            ClinicalManagerController.processSelectedRecords(
                'SUBMIT_SELECTION',
                new List<String>{testHPF[0].Id},
                testAccount.Id,
                testContract.Id,
                '{"test": "data"}'
            );
        Test.stopTest();
        
        System.assertEquals(true, response.success, 'Process selected records should succeed when CRC is deleted (new one is created)');
    }
    
    @isTest
    static void testGetClinicalDataBlankContractIdReturnsEmpty() {
        // When contractId is blank, getClinicalData returns empty wrapper (contractId is required)
        Account testAccount = [SELECT Id FROM Account WHERE Name = 'Test Service Account' LIMIT 1];
        ClinicalManagerController.ClinicalManagerRequest request = new ClinicalManagerController.ClinicalManagerRequest();
        request.accId = testAccount.Id;
        request.actionType = 'GET_DATA';
        request.contractId = null;  // Blank - getClinicalData returns empty
        
        Test.startTest();
        List<ClinicalManagerController.ClinicalManagerResponse> responses =
            ClinicalManagerController.getClinicalDataForAgentforce(new List<ClinicalManagerController.ClinicalManagerRequest>{request});
        Test.stopTest();
        
        System.assertEquals(true, responses[0].success, 'GET_DATA with blank contractId should succeed with empty data');
        System.assertEquals(0, responses[0].totalRecords, 'Should return 0 records when contractId is blank');
    }

    // Commented: getClinicalDataForLightning is dead code (commented out in controller)
    // @isTest
    // static void testGetClinicalDataForLightning() {
    //     Account testAccount = [SELECT Id FROM Account LIMIT 1];
    //     Test.startTest();
    //     ClinicalManagerController.LightningResponse response =
    //         ClinicalManagerController.getClinicalDataForLightning(testAccount.Id);
    //     Test.stopTest();
    //     System.assertEquals(true, response.success, 'Get clinical data for Lightning should succeed');
    // }
    //
    // @isTest
    // static void testGetClinicalDataForLightningException() {
    //     Test.startTest();
    //     ClinicalManagerController.LightningResponse response =
    //         ClinicalManagerController.getClinicalDataForLightning('abc');
    //     Test.stopTest();
    //     System.assertEquals(true, response.success, 'Get clinical data for Lightning should succeed');
    // }
    
    
    @isTest
    static void testUtilityMethods() {
        String inputJSON = '{"selectedClinicianIds":["003gP000007ZMKzQAO","003gP000007ZKRGQA4"]}';
        
        Test.startTest();
        String result1 = ClinicalManagerController.convertToComplexClinicianFormat(inputJSON);
        String result2 = ClinicalManagerController.convertToComplexClinicianFormat('invalid json');
        Test.stopTest();
        
        System.assertNotEquals(null, result1, 'Valid JSON conversion should succeed');
        System.assertEquals(null, result2, 'Invalid JSON should return null');
    }
    
    @isTest
    static void testLightningResponseConstructor() {
        Test.startTest();
        ClinicalManagerController.LightningResponse response = new ClinicalManagerController.LightningResponse();
        Test.stopTest();
        System.assertEquals(false, response.success, 'Default success should be false');
        System.assertEquals('', response.message, 'Default message should be empty');
        System.assertEquals('', response.recordsJson, 'Default recordsJson should be empty');
        System.assertNotEquals(null, response.allRecordIds, 'allRecordIds should be initialized');
        System.assertEquals(0, response.allRecordIds.size(), 'allRecordIds should be empty list');
        System.assertEquals(0, response.totalRecords, 'Default totalRecords should be 0');
    }
}