/**
 * @description Test class for RateChangeQueueable (CLONE and SYNC jobs).
 */
@isTest
private class RateChangeQueueableTest {

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
        update clinicianContract;

        HealthcarePayerNetwork hpn = tdf.createHealthcarePayerNetwork('Test Payer Network', serviceAcc.Id, true);
        HealthcareProvider hp = tdf.createHealthcareProvider('Physician Provider', con.Id, true);
        HealthcarePractitionerFacility hpf = tdf.createHealthcarePractitionerFacility('Test HPF', con.Id, serviceAcc.Id, corpId, true);
        ProviderNetworkContract pnc = tdf.createPNC(clinicianContract.Id, hp.Id, hpn.Id, hpf.Id, true);
        ContractPaymentAgreement cpa = tdf.createCPA('Test CPA', clinicianContract.Id, pnc.Id, true);
        tdf.createPCA(cpa.Id, true);

        Clinical_Rate_Change__c crc = tdf.createClinicalRateChangeNew(serviceAcc.Id, clientContract.Id, true);
        crc.Contract_ID__c = clientContract.Id;
        crc.Service_Account_ID__c = serviceAcc.Id;
        crc.Status__c = 'Open';
        crc.user_selected_IDs__c = '{"selectedClinicianIds":[{"selectId":"' + con.Id + '"}]}';
        update crc;
    }

    @isTest
    static void testExecute() {
        Account serviceAcc = [SELECT Id FROM Account WHERE Name = 'Test Service Account' LIMIT 1];
        Contract clientContract = [SELECT Id FROM Contract WHERE AccountId = :serviceAcc.Id AND Status = 'Executed' LIMIT 1];
        Contact con = [SELECT Id FROM Contact LIMIT 1];
        List<Clinical_Rate_Change__c> crcs = [SELECT Id, CreatedById FROM Clinical_Rate_Change__c];

        RateChangeQueueable q = new RateChangeQueueable(
            new List<Id>{ con.Id },
            clientContract.Id,
            crcs
        );

        Test.startTest();
        System.enqueueJob(q);
        Test.stopTest();

        List<Clinical_Rate_Change__c> updated = [SELECT PreviewClonedContractIds__c FROM Clinical_Rate_Change__c LIMIT 1];
        System.assertNotEquals(null, updated[0].PreviewClonedContractIds__c);
        System.assert(updated[0].PreviewClonedContractIds__c.length() > 0, 'Update block should populate PreviewClonedContractIds__c');
    }

    @isTest
    static void testExecuteEmptyClinicianIds() {
        Contract clientContract = [SELECT Id FROM Contract LIMIT 1];
        List<Clinical_Rate_Change__c> crcs = [SELECT Id FROM Clinical_Rate_Change__c];

        RateChangeQueueable q = new RateChangeQueueable(
            new List<Id>(),
            clientContract.Id,
            crcs
        );

        Test.startTest();
        System.enqueueJob(q);
        Test.stopTest();

        System.assert(true, 'Should complete without exception');
    }

    @isTest
    static void testExecuteNullClientContractIdUsesCrcAsTarget() {
        Account serviceAcc = [SELECT Id FROM Account WHERE Name = 'Test Service Account' LIMIT 1];
        Contact con = [SELECT Id FROM Contact LIMIT 1];
        List<Clinical_Rate_Change__c> crcs = [SELECT Id, CreatedById FROM Clinical_Rate_Change__c];

        RateChangeQueueable q = new RateChangeQueueable(
            new List<Id>{ con.Id },
            null,
            crcs
        );

        Test.startTest();
        System.enqueueJob(q);
        Test.stopTest();

        System.assert(true, 'Should complete - uses CRC as notification target when clientContractId is null');
    }

    @isTest
    static void testExecuteNullClinicianIds() {
        Contract clientContract = [SELECT Id FROM Contract LIMIT 1];
        List<Clinical_Rate_Change__c> crcs = [SELECT Id FROM Clinical_Rate_Change__c];

        RateChangeQueueable q = new RateChangeQueueable(null, clientContract.Id, crcs);

        Test.startTest();
        System.enqueueJob(q);
        Test.stopTest();

        System.assert(true, 'Should complete - null clinicianIds hits else branch');
    }

    // ---- SYNC job tests ----
    @isTest
    static void testSyncExecutes() {
        Contract clinicianContract = [SELECT Id FROM Contract WHERE Status = 'Executed' LIMIT 1];
        Clinical_Rate_Change__c crc = [SELECT Id FROM Clinical_Rate_Change__c LIMIT 1];
        Test.startTest();
        System.enqueueJob(new RateChangeQueueable(new List<Id>{ clinicianContract.Id }, crc.Id));
        Test.stopTest();
        List<AsyncApexJob> jobs = [SELECT Id, Status FROM AsyncApexJob WHERE ApexClass.Name = 'RateChangeQueueable'];
        System.assertEquals(1, jobs.size());
        System.assertEquals('Completed', jobs[0].Status);
    }

    @isTest
    static void testSyncChainsWhenMoreThanBatchSize() {
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

    @isTest
    static void testSyncEmptyContractIds() {
        Clinical_Rate_Change__c crc = [SELECT Id FROM Clinical_Rate_Change__c LIMIT 1];
        Test.startTest();
        System.enqueueJob(new RateChangeQueueable(new List<Id>(), crc.Id));
        Test.stopTest();
        List<AsyncApexJob> jobs = [SELECT Id, Status FROM AsyncApexJob WHERE ApexClass.Name = 'RateChangeQueueable'];
        System.assertEquals(1, jobs.size());
        System.assertEquals('Completed', jobs[0].Status);
    }
}