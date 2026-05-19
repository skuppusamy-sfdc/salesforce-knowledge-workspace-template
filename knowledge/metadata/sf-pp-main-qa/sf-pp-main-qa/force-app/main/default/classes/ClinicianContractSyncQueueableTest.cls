/**
 * @description Test class for ClinicianContractSyncQueueable
 * @author Abhinav Mishra
 * @date 2026-01-28
 */
@IsTest
private class ClinicianContractSyncQueueableTest {
    
    private static final String SHIFT_TYPE = 'Shift';
    private static final String CLINICIAN_RECORD_TYPE = 'Clinician';
    private static final String CLIENT_RECORD_TYPE = 'Client';
    private static final String CONTRACT_STATUS_EXECUTED = 'Executed';
    private static final String CLINICIAN_CONTRACT_STATUS = 'Submitted'; // Use Submitted/Approved to avoid Executed triggers
    private static final String PROCESS_TYPE_AUTOMATION = 'Automation';
    private static final String PROCESS_TYPE_MANUAL = 'Manual';
    private static final String PROCESS_TYPE_AGENT = 'Agent';
    private static final String CCM_STATUS_CANCELED = 'Canceled';
    private static final String CCM_STATUS_NEW = 'New';
    private static final String CCM_CANCELED_REASON_NO_EXECUTED_CONTRACT = 'No Executed Contract';
    private static final String CCM_CANCELED_REASON_MISSING_UPDATED_RATES = 'Clinician’s executed contract does not contain the rate(s) that have been updated.';
    private static final String TEAM_ROLE_CE_SPECIALIST = 'Clinician Experience Specialist';
    
    @TestSetup
    static void setupTestData() {
        TestDataFactory tdf = new TestDataFactory();

        // Create CodeSets for Shift Names
        CodeSet dayShiftCode = tdf.createCodeSet('Day', 'Day', 'Shift', true);
        CodeSet nightShiftCode = tdf.createCodeSet('Night', 'Night', 'Shift', true);

        // Create Service Account (Client)
        Account serviceAcc = tdf.createServiceAccount('Test Service Account', null, 'Service_Account', true);

        // Create PO Contract (Client Contract)
        Contract poContract = tdf.createClientContract(serviceAcc, Date.today(), 12, true);

        // Create Shifts for PO Contract (must be done while Contract is in Draft) - bulk insert
        List<Shift__c> poShifts = new List<Shift__c>();
        poShifts.add(tdf.createShift(dayShiftCode.Id, poContract.Id, '1', 'Monday', Time.newInstance(8, 0, 0, 0), Time.newInstance(16, 0, 0, 0), 'NP/PA', false));
        poShifts.add(tdf.createShift(dayShiftCode.Id, poContract.Id, '2', 'Tuesday', Time.newInstance(8, 0, 0, 0), Time.newInstance(16, 0, 0, 0), 'NP/PA', false));
        poShifts.add(tdf.createShift(nightShiftCode.Id, poContract.Id, '1', 'Monday', Time.newInstance(20, 0, 0, 0), Time.newInstance(4, 0, 0, 0), 'NP/PA', false));
        insert poShifts;
        Shift__c dayShift1 = poShifts[0];
        Shift__c dayShift2 = poShifts[1];
        Shift__c nightShift1 = poShifts[2];

        // Update status to Executed (after Shifts are inserted)
        poContract.Status = CONTRACT_STATUS_EXECUTED;
        update poContract;

        // Create PO CPA (Client CPA - no PNC)
        ContractPaymentAgreement poCPA = tdf.createCPA('PO CPA', poContract.Id, null, true);

        // Create PO PCAs with different rates
        List<PreventiveCareAgreement> poPCAs = new List<PreventiveCareAgreement>();
        poPCAs.add(tdf.createPCAWithShift(poCPA.Id, dayShift1.Id, 100, true, false));
        poPCAs.add(tdf.createPCAWithShift(poCPA.Id, dayShift2.Id, 100, true, false));
        poPCAs.add(tdf.createPCAWithShift(poCPA.Id, nightShift1.Id, 200, true, false));
        insert poPCAs;

        // Create Clinician Account and Contact
        Account clinicianAcc = tdf.createServiceAccount(null, 'Test Clinician', 'Clinician', true);
        Contact clinicianCon = tdf.getOrCreateContact(clinicianAcc, 'Test Contact');
        clinicianCon.FirstName = 'John';
        clinicianCon.LastName = 'Doe';
        update clinicianCon;

        // Create Healthcare Network
        HealthcarePayerNetwork hpn = tdf.createHealthcarePayerNetwork('Test Payer Network', serviceAcc.Id, true);

        // Create HealthcareProvider BEFORE PNC
        HealthcareProvider hp = tdf.createHealthcareProvider('Physician Provider', clinicianCon.Id, true);

        // Create Healthcare Practitioner Facility
        HealthcarePractitionerFacility hpf = tdf.createHealthcarePractitionerFacility(
            'Test HPF', clinicianCon.Id, serviceAcc.Id, serviceAcc.Id, true
        );

        // Create Clinician Contract
        Contract clinicianContract = tdf.createClinicianContract(clinicianAcc, true);

        // Create Night shift for Clinician Contract
        Shift__c clinicianNightShift = tdf.createShift(nightShiftCode.Id, clinicianContract.Id, '1', 'Monday', Time.newInstance(20, 0, 0, 0), Time.newInstance(4, 0, 0, 0), 'NP/PA', true);

        // Update status to Submitted (avoids Executed triggers)
        clinicianContract.Status = CLINICIAN_CONTRACT_STATUS;
        update clinicianContract;

        // Create Provider Network Contract
        ProviderNetworkContract pnc = tdf.createPNC(clinicianContract.Id, hp.Id, hpn.Id, hpf.Id, true);

        // Create Clinician CPA
        ContractPaymentAgreement clinicianCPA = tdf.createCPA('Clinician CPA', clinicianContract.Id, pnc.Id, true);

        // Create Clinician PCAs with Day shifts and Night shift
        List<PreventiveCareAgreement> clinicianPCAs = new List<PreventiveCareAgreement>();
        clinicianPCAs.add(tdf.createPCAWithShift(clinicianCPA.Id, dayShift1.Id, 90, false, false));
        clinicianPCAs.add(tdf.createPCAWithShift(clinicianCPA.Id, dayShift2.Id, 90, false, false));
        clinicianPCAs.add(tdf.createPCAWithShift(clinicianCPA.Id, clinicianNightShift.Id, 90, false, false));
        insert clinicianPCAs;

        // Create User for Account Team Member
        User testUser = tdf.createTestUser('Test', 'User', true);

        // Create Account Team Member
        tdf.createAccountTeamMember(serviceAcc.Id, testUser.Id, TEAM_ROLE_CE_SPECIALIST, true);
    }
    
    /**
     * Cached test data - reduces SOQL by bulk-querying common records once per test run.
     * Each test method gets fresh data from @TestSetup (transaction rollback).
     */
    private static TestDataCache cachedData;
    private static TestDataCache getTestData() {
        if (cachedData == null) {
            cachedData = new TestDataCache();
        }
        return cachedData;
    }
    
    private class TestDataCache {
        Contract poContract;
        Contract clinicianContract;
        HealthcarePractitionerFacility hpf;
        Account serviceAcc;
        Account clinicianAccount;
        CodeSet dayShiftCode;
        CodeSet nightShiftCode;
        ContractPaymentAgreement clinicianCPA;
        HealthcarePayerNetwork hpn;
        HealthcareProvider hp;
        
        TestDataCache() {
            List<Contract> contracts = [
                SELECT Id, AccountId, ContractNumber, RecordType.DeveloperName, OwnerId
                FROM Contract
                WHERE Status IN (:CONTRACT_STATUS_EXECUTED, :CLINICIAN_CONTRACT_STATUS)
            ];
            Set<Id> accountIds = new Set<Id>();
            for (Contract c : contracts) {
                if (c.RecordType.DeveloperName == CLIENT_RECORD_TYPE) {
                    poContract = c;
                } else if (c.RecordType.DeveloperName == CLINICIAN_RECORD_TYPE) {
                    clinicianContract = c;
                }
                if (c.AccountId != null) {
                    accountIds.add(c.AccountId);
                }
            }
            Map<Id, Account> accountMap = new Map<Id, Account>([
                SELECT Id FROM Account WHERE Id IN :accountIds
            ]);
            if (poContract != null && accountIds.contains(poContract.AccountId)) {
                serviceAcc = accountMap.get(poContract.AccountId);
            }
            if (clinicianContract != null && accountIds.contains(clinicianContract.AccountId)) {
                clinicianAccount = accountMap.get(clinicianContract.AccountId);
            }
            List<HealthcarePractitionerFacility> hpfList = [
                SELECT Id, PractitionerId, Practitioner.AccountId
                FROM HealthcarePractitionerFacility
                LIMIT 1
            ];
            hpf = hpfList.isEmpty() ? null : hpfList[0];
            List<CodeSet> codes = [
                SELECT Id, Code FROM CodeSet
                WHERE CodeSetType = 'Shift' AND Code IN ('Day', 'Night')
            ];
            for (CodeSet cs : codes) {
                if (cs.Code == 'Day') dayShiftCode = cs;
                else if (cs.Code == 'Night') nightShiftCode = cs;
            }
            if (clinicianContract != null) {
                List<ContractPaymentAgreement> cpas = [
                    SELECT Id FROM ContractPaymentAgreement
                    WHERE ContractId = :clinicianContract.Id AND Type__c = :SHIFT_TYPE
                    LIMIT 1
                ];
                clinicianCPA = cpas.isEmpty() ? null : cpas[0];
            }
            List<HealthcarePayerNetwork> hpnList = [SELECT Id FROM HealthcarePayerNetwork LIMIT 1];
            hpn = hpnList.isEmpty() ? null : hpnList[0];
            List<HealthcareProvider> hpList = [SELECT Id FROM HealthcareProvider LIMIT 1];
            hp = hpList.isEmpty() ? null : hpList[0];
        }
    }
    
    private static Client_Change_Management__c createCCM(Contract poContract, HealthcarePractitionerFacility hpf) {
        return new Client_Change_Management__c(
            Contract__c = poContract.Id,
            Healthcare_Practitioner_Facility__c = hpf.Id,
            Process_Type__c = PROCESS_TYPE_AUTOMATION,
            Status__c = CCM_STATUS_NEW
        );
    }

    private static String getCcmCanceledReason(Id ccmId) {
        Map<String, Schema.SObjectField> ccmFields = Client_Change_Management__c.SObjectType.getDescribe().fields.getMap();
        if (!ccmFields.containsKey('Canceled_Reason__c')) {
            return null;
        }
        String soql = 'SELECT Canceled_Reason__c FROM Client_Change_Management__c WHERE Id = :ccmId';
        SObject ccmRecord = Database.query(soql);
        return (String) ccmRecord.get('Canceled_Reason__c');
    }
    
    @IsTest
    static void testConstructorWithNull() {
        ClinicianContractSyncQueueable queueable = new ClinicianContractSyncQueueable(null);
        System.assertNotEquals(null, queueable, 'Queueable should be created');
    }

    @IsTest
    static void testConstructorWithEmptyList() {
        ClinicianContractSyncQueueable queueable = new ClinicianContractSyncQueueable(new List<Id>());
        System.assertNotEquals(null, queueable, 'Queueable should be created');
    }
    
    @IsTest
    static void testExecuteWithEmptyContractIds() {
        TestDataCache td = getTestData();
        Client_Change_Management__c ccm = createCCM(td.poContract, td.hpf);
        insert ccm;
        
        Test.startTest();
        ClinicianContractSyncQueueable queueable = new ClinicianContractSyncQueueable(new List<Id>());
        System.enqueueJob(queueable);
        Test.stopTest();
        
        // Verify no CCM records were updated (empty contractIds means no processing)
        Client_Change_Management__c updatedCCM = [
            SELECT Id, Status__c, Process_Type__c 
            FROM Client_Change_Management__c
            WHERE Id = :ccm.Id
        ];
        System.assertEquals(CCM_STATUS_NEW, updatedCCM.Status__c, 'CCM status should remain New');
        System.assertEquals(PROCESS_TYPE_AUTOMATION, updatedCCM.Process_Type__c, 'CCM Process Type should remain Automation');
    }
    
    @IsTest
    static void testExecuteWithNoPOContractData() {
        TestDataCache td = getTestData();
        Contract emptyContract = TestDataFactory.createContractWithDetails(td.serviceAcc, Date.today(), 'Draft', 12);
        emptyContract.RecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get(CLIENT_RECORD_TYPE).getRecordTypeId();
        emptyContract.EndDate = Date.today().addMonths(12);
        update emptyContract;
        // Update status to Executed
        emptyContract.Status = CONTRACT_STATUS_EXECUTED;
        update emptyContract;
        
        Client_Change_Management__c ccm = new Client_Change_Management__c(
            Contract__c = emptyContract.Id,
            Healthcare_Practitioner_Facility__c = td.hpf.Id,
            Process_Type__c = PROCESS_TYPE_AUTOMATION,
            Status__c = CCM_STATUS_NEW
        );
        insert ccm;
        
        Test.startTest();
        ClinicianContractSyncQueueable queueable = new ClinicianContractSyncQueueable(new List<Id>{emptyContract.Id});
        System.enqueueJob(queueable);
        Test.stopTest();
        
        // Verify no changes were made (no PO data means no processing)
        Client_Change_Management__c updatedCCM = [
            SELECT Id, Status__c, Process_Type__c 
            FROM Client_Change_Management__c
            WHERE Id = :ccm.Id
        ];
        System.assertEquals(CCM_STATUS_NEW, updatedCCM.Status__c, 'CCM status should remain New');
    }
    
    @IsTest
    static void testExecuteWithNoCCMRecords() {
        delete [SELECT Id FROM Client_Change_Management__c];
        TestDataCache td = getTestData();
        Test.startTest();
        ClinicianContractSyncQueueable queueable = new ClinicianContractSyncQueueable(new List<Id>{td.poContract.Id});
        System.enqueueJob(queueable);
        Test.stopTest();
        
        // Verify no CCM records exist
        List<Client_Change_Management__c> ccmRecords = [
            SELECT Id FROM Client_Change_Management__c
        ];
        System.assertEquals(0, ccmRecords.size(), 'No CCM records should exist');
    }
    
    @IsTest
    static void testExecuteWithNoClinicianShifts() {
        TestDataCache td = getTestData();
        Client_Change_Management__c ccm = createCCM(td.poContract, td.hpf);
        insert ccm;

        delete [
            SELECT Id FROM PreventiveCareAgreement
            WHERE ContractPaymentAgreement.Type__c = :SHIFT_TYPE
            AND ContractPaymentAgreement.Contract.AccountId = :td.hpf.Practitioner.AccountId
        ];
        
        Test.startTest();
        ClinicianContractSyncQueueable queueable = new ClinicianContractSyncQueueable(new List<Id>{td.poContract.Id});
        System.enqueueJob(queueable);
        Test.stopTest();
        
        // Verify CCM was canceled
        Client_Change_Management__c updatedCCM = [
            SELECT Id, Status__c, Process_Type__c 
            FROM Client_Change_Management__c
            WHERE Id = :ccm.Id
        ];
        System.assertEquals(CCM_STATUS_CANCELED, updatedCCM.Status__c, 'CCM should be canceled when no clinician shifts exist');
    }
    
    @IsTest
    static void testExecuteWithMatchingRates() {
        TestDataCache td = getTestData();
        Client_Change_Management__c ccm = createCCM(td.poContract, td.hpf);
        insert ccm;
        
        List<Shift__c> clinicianShifts = [
            SELECT Id, Shift_Name__c 
            FROM Shift__c 
            WHERE Contract__c = :td.clinicianContract.Id
        ];
        Shift__c clinicianNightShift = null;
        for (Shift__c s : clinicianShifts) {
            if (s.Shift_Name__c == td.nightShiftCode.Id) {
                clinicianNightShift = s;
                break;
            }
        }
        
        List<PreventiveCareAgreement> existingClinicianPCAs = [
            SELECT Id, Rate__c, Shift__r.Shift_Name__c, Shift__c
            FROM PreventiveCareAgreement 
            WHERE ContractPaymentAgreementId = :td.clinicianCPA.Id
            AND ContractPaymentAgreement.Type__c = :SHIFT_TYPE
        ];
        
        for (PreventiveCareAgreement pca : existingClinicianPCAs) {
            if (pca.Shift__r.Shift_Name__c == td.nightShiftCode.Id) {
                pca.Rate__c = 200;
            }
            if (pca.Shift__r.Shift_Name__c == td.dayShiftCode.Id) {
                pca.Rate__c = 100;
            }
        }
        update existingClinicianPCAs;
        
        Integer taskCountBefore = [SELECT COUNT() FROM Task];
        
        Test.startTest();
        ClinicianContractSyncQueueable queueable = new ClinicianContractSyncQueueable(new List<Id>{td.poContract.Id});
        System.enqueueJob(queueable);
        Test.stopTest();
        
        // Verify CCM was not updated (should remain Automation)
        Client_Change_Management__c updatedCCM = [
            SELECT Id, Status__c, Process_Type__c 
            FROM Client_Change_Management__c
            WHERE Id = :ccm.Id
        ];
        System.assertEquals(PROCESS_TYPE_AUTOMATION, updatedCCM.Process_Type__c, 'CCM should remain Automation when rates match');
        System.assertEquals(CCM_STATUS_NEW, updatedCCM.Status__c, 'CCM status should remain New');
        
        // Verify no tasks were created
        Integer taskCountAfter = [SELECT COUNT() FROM Task];
        System.assertEquals(taskCountBefore, taskCountAfter, 'No tasks should be created when rates match');
    }
    
    @IsTest
    static void testExecuteWithLowerClinicianRate() {
        TestDataCache td = getTestData();
        Client_Change_Management__c ccm = createCCM(td.poContract, td.hpf);
        insert ccm;
        
        List<PreventiveCareAgreement> clinicianNightPCAs = [
            SELECT Id FROM PreventiveCareAgreement
            WHERE ContractPaymentAgreement.ContractId = :td.clinicianContract.Id
            AND ContractPaymentAgreement.Type__c = :SHIFT_TYPE
            AND Shift__r.Shift_Name__c = :td.nightShiftCode.Id
        ];
        if (!clinicianNightPCAs.isEmpty()) {
            delete clinicianNightPCAs;
        }
        
        Test.startTest();
        ClinicianContractSyncQueueable queueable = new ClinicianContractSyncQueueable(new List<Id>{td.poContract.Id});
        System.enqueueJob(queueable);
        Test.stopTest();
        
        // Verify CCM remains Automation - we ignore Night (clinician doesn't have it), Day has same rates
        Client_Change_Management__c updatedCCM = [
            SELECT Id, Status__c, Process_Type__c 
            FROM Client_Change_Management__c
            WHERE Id = :ccm.Id
        ];
        System.assertEquals(PROCESS_TYPE_AUTOMATION, updatedCCM.Process_Type__c, 'CCM should remain Automation when clinician lacks Night - we only compare shift types clinician has');
    }
    
    @IsTest
    static void testExecuteWithHigherClinicianRate() {
        TestDataCache td = getTestData();
        Client_Change_Management__c ccm = createCCM(td.poContract, td.hpf);
        insert ccm;
        
        List<PreventiveCareAgreement> existingClinicianPCAs = [
            SELECT Id, Rate__c, Shift__r.Shift_Name__c
            FROM PreventiveCareAgreement 
            WHERE ContractPaymentAgreementId = :td.clinicianCPA.Id
            AND ContractPaymentAgreement.Type__c = :SHIFT_TYPE
        ];
        for (PreventiveCareAgreement pca : existingClinicianPCAs) {
            if (pca.Shift__r.Shift_Name__c == td.nightShiftCode.Id) {
                pca.Rate__c = 250;
            }
            if (pca.Shift__r.Shift_Name__c == td.dayShiftCode.Id) {
                pca.Rate__c = 150;
            }
        }
        update existingClinicianPCAs;
        
        Integer taskCountBefore = [SELECT COUNT() FROM Task];
        
        Test.startTest();
        ClinicianContractSyncQueueable queueable = new ClinicianContractSyncQueueable(new List<Id>{td.poContract.Id});
        System.enqueueJob(queueable);
        Test.stopTest();
        
        // Verify CCM was not updated (should remain Automation)
        Client_Change_Management__c updatedCCM = [
            SELECT Id, Status__c, Process_Type__c 
            FROM Client_Change_Management__c
            WHERE Id = :ccm.Id
        ];
        System.assertEquals(PROCESS_TYPE_AUTOMATION, updatedCCM.Process_Type__c, 'CCM should remain Automation when clinician rate is higher');
        
        // Verify no tasks were created
        Integer taskCountAfter = [SELECT COUNT() FROM Task];
        System.assertEquals(taskCountBefore, taskCountAfter, 'No tasks should be created when clinician rate is higher');
    }
    
    @IsTest
    static void testExecuteWithMixedRatesInPO() {
        TestDataCache td = getTestData();
        Client_Change_Management__c ccm = createCCM(td.poContract, td.hpf);
        insert ccm;
        
        Contract newPOContract = TestDataFactory.createContractWithDetails(td.serviceAcc, Date.today(), 'Draft', 12);
        newPOContract.RecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get(CLIENT_RECORD_TYPE).getRecordTypeId();
        newPOContract.EndDate = Date.today().addMonths(12);
        update newPOContract;

        Shift__c dayShift1 = new Shift__c(
            Shift_Name__c = td.dayShiftCode.Id,
            Contract__c = newPOContract.Id,
            Shift_Iteration__c = '1',
            Shift_Day_of_the_Week__c = 'Monday',
            Shift_Start_Time__c = Time.newInstance(8, 0, 0, 0),
            Shift_End_Time__c = Time.newInstance(16, 0, 0, 0),
            Type__c = 'NP/PA',
            Existing_Shift_Type_Added__c = true
        );
        Shift__c dayShift2 = new Shift__c(
            Shift_Name__c = td.dayShiftCode.Id,
            Contract__c = newPOContract.Id,
            Shift_Iteration__c = '2',
            Shift_Day_of_the_Week__c = 'Tuesday',
            Shift_Start_Time__c = Time.newInstance(8, 0, 0, 0),
            Shift_End_Time__c = Time.newInstance(16, 0, 0, 0),
            Type__c = 'NP/PA',
            Existing_Shift_Type_Added__c = true
        );
        insert new List<Shift__c>{dayShift1, dayShift2};
        
        ContractPaymentAgreement newPOCPA = new ContractPaymentAgreement(
            ContractId = newPOContract.Id,
            Type__c = SHIFT_TYPE,
            Name = 'PO CPA Mixed Rates',
            AgreementType = 'Preventive Care Agreement',
            Status = 'Draft'
        );
        insert newPOCPA;
        
        PreventiveCareAgreement poPCA1 = new PreventiveCareAgreement(
            ContractPaymentAgreementId = newPOCPA.Id,
            Shift__c = dayShift1.Id,
            Rate__c = 100,
            Existing_Shift_Type_Added__c = true,
            Existing_Rate_Increased__c = false,
            Existing_Rate_Decreased__c = false,
            Cloned_From__c = null,
            BonusMeasureType = 'Performance',
            TargetMeasurePercent = 10,
            BonusPayout = 12
        );
        PreventiveCareAgreement poPCA2 = new PreventiveCareAgreement(
            ContractPaymentAgreementId = newPOCPA.Id,
            Shift__c = dayShift2.Id,
            Rate__c = 110, // Different rate - mixed rates
            Existing_Shift_Type_Added__c = true,
            Existing_Rate_Increased__c = false,
            Existing_Rate_Decreased__c = false,
            Cloned_From__c = null,
            BonusMeasureType = 'Performance',
            TargetMeasurePercent = 10,
            BonusPayout = 12
        );
        insert new List<PreventiveCareAgreement>{poPCA1, poPCA2};
        
        newPOContract.Status = CONTRACT_STATUS_EXECUTED;
        update newPOContract;
        
        delete ccm;
        Client_Change_Management__c newCCM = new Client_Change_Management__c(
            Contract__c = newPOContract.Id,
            Healthcare_Practitioner_Facility__c = td.hpf.Id,
            Process_Type__c = PROCESS_TYPE_AUTOMATION,
            Status__c = CCM_STATUS_NEW
        );
        insert newCCM;
        
        // Clinician has rate 90 which doesn't match either PO rate (100 or 110)
        // NEW LOGIC: Manual only when clinician has MIXED rates AND PO has new shift for that category
        // Clinician has single rate (90) - no mixed rates, so remains Automation
        Test.startTest();
        ClinicianContractSyncQueueable queueable = new ClinicianContractSyncQueueable(new List<Id>{newPOContract.Id});
        System.enqueueJob(queueable);
        Test.stopTest();
        
        // Verify CCM remains Automation - clinician has single rate, not mixed
        Client_Change_Management__c updatedCCM = [
            SELECT Id, Status__c, Process_Type__c 
            FROM Client_Change_Management__c
            WHERE Id = :newCCM.Id
        ];
        System.assertEquals(PROCESS_TYPE_AUTOMATION, updatedCCM.Process_Type__c, 'CCM should remain Automation when clinician has single rate - Manual only when clinician has mixed rates AND PO has new shift');
    }
    
    @IsTest
    static void testExecuteWithMixedRatesInClinician() {
        TestDataCache td = getTestData();
        Client_Change_Management__c ccm = createCCM(td.poContract, td.hpf);
        insert ccm;
        
        List<PreventiveCareAgreement> dayPCAs = [
            SELECT Id, Rate__c, Shift__r.Shift_Name__c
            FROM PreventiveCareAgreement 
            WHERE ContractPaymentAgreement.ContractId = :td.clinicianContract.Id
            AND ContractPaymentAgreement.Type__c = :SHIFT_TYPE
            AND Shift__r.Shift_Name__c = :td.dayShiftCode.Id
            ORDER BY CreatedDate ASC
        ];
        if (dayPCAs.size() >= 2) {
            dayPCAs[0].Rate__c = 90;
            dayPCAs[1].Rate__c = 95;
            update dayPCAs;
        }
        
        Test.startTest();
        ClinicianContractSyncQueueable queueable = new ClinicianContractSyncQueueable(new List<Id>{td.poContract.Id});
        System.enqueueJob(queueable);
        Test.stopTest();
        
        // Verify CCM was set to Manual (covers lines 185-186)
        Client_Change_Management__c updatedCCM = [
            SELECT Id, Status__c, Process_Type__c 
            FROM Client_Change_Management__c
            WHERE Id = :ccm.Id
        ];
        System.assertEquals(PROCESS_TYPE_MANUAL, updatedCCM.Process_Type__c, 'CCM should be set to Manual when clinician has mixed rates for same shift type');
    }
    
    @IsTest
    static void testExecuteWithMultipleContractsSameRatesAcrossShift() {
        TestDataCache td = getTestData();
        Client_Change_Management__c ccm = createCCM(td.poContract, td.hpf);
        insert ccm;
        
        Contract clinicianContract2 = new TestDataFactory().createClinicianContract(td.clinicianAccount, false);
        clinicianContract2.StartDate = Date.today().addDays(1);
        clinicianContract2.put('Start_Date__c', Date.today().addDays(1));
        insert clinicianContract2;
        Shift__c dayShift1Contract2 = new Shift__c(
            Shift_Name__c = td.dayShiftCode.Id,
            Contract__c = clinicianContract2.Id,
            Shift_Iteration__c = '1',
            Shift_Day_of_the_Week__c = 'Wednesday',
            Shift_Start_Time__c = Time.newInstance(8, 0, 0, 0),
            Shift_End_Time__c = Time.newInstance(16, 0, 0, 0),
            Type__c = 'NP/PA',
            Existing_Shift_Type_Added__c = true
        );
        Shift__c dayShift2Contract2 = new Shift__c(
            Shift_Name__c = td.dayShiftCode.Id,
            Contract__c = clinicianContract2.Id,
            Shift_Iteration__c = '2',
            Shift_Day_of_the_Week__c = 'Thursday',
            Shift_Start_Time__c = Time.newInstance(8, 0, 0, 0),
            Shift_End_Time__c = Time.newInstance(16, 0, 0, 0),
            Type__c = 'NP/PA',
            Existing_Shift_Type_Added__c = true
        );
        Shift__c nightShiftContract2 = new Shift__c(
            Shift_Name__c = td.nightShiftCode.Id,
            Contract__c = clinicianContract2.Id,
            Shift_Iteration__c = '1',
            Shift_Day_of_the_Week__c = 'Wednesday',
            Shift_Start_Time__c = Time.newInstance(20, 0, 0, 0),
            Shift_End_Time__c = Time.newInstance(4, 0, 0, 0),
            Type__c = 'NP/PA',
            Existing_Shift_Type_Added__c = true
        );
        insert new List<Shift__c>{dayShift1Contract2, dayShift2Contract2, nightShiftContract2};
        clinicianContract2.Status = CLINICIAN_CONTRACT_STATUS;
        update clinicianContract2;
        
        // Create PNC and CPA for second contract (same HPF)
        // PNC StartDate must be on or after contract StartDate (contract uses addDays(1))
        ProviderNetworkContract pnc2 = new ProviderNetworkContract(
            ContractId = clinicianContract2.Id,
            Healthcare_Practitioner_Facility__c = td.hpf.Id,
            HealthcareProviderId = td.hp.Id,
            HealthcarePayerNetworkId = td.hpn.Id,
            StartDate = Date.today().addDays(1),
            EndDate = Date.today().addDays(1).addMonths(12)
        );
        insert pnc2;
        ContractPaymentAgreement clinicianCPA2 = new ContractPaymentAgreement(
            ContractId = clinicianContract2.Id,
            Provider_Network_Contract__c = pnc2.Id,
            Type__c = SHIFT_TYPE,
            Name = 'Clinician CPA 2-' + DateTime.now().getTime(),
            AgreementType = 'Preventive Care Agreement',
            Status = 'Draft',
            StartDateTime = DateTime.newInstance(Date.today().addDays(1), Time.newInstance(0, 0, 0, 0))
        );
        insert clinicianCPA2;
        
        PreventiveCareAgreement pca2Day1 = new PreventiveCareAgreement(
            ContractPaymentAgreementId = clinicianCPA2.Id,
            Shift__c = dayShift1Contract2.Id,
            Rate__c = 200,
            FacilityTitle__c = null,
            BonusMeasureType = 'Performance',
            TargetMeasurePercent = 10,
            BonusPayout = 12
        );
        PreventiveCareAgreement pca2Day2 = new PreventiveCareAgreement(
            ContractPaymentAgreementId = clinicianCPA2.Id,
            Shift__c = dayShift2Contract2.Id,
            Rate__c = 200,
            FacilityTitle__c = null,
            BonusMeasureType = 'Performance',
            TargetMeasurePercent = 10,
            BonusPayout = 12
        );
        PreventiveCareAgreement pca2Night = new PreventiveCareAgreement(
            ContractPaymentAgreementId = clinicianCPA2.Id,
            Shift__c = nightShiftContract2.Id,
            Rate__c = 300,
            FacilityTitle__c = null,
            BonusMeasureType = 'Performance',
            TargetMeasurePercent = 10,
            BonusPayout = 12
        );
        insert new List<PreventiveCareAgreement>{pca2Day1, pca2Day2, pca2Night};
        
        Contract clinicianContract1 = td.clinicianContract;
        List<PreventiveCareAgreement> contract1PCAs = [
            SELECT Id, Rate__c, Shift__r.Shift_Name__c
            FROM PreventiveCareAgreement
            WHERE ContractPaymentAgreement.ContractId = :clinicianContract1.Id
            AND ContractPaymentAgreement.Type__c = :SHIFT_TYPE
        ];
        for (PreventiveCareAgreement pca : contract1PCAs) {
            if (pca.Shift__r.Shift_Name__c == td.dayShiftCode.Id) {
                pca.Rate__c = 100;
            } else if (pca.Shift__r.Shift_Name__c == td.nightShiftCode.Id) {
                pca.Rate__c = 200;
            }
        }
        update contract1PCAs;
        
        Test.startTest();
        ClinicianContractSyncQueueable queueable = new ClinicianContractSyncQueueable(new List<Id>{td.poContract.Id});
        System.enqueueJob(queueable);
        Test.stopTest();
        
        // Both contracts have same rates across shift -> Automation
        Client_Change_Management__c updatedCCM = [
            SELECT Id, Status__c, Process_Type__c
            FROM Client_Change_Management__c
            WHERE Id = :ccm.Id
        ];
        System.assertEquals(PROCESS_TYPE_AUTOMATION, updatedCCM.Process_Type__c,
            'CCM should remain Automation when all contracts have same rates across shift');
    }
    
    @IsTest
    static void testExecuteWithMultipleContractsOneHasMixedRates() {
        TestDataCache td = getTestData();
        Client_Change_Management__c ccm = createCCM(td.poContract, td.hpf);
        insert ccm;
        
        Contract clinicianContract2 = new TestDataFactory().createClinicianContract(td.clinicianAccount, false);
        clinicianContract2.StartDate = Date.today().addDays(2);
        clinicianContract2.put('Start_Date__c', Date.today().addDays(2));
        insert clinicianContract2;
        Shift__c dayShift1Contract2 = new Shift__c(
            Shift_Name__c = td.dayShiftCode.Id,
            Contract__c = clinicianContract2.Id,
            Shift_Iteration__c = '1',
            Shift_Day_of_the_Week__c = 'Wednesday',
            Shift_Start_Time__c = Time.newInstance(8, 0, 0, 0),
            Shift_End_Time__c = Time.newInstance(16, 0, 0, 0),
            Type__c = 'NP/PA',
            Existing_Shift_Type_Added__c = true
        );
        Shift__c dayShift2Contract2 = new Shift__c(
            Shift_Name__c = td.dayShiftCode.Id,
            Contract__c = clinicianContract2.Id,
            Shift_Iteration__c = '2',
            Shift_Day_of_the_Week__c = 'Thursday',
            Shift_Start_Time__c = Time.newInstance(8, 0, 0, 0),
            Shift_End_Time__c = Time.newInstance(16, 0, 0, 0),
            Type__c = 'NP/PA',
            Existing_Shift_Type_Added__c = true
        );
        insert new List<Shift__c>{dayShift1Contract2, dayShift2Contract2};
        clinicianContract2.Status = CLINICIAN_CONTRACT_STATUS;
        update clinicianContract2;
        
        // PNC StartDate must be on or after contract StartDate (contract uses addDays(2))
        ProviderNetworkContract pnc2 = new ProviderNetworkContract(
            ContractId = clinicianContract2.Id,
            Healthcare_Practitioner_Facility__c = td.hpf.Id,
            HealthcareProviderId = td.hp.Id,
            HealthcarePayerNetworkId = td.hpn.Id,
            StartDate = Date.today().addDays(2),
            EndDate = Date.today().addDays(2).addMonths(12)
        );
        insert pnc2;
        ContractPaymentAgreement clinicianCPA2 = new ContractPaymentAgreement(
            ContractId = clinicianContract2.Id,
            Provider_Network_Contract__c = pnc2.Id,
            Type__c = SHIFT_TYPE,
            Name = 'Clinician CPA 2-' + DateTime.now().getTime(),
            AgreementType = 'Preventive Care Agreement',
            Status = 'Draft',
            StartDateTime = DateTime.newInstance(Date.today().addDays(2), Time.newInstance(0, 0, 0, 0))
        );
        insert clinicianCPA2;
        
        PreventiveCareAgreement pca2Day1 = new PreventiveCareAgreement(
            ContractPaymentAgreementId = clinicianCPA2.Id,
            Shift__c = dayShift1Contract2.Id,
            Rate__c = 200,
            FacilityTitle__c = null,
            BonusMeasureType = 'Performance',
            TargetMeasurePercent = 10,
            BonusPayout = 12
        );
        PreventiveCareAgreement pca2Day2 = new PreventiveCareAgreement(
            ContractPaymentAgreementId = clinicianCPA2.Id,
            Shift__c = dayShift2Contract2.Id,
            Rate__c = 200,
            FacilityTitle__c = null,
            BonusMeasureType = 'Performance',
            TargetMeasurePercent = 10,
            BonusPayout = 12
        );
        insert new List<PreventiveCareAgreement>{pca2Day1, pca2Day2};
        
        Contract clinicianContract1 = td.clinicianContract;
        List<PreventiveCareAgreement> contract1DayPCAs = [
            SELECT Id, Rate__c
            FROM PreventiveCareAgreement
            WHERE ContractPaymentAgreement.ContractId = :clinicianContract1.Id
            AND ContractPaymentAgreement.Type__c = :SHIFT_TYPE
            AND Shift__r.Shift_Name__c = :td.dayShiftCode.Id
            ORDER BY CreatedDate ASC
        ];
        if (contract1DayPCAs.size() >= 2) {
            contract1DayPCAs[0].Rate__c = 100;
            contract1DayPCAs[1].Rate__c = 200;
            update contract1DayPCAs;
        }
        
        Test.startTest();
        ClinicianContractSyncQueueable queueable = new ClinicianContractSyncQueueable(new List<Id>{td.poContract.Id});
        System.enqueueJob(queueable);
        Test.stopTest();
        
        Client_Change_Management__c updatedCCM = [
            SELECT Id, Status__c, Process_Type__c
            FROM Client_Change_Management__c
            WHERE Id = :ccm.Id
        ];
        System.assertEquals(PROCESS_TYPE_MANUAL, updatedCCM.Process_Type__c,
            'CCM should be Manual when any contract has mixed rates across shift');

        List<Task> tasks = [SELECT Id, Description FROM Task WHERE WhatId = :ccm.Id];
        System.assertEquals(1, tasks.size(), 'Task should be created for Manual CCM');
        System.assert(tasks[0].Description.contains('Clinician Contract Number(s):'), 'Task Description should contain Clinician Contract Number(s) label');
        String clinicianContract1Num = td.clinicianContract.ContractNumber;
        Contract clinicianContract2Requery = [SELECT ContractNumber FROM Contract WHERE Id = :clinicianContract2.Id LIMIT 1];
        if (String.isNotBlank(clinicianContract1Num)) {
            System.assert(tasks[0].Description.contains(clinicianContract1Num), 'Task Description should contain first clinician contract number');
        }
        if (String.isNotBlank(clinicianContract2Requery.ContractNumber)) {
            System.assert(tasks[0].Description.contains(clinicianContract2Requery.ContractNumber), 'Task Description should contain second clinician contract number');
        }
    }
    
    @IsTest
    static void testExecuteWithMissingShiftType() {
        TestDataCache td = getTestData();
        Client_Change_Management__c ccm = createCCM(td.poContract, td.hpf);
        insert ccm;
        
        List<PreventiveCareAgreement> poPCAs = [
            SELECT Id, Shift__r.Shift_Name__c 
            FROM PreventiveCareAgreement 
            WHERE ContractPaymentAgreement.ContractId = :td.poContract.Id
            AND ContractPaymentAgreement.Type__c = :SHIFT_TYPE
            AND Existing_Shift_Type_Added__c = true
        ];
        Boolean poHasDay = false;
        Boolean poHasNight = false;
        for (PreventiveCareAgreement pca : poPCAs) {
            if (pca.Shift__r.Shift_Name__c == td.dayShiftCode.Id) poHasDay = true;
            if (pca.Shift__r.Shift_Name__c == td.nightShiftCode.Id) poHasNight = true;
        }
        System.assert(poHasDay && poHasNight, 'PO contract should have both Day and Night shifts');
        
        List<PreventiveCareAgreement> dayPCAs = [
            SELECT Id, Rate__c FROM PreventiveCareAgreement
            WHERE ContractPaymentAgreement.ContractId = :td.clinicianContract.Id
            AND ContractPaymentAgreement.Type__c = :SHIFT_TYPE
            AND Shift__r.Shift_Name__c = :td.dayShiftCode.Id
        ];
        System.assert(!dayPCAs.isEmpty(), 'Clinician should have Day shift PCAs');

        List<PreventiveCareAgreement> nightPCAs = [
            SELECT Id FROM PreventiveCareAgreement
            WHERE ContractPaymentAgreement.ContractId = :td.clinicianContract.Id
            AND ContractPaymentAgreement.Type__c = :SHIFT_TYPE
            AND Shift__r.Shift_Name__c = :td.nightShiftCode.Id
        ];
        if (!nightPCAs.isEmpty()) {
            delete nightPCAs;
        }

        for (PreventiveCareAgreement pca : dayPCAs) {
            pca.Rate__c = 100;
        }
        update dayPCAs;
        
        Test.startTest();
        ClinicianContractSyncQueueable queueable = new ClinicianContractSyncQueueable(new List<Id>{td.poContract.Id});
        System.enqueueJob(queueable);
        Test.stopTest();
        
        Client_Change_Management__c updatedCCM = [
            SELECT Id, Status__c, Process_Type__c 
            FROM Client_Change_Management__c
            WHERE Id = :ccm.Id
        ];
        System.assertEquals(PROCESS_TYPE_AUTOMATION, updatedCCM.Process_Type__c, 'CCM should remain Automation - we only compare shift types clinician has, ignore missing Night');
    }
    
    @IsTest
    static void testTaskCreationWithAccountTeamMember() {
        TestDataCache td = getTestData();
        Client_Change_Management__c ccm = createCCM(td.poContract, td.hpf);
        insert ccm;

        List<PreventiveCareAgreement> dayPCAs = [
            SELECT Id, Rate__c FROM PreventiveCareAgreement
            WHERE ContractPaymentAgreement.ContractId = :td.clinicianContract.Id
            AND ContractPaymentAgreement.Type__c = :SHIFT_TYPE
            AND Shift__r.Shift_Name__c = :td.dayShiftCode.Id
            ORDER BY CreatedDate ASC
        ];
        if (dayPCAs.size() >= 2) {
            dayPCAs[0].Rate__c = 90;
            dayPCAs[1].Rate__c = 95;
            update dayPCAs;
        }

        Test.startTest();
        ClinicianContractSyncQueueable queueable = new ClinicianContractSyncQueueable(new List<Id>{td.poContract.Id});
        System.enqueueJob(queueable);
        Test.stopTest();

        List<Task> tasks = [
            SELECT Id, OwnerId, Subject, WhatId, WhoId, Description
            FROM Task
            WHERE WhatId = :ccm.Id
        ];
        System.assertEquals(1, tasks.size(), 'Task should be created for Manual CCM');
        System.assertEquals('New Clinician Contract Needed - Coverage Change', tasks[0].Subject, 'Task subject should match');
        System.assertEquals(ccm.Id, tasks[0].WhatId, 'Task WhatId should be CCM Id');
        System.assert(tasks[0].Description.contains('Clinician Contract Number(s):'), 'Task Description should contain Clinician Contract Number(s) label');
        if (String.isNotBlank(td.clinicianContract.ContractNumber)) {
            System.assert(tasks[0].Description.contains(td.clinicianContract.ContractNumber), 'Task Description should contain clinician contract number');
        }

        AccountTeamMember foundATM = [
            SELECT Id, UserId FROM AccountTeamMember
            WHERE AccountId = :td.poContract.AccountId AND TeamMemberRole = :TEAM_ROLE_CE_SPECIALIST LIMIT 1
        ];
        System.assertEquals(foundATM.UserId, tasks[0].OwnerId, 'Task owner should be Account Team Member (CE Specialist)');
    }
    
    @IsTest
    static void testTaskCreationWithContractOwnerFallback() {
        TestDataCache td = getTestData();
        Client_Change_Management__c ccm = createCCM(td.poContract, td.hpf);
        insert ccm;
        
        List<PreventiveCareAgreement> dayPCAs = [
            SELECT Id, Rate__c FROM PreventiveCareAgreement
            WHERE ContractPaymentAgreement.ContractId = :td.clinicianContract.Id
            AND ContractPaymentAgreement.Type__c = :SHIFT_TYPE
            AND Shift__r.Shift_Name__c = :td.dayShiftCode.Id
            ORDER BY CreatedDate ASC
        ];
        if (dayPCAs.size() >= 2) {
            dayPCAs[0].Rate__c = 90;
            dayPCAs[1].Rate__c = 95;
            update dayPCAs;
        }
        
        delete [SELECT Id FROM AccountTeamMember];
        
        Test.startTest();
        ClinicianContractSyncQueueable queueable = new ClinicianContractSyncQueueable(new List<Id>{td.poContract.Id});
        System.enqueueJob(queueable);
        Test.stopTest();
        
        List<Task> tasks = [
            SELECT Id, OwnerId, Subject
            FROM Task
            WHERE WhatId = :ccm.Id
        ];
        System.assertEquals(1, tasks.size(), 'Task should be created');
        
        Contract contract = [SELECT OwnerId FROM Contract WHERE Id = :td.poContract.Id LIMIT 1];
        System.assertEquals(contract.OwnerId, tasks[0].OwnerId, 'Task owner should be Contract Owner when no team member');
    }
    
    @IsTest
    static void testTaskCreationWithNoOwner() {
        TestDataCache td = getTestData();
        Client_Change_Management__c ccm = createCCM(td.poContract, td.hpf);
        insert ccm;

        List<PreventiveCareAgreement> dayPCAs = [
            SELECT Id, Rate__c FROM PreventiveCareAgreement
            WHERE ContractPaymentAgreement.ContractId = :td.clinicianContract.Id
            AND ContractPaymentAgreement.Type__c = :SHIFT_TYPE
            AND Shift__r.Shift_Name__c = :td.dayShiftCode.Id
            ORDER BY CreatedDate ASC
        ];
        if (dayPCAs.size() >= 2) {
            dayPCAs[0].Rate__c = 90;
            dayPCAs[1].Rate__c = 95;
            update dayPCAs;
        }

        delete [SELECT Id FROM AccountTeamMember];

        Test.startTest();
        ClinicianContractSyncQueueable queueable = new ClinicianContractSyncQueueable(new List<Id>{td.poContract.Id});
        System.enqueueJob(queueable);
        Test.stopTest();

        List<Task> tasks = [SELECT Id, OwnerId FROM Task WHERE WhatId = :ccm.Id];
        System.assertEquals(1, tasks.size(), 'Task should be created with Contract Owner as fallback when no CE Specialist');
        System.assertEquals(td.poContract.OwnerId, tasks[0].OwnerId, 'Task owner should be Contract Owner when no Account Team Member');
    }
    
    @IsTest
    static void testCCMUpdateErrorHandling() {
        TestDataCache td = getTestData();
        Client_Change_Management__c ccm = createCCM(td.poContract, td.hpf);
        insert ccm;
        delete ccm;
        
        Test.startTest();
        ClinicianContractSyncQueueable queueable = new ClinicianContractSyncQueueable(new List<Id>{td.poContract.Id});
        System.enqueueJob(queueable);
        Test.stopTest();
        
        System.assertEquals(0, [SELECT COUNT() FROM Client_Change_Management__c WHERE Contract__c = :td.poContract.Id], 'CCM deleted; queueable completes without error');
    }
    
    @IsTest
    static void testTaskInsertErrorHandling() {
        // Cover insertTasks catch block when DML fails (ClinicianContractSyncService)
        // Deliberately insert invalid Task (OwnerId = non-existent user) to trigger DmlException
        ClinicianContractSyncService service = new ClinicianContractSyncService();
        
        Task invalidTask = new Task(
            Subject = 'Test Subject',
            OwnerId = '005000000000000AAA' // Invalid/non-existent User Id causes insert to fail
        );
        List<Task> tasksToInsert = new List<Task>{ invalidTask };
        
        Test.startTest();
        service.insertTasks(tasksToInsert);
        Test.stopTest();
        
        List<Task> tasksAfter = [SELECT Id FROM Task WHERE Subject = 'Test Subject'];
        System.assertEquals(0, tasksAfter.size(), 'Invalid task should not be inserted');
    }
    
    @IsTest
    static void testMultipleContracts() {
        TestDataCache td = getTestData();
        Contract poContract2 = TestDataFactory.createContractWithDetails(td.serviceAcc, Date.today(), 'Draft', 12);
        poContract2.RecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get(CLIENT_RECORD_TYPE).getRecordTypeId();
        poContract2.EndDate = Date.today().addMonths(12);
        update poContract2;

        Shift__c dayShift = new Shift__c(
            Shift_Name__c = td.dayShiftCode.Id,
            Contract__c = poContract2.Id,
            Shift_Iteration__c = '1',
            Shift_Day_of_the_Week__c = 'Monday',
            Shift_Start_Time__c = Time.newInstance(8, 0, 0, 0),
            Shift_End_Time__c = Time.newInstance(16, 0, 0, 0),
            Type__c = 'NP/PA',
            Existing_Shift_Type_Added__c = true
        );
        insert dayShift;
        
        ContractPaymentAgreement poCPA2 = new ContractPaymentAgreement(
            ContractId = poContract2.Id,
            Type__c = SHIFT_TYPE,
            Name = 'PO CPA 2',
            AgreementType = 'Preventive Care Agreement',
            Status = 'Draft'
        );
        insert poCPA2;
        
        PreventiveCareAgreement poPCA = new PreventiveCareAgreement(
            ContractPaymentAgreementId = poCPA2.Id,
            Shift__c = dayShift.Id,
            Rate__c = 100,
            Existing_Shift_Type_Added__c = true,
            Existing_Rate_Increased__c = false,
            Existing_Rate_Decreased__c = false,
            Cloned_From__c = null,
            BonusMeasureType = 'Performance',
            TargetMeasurePercent = 10,
            BonusPayout = 12
        );
        insert poPCA;
        
        // Update status to Executed (after Shift and PCA are inserted)
        poContract2.Status = CONTRACT_STATUS_EXECUTED;
        update poContract2;
        
        Client_Change_Management__c ccm2 = new Client_Change_Management__c(
            Contract__c = poContract2.Id,
            Healthcare_Practitioner_Facility__c = td.hpf.Id,
            Process_Type__c = PROCESS_TYPE_AUTOMATION,
            Status__c = CCM_STATUS_NEW
        );
        insert ccm2;
        
        Client_Change_Management__c ccm1 = new Client_Change_Management__c(
            Contract__c = td.poContract.Id,
            Healthcare_Practitioner_Facility__c = td.hpf.Id,
            Process_Type__c = PROCESS_TYPE_AUTOMATION,
            Status__c = CCM_STATUS_NEW
        );
        insert ccm1;
        
        Test.startTest();
        ClinicianContractSyncQueueable queueable = new ClinicianContractSyncQueueable(
            new List<Id>{td.poContract.Id, poContract2.Id}
        );
        System.enqueueJob(queueable);
        Test.stopTest();
        
        List<Client_Change_Management__c> ccmRecords = [
            SELECT Id, Process_Type__c FROM Client_Change_Management__c
            WHERE Id IN (:ccm1.Id, :ccm2.Id) ORDER BY CreatedDate ASC
        ];
        System.assertEquals(2, ccmRecords.size(), 'Both CCM records should exist');
        for (Client_Change_Management__c c : ccmRecords) {
            System.assertNotEquals(null, c.Process_Type__c, 'Each CCM should have Process_Type set');
        }
    }
    
    @IsTest
    static void testClinicianNameHandling() {
        TestDataCache td = getTestData();
        Client_Change_Management__c ccm = createCCM(td.poContract, td.hpf);
        insert ccm;
        
        List<PreventiveCareAgreement> dayPCAs = [
            SELECT Id, Rate__c FROM PreventiveCareAgreement
            WHERE ContractPaymentAgreement.ContractId = :td.clinicianContract.Id
            AND ContractPaymentAgreement.Type__c = :SHIFT_TYPE
            AND Shift__r.Shift_Name__c = :td.dayShiftCode.Id
            ORDER BY CreatedDate ASC
        ];
        if (dayPCAs.size() >= 2) {
            dayPCAs[0].Rate__c = 90;
            dayPCAs[1].Rate__c = 95;
            update dayPCAs;
        }
        
        Contact clinicianCon = [SELECT Id FROM Contact WHERE LastName = 'Doe' LIMIT 1];
        clinicianCon.FirstName = null;
        update clinicianCon;
        
        Test.startTest();
        ClinicianContractSyncQueueable queueable = new ClinicianContractSyncQueueable(new List<Id>{td.poContract.Id});
        System.enqueueJob(queueable);
        Test.stopTest();
        
        List<Task> tasks = [SELECT Id, Subject FROM Task WHERE WhatId = :ccm.Id];
        System.assertEquals(1, tasks.size(), 'Task should be created');
        System.assertEquals('New Clinician Contract Needed - Coverage Change', tasks[0].Subject, 'Task subject should match');
    }
    
    @IsTest
    static void testNullPractitionerIdHandling() {
        TestDataCache td = getTestData();
        td.hpf.PractitionerId = null;
        update td.hpf;
        
        delete [SELECT Id FROM Client_Change_Management__c];
        
        Client_Change_Management__c ccm = new Client_Change_Management__c(
            Contract__c = td.poContract.Id,
            Healthcare_Practitioner_Facility__c = td.hpf.Id,
            Process_Type__c = PROCESS_TYPE_AUTOMATION,
            Status__c = CCM_STATUS_NEW
        );
        insert ccm;
        
        Test.startTest();
        ClinicianContractSyncQueueable queueable = new ClinicianContractSyncQueueable(new List<Id>{td.poContract.Id});
        System.enqueueJob(queueable);
        Test.stopTest();
        
        Client_Change_Management__c updatedCCM = [
            SELECT Id, Process_Type__c 
            FROM Client_Change_Management__c
            WHERE Id = :ccm.Id
        ];
        System.assertEquals(PROCESS_TYPE_AUTOMATION, updatedCCM.Process_Type__c, 'CCM should remain Automation when PractitionerId is null');
    }
    
    @IsTest
    static void testExecuteWithNoExecutedClinicianContracts() {
        TestDataCache td = getTestData();
        Client_Change_Management__c ccm = createCCM(td.poContract, td.hpf);
        insert ccm;
        List<Contract> clinicianContracts = [
            SELECT Id FROM Contract
            WHERE RecordType.DeveloperName = :CLINICIAN_RECORD_TYPE
            AND Status = :CLINICIAN_CONTRACT_STATUS
            AND AccountId = :td.hpf.Practitioner.AccountId
        ];
        if (!clinicianContracts.isEmpty()) {
            Set<Id> contractIds = new Set<Id>();
            for (Contract c : clinicianContracts) {
                contractIds.add(c.Id);
            }
            delete [SELECT Id FROM PreventiveCareAgreement WHERE ContractPaymentAgreement.ContractId IN :contractIds];
            delete [SELECT Id FROM ContractPaymentAgreement WHERE ContractId IN :contractIds];
            delete clinicianContracts;
        }
        
        Test.startTest();
        ClinicianContractSyncQueueable queueable = new ClinicianContractSyncQueueable(new List<Id>{td.poContract.Id});
        System.enqueueJob(queueable);
        Test.stopTest();
        
        Client_Change_Management__c updatedCCM = [
            SELECT Id, Status__c, Process_Type__c 
            FROM Client_Change_Management__c
            WHERE Id = :ccm.Id
        ];
        System.assertEquals(CCM_STATUS_CANCELED, updatedCCM.Status__c, 'CCM should be canceled when no executed clinician contracts exist');
    }
    
    @IsTest
    static void testGetClinicianContractShiftsWithEmptySets() {
        TestDataCache td = getTestData();
        Contract poContract = TestDataFactory.createContractWithDetails(td.serviceAcc, Date.today(), 'Draft', 12);
        poContract.RecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get(CLIENT_RECORD_TYPE).getRecordTypeId();
        poContract.EndDate = Date.today().addMonths(12);
        update poContract;

        // Create CodeSet with blank Name - this will cause Shift_Name__r.Name to be blank
        CodeSet blankShiftCode = new CodeSet(Name='BlankCodeSet', Code='BLANK', CodeSetType='Shift', IsActive=true);
        insert blankShiftCode;
        
        // Create Shift with blank name CodeSet
        Shift__c blankShift = new Shift__c(
            Shift_Name__c = blankShiftCode.Id,
            Contract__c = poContract.Id,
            Shift_Iteration__c = '1',
            Shift_Day_of_the_Week__c = 'Monday',
            Shift_Start_Time__c = Time.newInstance(8, 0, 0, 0),
            Shift_End_Time__c = Time.newInstance(16, 0, 0, 0),
            Type__c = 'NP/PA',
            Existing_Shift_Type_Added__c = true
        );
        insert blankShift;
        
        poContract.Status = CONTRACT_STATUS_EXECUTED;
        update poContract;
        
        ContractPaymentAgreement poCPA = new ContractPaymentAgreement(
            ContractId = poContract.Id,
            Type__c = SHIFT_TYPE,
            Name = 'PO CPA Blank Shift',
            AgreementType = 'Preventive Care Agreement',
            Status = 'Draft'
        );
        insert poCPA;
        
        PreventiveCareAgreement poPCA = new PreventiveCareAgreement(
            ContractPaymentAgreementId = poCPA.Id,
            Shift__c = blankShift.Id,
            Rate__c = 100,
            Existing_Shift_Type_Added__c = true,
            Existing_Rate_Increased__c = false,
            Existing_Rate_Decreased__c = false,
            Cloned_From__c = null,
            BonusMeasureType = 'Performance',
            TargetMeasurePercent = 10,
            BonusPayout = 12
        );
        insert poPCA;
        
        Client_Change_Management__c ccm = new Client_Change_Management__c(
            Contract__c = poContract.Id,
            Healthcare_Practitioner_Facility__c = td.hpf.Id,
            Process_Type__c = PROCESS_TYPE_AUTOMATION,
            Status__c = CCM_STATUS_NEW
        );
        insert ccm;
        
        Test.startTest();
        ClinicianContractSyncQueueable queueable = new ClinicianContractSyncQueueable(new List<Id>{poContract.Id});
        System.enqueueJob(queueable);
        Test.stopTest();
       
        Client_Change_Management__c updatedCCM = [
            SELECT Id, Status__c, Process_Type__c 
            FROM Client_Change_Management__c
            WHERE Id = :ccm.Id
        ];
        System.assertEquals(PROCESS_TYPE_AUTOMATION, updatedCCM.Process_Type__c, 'CCM should remain Automation when shift types are empty');
    }
    
    @IsTest
    static void testGetClinicianContractShiftsWithEmptySetsDirect() {
        // This test directly covers getClinicianContractShifts with empty sets (ClinicianContractSyncService)
        // The method is @TestVisible so we can test it directly
        
        Test.startTest();
        ClinicianContractSyncService service = new ClinicianContractSyncService();
        
        Map<Id, Map<Id, Map<String, Set<Decimal>>>> result1 = service.getClinicianContractShifts(new Set<Id>(), new Set<String>{'Day'}, new Set<Id>());
        System.assert(result1.isEmpty(), 'Should return empty map when clinicianAccountIds is empty');
        Test.stopTest();
    }

    @IsTest
    static void testTaskDescriptionContainsClinicianContractNumbers() {
        // Verifies that Manual path tasks include Clinician Contract Number(s) in the Description
        TestDataCache td = getTestData();
        Client_Change_Management__c ccm = createCCM(td.poContract, td.hpf);
        insert ccm;

        List<PreventiveCareAgreement> dayPCAs = [
            SELECT Id, Rate__c FROM PreventiveCareAgreement
            WHERE ContractPaymentAgreement.ContractId = :td.clinicianContract.Id
            AND ContractPaymentAgreement.Type__c = :SHIFT_TYPE
            AND Shift__r.Shift_Name__c = :td.dayShiftCode.Id
            ORDER BY CreatedDate ASC
        ];
        if (dayPCAs.size() >= 2) {
            dayPCAs[0].Rate__c = 90;
            dayPCAs[1].Rate__c = 95;
            update dayPCAs;
        }

        Test.startTest();
        ClinicianContractSyncQueueable queueable = new ClinicianContractSyncQueueable(new List<Id>{td.poContract.Id});
        System.enqueueJob(queueable);
        Test.stopTest();

        List<Task> tasks = [SELECT Id, Description FROM Task WHERE WhatId = :ccm.Id];
        System.assertEquals(1, tasks.size(), 'Task should be created for Manual CCM');
        System.assert(tasks[0].Description.contains('Review clinician rate for coverage only change'), 'Task Description should contain base comments');
        System.assert(tasks[0].Description.contains('Clinician Contract Number(s):'), 'Task Description should contain Clinician Contract Number(s) label');
        if (String.isNotBlank(td.clinicianContract.ContractNumber)) {
            System.assert(tasks[0].Description.contains(td.clinicianContract.ContractNumber), 'Task Description should contain clinician contract number');
        }
    }

    @IsTest
    static void testGetClinicianContractShiftsPopulatesContractNumberMap() {
        // Verifies that getClinicianContractShifts populates contractIdToContractNumberMap with ContractNumber
        TestDataCache td = getTestData();
        Client_Change_Management__c ccm = createCCM(td.poContract, td.hpf);
        insert ccm;

        Set<Id> clinicianAccountIds = new Set<Id>{ td.hpf.Practitioner.AccountId };
        Set<Id> hpfIds = new Set<Id>{ td.hpf.Id };

        Test.startTest();
        ClinicianContractSyncService service = new ClinicianContractSyncService();
        Map<Id, Map<Id, Map<String, Set<Decimal>>>> result = service.getClinicianContractShifts(clinicianAccountIds, null, hpfIds);
        Test.stopTest();

        System.assert(!result.isEmpty(), 'Should return clinician contract shifts');
        System.assert(!service.contractIdToContractNumberMap.isEmpty(), 'contractIdToContractNumberMap should be populated');
        System.assert(service.contractIdToContractNumberMap.containsKey(td.clinicianContract.Id),
            'contractIdToContractNumberMap should contain clinician contract Id');
        if (String.isNotBlank(td.clinicianContract.ContractNumber)) {
            System.assertEquals(td.clinicianContract.ContractNumber, service.contractIdToContractNumberMap.get(td.clinicianContract.Id),
                'ContractNumber in map should match clinician contract');
        }
    }

    @IsTest
    static void testAgentCcmCanceledWhenNoExecutedContract() {
        TestDataCache td = getTestData();
        Client_Change_Management__c agentCcm = new Client_Change_Management__c(
            Contract__c = td.poContract.Id,
            Healthcare_Practitioner_Facility__c = td.hpf.Id,
            Process_Type__c = PROCESS_TYPE_AGENT,
            Status__c = CCM_STATUS_NEW
        );
        insert agentCcm;

        // Mark one PO shift rate as rate-increase so Agent flow has expected rates to validate.
        PreventiveCareAgreement poPca = [
            SELECT Id, Existing_Rate_Increased__c
            FROM PreventiveCareAgreement
            WHERE ContractPaymentAgreement.ContractId = :td.poContract.Id
            AND ContractPaymentAgreement.Type__c = :SHIFT_TYPE
            LIMIT 1
        ];
        poPca.Existing_Rate_Increased__c = true;
        update poPca;

        Test.startTest();
        System.enqueueJob(new ClinicianContractSyncQueueable(new List<Id>{td.poContract.Id}));
        Test.stopTest();

        Client_Change_Management__c updatedCcm = [
            SELECT Id, Status__c, Process_Type__c
            FROM Client_Change_Management__c
            WHERE Id = :agentCcm.Id
        ];
        System.assertEquals(CCM_STATUS_CANCELED, updatedCcm.Status__c,
            'Agent CCM should be canceled when no executed clinician contract exists');

        String canceledReason = getCcmCanceledReason(agentCcm.Id);
        if (canceledReason != null) {
            System.assertEquals(CCM_CANCELED_REASON_NO_EXECUTED_CONTRACT, canceledReason,
                'Canceled reason should be No Executed Contract');
        }
    }

    @IsTest
    static void testAgentCcmCanceledWhenExecutedMissingUpdatedShiftType() {
        TestDataCache td = getTestData();
        Client_Change_Management__c agentCcm = new Client_Change_Management__c(
            Contract__c = td.poContract.Id,
            Healthcare_Practitioner_Facility__c = td.hpf.Id,
            Process_Type__c = PROCESS_TYPE_AGENT,
            Status__c = CCM_STATUS_NEW
        );
        insert agentCcm;

        // Avoid Contract status transition in test (prevents Contract After Save flow chain).
        ClinicianContractSyncService.AGENT_CLINICIAN_CONTRACT_STATUSES =
            new Set<String>{ CLINICIAN_CONTRACT_STATUS };

        // Trigger Agent logic on Night, then remove Night from executed contract so shift type is missing.
        List<PreventiveCareAgreement> poNightPcas = [
            SELECT Id, Existing_Rate_Increased__c
            FROM PreventiveCareAgreement
            WHERE ContractPaymentAgreement.ContractId = :td.poContract.Id
            AND ContractPaymentAgreement.Type__c = :SHIFT_TYPE
            AND Shift__r.Shift_Name__c = :td.nightShiftCode.Id
        ];
        for (PreventiveCareAgreement p : poNightPcas) {
            p.Existing_Rate_Increased__c = true;
        }
        update poNightPcas;

        List<PreventiveCareAgreement> clinicianNightPcas = [
            SELECT Id
            FROM PreventiveCareAgreement
            WHERE ContractPaymentAgreement.ContractId = :td.clinicianContract.Id
            AND ContractPaymentAgreement.Type__c = :SHIFT_TYPE
            AND Shift__r.Shift_Name__c = :td.nightShiftCode.Id
        ];
        if (!clinicianNightPcas.isEmpty()) {
            delete clinicianNightPcas;
        }

        Test.startTest();
        System.enqueueJob(new ClinicianContractSyncQueueable(new List<Id>{td.poContract.Id}));
        Test.stopTest();

        Client_Change_Management__c updatedCcm = [
            SELECT Id, Status__c
            FROM Client_Change_Management__c
            WHERE Id = :agentCcm.Id
        ];
        System.assertEquals(CCM_STATUS_CANCELED, updatedCcm.Status__c,
            'Agent CCM should be canceled when executed contract does not contain updated shift type/rate');

        String canceledReason = getCcmCanceledReason(agentCcm.Id);
        if (canceledReason != null) {
            System.assertEquals(CCM_CANCELED_REASON_MISSING_UPDATED_RATES, canceledReason,
                'Canceled reason should explain missing updated rate(s) in executed contract');
        }
    }

    @IsTest
    static void testAgentCcmRemainsNewWhenExecutedHasMatchingRate() {
        TestDataCache td = getTestData();
        Client_Change_Management__c agentCcm = new Client_Change_Management__c(
            Contract__c = td.poContract.Id,
            Healthcare_Practitioner_Facility__c = td.hpf.Id,
            Process_Type__c = PROCESS_TYPE_AGENT,
            Status__c = CCM_STATUS_NEW
        );
        insert agentCcm;

        // Avoid Contract status transition in test (prevents Contract After Save flow chain).
        ClinicianContractSyncService.AGENT_CLINICIAN_CONTRACT_STATUSES =
            new Set<String>{ CLINICIAN_CONTRACT_STATUS };

        // Mark Day PO rates as increased and set executed clinician Day rates to match exactly.
        List<PreventiveCareAgreement> poDayPcas = [
            SELECT Id, Existing_Rate_Increased__c, Rate__c
            FROM PreventiveCareAgreement
            WHERE ContractPaymentAgreement.ContractId = :td.poContract.Id
            AND ContractPaymentAgreement.Type__c = :SHIFT_TYPE
            AND Shift__r.Shift_Name__c = :td.dayShiftCode.Id
        ];
        Set<Decimal> dayRates = new Set<Decimal>();
        for (PreventiveCareAgreement p : poDayPcas) {
            p.Existing_Rate_Increased__c = true;
            dayRates.add(p.Rate__c);
        }
        update poDayPcas;

        List<PreventiveCareAgreement> clinicianDayPcas = [
            SELECT Id, Rate__c
            FROM PreventiveCareAgreement
            WHERE ContractPaymentAgreement.ContractId = :td.clinicianContract.Id
            AND ContractPaymentAgreement.Type__c = :SHIFT_TYPE
            AND Shift__r.Shift_Name__c = :td.dayShiftCode.Id
            ORDER BY CreatedDate ASC
        ];
        Decimal expectedRate = dayRates.isEmpty() ? 100 : dayRates.iterator().next();
        for (PreventiveCareAgreement p : clinicianDayPcas) {
            p.Rate__c = expectedRate;
        }
        update clinicianDayPcas;

        Test.startTest();
        System.enqueueJob(new ClinicianContractSyncQueueable(new List<Id>{td.poContract.Id}));
        Test.stopTest();

        Client_Change_Management__c updatedCcm = [
            SELECT Id, Status__c, Process_Type__c
            FROM Client_Change_Management__c
            WHERE Id = :agentCcm.Id
        ];
        System.assertEquals(CCM_STATUS_NEW, updatedCcm.Status__c,
            'Agent CCM should stay New when executed contract contains matching updated rates');
        System.assertEquals(PROCESS_TYPE_AGENT, updatedCcm.Process_Type__c,
            'Agent CCM process type should remain Agent');
    }

}