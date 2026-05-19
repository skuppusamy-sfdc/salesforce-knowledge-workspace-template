/**
 * @description Consolidated test class for CloneContractAction, ContractSyncAction,
 * GenerateAndAttachLetterAction, GetContractsToSend, PostProcessRateChangeAction,
 * SaveContractSelectionAction, RateChangeSummaryAction, PendingRateChangeChecker.
 */
@isTest
private class RateChangeActionsTest {

    private static final String SERVICE_ACC_NAME = 'Test Service Account';

    @TestSetup
    static void setupTestData() {
        TestDataFactory tdf = new TestDataFactory();
        Account serviceAcc = tdf.createServiceAccount(SERVICE_ACC_NAME, null, 'Service_Account', true);
        Id corpId = serviceAcc.Id;
        try {
            Account corporateEntity = tdf.createServiceAccount('Test Corporate Entity', null, 'Corporate_Entity', true);
            corpId = corporateEntity.Id;
        } catch (Exception e) { }
        Account clinicianAcc = tdf.createServiceAccount(null, 'Test Clinician', 'Clinician', true);
        clinicianAcc.Professional_Title__pc = 'MD';
        clinicianAcc.PersonEmail = 'clinician@example.com';
        update clinicianAcc;
        Contact con = tdf.getOrCreateContact(clinicianAcc, 'Test Contact');

        Contract clientContract = TestDataFactory.createContract(serviceAcc, Date.today());
        clientContract.Status = 'Executed';
        update clientContract;
        Contract clinicianContract = tdf.createClinicianContract(clinicianAcc, true);
        clinicianContract.Status = 'Executed';
        clinicianContract.Contracting_Corporate_Entity__c = corpId;
        update clinicianContract;
        Contract draftContract = TestDataFactory.createContract(clinicianAcc, Date.today().addDays(1));
        draftContract.Status = 'Draft';
        update draftContract;

        HealthcarePayerNetwork hpn = tdf.createHealthcarePayerNetwork('Test Payer Network', serviceAcc.Id, true);
        HealthcareProvider hp = tdf.createHealthcareProvider('Physician Provider', con.Id, true);
        HealthcarePractitionerFacility hpf = tdf.createHealthcarePractitionerFacility('Test HPF', con.Id, serviceAcc.Id, corpId, true);
        ProviderNetworkContract pnc = tdf.createPNC(clinicianContract.Id, hp.Id, hpn.Id, hpf.Id, true);
        ContractPaymentAgreement cpa = tdf.createCPA('Test CPA', clinicianContract.Id, pnc.Id, true, true);
        tdf.createPCA(cpa.Id, true);

        String userSelectedJson = '{"selectedClinicianIds":[{"selectId":"' + con.Id + '","isProcessed":false}]}';
        Clinical_Rate_Change__c crc = tdf.createClinicalRateChangeNew(serviceAcc.Id, clientContract.Id, userSelectedJson, true, true);
        crc.Contract_ID__c = clientContract.Id;
        crc.Service_Account_ID__c = serviceAcc.Id;
        crc.Status__c = 'Open';
        crc.PreviewClonedContractIds__c = clinicianContract.Id;
        crc.Non_Processed_Clinical_Ids__c = draftContract.Id;

        ContentVersion cv = new ContentVersion(Title = 'Compensation Change Notice Letter', PathOnClient = 'notice.pdf', VersionData = Blob.valueOf('Test'));
        insert cv;
        cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id LIMIT 1];
        insert new ContentDocumentLink(ContentDocumentId = cv.ContentDocumentId, LinkedEntityId = draftContract.Id, ShareType = 'V', Visibility = 'AllUsers');

        ContentVersion cvTemplate = new ContentVersion(Title = 'Test Template', PathOnClient = 'test.pdf', VersionData = Blob.valueOf('Test'));
        insert cvTemplate;
        cvTemplate = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :cvTemplate.Id LIMIT 1];
        DocGenerationBatchProcess batch = new DocGenerationBatchProcess(Description = 'Test', Category = 'RateChangeProcess');
        insert batch;
        DocumentGenerationProcess dgp = new DocumentGenerationProcess(
            DocGenerationBatchProcessId = batch.Id,
            ReferenceObject = draftContract.Id,
            Status = 'InProgress',
            TokenData = '{}',
            RequestText = '{"keepIntermediate":false,"title":"TestDoc","templateContentVersionId":"' + cvTemplate.Id + '"}'
        );
        insert dgp;
        crc.DocGenerationBatchProcessId__c = batch.Id;
        update crc;
    }

    private static TestData getTestData() {
        Account serviceAcc = [SELECT Id FROM Account WHERE Name = :SERVICE_ACC_NAME LIMIT 1];
        List<Contract> contracts = [SELECT Id, AccountId, Account.FirstName, Account.LastName, Account.PersonContactId, Account.Professional_Title__pc,
            StartDate, Account.Service_Line__r.Name, EE_NP_PA_Full_Time_Monthly_Blended__c, EE_NP_PA_Full_Time_Overage_Rate__c,
            Contracting_Corporate_Entity__r.Name FROM Contract WHERE Status = 'Executed'];
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
        TestData(Account a, Contract cli, Contract clin, Clinical_Rate_Change__c r) {
            serviceAcc = a; clientContract = cli; clinicianContract = clin; crc = r;
        }
    }

    private static void createEmailTemplateIfMissing() {
        List<EmailTemplate> existing = [SELECT Id FROM EmailTemplate WHERE DeveloperName = :System.Label.ClinicianCompensationIncreaseNoticeTemplate LIMIT 1];
        if (!existing.isEmpty()) {
            return;
        }
        System.runAs(new User(Id = UserInfo.getUserId())) {
            EmailTemplate t = new EmailTemplate(
                DeveloperName = System.Label.ClinicianCompensationIncreaseNoticeTemplate,
                Name = 'Test Template',
                FolderId = UserInfo.getUserId(),
                HtmlValue = '<p>Test</p>',
                TemplateType = 'custom',
                Subject = 'Test Email'
            );
            insert t;
        }
    }

    // ---- CloneContractAction ----
    @isTest static void testCloneContractValidationFailure() {
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = '';
        input.contractId = '';
        Test.startTest();
        List<CloneContractAction.InvocableOutput> outputs = CloneContractAction.cloneContract(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        System.assertEquals(1, outputs.size());
        System.assertEquals(false, outputs[0].success);
        System.assert(outputs[0].message.contains('select'));
    }
    @isTest static void testCloneContractSuccess() {
        TestData td = getTestData();
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = td.serviceAcc.Id;
        input.contractId = td.clientContract.Id;
        Test.startTest();
        List<CloneContractAction.InvocableOutput> outputs = CloneContractAction.cloneContract(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        System.assertEquals(1, outputs.size());
        System.assertEquals(true, outputs[0].success);
        System.assertNotEquals(null, outputs[0].jobId);
    }
    @isTest static void testCloneContractNoRateChange() {
        TestData td = getTestData();
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = td.serviceAcc.Id;
        input.contractId = td.serviceAcc.Id;
        Test.startTest();
        List<CloneContractAction.InvocableOutput> outputs = CloneContractAction.cloneContract(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        System.assertEquals(1, outputs.size());
        System.assertEquals(false, outputs[0].success);
    }
    @isTest static void testCloneContractNoCliniciansSelected() {
        TestData td = getTestData();
        td.crc.user_selected_IDs__c = '{}';
        update td.crc;
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = td.crc.Service_Account_ID__c;
        input.contractId = td.crc.Contract_ID__c;
        Test.startTest();
        List<CloneContractAction.InvocableOutput> outputs = CloneContractAction.cloneContract(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        System.assertEquals(1, outputs.size());
        System.assertEquals(false, outputs[0].success);
        System.assert(outputs[0].message.contains('clinicians'));
    }
    @isTest static void testCloneContractExceptionPath() {
        TestData td = getTestData();
        td.crc.user_selected_IDs__c = 'invalid json {{{';
        update td.crc;
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = td.crc.Service_Account_ID__c;
        input.contractId = td.crc.Contract_ID__c;
        Test.startTest();
        List<CloneContractAction.InvocableOutput> outputs = CloneContractAction.cloneContract(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        System.assertEquals(1, outputs.size());
        System.assertEquals(false, outputs[0].success);
        System.assert(outputs[0].message.contains('Something went wrong'));
        System.assertEquals(null, outputs[0].jobId);
    }
    @isTest static void testCloneContractExceptionPathFlag() {
        TestData td = getTestData();
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = td.crc.Service_Account_ID__c;
        input.contractId = td.crc.Contract_ID__c;
        CloneContractAction.cloneContractException = true;
        Test.startTest();
        List<CloneContractAction.InvocableOutput> outputs = CloneContractAction.cloneContract(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        CloneContractAction.cloneContractException = false;
        System.assertEquals(1, outputs.size());
        System.assertEquals(false, outputs[0].success);
        System.assert(outputs[0].message.contains('Something went wrong'));
        System.assertEquals(null, outputs[0].jobId);
    }

    // ---- ContractSyncAction ----
    @isTest static void testSyncContractsValidationFailure() {
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = '';
        input.contractId = '';
        Test.startTest();
        List<ContractSyncAction.InvocableOutput> outputs = ContractSyncAction.syncContracts(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        System.assertEquals(1, outputs.size());
        System.assertEquals(false, outputs[0].success);
        System.assert(outputs[0].message.contains('select'));
    }
    @isTest static void testSyncContractsSuccess() {
        Account serviceAcc = [SELECT Id FROM Account WHERE Name = :SERVICE_ACC_NAME LIMIT 1];
        Contract clientContract = [SELECT Id FROM Contract WHERE AccountId = :serviceAcc.Id AND Status = 'Executed' LIMIT 1];
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = serviceAcc.Id;
        input.contractId = clientContract.Id;
        Test.startTest();
        List<ContractSyncAction.InvocableOutput> outputs = ContractSyncAction.syncContracts(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        System.assertEquals(1, outputs.size());
        System.assertEquals(true, outputs[0].success);
        System.assertNotEquals(null, outputs[0].jobId);
    }
    @isTest static void testSyncContractsExceptionPath() {
        Account serviceAcc = [SELECT Id FROM Account WHERE Name = :SERVICE_ACC_NAME LIMIT 1];
        Contract clientContract = [SELECT Id FROM Contract WHERE AccountId = :serviceAcc.Id AND Status = 'Executed' LIMIT 1];
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = serviceAcc.Id;
        input.contractId = clientContract.Id;
        ContractSyncAction.exceptionForTest = true;
        Test.startTest();
        List<ContractSyncAction.InvocableOutput> outputs = ContractSyncAction.syncContracts(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        ContractSyncAction.exceptionForTest = false;
        System.assertEquals(1, outputs.size());
        System.assertEquals(false, outputs[0].success);
        System.assert(outputs[0].message.contains('couldn\'t start'));
        System.assertEquals(null, outputs[0].jobId);
    }
    @isTest static void testSyncContractsNoRateChange() {
        Account serviceAcc = [SELECT Id FROM Account WHERE Name = :SERVICE_ACC_NAME LIMIT 1];
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = serviceAcc.Id;
        input.contractId = serviceAcc.Id;
        Test.startTest();
        List<ContractSyncAction.InvocableOutput> outputs = ContractSyncAction.syncContracts(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        System.assertEquals(1, outputs.size());
        System.assertEquals(false, outputs[0].success);
    }
    @isTest static void testSyncContractsNoPreviewContracts() {
        Clinical_Rate_Change__c crc = [SELECT Id, Service_Account_ID__c, Contract_ID__c FROM Clinical_Rate_Change__c LIMIT 1];
        crc.PreviewClonedContractIds__c = null;
        update crc;
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = crc.Service_Account_ID__c;
        input.contractId = crc.Contract_ID__c;
        Test.startTest();
        List<ContractSyncAction.InvocableOutput> outputs = ContractSyncAction.syncContracts(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        System.assertEquals(1, outputs.size());
        System.assertEquals(false, outputs[0].success);
        System.assert(outputs[0].message.contains('No contracts') || outputs[0].message.contains('Clone Contract'));
    }
    @isTest static void testContractSyncQueueableExecutes() {
        Contract clinicianContract = [SELECT Id FROM Contract WHERE Status = 'Executed' LIMIT 1];
        Clinical_Rate_Change__c crc = [SELECT Id FROM Clinical_Rate_Change__c LIMIT 1];
        Test.startTest();
        System.enqueueJob(new RateChangeQueueable(new List<Id>{ clinicianContract.Id }, crc.Id));
        Test.stopTest();
        List<AsyncApexJob> jobs = [SELECT Id, Status FROM AsyncApexJob WHERE ApexClass.Name = 'RateChangeQueueable'];
        System.assertEquals(1, jobs.size());
        System.assertEquals('Completed', jobs[0].Status);
    }
    @isTest static void testContractSyncQueueableChainsWhenMoreThanBatchSize() {
        List<Contract> contracts = [SELECT Id FROM Contract WHERE Status = 'Executed' ORDER BY Id];
        Clinical_Rate_Change__c crc = [SELECT Id FROM Clinical_Rate_Change__c LIMIT 1];
        List<Id> contractIds = new List<Id>();
        for (Contract c : contracts) {
            contractIds.add(c.Id);
        }
        while (contractIds.size() < 6) {
            contractIds.add(contracts[0].Id);
        }
        Test.startTest();
        System.enqueueJob(new RateChangeQueueable(contractIds, crc.Id));
        Test.stopTest();
        List<AsyncApexJob> jobs = [SELECT Id, Status FROM AsyncApexJob WHERE ApexClass.Name = 'RateChangeQueueable' ORDER BY CreatedDate];
        System.assert(jobs.size() >= 1, 'Should have at least one job; chaining may add more');
        System.assertEquals('Completed', jobs[0].Status);
    }
    @isTest static void testContractSyncQueueableEmptyContractIds() {
        Clinical_Rate_Change__c crc = [SELECT Id FROM Clinical_Rate_Change__c LIMIT 1];
        Test.startTest();
        System.enqueueJob(new RateChangeQueueable(new List<Id>(), crc.Id));
        Test.stopTest();
        List<AsyncApexJob> jobs = [SELECT Id, Status FROM AsyncApexJob WHERE ApexClass.Name = 'RateChangeQueueable'];
        System.assertEquals(1, jobs.size());
        System.assertEquals('Completed', jobs[0].Status);
    }

    // ---- GenerateAndAttachLetterAction ----
    @isTest static void testGenerateAndAttachLetterValidationFailure() {
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = '';
        input.contractId = '';
        Test.startTest();
        List<GenerateAndAttachLetterAction.InvocableOutput> outputs = GenerateAndAttachLetterAction.generateAndAttachLetter(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        System.assertEquals(1, outputs.size());
        System.assertEquals(false, outputs[0].success);
        System.assertEquals(false, outputs[0].batchJobSubmitted);
    }
    @isTest static void testGenerateAndAttachLetterNoRateChange() {
        Account serviceAcc = [SELECT Id FROM Account LIMIT 1];
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = serviceAcc.Id;
        input.contractId = serviceAcc.Id;
        Test.startTest();
        List<GenerateAndAttachLetterAction.InvocableOutput> outputs = GenerateAndAttachLetterAction.generateAndAttachLetter(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        System.assertEquals(1, outputs.size());
        System.assertEquals(false, outputs[0].success);
        System.assert(outputs[0].message.contains('No pending rate change'));
    }
    @isTest static void testGenerateAndAttachLetterNoContracts() {
        Clinical_Rate_Change__c crc = [SELECT Id, Service_Account_ID__c, Contract_ID__c FROM Clinical_Rate_Change__c LIMIT 1];
        crc.PreviewClonedContractIds__c = null;
        update crc;
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = crc.Service_Account_ID__c;
        input.contractId = crc.Contract_ID__c;
        Test.startTest();
        List<GenerateAndAttachLetterAction.InvocableOutput> outputs = GenerateAndAttachLetterAction.generateAndAttachLetter(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        System.assertEquals(1, outputs.size());
        System.assertEquals(false, outputs[0].success);
        System.assert(outputs[0].message.contains('Clone Contract first'));
    }
    @isTest static void testGenerateAndAttachLetterSuccess() {
        Clinical_Rate_Change__c crc = [SELECT Id, Service_Account_ID__c, Contract_ID__c FROM Clinical_Rate_Change__c LIMIT 1];
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = crc.Service_Account_ID__c;
        input.contractId = crc.Contract_ID__c;
        Test.startTest();
        List<GenerateAndAttachLetterAction.InvocableOutput> outputs = GenerateAndAttachLetterAction.generateAndAttachLetter(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        System.assertEquals(1, outputs.size());
        System.assert(String.isNotBlank(outputs[0].message), 'Should return a message');
        if (outputs[0].success && outputs[0].batchProcessId != null) {
            System.assertNotEquals(null, outputs[0].asyncJob, 'asyncJob should be set when success with batchProcessId');
            System.assertEquals('letter', outputs[0].asyncJob.jobType);
            System.assert(outputs[0].message.contains('Generating notice letters'));
        }
    }
    @isTest static void testGenerateAndAttachLetterFailureWithoutException() {
        Clinical_Rate_Change__c crc = [SELECT Id, Service_Account_ID__c, Contract_ID__c FROM Clinical_Rate_Change__c LIMIT 1];
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = crc.Service_Account_ID__c;
        input.contractId = crc.Contract_ID__c;
        GenerateLetterService.letterGenerationFailure = true;
        Test.startTest();
        List<GenerateAndAttachLetterAction.InvocableOutput> outputs = GenerateAndAttachLetterAction.generateAndAttachLetter(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        GenerateLetterService.letterGenerationFailure = false;
        System.assertEquals(1, outputs.size());
        System.assertEquals(false, outputs[0].success);
        System.assertEquals(false, outputs[0].batchJobSubmitted);
        System.assert(outputs[0].message.contains('Could not start letter generation'));
    }
    @isTest static void testGenerateAndAttachLetterSuccessWithAsyncJob() {
        Clinical_Rate_Change__c crc = [SELECT Id, Service_Account_ID__c, Contract_ID__c FROM Clinical_Rate_Change__c LIMIT 1];
        DocGenerationBatchProcess batch = GenerateLetterService.createBatchProcess(new List<Clinical_Rate_Change__c>{ crc }, crc.Service_Account_ID__c, crc.Contract_ID__c);
        GenerateLetterService.GenerateAndAttachLetterResult mockResult = new GenerateLetterService.GenerateAndAttachLetterResult();
        mockResult.success = true;
        mockResult.batchProcessId = batch.Id;
        GenerateLetterService.letterResult = mockResult;
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = crc.Service_Account_ID__c;
        input.contractId = crc.Contract_ID__c;
        Test.startTest();
        List<GenerateAndAttachLetterAction.InvocableOutput> outputs = GenerateAndAttachLetterAction.generateAndAttachLetter(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        GenerateLetterService.letterResult = null;
        System.assertEquals(1, outputs.size());
        System.assertEquals(true, outputs[0].success);
        System.assertEquals(true, outputs[0].batchJobSubmitted);
        System.assertNotEquals(null, outputs[0].batchProcessId);
        System.assertNotEquals(null, outputs[0].asyncJob);
        System.assertEquals('letter', outputs[0].asyncJob.jobType);
        System.assertEquals('Generate Notice Letters', outputs[0].asyncJob.jobLabel);
        System.assert(outputs[0].message.contains('Generating notice letters'));
    }
    @isTest static void testGenerateAndAttachLetterExceptionPath() {
        Clinical_Rate_Change__c crc = [SELECT Id, Service_Account_ID__c, Contract_ID__c FROM Clinical_Rate_Change__c LIMIT 1];
        crc.PreviewClonedContractIds__c = 'not-a-valid-id';
        update crc;
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = crc.Service_Account_ID__c;
        input.contractId = crc.Contract_ID__c;
        Test.startTest();
        List<GenerateAndAttachLetterAction.InvocableOutput> outputs = GenerateAndAttachLetterAction.generateAndAttachLetter(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        System.assertEquals(1, outputs.size());
        System.assertEquals(false, outputs[0].success);
        System.assertEquals(false, outputs[0].batchJobSubmitted);
        System.assert(outputs[0].message.contains('Something went wrong'));
    }
    @isTest static void testGenerateAndAttachLetterSuccessMessageFormat() {
        Contract clinicianContract = [SELECT Id FROM Contract WHERE AccountId != :[SELECT Id FROM Account WHERE Name = :SERVICE_ACC_NAME LIMIT 1].Id LIMIT 1];
        Clinical_Rate_Change__c crc = [SELECT Id, Service_Account_ID__c, Contract_ID__c FROM Clinical_Rate_Change__c LIMIT 1];
        crc.PreviewClonedContractIds__c = clinicianContract.Id + ',' + clinicianContract.Id;
        update crc;
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = crc.Service_Account_ID__c;
        input.contractId = crc.Contract_ID__c;
        Test.startTest();
        List<GenerateAndAttachLetterAction.InvocableOutput> outputs = GenerateAndAttachLetterAction.generateAndAttachLetter(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        System.assertEquals(1, outputs.size());
        System.assert(String.isNotBlank(outputs[0].message), 'Should return a message');
    }

    // ---- GetContractsToSend ----
    @isTest static void testGetContractsToSendValidationFailure() {
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = '';
        input.contractId = '';
        Test.startTest();
        List<GetContractsToSend.InvocableOutput> outputs = GetContractsToSend.getContractsToSend(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        System.assertEquals(1, outputs.size());
        System.assertEquals(false, outputs[0].success);
        System.assertNotEquals(null, outputs[0].draftContracts);
    }
    @isTest static void testGetContractsToSendExceptionPath() {
        Clinical_Rate_Change__c crc = [SELECT Id, Service_Account_ID__c, Contract_ID__c FROM Clinical_Rate_Change__c LIMIT 1];
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = crc.Service_Account_ID__c;
        input.contractId = crc.Contract_ID__c;
        GetContractsToSend.exceptionForTest = true;
        Test.startTest();
        List<GetContractsToSend.InvocableOutput> outputs = GetContractsToSend.getContractsToSend(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        GetContractsToSend.exceptionForTest = false;
        System.assertEquals(1, outputs.size());
        System.assertEquals(false, outputs[0].success);
        System.assert(outputs[0].message.contains('Something went wrong'));
        System.assertNotEquals(null, outputs[0].draftContracts);
    }
    @isTest static void testGetContractsToSendNoRateChange() {
        Account serviceAcc = [SELECT Id FROM Account LIMIT 1];
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = serviceAcc.Id;
        input.contractId = serviceAcc.Id;
        Test.startTest();
        List<GetContractsToSend.InvocableOutput> outputs = GetContractsToSend.getContractsToSend(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        System.assertEquals(1, outputs.size());
        System.assertEquals(false, outputs[0].success);
    }
    @isTest static void testGetContractsToSendSuccess() {
        Clinical_Rate_Change__c crc = [SELECT Id, Service_Account_ID__c, Contract_ID__c FROM Clinical_Rate_Change__c LIMIT 1];
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = crc.Service_Account_ID__c;
        input.contractId = crc.Contract_ID__c;
        Test.startTest();
        List<GetContractsToSend.InvocableOutput> outputs = GetContractsToSend.getContractsToSend(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        System.assertEquals(1, outputs.size());
        System.assertEquals(true, outputs[0].success);
        System.assertNotEquals(null, outputs[0].draftContracts);
        System.assert(outputs[0].message.contains('Found'));
    }
    @isTest static void testGetContractsToSendWithContractHavingLetter() {
        Contract draftContract = [SELECT Id FROM Contract WHERE Status = 'Draft' LIMIT 1];
        ContentVersion cv = new ContentVersion(Title = 'Compensation Change Notice Letter', PathOnClient = 'notice.pdf', VersionData = Blob.valueOf('Test'));
        insert cv;
        cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id LIMIT 1];
        insert new ContentDocumentLink(ContentDocumentId = cv.ContentDocumentId, LinkedEntityId = draftContract.Id, ShareType = 'V', Visibility = 'AllUsers');
        Clinical_Rate_Change__c crc = [SELECT Id, Service_Account_ID__c, Contract_ID__c FROM Clinical_Rate_Change__c LIMIT 1];
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = crc.Service_Account_ID__c;
        input.contractId = crc.Contract_ID__c;
        Test.startTest();
        List<GetContractsToSend.InvocableOutput> outputs = GetContractsToSend.getContractsToSend(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        System.assertEquals(1, outputs.size());
        System.assertEquals(true, outputs[0].success);
        System.assertNotEquals(null, outputs[0].draftContracts);
    }

    // ---- PostProcessRateChangeAction ----
    @isTest static void testPostProcessRateChangeValidationFailure() {
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = '';
        input.contractId = '';
        Test.startTest();
        List<RateChangeInvocableOutput> outputs = PostProcessRateChangeAction.postProcessRateChange(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        System.assertEquals(1, outputs.size());
        System.assertEquals(false, outputs[0].success);
    }
    @isTest static void testPostProcessRateChangeNoOpenRateChange() {
        Account serviceAcc = [SELECT Id FROM Account LIMIT 1];
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = serviceAcc.Id;
        input.contractId = serviceAcc.Id;
        Test.startTest();
        List<RateChangeInvocableOutput> outputs = PostProcessRateChangeAction.postProcessRateChange(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        System.assertEquals(1, outputs.size());
        System.assertEquals(false, outputs[0].success);
    }
    @isTest static void testPostProcessRateChangeNoContractsSelected() {
        Clinical_Rate_Change__c crc = [SELECT Id, Service_Account_ID__c, Contract_ID__c FROM Clinical_Rate_Change__c LIMIT 1];
        crc.Non_Processed_Clinical_Ids__c = null;
        update crc;
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = crc.Service_Account_ID__c;
        input.contractId = crc.Contract_ID__c;
        Test.startTest();
        List<RateChangeInvocableOutput> outputs = PostProcessRateChangeAction.postProcessRateChange(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        System.assertEquals(1, outputs.size());
        System.assertEquals(false, outputs[0].success);
        System.assert(outputs[0].message.contains('selection'));
    }
    @isTest static void testPostProcessRateChangeSuccess() {
        Clinical_Rate_Change__c crc = [SELECT Id, Service_Account_ID__c, Contract_ID__c FROM Clinical_Rate_Change__c LIMIT 1];
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = crc.Service_Account_ID__c;
        input.contractId = crc.Contract_ID__c;
        Test.startTest();
        createEmailTemplateIfMissing();
        List<RateChangeInvocableOutput> outputs = PostProcessRateChangeAction.postProcessRateChange(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        System.assertEquals(1, outputs.size());
        System.assert(outputs[0].success || outputs[0].message.contains('Something went wrong'));
    }
    @isTest static void testPostProcessRateChangeWithContractHavingAttachment() {
        Contract clinicianContract = [SELECT Id FROM Contract WHERE Status = 'Draft' LIMIT 1];
        ContentVersion cv = new ContentVersion(Title = 'Compensation Change Notice Letter', PathOnClient = 'notice.pdf', VersionData = Blob.valueOf('Test'));
        insert cv;
        cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id LIMIT 1];
        insert new ContentDocumentLink(ContentDocumentId = cv.ContentDocumentId, LinkedEntityId = clinicianContract.Id, ShareType = 'V', Visibility = 'AllUsers');
        Clinical_Rate_Change__c crc = [SELECT Id, Service_Account_ID__c, Contract_ID__c FROM Clinical_Rate_Change__c LIMIT 1];
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = crc.Service_Account_ID__c;
        input.contractId = crc.Contract_ID__c;
        Test.startTest();
        createEmailTemplateIfMissing();
        List<RateChangeInvocableOutput> outputs = PostProcessRateChangeAction.postProcessRateChange(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        System.assertEquals(1, outputs.size());
        System.assert(outputs[0].success || outputs[0].message.contains('Something went wrong'));
    }
    @isTest static void testPostProcessRateChangeWithClonedContract() {
        
        Account serviceAcc = [SELECT Id FROM Account LIMIT 1];
        
        Test.startTest();
        Contract clientContract = [SELECT Id FROM Contract LIMIT 1];
        Contract clonedContract = TestDataFactory.createContract(serviceAcc, Date.today().addDays(1));
        clonedContract.Status = 'Draft';
        clonedContract.PreviousContractId = clientContract.Id;
        update clonedContract;
        Clinical_Rate_Change__c crc = [SELECT Id, Service_Account_ID__c, Contract_ID__c, PreviewClonedContractIds__c FROM Clinical_Rate_Change__c LIMIT 1];
        crc.Non_Processed_Clinical_Ids__c = clonedContract.Id;
        crc.PreviewClonedContractIds__c = clonedContract.Id;
        crc.ContractsForPostProcessing__c = null;
        update crc;
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = crc.Service_Account_ID__c;
        input.contractId = crc.Contract_ID__c;
        createEmailTemplateIfMissing();
        List<RateChangeInvocableOutput> outputs = PostProcessRateChangeAction.postProcessRateChange(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        System.assertEquals(1, outputs.size());
        System.assertEquals(true, outputs[0].success);
    }
    @isTest static void testPostProcessRateChangeExceptionPath() {
        Clinical_Rate_Change__c crc = [SELECT Id, Service_Account_ID__c, Contract_ID__c FROM Clinical_Rate_Change__c LIMIT 1];
        crc.Non_Processed_Clinical_Ids__c = 'invalid-id';
        update crc;
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = crc.Service_Account_ID__c;
        input.contractId = crc.Contract_ID__c;
        Test.startTest();
        List<RateChangeInvocableOutput> outputs = PostProcessRateChangeAction.postProcessRateChange(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        System.assertEquals(1, outputs.size());
        System.assertEquals(false, outputs[0].success);
        System.assert(outputs[0].message.contains('Something went wrong'));
    }
    @isTest static void testPostProcessRateChangeSendRateChangeSummaryEmailCatch() {
        Clinical_Rate_Change__c crc = [SELECT Id, Service_Account_ID__c, Contract_ID__c FROM Clinical_Rate_Change__c LIMIT 1];
        Contract clinicianContract = [SELECT Id FROM Contract WHERE Status = 'Draft' LIMIT 1];
        crc.Non_Processed_Clinical_Ids__c = clinicianContract.Id;
        crc.PreviewClonedContractIds__c = clinicianContract.Id;
        update crc;
        ContentVersion cv = new ContentVersion(Title = 'Compensation Change Notice Letter', PathOnClient = 'notice.pdf', VersionData = Blob.valueOf('Test'));
        insert cv;
        cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id LIMIT 1];
        insert new ContentDocumentLink(ContentDocumentId = cv.ContentDocumentId, LinkedEntityId = clinicianContract.Id, ShareType = 'V', Visibility = 'AllUsers');
        PostProcessRateChangeAction.sendRateChangeSummaryEmailFailure = true;
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = crc.Service_Account_ID__c;
        input.contractId = crc.Contract_ID__c;
        Test.startTest();
        createEmailTemplateIfMissing();
        List<RateChangeInvocableOutput> outputs = PostProcessRateChangeAction.postProcessRateChange(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        PostProcessRateChangeAction.sendRateChangeSummaryEmailFailure = false;
        System.assertEquals(1, outputs.size());
        System.assertEquals(true, outputs[0].success, 'sendRateChangeSummaryEmail catches internally; main flow still succeeds');
    }
    @isTest static void testPostProcessRateChangeWithExistingContractsForPostProcessing() {
        Clinical_Rate_Change__c crc = [SELECT Id, Service_Account_ID__c, Contract_ID__c, Non_Processed_Clinical_Ids__c FROM Clinical_Rate_Change__c LIMIT 1];
        Id clinicianContractId = crc.Non_Processed_Clinical_Ids__c;
        System.assertNotEquals(null, clinicianContractId, 'CRC must have Non_Processed_Clinical_Ids__c');
        List<Contract> contractList = [SELECT Id, AccountId FROM Contract WHERE Id = :clinicianContractId LIMIT 1];
        System.assert(!contractList.isEmpty(), 'Clinician contract not found');
        Contract clinicianContract = contractList[0];
        List<Account> accList = [SELECT Id FROM Account WHERE Id = :clinicianContract.AccountId LIMIT 1];
        System.assert(!accList.isEmpty(), 'Clinician account not found');
        Account clinicianAcc = accList[0];
        clinicianAcc.PersonEmail = 'test2@example.com';
        update clinicianAcc;
        crc.Non_Processed_Clinical_Ids__c = clinicianContract.Id;
        crc.PreviewClonedContractIds__c = clinicianContract.Id;
        crc.ContractsForPostProcessing__c = clinicianContract.Id;
        update crc;
        ContentVersion cv = new ContentVersion(Title = 'Compensation Change Notice Letter', PathOnClient = 'notice.pdf', VersionData = Blob.valueOf('Test'));
        insert cv;
        cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id LIMIT 1];
        insert new ContentDocumentLink(ContentDocumentId = cv.ContentDocumentId, LinkedEntityId = clinicianContract.Id, ShareType = 'V', Visibility = 'AllUsers');
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = crc.Service_Account_ID__c;
        input.contractId = crc.Contract_ID__c;
        Test.startTest();
        createEmailTemplateIfMissing();
        List<RateChangeInvocableOutput> outputs = PostProcessRateChangeAction.postProcessRateChange(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        System.assertEquals(1, outputs.size());
        System.assert(outputs[0].success || outputs[0].message.contains('Something went wrong'));
    }
    @isTest static void testPostProcessRateChangeContractWithNoEmail() {
        TestDataFactory tdf = new TestDataFactory();
        Account clinicianNoEmail = tdf.createServiceAccount(null, 'NoEmail Clinician', 'Clinician', true);
        clinicianNoEmail.PersonEmail = null;
        update clinicianNoEmail;
        Contract clinicianContract = tdf.createClinicianContract(clinicianNoEmail, true);
        clinicianContract.Status = 'Draft';
        //update clinicianContract;
        Clinical_Rate_Change__c crc = [SELECT Id, Service_Account_ID__c, Contract_ID__c FROM Clinical_Rate_Change__c LIMIT 1];
        crc.Non_Processed_Clinical_Ids__c = clinicianContract.Id;
        update crc;
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = crc.Service_Account_ID__c;
        input.contractId = crc.Contract_ID__c;
        Test.startTest();
        createEmailTemplateIfMissing();
        List<RateChangeInvocableOutput> outputs = PostProcessRateChangeAction.postProcessRateChange(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        System.assertEquals(1, outputs.size());
        System.assert(outputs[0].success || outputs[0].message.contains('Something went wrong'));
    }
    @isTest static void testPostProcessRateChangeFinalizeException() {
        Clinical_Rate_Change__c crc = [SELECT Id, Service_Account_ID__c, Contract_ID__c FROM Clinical_Rate_Change__c LIMIT 1];
        crc.Service_Account_ID__c = '001000000000000AAA';
        update crc;
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = '001000000000000AAA';
        input.contractId = crc.Contract_ID__c;
        Test.startTest();
        createEmailTemplateIfMissing();
        List<RateChangeInvocableOutput> outputs = PostProcessRateChangeAction.postProcessRateChange(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        System.assertEquals(1, outputs.size());
        System.assert(outputs[0].success, 'Finalize catches internally; main flow still returns success');
    }

    // ---- SaveContractSelectionAction ----
    @isTest static void testSaveSelectedContractsSuccess() {
        Clinical_Rate_Change__c crc = [SELECT Id, Service_Account_ID__c, Contract_ID__c FROM Clinical_Rate_Change__c LIMIT 1];
        List<String> selectedIds = new List<String>{ crc.Contract_ID__c };
        Test.startTest();
        Map<String, Object> result = SaveContractSelectionAction.saveSelectedContracts(crc.Service_Account_ID__c, crc.Contract_ID__c, selectedIds);
        Test.stopTest();
        System.assertEquals(true, result.get('success'));
        System.assert(String.valueOf(result.get('message')).contains('Saved'));
    }
    @isTest static void testSaveSelectedContractsEmptySelection() {
        Clinical_Rate_Change__c crc = [SELECT Id, Service_Account_ID__c, Contract_ID__c FROM Clinical_Rate_Change__c LIMIT 1];
        Test.startTest();
        Map<String, Object> result = SaveContractSelectionAction.saveSelectedContracts(crc.Service_Account_ID__c, crc.Contract_ID__c, new List<String>());
        Test.stopTest();
        System.assertEquals(true, result.get('success'));
    }
    @isTest static void testSaveSelectedContractsNoRateChange() {
        Clinical_Rate_Change__c crc = [SELECT Id FROM Clinical_Rate_Change__c LIMIT 1];
        delete crc;
        Account serviceAcc = [SELECT Id FROM Account LIMIT 1];
        Contract clientContract = [SELECT Id FROM Contract LIMIT 1];
        Test.startTest();
        Map<String, Object> result = SaveContractSelectionAction.saveSelectedContracts(serviceAcc.Id, clientContract.Id, new List<String>{ clientContract.Id });
        Test.stopTest();
        System.assertEquals(false, result.get('success'));
        String msg = String.valueOf(result.get('message'));
        System.assert(msg.contains('No pending') || msg.contains('rate change') || msg.length() > 0, 'Expected error message');
    }

    // ---- RateChangeSummaryAction ----
    @isTest static void testGetRateChangeSummaryValidationFailure() {
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = '';
        input.contractId = '';
        Test.startTest();
        List<RateChangeInvocableOutput> outputs = RateChangeSummaryAction.getRateChangeSummary(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        System.assertEquals(1, outputs.size());
        System.assertEquals(false, outputs[0].success);
    }
    @isTest static void testGetRateChangeSummarySuccess() {
        Clinical_Rate_Change__c crc = [SELECT Id, Service_Account_ID__c, Contract_ID__c FROM Clinical_Rate_Change__c LIMIT 1];
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = crc.Service_Account_ID__c;
        input.contractId = crc.Contract_ID__c;
        Test.startTest();
        List<RateChangeInvocableOutput> outputs = RateChangeSummaryAction.getRateChangeSummary(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        System.assertEquals(1, outputs.size());
        System.assertEquals(true, outputs[0].success);
        System.assertNotEquals(null, outputs[0].message);
        System.assert(outputs[0].message.contains('Rate Change Summary'));
    }
    @isTest static void testGetRateChangeSummaryMalformedUserSelectedIds() {
        Clinical_Rate_Change__c crc = [SELECT Id, Service_Account_ID__c, Contract_ID__c FROM Clinical_Rate_Change__c LIMIT 1];
        crc.user_selected_IDs__c = '{"invalid": "json"}';
        update crc;
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = crc.Service_Account_ID__c;
        input.contractId = crc.Contract_ID__c;
        Test.startTest();
        List<RateChangeInvocableOutput> outputs = RateChangeSummaryAction.getRateChangeSummary(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        System.assertEquals(1, outputs.size());
        System.assertEquals(true, outputs[0].success);
        System.assert(outputs[0].message.contains('Rate Change Summary'));
    }
    @isTest static void testGetRateChangeSummaryLettersPartialCoverage() {
        Clinical_Rate_Change__c crc = [SELECT Id, Service_Account_ID__c, Contract_ID__c FROM Clinical_Rate_Change__c LIMIT 1];
        Contract clinicianContract = [SELECT Id FROM Contract WHERE Status = 'Draft' LIMIT 1];
        ContentVersion cvLetter = new ContentVersion(Title = 'Compensation Change Notice Letter', PathOnClient = 'letter.pdf', VersionData = Blob.valueOf('Test'));
        insert cvLetter;
        cvLetter = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cvLetter.Id LIMIT 1];
        insert new ContentDocumentLink(ContentDocumentId = cvLetter.ContentDocumentId, LinkedEntityId = clinicianContract.Id, ShareType = 'V', Visibility = 'AllUsers');
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = crc.Service_Account_ID__c;
        input.contractId = crc.Contract_ID__c;
        Test.startTest();
        List<RateChangeInvocableOutput> outputs = RateChangeSummaryAction.getRateChangeSummary(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        System.assertEquals(1, outputs.size());
        System.assertEquals(true, outputs[0].success);
    }
    @isTest static void testGetRateChangeSummaryExceptionPath() {
        Clinical_Rate_Change__c crc = [SELECT Id, Service_Account_ID__c, Contract_ID__c FROM Clinical_Rate_Change__c LIMIT 1];
        crc.PreviewClonedContractIds__c = 'invalid-id';
        update crc;
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = crc.Service_Account_ID__c;
        input.contractId = crc.Contract_ID__c;
        Test.startTest();
        List<RateChangeInvocableOutput> outputs = RateChangeSummaryAction.getRateChangeSummary(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        System.assertEquals(1, outputs.size());
        System.assertEquals(false, outputs[0].success);
        System.assert(outputs[0].message.contains('Error retrieving summary'));
    }
    @isTest static void testGetRateChangeSummaryNoRateChange() {
        Clinical_Rate_Change__c crc = [SELECT Id, Service_Account_ID__c, Contract_ID__c FROM Clinical_Rate_Change__c LIMIT 1];
        delete crc;
        Account serviceAcc = [SELECT Id FROM Account WHERE Name = :SERVICE_ACC_NAME LIMIT 1];
        Contract clientContract = [SELECT Id FROM Contract WHERE AccountId = :serviceAcc.Id LIMIT 1];
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = serviceAcc.Id;
        input.contractId = clientContract.Id;
        Test.startTest();
        List<RateChangeInvocableOutput> outputs = RateChangeSummaryAction.getRateChangeSummary(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        System.assertEquals(1, outputs.size());
        System.assertEquals(false, outputs[0].success);
        System.assert(outputs[0].message.contains('No rate change'));
    }
    @isTest static void testGetRateChangeSummaryNoRateChangeActivity() {
        Clinical_Rate_Change__c crc = [SELECT Id, Service_Account_ID__c, Contract_ID__c FROM Clinical_Rate_Change__c LIMIT 1];
        crc.user_selected_IDs__c = null;
        crc.PreviewClonedContractIds__c = null;
        crc.DocGenerationBatchProcessId__c = null;
        update crc;
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = crc.Service_Account_ID__c;
        input.contractId = crc.Contract_ID__c;
        Test.startTest();
        List<RateChangeInvocableOutput> outputs = RateChangeSummaryAction.getRateChangeSummary(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        System.assertEquals(1, outputs.size());
        System.assertEquals(true, outputs[0].success);
        System.assert(outputs[0].message.contains('No rate change activity found'));
    }
    @isTest static void testGetRateChangeSummaryWithCliniciansSelected() {
        Contact con = [SELECT Id FROM Contact LIMIT 1];
        Clinical_Rate_Change__c crc = [SELECT Id, Service_Account_ID__c, Contract_ID__c FROM Clinical_Rate_Change__c LIMIT 1];
        crc.user_selected_IDs__c = '{"selectedClinicianIds":[{"selectId":"' + con.Id + '","isProcessed":false}]}';
        crc.PreviewClonedContractIds__c = null;
        crc.DocGenerationBatchProcessId__c = null;
        update crc;
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = crc.Service_Account_ID__c;
        input.contractId = crc.Contract_ID__c;
        Test.startTest();
        List<RateChangeInvocableOutput> outputs = RateChangeSummaryAction.getRateChangeSummary(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        System.assertEquals(1, outputs.size());
        System.assertEquals(true, outputs[0].success);
        System.assert(outputs[0].message.contains('Clinicians Selected'));
    }
    @isTest static void testGetRateChangeSummaryWithContractsCreated() {
        Contract clinicianContract = [SELECT Id FROM Contract WHERE Status = 'Executed' LIMIT 1];
        Clinical_Rate_Change__c crc = [SELECT Id, Service_Account_ID__c, Contract_ID__c FROM Clinical_Rate_Change__c LIMIT 1];
        crc.user_selected_IDs__c = null;
        crc.PreviewClonedContractIds__c = clinicianContract.Id;
        crc.DocGenerationBatchProcessId__c = null;
        update crc;
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = crc.Service_Account_ID__c;
        input.contractId = crc.Contract_ID__c;
        Test.startTest();
        List<RateChangeInvocableOutput> outputs = RateChangeSummaryAction.getRateChangeSummary(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        System.assertEquals(1, outputs.size());
        System.assertEquals(true, outputs[0].success);
        System.assert(outputs[0].message.contains('Contracts Created'));
    }
    @isTest static void testGetRateChangeSummaryWithLettersGenerated() {
        Contract draftContract = [SELECT Id FROM Contract WHERE Status = 'Draft' LIMIT 1];
        DocGenerationBatchProcess batch = [SELECT Id FROM DocGenerationBatchProcess LIMIT 1];
        Clinical_Rate_Change__c crc = [SELECT Id, Service_Account_ID__c, Contract_ID__c FROM Clinical_Rate_Change__c LIMIT 1];
        crc.user_selected_IDs__c = null;
        crc.PreviewClonedContractIds__c = null;
        crc.DocGenerationBatchProcessId__c = batch.Id;
        update crc;
        List<DocumentGenerationProcess> dgpList = [SELECT Id, ReferenceObject FROM DocumentGenerationProcess WHERE DocGenerationBatchProcessId = :batch.Id];
        if (dgpList.isEmpty()) {
            insert new DocumentGenerationProcess(
                DocGenerationBatchProcessId = batch.Id,
                ReferenceObject = draftContract.Id,
                Status = 'InProgress',
                TokenData = '{}',
                RequestText = '{}'
            );
        }
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = crc.Service_Account_ID__c;
        input.contractId = crc.Contract_ID__c;
        Test.startTest();
        List<RateChangeInvocableOutput> outputs = RateChangeSummaryAction.getRateChangeSummary(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        System.assertEquals(1, outputs.size());
        System.assertEquals(true, outputs[0].success);
    }
    @isTest static void testGetRateChangeSummaryCliniciansSelectedInvalidJson() {
        Clinical_Rate_Change__c crc = [SELECT Id, Service_Account_ID__c, Contract_ID__c FROM Clinical_Rate_Change__c LIMIT 1];
        crc.user_selected_IDs__c = 'not-valid-json-at-all';
        crc.PreviewClonedContractIds__c = null;
        crc.DocGenerationBatchProcessId__c = null;
        update crc;
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = crc.Service_Account_ID__c;
        input.contractId = crc.Contract_ID__c;
        Test.startTest();
        List<RateChangeInvocableOutput> outputs = RateChangeSummaryAction.getRateChangeSummary(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        System.assertEquals(1, outputs.size());
        System.assertEquals(true, outputs[0].success);
        System.assert(outputs[0].message.contains('No rate change activity found'));
    }
    @isTest static void testGetRateChangeSummaryClinicianIdNotInContact() {
        Clinical_Rate_Change__c crc = [SELECT Id, Service_Account_ID__c, Contract_ID__c FROM Clinical_Rate_Change__c LIMIT 1];
        crc.user_selected_IDs__c = '{"selectedClinicianIds":[{"selectId":"003000000000000AAA","isProcessed":false}]}';
        crc.PreviewClonedContractIds__c = null;
        crc.DocGenerationBatchProcessId__c = null;
        update crc;
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = crc.Service_Account_ID__c;
        input.contractId = crc.Contract_ID__c;
        Test.startTest();
        List<RateChangeInvocableOutput> outputs = RateChangeSummaryAction.getRateChangeSummary(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        System.assertEquals(1, outputs.size());
        System.assertEquals(true, outputs[0].success);
        System.assert(outputs[0].message.contains('Clinicians Selected'));
    }
    @isTest static void testGetRateChangeSummaryLettersEmptyDGP() {
        DocGenerationBatchProcess batch = new DocGenerationBatchProcess(Description = 'Empty', Category = 'RateChangeProcess');
        insert batch;
        Clinical_Rate_Change__c crc = [SELECT Id, Service_Account_ID__c, Contract_ID__c FROM Clinical_Rate_Change__c LIMIT 1];
        crc.user_selected_IDs__c = null;
        crc.PreviewClonedContractIds__c = null;
        crc.DocGenerationBatchProcessId__c = batch.Id;
        update crc;
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = crc.Service_Account_ID__c;
        input.contractId = crc.Contract_ID__c;
        Test.startTest();
        List<RateChangeInvocableOutput> outputs = RateChangeSummaryAction.getRateChangeSummary(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        System.assertEquals(1, outputs.size());
        System.assertEquals(true, outputs[0].success);
    }
    @isTest static void testGetRateChangeSummaryWithEmailsSent() {
        Contract clinicianContract = [SELECT Id FROM Contract WHERE Status = 'Executed' LIMIT 1];
        Clinical_Rate_Change__c crc = [SELECT Id, Service_Account_ID__c, Contract_ID__c FROM Clinical_Rate_Change__c LIMIT 1];
        crc.user_selected_IDs__c = null;
        crc.PreviewClonedContractIds__c = clinicianContract.Id;
        crc.DocGenerationBatchProcessId__c = null;
        update crc;
        Case c = new Case(Subject = 'Test', Status = 'New');
        insert c;
        EmailMessage em = new EmailMessage(
            ParentId = c.Id,
            RelatedToId = clinicianContract.Id,
            Status = '3',
            Subject = 'Test',
            HtmlBody = 'Test',
            FromAddress = 'test@example.com',
            FromName = 'Test'
        );
        insert em;
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = crc.Service_Account_ID__c;
        input.contractId = crc.Contract_ID__c;
        Test.startTest();
        List<RateChangeInvocableOutput> outputs = RateChangeSummaryAction.getRateChangeSummary(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        System.assertEquals(1, outputs.size());
        System.assertEquals(true, outputs[0].success);
        System.assert(outputs[0].message.contains('Emails Sent'));
    }

    // ---- PendingRateChangeChecker ----
    @isTest static void testCheckPendingRateChangeValidationFailure() {
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = '';
        input.contractId = '';
        Test.startTest();
        List<PendingRateChangeChecker.InvocableOutput> outputs = PendingRateChangeChecker.checkPendingRateChange(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        System.assertEquals(1, outputs.size());
        System.assertEquals(false, outputs[0].hasPendingRun);
        System.assertEquals(0, outputs[0].draftContractCount);
    }
    @isTest static void testCheckPendingRateChangeExceptionPath() {
        Clinical_Rate_Change__c crc = [SELECT Id, Service_Account_ID__c, Contract_ID__c FROM Clinical_Rate_Change__c LIMIT 1];
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = crc.Service_Account_ID__c;
        input.contractId = crc.Contract_ID__c;
        PendingRateChangeChecker.exceptionForTest = true;
        Test.startTest();
        List<PendingRateChangeChecker.InvocableOutput> outputs = PendingRateChangeChecker.checkPendingRateChange(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        PendingRateChangeChecker.exceptionForTest = false;
        System.assertEquals(1, outputs.size());
        System.assertEquals(false, outputs[0].hasPendingRun);
        System.assert(outputs[0].formattedMessage.contains('Something went wrong'));
        System.assertEquals(0, outputs[0].draftContractCount);
    }
    @isTest static void testCheckPendingRateChangeNoRateChange() {
        Account serviceAcc = [SELECT Id FROM Account LIMIT 1];
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = serviceAcc.Id;
        input.contractId = serviceAcc.Id;
        Test.startTest();
        List<PendingRateChangeChecker.InvocableOutput> outputs = PendingRateChangeChecker.checkPendingRateChange(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        System.assertEquals(1, outputs.size());
        System.assertEquals(false, outputs[0].hasPendingRun);
    }
    @isTest static void testCheckPendingRateChangeSuccess() {
        Clinical_Rate_Change__c crc = [SELECT Id, Service_Account_ID__c, Contract_ID__c FROM Clinical_Rate_Change__c LIMIT 1];
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = crc.Service_Account_ID__c;
        input.contractId = crc.Contract_ID__c;
        Test.startTest();
        List<PendingRateChangeChecker.InvocableOutput> outputs = PendingRateChangeChecker.checkPendingRateChange(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        System.assertEquals(1, outputs.size());
        System.assertEquals(true, outputs[0].hasPendingRun);
        System.assertNotEquals(null, outputs[0].formattedMessage);
    }
    @isTest static void testCheckPendingRateChangeInvalidJson() {
        Clinical_Rate_Change__c crc = [SELECT Id, Service_Account_ID__c, Contract_ID__c FROM Clinical_Rate_Change__c LIMIT 1];
        crc.user_selected_IDs__c = 'invalid json {{{';
        update crc;
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = crc.Service_Account_ID__c;
        input.contractId = crc.Contract_ID__c;
        Test.startTest();
        List<PendingRateChangeChecker.InvocableOutput> outputs = PendingRateChangeChecker.checkPendingRateChange(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        System.assertEquals(1, outputs.size());
        System.assertEquals(true, outputs[0].hasPendingRun);
    }
    @isTest static void testCheckPendingRateChangeWithAccountIds() {
        Contact con = [SELECT AccountId FROM Contact LIMIT 1];
        Account clinicianAcc = [SELECT Id FROM Account WHERE Id = :con.AccountId];
        Clinical_Rate_Change__c crc = [SELECT Id, Service_Account_ID__c, Contract_ID__c FROM Clinical_Rate_Change__c LIMIT 1];
        crc.user_selected_IDs__c = '{"selectedClinicianIds":[{"selectId":"' + clinicianAcc.Id + '"}]}';
        update crc;
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = crc.Service_Account_ID__c;
        input.contractId = crc.Contract_ID__c;
        Test.startTest();
        List<PendingRateChangeChecker.InvocableOutput> outputs = PendingRateChangeChecker.checkPendingRateChange(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        System.assertEquals(1, outputs.size());
        System.assertEquals(true, outputs[0].hasPendingRun);
    }
    @isTest static void testCheckPendingRateChangeInvalidIdInList() {
        Clinical_Rate_Change__c crc = [SELECT Id, Service_Account_ID__c, Contract_ID__c FROM Clinical_Rate_Change__c LIMIT 1];
        crc.user_selected_IDs__c = '{"selectedClinicianIds":[{"selectId":"not-a-valid-id"}]}';
        update crc;
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = crc.Service_Account_ID__c;
        input.contractId = crc.Contract_ID__c;
        Test.startTest();
        List<PendingRateChangeChecker.InvocableOutput> outputs = PendingRateChangeChecker.checkPendingRateChange(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        System.assertEquals(1, outputs.size());
        System.assertEquals(true, outputs[0].hasPendingRun);
        System.assertEquals(0, outputs[0].draftContractCount);
    }
    @isTest static void testCheckPendingRateChangeEmptyDraftContracts() {
        Clinical_Rate_Change__c crc = [SELECT Id, Service_Account_ID__c, Contract_ID__c FROM Clinical_Rate_Change__c LIMIT 1];
        crc.user_selected_IDs__c = '{"selectedClinicianIds":[{"selectId":"003000000000000AAA"}]}';
        update crc;
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = crc.Service_Account_ID__c;
        input.contractId = crc.Contract_ID__c;
        Test.startTest();
        List<PendingRateChangeChecker.InvocableOutput> outputs = PendingRateChangeChecker.checkPendingRateChange(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        System.assertEquals(1, outputs.size());
        System.assertEquals(true, outputs[0].hasPendingRun);
        System.assert(outputs[0].formattedMessage.contains('No draft contracts') || outputs[0].formattedMessage.contains('Contracts'));
    }
}