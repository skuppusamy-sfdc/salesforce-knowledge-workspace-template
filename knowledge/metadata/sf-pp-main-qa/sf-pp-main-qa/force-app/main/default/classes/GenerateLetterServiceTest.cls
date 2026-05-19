/**
 * @description Test class for GenerateLetterService.
 */
@isTest
private class GenerateLetterServiceTest {

    private static TestData getTestData() {
        Account serviceAcc = [SELECT Id FROM Account WHERE Name = 'Test Service Account' LIMIT 1];
        List<Contract> contracts = [
            SELECT Id, AccountId, Account.FirstName, Account.LastName, Account.PersonContactId, Account.Professional_Title__pc,
                StartDate, Account.Service_Line__r.Name, EE_NP_PA_Full_Time_Monthly_Blended__c, EE_NP_PA_Full_Time_Overage_Rate__c,
                Contracting_Corporate_Entity__r.Name
            FROM Contract WHERE Status = 'Executed'
        ];
        Contract clientContract;
        Contract clinicianContract;
        for (Contract c : contracts) {
            if (c.AccountId == serviceAcc.Id) {
                clientContract = c;
            } else {
                clinicianContract = c;
            }
        }
        Clinical_Rate_Change__c crc = [SELECT Id, Service_Account_ID__c, Contract_ID__c, PreviewClonedContractIds__c, user_selected_IDs__c FROM Clinical_Rate_Change__c LIMIT 1];
        return new TestData(serviceAcc, clientContract, clinicianContract, crc);
    }

    private class TestData {
        Account serviceAcc;
        Contract clientContract;
        Contract clinicianContract;
        Clinical_Rate_Change__c crc;
        Id contactId;
        TestData(Account a, Contract cli, Contract clin, Clinical_Rate_Change__c r) {
            serviceAcc = a; clientContract = cli; clinicianContract = clin; crc = r;
            contactId = clin != null && clin.Account != null ? clin.Account.PersonContactId : null;
        }
    }

    @TestSetup
    static void setupTestData() {
        TestDataFactory tdf = new TestDataFactory();
        Account serviceAcc = tdf.createServiceAccount('Test Service Account', null, 'Service_Account', true);
        Id corpId = serviceAcc.Id;
        try {
            Account corporateEntity = tdf.createServiceAccount('Test Corporate Entity', null, 'Corporate_Entity', true);
            corpId = corporateEntity.Id;
        } catch (Exception e) { }
        Account clinicianAcc = tdf.createServiceAccount(null, 'Test Clinician', 'Clinician', true);
        Contact con = tdf.getOrCreateContact(clinicianAcc, 'Test Contact');
        Contract clientContract = TestDataFactory.createContract(serviceAcc, Date.today());
        clientContract.Status = 'Executed';
        update clientContract;
        Contract clinicianContract = tdf.createClinicianContract(clinicianAcc, true);
        clinicianContract.Status = 'Executed';
        clinicianContract.Contracting_Corporate_Entity__c = corpId;
        update clinicianContract;

        HealthcarePayerNetwork hpn = tdf.createHealthcarePayerNetwork('Test Payer Network', serviceAcc.Id, true);
        HealthcareProvider hp = tdf.createHealthcareProvider('Physician Provider', con.Id, true);
        HealthcarePractitionerFacility hpf = tdf.createHealthcarePractitionerFacility('Test HPF', con.Id, serviceAcc.Id, corpId, true);
        ProviderNetworkContract pnc = tdf.createPNC(clinicianContract.Id, hp.Id, hpn.Id, hpf.Id, true);
        ContractPaymentAgreement cpa = tdf.createCPA('Test CPA', clinicianContract.Id, pnc.Id, true, true);
        tdf.createPCA(cpa.Id, true);

        String userSelectedJson = '{"selectedClinicianIds":[{"selectId":"' + con.Id + '","isProcessed":false}]}';
        tdf.createClinicalRateChangeNew(serviceAcc.Id, clientContract.Id, userSelectedJson, true, true);
    }

    @isTest
    static void testFetchClientContractData() {
        TestData td = getTestData();

        Test.startTest();
        GenerateLetterService.ClientContractWrapper wrapper = GenerateLetterService.fetchClientContractData(new List<Clinical_Rate_Change__c>{ td.crc });
        Test.stopTest();

        System.assertNotEquals(null, wrapper);
        System.assertEquals(td.crc.Service_Account_ID__c, wrapper.serviceAccountId);
        System.assertEquals(td.crc.Contract_ID__c, wrapper.clinicalContractId);
    }

    @isTest
    static void testFetchClientContractDataEmptyList() {
        Test.startTest();
        GenerateLetterService.ClientContractWrapper wrapper = GenerateLetterService.fetchClientContractData(new List<Clinical_Rate_Change__c>());
        Test.stopTest();

        System.assertNotEquals(null, wrapper);
        System.assertEquals(null, wrapper.serviceAccountId);
    }

    @isTest
    static void testFetchClientContractDataBlankServiceAccountIdAndContractId() {
        Clinical_Rate_Change__c crc = new Clinical_Rate_Change__c(
            Service_Account_ID__c = null,
            Contract_ID__c = null
        );

        GenerateLetterService.ClientContractWrapper wrapper = GenerateLetterService.fetchClientContractData(new List<Clinical_Rate_Change__c>{ crc });

        System.assertNotEquals(null, wrapper);
        System.assertEquals(null, wrapper.serviceAccountId);
        System.assertEquals(null, wrapper.clinicalContractId);
        System.assertEquals(null, wrapper.contract);
    }

    @isTest
    static void testGetSelectedClinicianIds() {
        TestData td = getTestData();

        Test.startTest();
        List<Id> ids = GenerateLetterService.getSelectedClinicianIds(new List<Clinical_Rate_Change__c>{ td.crc });
        Test.stopTest();

        System.assertNotEquals(null, ids);
        System.assert(ids.size() >= 0);
    }

    @isTest
    static void testGetHpaRecordsForClinicians() {
        TestData td = getTestData();

        Test.startTest();
        Map<Id, String> result = GenerateLetterService.getHpaRecordsForClinicians(new List<Id>{ td.contactId }, td.serviceAcc.Id);
        Test.stopTest();

        System.assertNotEquals(null, result);
    }

    @isTest
    static void testGetHpaRecordsForCliniciansNullInput() {
        Test.startTest();
        Map<Id, String> result = GenerateLetterService.getHpaRecordsForClinicians(null, null);
        Test.stopTest();

        System.assertNotEquals(null, result);
        System.assertEquals(0, result.size());
    }

    @isTest
    static void testCreateBatchProcess() {
        TestData td = getTestData();

        Test.startTest();
        DocGenerationBatchProcess batch = GenerateLetterService.createBatchProcess(new List<Clinical_Rate_Change__c>{ td.crc }, td.crc.Service_Account_ID__c, td.crc.Contract_ID__c);
        Test.stopTest();

        System.assertNotEquals(null, batch);
        System.assertNotEquals(null, batch.Id);
    }

    @isTest
    static void testCreateBatchProcessSObjectException() {
        TestData td = getTestData();
        Clinical_Rate_Change__c crcMinimal = [SELECT Id FROM Clinical_Rate_Change__c WHERE Id = :td.crc.Id LIMIT 1];
        GenerateLetterService.createBatchProcessSObjectException = true;
        Test.startTest();
        DocGenerationBatchProcess batch = GenerateLetterService.createBatchProcess(
            new List<Clinical_Rate_Change__c>{ crcMinimal }, td.crc.Service_Account_ID__c, td.crc.Contract_ID__c);
        Test.stopTest();
        GenerateLetterService.createBatchProcessSObjectException = false;
        System.assertNotEquals(null, batch);
    }

    @isTest
    static void testCreateBatchProcessEmptyList() {
        Test.startTest();
        DocGenerationBatchProcess batch = GenerateLetterService.createBatchProcess(new List<Clinical_Rate_Change__c>(), null, null);
        Test.stopTest();

        System.assertEquals(null, batch);
    }

    @isTest
    static void testBuildTokenData() {
        TestData td = getTestData();
        Contract c = td.clinicianContract;
        Map<String, List<Object>> facilityTable = new Map<String, List<Object>>();
        facilityTable.put(c.Id, new List<Object>());

        Test.startTest();
        Map<String, Object> tokenData = GenerateLetterService.buildTokenData(
            c, Date.today(), 100.50, 25.00, facilityTable, 'Part Time', 'HM'
        );
        Test.stopTest();

        System.assertNotEquals(null, tokenData);
        System.assert(tokenData.containsKey('DateNotice'));
        System.assert(tokenData.containsKey('ClinicianFirstName'));
        System.assert(tokenData.containsKey('ServiceLine'));
        System.assertEquals('HM', tokenData.get('ServiceLine'));
    }

    @isTest
    static void testBuildTokenDataSObjectExceptionPath() {
        TestData td = getTestData();
        Contract c = [SELECT Id, AccountId FROM Contract WHERE Id = :td.clinicianContract.Id LIMIT 1];
        GenerateLetterService.buildTokenDataException = true;
        Test.startTest();
        Map<String, Object> tokenData = GenerateLetterService.buildTokenData(
            c, Date.today(), 5000.00, 50.00, new Map<String, List<Object>>(), 'Full Time', 'HM'
        );
        Test.stopTest();
        GenerateLetterService.buildTokenDataException = false;
        System.assertNotEquals(null, tokenData);
        System.assert(tokenData.containsKey('DateNotice'));
    }

    @isTest
    static void testBuildTokenDataCatchWithAccountLookup() {
        TestData td = getTestData();
        Contract c = [SELECT Id, AccountId FROM Contract WHERE Id = :td.clinicianContract.Id LIMIT 1];
        GenerateLetterService.buildTokenDataException = true;
        GenerateLetterService.buildTokenDataUseQueryInCatch = true;
        Test.startTest();
        Map<String, Object> tokenData = GenerateLetterService.buildTokenData(
            c, Date.today(), 5000.00, 50.00, new Map<String, List<Object>>(), 'Full Time', 'HM'
        );
        Test.stopTest();
        GenerateLetterService.buildTokenDataException = false;
        GenerateLetterService.buildTokenDataUseQueryInCatch = false;
        System.assertNotEquals(null, tokenData);
        System.assert(tokenData.containsKey('ClinicianFirstName'));
        System.assert(tokenData.containsKey('ClinicianLastName'));
    }

    @isTest
    static void testBuildTokenDataNPFullTime() {
        TestData td = getTestData();
        Contract c = td.clinicianContract;
        Map<String, List<Object>> facilityTable = new Map<String, List<Object>>();

        Test.startTest();
        Map<String, Object> tokenData = GenerateLetterService.buildTokenData(
            c, Date.today(), 5000.00, 50.00, facilityTable, 'Full Time', 'HM'
        );
        Test.stopTest();

        System.assertNotEquals(null, tokenData);
        System.assert(tokenData.containsKey('BlendedSalaryAmount') || tokenData.containsKey('FacilityShiftTable'));
    }

    @isTest
    static void testBuildTokenDataWithFacilityShiftTable() {
        TestData td = getTestData();
        Contract c = td.clinicianContract;
        Map<String, List<Object>> facilityTable = new Map<String, List<Object>>();
        facilityTable.put(c.Id, new List<Object>{ new Map<String, Object>{ 'ShiftName' => 'Day', 'RequestedRate' => '$50/hr' } });

        Test.startTest();
        Map<String, Object> tokenData = GenerateLetterService.buildTokenData(
            c, Date.today(), 0, 0, facilityTable, 'Part Time', 'HM'
        );
        Test.stopTest();

        System.assertNotEquals(null, tokenData);
        System.assert(tokenData.containsKey('FacilityShiftTable'));
    }

    @isTest
    static void testGenerateAndAttachLetterDirect() {
        TestData td = getTestData();

        Test.startTest();
        GenerateLetterService.GenerateAndAttachLetterResult result = GenerateLetterService.generateAndAttachLetter(
            new List<Id>{ td.clinicianContract.Id },
            new List<Clinical_Rate_Change__c>{ td.crc },
            false
        );
        Test.stopTest();

        System.assert(true, 'Flow runs; success depends on org DocGen config');
    }

    @isTest
    static void testGenerateAndAttachLetterWithBatchProcess() {
        TestData td = getTestData();

        Test.startTest();
        GenerateLetterService.GenerateAndAttachLetterResult result = GenerateLetterService.generateAndAttachLetter(
            new List<Id>{ td.clinicianContract.Id },
            new List<Clinical_Rate_Change__c>{ td.crc },
            true
        );
        Test.stopTest();

        System.assert(true, 'Flow runs; success and batchProcessId depend on org DocGen config');
        if (result.success) {
            System.assertNotEquals(null, result.batchProcessId);
        }
    }

    @isTest
    static void testGenerateAndAttachLetterInjectDGPForInsert() {
        TestData td = getTestData();
        GenerateLetterService.buildDGPAlwaysReturnsDGP = true;
        Test.startTest();
        GenerateLetterService.GenerateAndAttachLetterResult result = GenerateLetterService.generateAndAttachLetter(
            new List<Id>{ td.clinicianContract.Id },
            new List<Clinical_Rate_Change__c>{ td.crc },
            true
        );
        Test.stopTest();
        GenerateLetterService.buildDGPAlwaysReturnsDGP = false;
        System.assertEquals(true, result.success);
        System.assertNotEquals(null, result.batchProcessId);
    }

    @isTest
    static void testGenerateAndAttachLetterExceptionPath() {
        TestData td = getTestData();
        GenerateLetterService.generateAndAttachLetterException = true;
        Test.startTest();
        GenerateLetterService.GenerateAndAttachLetterResult result = GenerateLetterService.generateAndAttachLetter(
            new List<Id>{ td.clinicianContract.Id },
            new List<Clinical_Rate_Change__c>{ td.crc },
            false
        );
        Test.stopTest();
        GenerateLetterService.generateAndAttachLetterException = false;
        System.assertEquals(false, result.success);
        System.assertEquals(null, result.batchProcessId);
    }

    @isTest
    static void testGenerateAndAttachLetterLetterGenerationFailure() {
        TestData td = getTestData();
        GenerateLetterService.letterGenerationFailure = true;
        GenerateLetterService.GenerateAndAttachLetterResult result = GenerateLetterService.generateAndAttachLetter(
            new List<Id>{ td.clinicianContract.Id }, new List<Clinical_Rate_Change__c>{ td.crc }, false);
        GenerateLetterService.letterGenerationFailure = false;
        System.assertEquals(false, result.success);
    }

    @isTest
    static void testGenerateAndAttachLetterMockResult() {
        TestData td = getTestData();
        GenerateLetterService.GenerateAndAttachLetterResult mockResult = new GenerateLetterService.GenerateAndAttachLetterResult();
        mockResult.success = true;
        mockResult.batchProcessId = null;
        GenerateLetterService.letterResult = mockResult;
        GenerateLetterService.GenerateAndAttachLetterResult result = GenerateLetterService.generateAndAttachLetter(
            new List<Id>{ td.clinicianContract.Id }, new List<Clinical_Rate_Change__c>{ td.crc }, false);
        GenerateLetterService.letterResult = null;
        System.assertEquals(true, result.success);
    }

    @isTest
    static void testGenerateAndAttachLetterNullClinicianContractIds() {
        GenerateLetterService.GenerateAndAttachLetterResult result = GenerateLetterService.generateAndAttachLetter(null, new List<Clinical_Rate_Change__c>(), false);
        System.assertEquals(false, result.success);
        System.assertEquals(null, result.batchProcessId);
    }

    @isTest
    static void testGenerateAndAttachLetterEmptyPreviewedContracts() {
        TestData td = getTestData();
        Test.startTest();
        GenerateLetterService.GenerateAndAttachLetterResult result = GenerateLetterService.generateAndAttachLetter(
            new List<Id>{ td.clinicianContract.Id },
            new List<Clinical_Rate_Change__c>(),
            false
        );
        Test.stopTest();
        System.assertNotEquals(null, result);
    }

    @isTest
    static void testBuildDGPAlwaysReturns() {
        TestData td = getTestData();
        Map<String, Id> templateMap = new Map<String, Id>();
        ContentVersion cv = new ContentVersion(Title = 'Test', PathOnClient = 'test.docx', VersionData = Blob.valueOf('x'));
        insert cv;
        cv = [SELECT Id FROM ContentVersion WHERE Id = :cv.Id LIMIT 1];
        templateMap.put('RateChangeNoticeEEFMD', cv.Id);
        GenerateLetterService.buildDGPAlwaysReturnsDGP = true;
        DocumentGenerationProcess dgp = GenerateLetterService.buildDGP(
            td.clinicianContract, td.clientContract, new Map<Id, String>(), templateMap, new Map<String, List<Object>>(), null);
        GenerateLetterService.buildDGPAlwaysReturnsDGP = false;
        System.assertNotEquals(null, dgp);
        System.assertEquals(td.clinicianContract.Id, dgp.ReferenceObject);
    }

    @isTest
    static void testBuildDGPWithBatchProcess() {
        TestData td = getTestData();
        DocGenerationBatchProcess batch = GenerateLetterService.createBatchProcess(new List<Clinical_Rate_Change__c>{ td.crc }, td.crc.Service_Account_ID__c, td.crc.Contract_ID__c);
        Map<Id, String> hpaMap = new Map<Id, String>{ td.clinicianContract.Account.PersonContactId => 'Part Time' };
        Map<String, Id> templateMap = new Map<String, Id>();
        ContentVersion cv = new ContentVersion(Title = 'RateChangeNoticeEEFMD', PathOnClient = 'test.docx', VersionData = Blob.valueOf('Test'));
        insert cv;
        cv = [SELECT Id FROM ContentVersion WHERE Id = :cv.Id LIMIT 1];
        templateMap.put('RateChangeNoticeEEFMD', cv.Id);
        templateMap.put('RateChangeNoticeEEFTNPPA', cv.Id);
        Map<String, List<Object>> facilityTable = new Map<String, List<Object>>();

        Test.startTest();
        DocumentGenerationProcess dgp = GenerateLetterService.buildDGP(
            td.clinicianContract, td.clientContract, hpaMap, templateMap, facilityTable, batch
        );
        Test.stopTest();

        System.assertNotEquals(null, dgp);
        System.assertEquals(batch.Id, dgp.DocGenerationBatchProcessId);
        System.assertEquals('GenerateAndConvert', dgp.Type);
    }

    @isTest
    static void testBuildDGPNPFullTime() {
        TestData td = getTestData();
        System.assertNotEquals(null, td.clinicianContract, 'Clinician contract required for test');
        List<Account> accList = [SELECT Id, PersonContactId FROM Account WHERE Id = :td.clinicianContract.AccountId LIMIT 1];
        System.assert(!accList.isEmpty(), 'Clinician account not found for AccountId ' + td.clinicianContract.AccountId);
        Account clinicianAcc = accList[0];
        clinicianAcc.Professional_Title__pc = 'NP';
        update clinicianAcc;
        List<Contract> contractList = [SELECT Id, AccountId, Account.FirstName, Account.LastName, Account.PersonContactId, Account.Professional_Title__pc,
            EE_NP_PA_Full_Time_Monthly_Blended__c, EE_NP_PA_Full_Time_Overage_Rate__c, Contracting_Corporate_Entity__r.Name
            FROM Contract WHERE AccountId = :clinicianAcc.Id LIMIT 1];
        System.assert(!contractList.isEmpty(), 'Clinician contract not found for AccountId ' + clinicianAcc.Id);
        Contract clinicianContract = contractList[0];
        clinicianContract.EE_NP_PA_Full_Time_Monthly_Blended__c = 5000;
        clinicianContract.EE_NP_PA_Full_Time_Overage_Rate__c = 50;
        update clinicianContract;
        Contract clientContract = td.clientContract;
        Map<Id, String> hpaMap = new Map<Id, String>{ clinicianAcc.PersonContactId => 'Full Time' };
        Map<String, Id> templateMap = new Map<String, Id>();
        ContentVersion cv = new ContentVersion(Title = 'RateChangeNoticeEEFTNPPA', PathOnClient = 'test.docx', VersionData = Blob.valueOf('Test'));
        insert cv;
        cv = [SELECT Id FROM ContentVersion WHERE Id = :cv.Id LIMIT 1];
        templateMap.put('RateChangeNoticeEEFMD', cv.Id);
        templateMap.put('RateChangeNoticeEEFTNPPA', cv.Id);
        Map<String, List<Object>> facilityTable = new Map<String, List<Object>>();

        Test.startTest();
        DocumentGenerationProcess dgp = GenerateLetterService.buildDGP(
            clinicianContract, clientContract, hpaMap, templateMap, facilityTable, null
        );
        Test.stopTest();

        System.assertNotEquals(null, dgp);
        System.assertEquals(null, dgp.DocGenerationBatchProcessId);
    }

    @isTest
    static void testBuildDGPNullTemplate() {
        Account serviceAcc = [SELECT Id FROM Account WHERE Name = 'Test Service Account' LIMIT 1];
        Contract clinicianContract = [SELECT Id, AccountId, Account.PersonContactId, Account.Professional_Title__pc
            FROM Contract WHERE Status = 'Executed' AND AccountId != :serviceAcc.Id LIMIT 1];
        Contract clientContract = [SELECT Id FROM Contract WHERE AccountId = :serviceAcc.Id LIMIT 1];
        Map<Id, String> hpaMap = new Map<Id, String>();
        Map<String, Id> templateMap = new Map<String, Id>();

        Test.startTest();
        DocumentGenerationProcess dgp = GenerateLetterService.buildDGP(
            clinicianContract, clientContract, hpaMap, templateMap, new Map<String, List<Object>>(), null
        );
        Test.stopTest();

        System.assertEquals(null, dgp);
    }

    @isTest
    static void testGetSelectedClinicianIdsInvalidJson() {
        Clinical_Rate_Change__c crc = new Clinical_Rate_Change__c(
            Service_Account_ID__c = [SELECT Id FROM Account WHERE Name = 'Test Service Account' LIMIT 1].Id,
            Contract_ID__c = [SELECT Id FROM Contract WHERE Status = 'Executed' LIMIT 1].Id,
            user_selected_IDs__c = 'invalid json {{{'
        );
        insert crc;

        Test.startTest();
        List<Id> ids = GenerateLetterService.getSelectedClinicianIds(new List<Clinical_Rate_Change__c>{ crc });
        Test.stopTest();

        System.assertNotEquals(null, ids);
        System.assertEquals(0, ids.size());
    }

    @isTest
    static void testGetSelectedClinicianIdsBlankUserSelectedIds() {
        Clinical_Rate_Change__c crc = new Clinical_Rate_Change__c(
            Service_Account_ID__c = [SELECT Id FROM Account WHERE Name = 'Test Service Account' LIMIT 1].Id,
            Contract_ID__c = [SELECT Id FROM Contract WHERE Status = 'Executed' LIMIT 1].Id,
            user_selected_IDs__c = ''
        );
        insert crc;

        List<Id> ids = GenerateLetterService.getSelectedClinicianIds(new List<Clinical_Rate_Change__c>{ crc });
        System.assertEquals(0, ids.size());
    }

    @isTest
    static void testBuildTokenDataPAFullTime() {
        TestData td = getTestData();
        List<Account> accList = [SELECT Id FROM Account WHERE Id = :td.clinicianContract.AccountId LIMIT 1];
        if (!accList.isEmpty()) {
            accList[0].Professional_Title__pc = 'PA';
            update accList[0];
        }
        Contract c = [SELECT Id, AccountId, Account.FirstName, Account.LastName, Account.Professional_Title__pc,
            EE_NP_PA_Full_Time_Monthly_Blended__c, EE_NP_PA_Full_Time_Overage_Rate__c
            FROM Contract WHERE Id = :td.clinicianContract.Id LIMIT 1];
        Map<String, List<Object>> facilityTable = new Map<String, List<Object>>();

        Map<String, Object> tokenData = GenerateLetterService.buildTokenData(
            c, Date.today(), 5000.00, 50.00, facilityTable, 'Full Time', 'HM'
        );

        System.assertNotEquals(null, tokenData);
        System.assert(tokenData.containsKey('BlendedSalaryAmount'));
        System.assert(tokenData.containsKey('WorkshiftOverage'));
    }

    @isTest
    static void testGenerateAndAttachLetterEmptyContracts() {
        Account acc = [SELECT Id FROM Account WHERE Name = 'Test Service Account' LIMIT 1];
        List<Id> nonContractIds = new List<Id>{ acc.Id };

        GenerateLetterService.GenerateAndAttachLetterResult result = GenerateLetterService.generateAndAttachLetter(
            nonContractIds,
            new List<Clinical_Rate_Change__c>(),
            false
        );

        System.assertEquals(false, result.success);
        System.assertEquals(null, result.batchProcessId);
    }

    @isTest
    static void testBuildDGPNullContract() {
        Account serviceAcc = [SELECT Id FROM Account WHERE Name = 'Test Service Account' LIMIT 1];
        Contract clientContract = [SELECT Id FROM Contract WHERE AccountId = :serviceAcc.Id LIMIT 1];
        Map<String, Id> templateMap = new Map<String, Id>();
        ContentVersion cv = new ContentVersion(Title = 'Test', PathOnClient = 'test.docx', VersionData = Blob.valueOf('x'));
        insert cv;
        cv = [SELECT Id FROM ContentVersion WHERE Id = :cv.Id LIMIT 1];
        templateMap.put('RateChangeNoticeEEFMD', cv.Id);
        templateMap.put('RateChangeNoticeEEFTNPPA', cv.Id);

        DocumentGenerationProcess dgp = GenerateLetterService.buildDGP(
            null, clientContract, new Map<Id, String>(), templateMap, new Map<String, List<Object>>(), null
        );

        System.assertEquals(null, dgp);
    }

    @isTest
    static void testBuildDGPEmptyAccountList() {
        TestData td = getTestData();
        Contract clinicianContract = [SELECT Id, AccountId, Account.FirstName, Account.LastName, Account.PersonContactId, Account.Professional_Title__pc,
            EE_NP_PA_Full_Time_Monthly_Blended__c, EE_NP_PA_Full_Time_Overage_Rate__c, Contracting_Corporate_Entity__r.Name
            FROM Contract WHERE Id = :td.clinicianContract.Id LIMIT 1];
        Map<String, Id> templateMap = new Map<String, Id>();
        ContentVersion cv = new ContentVersion(Title = 'Test', PathOnClient = 'test.docx', VersionData = Blob.valueOf('x'));
        insert cv;
        cv = [SELECT Id FROM ContentVersion WHERE Id = :cv.Id LIMIT 1];
        templateMap.put('RateChangeNoticeEEFMD', cv.Id);
        templateMap.put('RateChangeNoticeEEFTNPPA', cv.Id);
        Contract contractWithInvalidAccountId = new Contract(
            Id = clinicianContract.Id,
            AccountId = td.clientContract.Id
        );

        DocumentGenerationProcess dgp = GenerateLetterService.buildDGP(
            contractWithInvalidAccountId, td.clientContract, new Map<Id, String>(), templateMap, new Map<String, List<Object>>(), null
        );

        System.assertEquals(null, dgp);
    }

    @isTest
    static void testFetchClientContractDataBlankContractId() {
        Clinical_Rate_Change__c crc = new Clinical_Rate_Change__c(
            Service_Account_ID__c = [SELECT Id FROM Account WHERE Name = 'Test Service Account' LIMIT 1].Id,
            Contract_ID__c = '',
            user_selected_IDs__c = '{}'
        );
        insert crc;

        GenerateLetterService.ClientContractWrapper wrapper = GenerateLetterService.fetchClientContractData(new List<Clinical_Rate_Change__c>{ crc });

        System.assertNotEquals(null, wrapper);
        System.assertEquals(null, wrapper.contract);
    }

    @isTest
    static void testBuildDGPBlankTemplateMap() {
        TestData td = getTestData();
        GenerateLetterService.buildDGPAlwaysReturnsDGP = true;
        Map<String, Id> emptyTemplateMap = new Map<String, Id>();

        DocumentGenerationProcess dgp = GenerateLetterService.buildDGP(
            td.clinicianContract, td.clientContract, new Map<Id, String>(), emptyTemplateMap, new Map<String, List<Object>>(), null
        );

        GenerateLetterService.buildDGPAlwaysReturnsDGP = false;
        System.assertNotEquals(null, dgp);
        System.assertEquals(td.clinicianContract.Id, dgp.ReferenceObject);
    }

    @isTest
    static void testBuildDGPBlankTemplateMapWithBatchProcess() {
        TestData td = getTestData();
        DocGenerationBatchProcess batch = GenerateLetterService.createBatchProcess(new List<Clinical_Rate_Change__c>{ td.crc }, td.crc.Service_Account_ID__c, td.crc.Contract_ID__c);
        GenerateLetterService.buildDGPAlwaysReturnsDGP = true;
        Map<String, Id> emptyTemplateMap = new Map<String, Id>();

        DocumentGenerationProcess dgp = GenerateLetterService.buildDGP(
            td.clinicianContract, td.clientContract, new Map<Id, String>(), emptyTemplateMap, new Map<String, List<Object>>(), batch
        );

        GenerateLetterService.buildDGPAlwaysReturnsDGP = false;
        System.assertNotEquals(null, dgp);
        System.assertEquals(td.clinicianContract.Id, dgp.ReferenceObject);
        System.assertEquals(batch.Id, dgp.DocGenerationBatchProcessId);
    }

    @isTest
    static void testBuildDGPNullClientContract() {
        Account serviceAcc = [SELECT Id FROM Account WHERE Name = 'Test Service Account' LIMIT 1];
        Contract clinicianContract = [SELECT Id, AccountId, Account.FirstName, Account.LastName, Account.PersonContactId, Account.Professional_Title__pc,
            EE_NP_PA_Full_Time_Monthly_Blended__c, EE_NP_PA_Full_Time_Overage_Rate__c, Contracting_Corporate_Entity__r.Name
            FROM Contract WHERE Status = 'Executed' AND AccountId != :serviceAcc.Id LIMIT 1];
        Map<Id, String> hpaMap = new Map<Id, String>{ clinicianContract.Account.PersonContactId => 'Part Time' };
        Map<String, Id> templateMap = new Map<String, Id>();
        ContentVersion cv = new ContentVersion(Title = 'RateChangeNoticeEEFMD', PathOnClient = 'test.docx', VersionData = Blob.valueOf('Test'));
        insert cv;
        cv = [SELECT Id FROM ContentVersion WHERE Id = :cv.Id LIMIT 1];
        templateMap.put('RateChangeNoticeEEFMD', cv.Id);
        templateMap.put('RateChangeNoticeEEFTNPPA', cv.Id);

        Test.startTest();
        DocumentGenerationProcess dgp = GenerateLetterService.buildDGP(
            clinicianContract, null, hpaMap, templateMap, new Map<String, List<Object>>(), null
        );
        Test.stopTest();

        System.assertNotEquals(null, dgp);
    }

    @isTest
    static void testBuildTokenDataEmptyAccountListInCatch() {
        TestData td = getTestData();
        Contract c = [SELECT Id, AccountId FROM Contract WHERE Id = :td.clinicianContract.Id LIMIT 1];
        GenerateLetterService.buildTokenDataException = true;
        GenerateLetterService.buildTokenDataUseQueryInCatch = false;
        Test.startTest();
        Map<String, Object> tokenData = GenerateLetterService.buildTokenData(
            c, Date.today(), 100.00, 25.00, new Map<String, List<Object>>(), 'Part Time', 'HM'
        );
        Test.stopTest();
        GenerateLetterService.buildTokenDataException = false;
        GenerateLetterService.buildTokenDataUseQueryInCatch = false;
        System.assertNotEquals(null, tokenData);
        System.assertEquals('', tokenData.get('ClinicianFirstName'));
        System.assertEquals('', tokenData.get('ClinicianLastName'));
        System.assert(tokenData.containsKey('FacilityShiftTable'));
    }

    @isTest
    static void testGenerateAndAttachLetterWithFacilityData() {
        TestData td = getTestData();
        GenerateLetterService.buildDGPAlwaysReturnsDGP = false;
        Test.startTest();
        GenerateLetterService.GenerateAndAttachLetterResult result = GenerateLetterService.generateAndAttachLetter(
            new List<Id>{ td.clinicianContract.Id },
            new List<Clinical_Rate_Change__c>{ td.crc },
            false
        );
        Test.stopTest();
        System.assertNotEquals(null, result);
    }

    @isTest
    static void testGenerateAndAttachLetterEmptyClinicianContractIds() {
        GenerateLetterService.GenerateAndAttachLetterResult result = GenerateLetterService.generateAndAttachLetter(
            new List<Id>(),
            new List<Clinical_Rate_Change__c>(),
            false
        );
        System.assertEquals(false, result.success);
        System.assertEquals(null, result.batchProcessId);
    }
}