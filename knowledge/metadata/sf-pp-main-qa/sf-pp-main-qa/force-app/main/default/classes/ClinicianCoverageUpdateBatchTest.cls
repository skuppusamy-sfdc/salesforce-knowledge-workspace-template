@IsTest
public class ClinicianCoverageUpdateBatchTest {
    
    @TestSetup
    static void setupTestData() {
        TestDataFactoryCore tdf = new TestDataFactoryCore();

        // Create CodeSet records for FacilityTitle and Shift
        CodeSet eeNurseCode = tdf.createCodeSet('EE Nurse Practitioner', 'EE Nurse Practitioner', 'Facility Title', true);
        CodeSet medDirectorCode = tdf.createCodeSet('Medical Director', 'Medical Director', 'Facility Title', true);

        // Service Account for Client
        Account serviceAcc = tdf.createServiceAccount('Test Service Account', null, 'Service_Account', true);

        // Client Contracts (original and one with PreviousContractId)
        Contract originalClientContract = tdf.createClientContract(serviceAcc, Date.today(), 6, null, true);
        Contract clientContract = tdf.createClientContract(serviceAcc, Date.today(), 6, originalClientContract.Id, true);

        // Create Shift Code and Shift records - bulk insert
        CodeSet shiftCode = tdf.createCodeSet('Day Shift', 'Day', 'Shift', true);
        List<Shift__c> shifts = new List<Shift__c>();
        shifts.add(tdf.createShift(shiftCode.Id, clientContract.Id, '1', 'Monday', Time.newInstance(1, 2, 3, 4), Time.newInstance(1, 2, 3, 4), 'NP/PA', false));
        shifts.add(tdf.createShift(shiftCode.Id, clientContract.Id, '2', 'Monday', Time.newInstance(1, 2, 3, 4), Time.newInstance(1, 2, 3, 4), 'NP/PA', false));
        insert shifts;
        Shift__c shiftRecord = shifts[0];
        Shift__c shiftRecord2 = shifts[1];

        // Client CPAs
        ContractPaymentAgreement clientCPA = tdf.createCPA('Client CPA', clientContract.Id, null, true);
        ContractPaymentAgreement clientCPA2 = tdf.createCPA('Client CPA 2', clientContract.Id, null, true);

        // Client PCAs
        PreventiveCareAgreement clientPCA = tdf.createPCA(clientCPA.Id, false);
        clientPCA.Existing_Shift_Type_Added__c = true;
        clientPCA.Is_Newly_Added__c = true;
        clientPCA.Shift__c = shiftRecord.Id;
        clientPCA.FacilityTitle__c = eeNurseCode.Id;

        PreventiveCareAgreement clientPCA2 = tdf.createPCA(clientCPA2.Id, false);
        clientPCA2.Existing_Shift_Type_Added__c = true;
        clientPCA2.Is_Newly_Added__c = true;
        clientPCA2.Shift__c = shiftRecord2.Id;
        clientPCA2.FacilityTitle__c = eeNurseCode.Id;

        PreventiveCareAgreement clientPCAWithPayRate = tdf.createPCA(clientCPA.Id, false);
        clientPCAWithPayRate.FacilityTitle__c = eeNurseCode.Id;
        clientPCAWithPayRate.Shift__c = shiftRecord.Id;

        insert new List<PreventiveCareAgreement>{ clientPCA, clientPCA2, clientPCAWithPayRate };

        // Rate Pay Code linked to Client PCA with pay rate change
        tdf.createRatePayCode(clientPCAWithPayRate.Id, null, true, null, true);

        Pay_Codes__c payCode2 = new Pay_Codes__c(Pay_Code_Label__c = 'TEST_PAYCODE');
        insert payCode2;

        // Clinician Account & Contact
        Account clinicianAcc = tdf.createServiceAccount(null, 'Test Clinician', 'Clinician', true);
        Contact clinicianCon = tdf.getOrCreateContact(clinicianAcc, 'Test Contact');

        // Healthcare Network / Providers / Facilities
        HealthcarePayerNetwork hpn = tdf.createHealthcarePayerNetwork('Test Payer Network', serviceAcc.Id, true);
        HealthcareProvider hp = tdf.createHealthcareProvider('Physician Provider', clinicianCon.Id, true);

        HealthcarePractitionerFacility hpf = tdf.createHealthcarePractitionerFacility(
            'Test HPF', clinicianCon.Id, serviceAcc.Id, serviceAcc.Id, false
        );
        hpf.Facility_Title__c = eeNurseCode.Id;
        insert hpf;

        // Clinician Contract
        Contract clinicianContract = tdf.createClinicianContract(clinicianAcc, false);
        clinicianContract.StartDate = Date.today();
        insert clinicianContract;

        // Provider Network Contract for Clinician
        ProviderNetworkContract pnc = tdf.createPNC(clinicianContract.Id, hp.Id, hpn.Id, hpf.Id, true);

        // Clinician CPA
        ContractPaymentAgreement clinicianCPA = tdf.createCPA('Clinician CPA', clinicianContract.Id, pnc.Id, true);

        // Clinician PCA linked to Client PCA (Facility Rate)
        PreventiveCareAgreement clinicianPCA = tdf.createPCA(clinicianCPA.Id, false);
        clinicianPCA.Facility_Rate__c = clientPCAWithPayRate.Id;
        clinicianPCA.FacilityTitle__c = eeNurseCode.Id;
        clinicianPCA.Shift__c = shiftRecord.Id;
        insert clinicianPCA;

        tdf.createRatePayCode(clientPCAWithPayRate.Id, payCode2.Id, true, null, true);

        // Practice Operation Change and Client Change Management
        Practice_Operation_Change__c poc = tdf.createPracticeOperationChange(eeNurseCode.Id, clientContract.Id, true);

        tdf.createClientChangeManagement(clientContract.Id, poc.Id, hpf.Id, 'Automation', 'New', true);
    }
    
    @IsTest
    static void testClinicianCoverageUpdateBatch() {
        Test.startTest();
        
        // --------------------------
        // Execute the batch
        // --------------------------
        ClinicianCoverageUpdateBatch batch = new ClinicianCoverageUpdateBatch();
        Database.executeBatch(batch, 50);
        
        Test.stopTest();
        
        // --------------------------
        // Assert that Clinician PCA is created
        // --------------------------
        List<PreventiveCareAgreement> clinicianPCAs = [
            SELECT Id, ContractPaymentAgreementId, Facility_Rate__c
            FROM PreventiveCareAgreement
            WHERE ContractPaymentAgreement.Contract.RecordType.DeveloperName = 'Clinician'
        ];
        System.assert(!clinicianPCAs.isEmpty(), 'Clinician PCAs should be created.');
        
        // --------------------------
        // Assert that Rate Pay Codes are cloned to Clinician PCA
        // --------------------------
        List<Rate_Pay_Code__c> rpcList = [
            SELECT Id, Preventive_Care_Agreement__c
            FROM Rate_Pay_Code__c
            WHERE Preventive_Care_Agreement__r.ContractPaymentAgreement.Contract.RecordType.DeveloperName = 'Clinician'
        ];
        System.assert(!rpcList.isEmpty(), 'Rate Pay Codes should be cloned to Clinician PCA.');
    }
    @IsTest
    static void testClinicianCoverageUpdateBatch_DeletesClinicianRPCWhenClientRPCMarkedDeleted() {
        Pay_Codes__c payCode =  new Pay_Codes__c(
            Pay_Code_Label__c = 'TEST_DELETE_CODE'
        );
        insert payCode;
                
        // Arrange: mark client PCA as having removals and create a deleted client RPC with a specific pay code
        PreventiveCareAgreement clientPCA = [
            SELECT Id,ContractPaymentAgreement.ContractId, Rate_Pay_Code_Remove__c
            FROM PreventiveCareAgreement
            WHERE ContractPaymentAgreement.Contract.RecordType.DeveloperName = 'Client'
            ORDER BY CreatedDate ASC
            LIMIT 1
        ];
        Rate_Pay_Code__c clientDeletedRPC = new Rate_Pay_Code__c(
            Preventive_Care_Agreement__c = clientPCA.Id,
            Pay_Code__c = payCode.Id,
            Is_Deleted__c = true
        );
        insert clientDeletedRPC;
        // Create a matching clinician RPC that should be deleted by the batch (same pay code)
        PreventiveCareAgreement clinicianPCA = [
            SELECT Id,ContractPaymentAgreement.ContractId
            FROM PreventiveCareAgreement
            WHERE ContractPaymentAgreement.Contract.RecordType.DeveloperName = 'Clinician'
            ORDER BY CreatedDate ASC
            LIMIT 1
        ];
        Rate_Pay_Code__c clinicianRPC = new Rate_Pay_Code__c(
            Preventive_Care_Agreement__c = clinicianPCA.Id,
            Pay_Code__c = payCode.Id
        );
        insert clinicianRPC;
         Contract clinicianContract = new Contract();
        clinicianContract.Id = clinicianPCA.ContractPaymentAgreement.ContractId;
       clinicianContract.Status = 'Executed';
        update clinicianContract;
        
        Contract clientContract = new Contract();
        clientContract.Id = clientPCA.ContractPaymentAgreement.ContractId;
        clientContract.Status = 'Executed';
        update clientContract;
        Test.startTest();
        Database.executeBatch(new ClinicianCoverageUpdateBatch(), 50);
        Test.stopTest();
        // Assert: the clinician RPC with the matching pay code has been deleted
        List<Rate_Pay_Code__c> remaining = [
            SELECT Id
            FROM Rate_Pay_Code__c
            WHERE Preventive_Care_Agreement__r.ContractPaymentAgreement.Contract.RecordType.DeveloperName = 'Clinician'
              AND Pay_Code__c = :payCode.Id
        ];
        System.assertEquals(0, remaining.size(), 'Matching clinician Rate Pay Code should be deleted.');
    }
    
    @IsTest
    static void testLogDmlException() {
        // Test ErrorLogUtil.logException with DML exception (used by ClinicianCoverageUpdateBatch)
        Test.startTest();
        
        CodeSet facilityTitle = [SELECT Id FROM CodeSet WHERE CodeSetType = 'Facility Title' LIMIT 1];
        Contract clientContract = [
            SELECT Id FROM Contract WHERE RecordType.DeveloperName = 'Client' LIMIT 1
        ];
        
        Practice_Operation_Change__c poc = new Practice_Operation_Change__c(
            Facility_Title__c = facilityTitle.Id,
            Contract__c = clientContract.Id
        );
        insert poc;
        
        Client_Change_Management__c ccm = new Client_Change_Management__c(
            Contract__c = clientContract.Id,
            Practice_Operation_Change__c = poc.Id,
            Process_Type__c = 'Automation',
            Status__c = 'New'
        );
        insert ccm;
        
        delete ccm;
        
        try {
            Client_Change_Management__c deletedCCM = new Client_Change_Management__c(
                Id = ccm.Id,
                Status__c = 'Completed'
            );
            update deletedCCM;
        } catch (DmlException e) {
            String recordId = e.getNumDml() > 0 && e.getDmlId(0) != null ? String.valueOf(e.getDmlId(0)) : null;
            ErrorLogUtil.logException(e, 'ClinicianCoverageUpdateBatch.testMethod', recordId);
        }
        
        Test.stopTest();
        
        List<Error_Log__c> errorLogs = [
            SELECT Id, Error_Message__c, Source_Component__c, Error_Type__c, Stack_Trace__c, Error_Timestamp__c
            FROM Error_Log__c
            WHERE Source_Component__c = 'ClinicianCoverageUpdateBatch.testMethod'
            ORDER BY CreatedDate DESC
            LIMIT 1
        ];
        
        System.assertEquals(1, errorLogs.size(), 'Error log should be created when ErrorLogUtil.logException is called');
        System.assertEquals('System.DmlException', errorLogs[0].Error_Type__c, 'Error type should be DmlException');
        System.assertEquals('ClinicianCoverageUpdateBatch.testMethod', errorLogs[0].Source_Component__c,
            'Source component should match the method name');
        System.assertNotEquals(null, errorLogs[0].Error_Message__c, 'Error message should be populated');
        System.assertNotEquals(null, errorLogs[0].Stack_Trace__c, 'Stack trace should be populated');
        System.assertNotEquals(null, errorLogs[0].Error_Timestamp__c, 'Error timestamp should be populated');
    }
    
    @IsTest
    static void testLogDmlExceptionWithRecordId() {
        // Test ErrorLogUtil.logException with DML exception including record ID
        Test.startTest();
        
        CodeSet facilityTitle = [SELECT Id FROM CodeSet WHERE CodeSetType = 'Facility Title' LIMIT 1];
        Contract clientContract = [
            SELECT Id FROM Contract WHERE RecordType.DeveloperName = 'Client' LIMIT 1
        ];
        
        Practice_Operation_Change__c poc = new Practice_Operation_Change__c(
            Facility_Title__c = facilityTitle.Id,
            Contract__c = clientContract.Id
        );
        insert poc;
        
        Client_Change_Management__c ccm = new Client_Change_Management__c(
            Contract__c = clientContract.Id,
            Practice_Operation_Change__c = poc.Id,
            Process_Type__c = 'Automation',
            Status__c = 'New'
        );
        insert ccm;
        
        delete ccm;
        
        try {
            Client_Change_Management__c deletedCCM = new Client_Change_Management__c(
                Id = ccm.Id,
                Status__c = 'Completed'
            );
            update deletedCCM;
        } catch (DmlException e) {
            String recordId = e.getNumDml() > 0 && e.getDmlId(0) != null ? String.valueOf(e.getDmlId(0)) : null;
            ErrorLogUtil.logException(e, 'ClinicianCoverageUpdateBatch.testMethodWithRecordId', recordId);
        }
        
        Test.stopTest();
        
        // Assert: Verify that an Error_Log__c record was created with the record ID
        List<Error_Log__c> errorLogs = [
            SELECT Id, Error_Message__c, Source_Component__c, Error_Type__c, Record_Id__c
            FROM Error_Log__c
            WHERE Source_Component__c = 'ClinicianCoverageUpdateBatch.testMethodWithRecordId'
            ORDER BY CreatedDate DESC
            LIMIT 1
        ];
        
        System.assertEquals(1, errorLogs.size(), 'Error log should be created');
        System.assertNotEquals(null, errorLogs[0].Record_Id__c, 'Record ID should be populated when available in DML exception');
    }
    
    @IsTest
    static void testShouldCloneRatePayCode_Case1_ClonedFromMatchesPCA() {
        // Test Case 1: Clinician PCA is cloned, Facility Rate is null, 
        // and Cloned_From's Facility_Rate matches payRateCode's Preventive_Care_Agreement__c
        
        // Get existing test data
        Contract clientContract = [
            SELECT Id, AccountId
            FROM Contract
            WHERE RecordType.DeveloperName = 'Client'
            AND PreviousContractId != null
            LIMIT 1
        ];
        
        ContractPaymentAgreement clientCPA = [
            SELECT Id
            FROM ContractPaymentAgreement
            WHERE ContractId = :clientContract.Id
            LIMIT 1
        ];
        
        ContractPaymentAgreement clinicianCPA = [
            SELECT Id, ContractId
            FROM ContractPaymentAgreement
            WHERE Contract.RecordType.DeveloperName = 'Clinician'
            LIMIT 1
        ];
        
        CodeSet facilityTitle = [SELECT Id FROM CodeSet WHERE CodeSetType = 'Facility Title' LIMIT 1];
        Shift__c shiftRecord = [SELECT Id FROM Shift__c LIMIT 1];
        
        // Create a client PCA that will be used for Rate Pay Code
        PreventiveCareAgreement testClientPCA = new PreventiveCareAgreement(
            ContractPaymentAgreementId = clientCPA.Id,
            FacilityTitle__c = facilityTitle.Id,
            Shift__c = shiftRecord.Id,
            Existing_Shift_Type_Added__c = true,
            Is_Newly_Added__c = true,
            Existing_Rate_Increased__c = false,
            Existing_Rate_Decreased__c = false,
            BonusMeasureType = 'NA',
            TargetMeasurePercent = 0,
            BonusPayout = 0
        );
        insert testClientPCA;
        
        // Create an intermediate PCA that will be cloned from
        PreventiveCareAgreement intermediatePCA = new PreventiveCareAgreement(
            ContractPaymentAgreementId = clinicianCPA.Id,
            Facility_Rate__c = testClientPCA.Id, // This will be referenced in Cloned_From
            FacilityTitle__c = facilityTitle.Id,
            Shift__c = shiftRecord.Id,
            BonusMeasureType = 'NA',
            TargetMeasurePercent = 0,
            BonusPayout = 0
        );
        insert intermediatePCA;
        
        // Create a cloned PCA (Cloned_From__c != null, Facility_Rate__c == null)
        PreventiveCareAgreement clonedClinicianPCA = new PreventiveCareAgreement(
            ContractPaymentAgreementId = clinicianCPA.Id,
            Cloned_From__c = intermediatePCA.Id,
            Facility_Rate__c = null, // Case 1 condition
            FacilityTitle__c = facilityTitle.Id,
            Shift__c = shiftRecord.Id,
            BonusMeasureType = 'NA',
            TargetMeasurePercent = 0,
            BonusPayout = 0
        );
        insert clonedClinicianPCA;
        
        // Create a Rate Pay Code on the client PCA
        Pay_Codes__c payCode = new Pay_Codes__c(Pay_Code_Label__c = 'TEST_CASE1_CODE');
        insert payCode;
        
        Rate_Pay_Code__c clientRPC = new Rate_Pay_Code__c(
            Preventive_Care_Agreement__c = testClientPCA.Id,
            Pay_Code__c = payCode.Id,
            Is_Newly_Added__c = true
        );
        insert clientRPC;
        
        // Ensure CCM record exists
        CodeSet facilityTitleForCCM = [SELECT Id FROM CodeSet WHERE CodeSetType = 'Facility Title' LIMIT 1];
        Practice_Operation_Change__c poc = new Practice_Operation_Change__c(
            Facility_Title__c = facilityTitleForCCM.Id,
            Contract__c = clientContract.Id
        );
        insert poc;
        
        Client_Change_Management__c ccm = new Client_Change_Management__c(
            Contract__c = clientContract.Id,
            Practice_Operation_Change__c = poc.Id,
            Process_Type__c = 'Automation',
            Status__c = 'New'
        );
        insert ccm;
        
        // Update client contract to Executed
        clientContract.Status = 'Executed';
        update clientContract;
        
        // Execute batch
        Test.startTest();
        Database.executeBatch(new ClinicianCoverageUpdateBatch(), 50);
        Test.stopTest();
        
        // Verify: Rate Pay Code should be cloned because Case 1 conditions are met
        // Cloned_From__r.Facility_Rate__c (intermediatePCA.Facility_Rate__c = testClientPCA.Id) 
        // matches payRateCode.Preventive_Care_Agreement__c (testClientPCA.Id)
        List<Rate_Pay_Code__c> clonedRPCs = [
            SELECT Id, Preventive_Care_Agreement__c, Pay_Code__c
            FROM Rate_Pay_Code__c
            WHERE Preventive_Care_Agreement__c = :clonedClinicianPCA.Id
            AND Pay_Code__c = :payCode.Id
        ];
        System.assertEquals(1, clonedRPCs.size(), 'Rate Pay Code should be cloned when Case 1 conditions are met (Cloned_From Facility_Rate matches PCA)');
    }
    
    @IsTest
    static void testShouldCloneRatePayCode_Case1_ClonedFromMatchesClonedFrom() {
        // Test Case 1: Clinician PCA is cloned, Facility Rate is null,
        // and Cloned_From's Facility_Rate matches payRateCode's Preventive_Care_Agreement__r.Cloned_From__c
        
        // Get existing test data
        PreventiveCareAgreement clientPCA = [
            SELECT Id, ContractPaymentAgreementId, ContractPaymentAgreement.ContractId
            FROM PreventiveCareAgreement
            WHERE ContractPaymentAgreement.Contract.RecordType.DeveloperName = 'Client'
            LIMIT 1
        ];
        
        ContractPaymentAgreement clinicianCPA = [
            SELECT Id, ContractId
            FROM ContractPaymentAgreement
            WHERE Contract.RecordType.DeveloperName = 'Clinician'
            LIMIT 1
        ];
        
        CodeSet facilityTitle = [SELECT Id FROM CodeSet WHERE CodeSetType = 'Facility Title' LIMIT 1];
        Shift__c shiftRecord = [SELECT Id FROM Shift__c LIMIT 1];
        
        // Create a client PCA that will be cloned from (this will be the Cloned_From of the RPC's PCA)
        PreventiveCareAgreement sourceClientPCA = new PreventiveCareAgreement(
            ContractPaymentAgreementId = clientPCA.ContractPaymentAgreementId,
            FacilityTitle__c = facilityTitle.Id,
            Shift__c = shiftRecord.Id,
            BonusMeasureType = 'NA',
            TargetMeasurePercent = 0,
            BonusPayout = 0
        );
        insert sourceClientPCA;
        
        // Create a client PCA that is cloned from sourceClientPCA (this will have the RPC)
        PreventiveCareAgreement clonedClientPCA = new PreventiveCareAgreement(
            ContractPaymentAgreementId = clientPCA.ContractPaymentAgreementId,
            Cloned_From__c = sourceClientPCA.Id,
            FacilityTitle__c = facilityTitle.Id,
            Shift__c = shiftRecord.Id,
            BonusMeasureType = 'NA',
            TargetMeasurePercent = 0,
            BonusPayout = 0
        );
        insert clonedClientPCA;
        
        // Create an intermediate PCA that will be cloned from (references sourceClientPCA)
        PreventiveCareAgreement intermediatePCA = new PreventiveCareAgreement(
            ContractPaymentAgreementId = clinicianCPA.Id,
            Facility_Rate__c = sourceClientPCA.Id, // This matches clonedClientPCA.Cloned_From__c
            FacilityTitle__c = facilityTitle.Id,
            Shift__c = shiftRecord.Id,
            BonusMeasureType = 'NA',
            TargetMeasurePercent = 0,
            BonusPayout = 0
        );
        insert intermediatePCA;
        
        // Create a cloned PCA (Cloned_From__c != null, Facility_Rate__c == null)
        PreventiveCareAgreement clonedClinicianPCA = new PreventiveCareAgreement(
            ContractPaymentAgreementId = clinicianCPA.Id,
            Cloned_From__c = intermediatePCA.Id,
            Facility_Rate__c = null, // Case 1 condition
            FacilityTitle__c = facilityTitle.Id,
            Shift__c = shiftRecord.Id,
            BonusMeasureType = 'NA',
            TargetMeasurePercent = 0,
            BonusPayout = 0
        );
        insert clonedClinicianPCA;
        
        // Create a Rate Pay Code on the cloned client PCA
        Pay_Codes__c payCode = new Pay_Codes__c(Pay_Code_Label__c = 'TEST_CASE1_CLONED_CODE');
        insert payCode;
        
        Rate_Pay_Code__c clientRPC = new Rate_Pay_Code__c(
            Preventive_Care_Agreement__c = clonedClientPCA.Id, // This PCA has Cloned_From__c = sourceClientPCA.Id
            Pay_Code__c = payCode.Id,
            Is_Newly_Added__c = true
        );
        insert clientRPC;
        
        // Update client contract to Executed
        Contract clientContract = new Contract(Id = clientPCA.ContractPaymentAgreement.ContractId, Status = 'Executed');
        update clientContract;
        
        // Execute batch
        Test.startTest();
        Database.executeBatch(new ClinicianCoverageUpdateBatch(), 50);
        Test.stopTest();
        
        // Verify: Rate Pay Code should be cloned because Case 1 conditions are met
        // Cloned_From__r.Facility_Rate__c (intermediatePCA.Facility_Rate__c = sourceClientPCA.Id)
        // matches payRateCode.Preventive_Care_Agreement__r.Cloned_From__c (clonedClientPCA.Cloned_From__c = sourceClientPCA.Id)
        List<Rate_Pay_Code__c> clonedRPCs = [
            SELECT Id, Preventive_Care_Agreement__c, Pay_Code__c
            FROM Rate_Pay_Code__c
            WHERE Preventive_Care_Agreement__c = :clonedClinicianPCA.Id
            AND Pay_Code__c = :payCode.Id
        ];
        System.assertEquals(1, clonedRPCs.size(), 'Rate Pay Code should be cloned when Case 1 conditions are met (Cloned_From Facility_Rate matches RPC PCA Cloned_From)');
    }
    
    @IsTest
    static void testShouldCloneRatePayCode_Case1_False() {
        // Test Case 1: False scenario - Cloned PCA but Facility_Rate doesn't match
        
        // Get existing test data
        PreventiveCareAgreement clientPCA = [
            SELECT Id, ContractPaymentAgreementId, ContractPaymentAgreement.ContractId
            FROM PreventiveCareAgreement
            WHERE ContractPaymentAgreement.Contract.RecordType.DeveloperName = 'Client'
            LIMIT 1
        ];
        
        ContractPaymentAgreement clinicianCPA = [
            SELECT Id, ContractId
            FROM ContractPaymentAgreement
            WHERE Contract.RecordType.DeveloperName = 'Clinician'
            LIMIT 1
        ];
        
        CodeSet facilityTitle = [SELECT Id FROM CodeSet WHERE CodeSetType = 'Facility Title' LIMIT 1];
        Shift__c shiftRecord = [SELECT Id FROM Shift__c LIMIT 1];
        
        // Create a different client PCA that won't match
        PreventiveCareAgreement differentClientPCA = new PreventiveCareAgreement(
            ContractPaymentAgreementId = clientPCA.ContractPaymentAgreementId,
            FacilityTitle__c = facilityTitle.Id,
            Shift__c = shiftRecord.Id,
            BonusMeasureType = 'NA',
            TargetMeasurePercent = 0,
            BonusPayout = 0
        );
        insert differentClientPCA;
        
        // Create an intermediate PCA that references a different client PCA
        PreventiveCareAgreement intermediatePCA = new PreventiveCareAgreement(
            ContractPaymentAgreementId = clinicianCPA.Id,
            Facility_Rate__c = differentClientPCA.Id, // Different from the RPC's PCA
            FacilityTitle__c = facilityTitle.Id,
            Shift__c = shiftRecord.Id,
            BonusMeasureType = 'NA',
            TargetMeasurePercent = 0,
            BonusPayout = 0
        );
        insert intermediatePCA;
        
        // Create a cloned PCA (Cloned_From__c != null, Facility_Rate__c == null)
        PreventiveCareAgreement clonedClinicianPCA = new PreventiveCareAgreement(
            ContractPaymentAgreementId = clinicianCPA.Id,
            Cloned_From__c = intermediatePCA.Id,
            Facility_Rate__c = null, // Case 1 condition
            FacilityTitle__c = facilityTitle.Id,
            Shift__c = shiftRecord.Id,
            BonusMeasureType = 'NA',
            TargetMeasurePercent = 0,
            BonusPayout = 0
        );
        insert clonedClinicianPCA;
        
        // Create a Rate Pay Code on the original client PCA (different from intermediatePCA.Facility_Rate__c)
        Pay_Codes__c payCode = new Pay_Codes__c(Pay_Code_Label__c = 'TEST_CASE1_FALSE_CODE');
        insert payCode;
        
        Rate_Pay_Code__c clientRPC = new Rate_Pay_Code__c(
            Preventive_Care_Agreement__c = clientPCA.Id, // Different from differentClientPCA.Id
            Pay_Code__c = payCode.Id,
            Is_Newly_Added__c = true
        );
        insert clientRPC;
        
        // Update client contract to Executed
        Contract clientContract = new Contract(Id = clientPCA.ContractPaymentAgreement.ContractId, Status = 'Executed');
        update clientContract;
        
        // Execute batch
        Test.startTest();
        Database.executeBatch(new ClinicianCoverageUpdateBatch(), 50);
        Test.stopTest();
        
        // Verify: Rate Pay Code should NOT be cloned because Facility_Rate doesn't match
        List<Rate_Pay_Code__c> clonedRPCs = [
            SELECT Id, Preventive_Care_Agreement__c, Pay_Code__c
            FROM Rate_Pay_Code__c
            WHERE Preventive_Care_Agreement__c = :clonedClinicianPCA.Id
            AND Pay_Code__c = :payCode.Id
        ];
        System.assertEquals(0, clonedRPCs.size(), 'Rate Pay Code should NOT be cloned when Case 1 Facility_Rate does not match');
    }
    
    @IsTest
    static void testShouldCloneRatePayCode_Case2_FacilityRateMatchesPCA() {
        // Test Case 2: Clinician PCA has Facility_Rate__c populated
        // and Facility_Rate__c matches payRateCode.Preventive_Care_Agreement__c
        
        // Get existing test data
        PreventiveCareAgreement clientPCA = [
            SELECT Id, ContractPaymentAgreementId, ContractPaymentAgreement.ContractId
            FROM PreventiveCareAgreement
            WHERE ContractPaymentAgreement.Contract.RecordType.DeveloperName = 'Client'
            LIMIT 1
        ];
        
        ContractPaymentAgreement clinicianCPA = [
            SELECT Id, ContractId
            FROM ContractPaymentAgreement
            WHERE Contract.RecordType.DeveloperName = 'Clinician'
            LIMIT 1
        ];
        
        CodeSet facilityTitle = [SELECT Id FROM CodeSet WHERE CodeSetType = 'Facility Title' LIMIT 1];
        Shift__c shiftRecord = [SELECT Id FROM Shift__c LIMIT 1];
        
        // Create a clinician PCA with Facility_Rate__c populated (matches client PCA)
        PreventiveCareAgreement testClinicianPCA = new PreventiveCareAgreement(
            ContractPaymentAgreementId = clinicianCPA.Id,
            Facility_Rate__c = clientPCA.Id, // Case 2 condition - matches RPC's PCA
            FacilityTitle__c = facilityTitle.Id,
            Shift__c = shiftRecord.Id,
            BonusMeasureType = 'NA',
            TargetMeasurePercent = 0,
            BonusPayout = 0
        );
        insert testClinicianPCA;
        
        // Create a Rate Pay Code on the client PCA
        Pay_Codes__c payCode = new Pay_Codes__c(Pay_Code_Label__c = 'TEST_CASE2_CODE');
        insert payCode;
        
        Rate_Pay_Code__c clientRPC = new Rate_Pay_Code__c(
            Preventive_Care_Agreement__c = clientPCA.Id, // Matches clinicianPCA.Facility_Rate__c
            Pay_Code__c = payCode.Id,
            Is_Newly_Added__c = true
        );
        insert clientRPC;
        
        // Update client contract to Executed
        Contract clientContract = new Contract(Id = clientPCA.ContractPaymentAgreement.ContractId, Status = 'Executed');
        update clientContract;
        
        // Execute batch
        Test.startTest();
        Database.executeBatch(new ClinicianCoverageUpdateBatch(), 50);
        Test.stopTest();
        
        // Verify: Rate Pay Code should be cloned because Case 2 conditions are met
        // Facility_Rate__c (clientPCA.Id) matches payRateCode.Preventive_Care_Agreement__c (clientPCA.Id)
        List<Rate_Pay_Code__c> clonedRPCs = [
            SELECT Id, Preventive_Care_Agreement__c, Pay_Code__c
            FROM Rate_Pay_Code__c
            WHERE Preventive_Care_Agreement__c = :testClinicianPCA.Id
            AND Pay_Code__c = :payCode.Id
        ];
        System.assertEquals(1, clonedRPCs.size(), 'Rate Pay Code should be cloned when Case 2 conditions are met (Facility_Rate matches PCA)');
    }
    
    @IsTest
    static void testShouldCloneRatePayCode_Case2_FacilityRateMatchesClonedFrom() {
        // Test Case 2: Clinician PCA has Facility_Rate__c populated
        // and Facility_Rate__c matches payRateCode.Preventive_Care_Agreement__r.Cloned_From__c
        
        // Get existing test data
        PreventiveCareAgreement clientPCA = [
            SELECT Id, ContractPaymentAgreementId, ContractPaymentAgreement.ContractId
            FROM PreventiveCareAgreement
            WHERE ContractPaymentAgreement.Contract.RecordType.DeveloperName = 'Client'
            LIMIT 1
        ];
        
        ContractPaymentAgreement clinicianCPA = [
            SELECT Id, ContractId
            FROM ContractPaymentAgreement
            WHERE Contract.RecordType.DeveloperName = 'Clinician'
            LIMIT 1
        ];
        
        CodeSet facilityTitle = [SELECT Id FROM CodeSet WHERE CodeSetType = 'Facility Title' LIMIT 1];
        Shift__c shiftRecord = [SELECT Id FROM Shift__c LIMIT 1];
        
        // Create a source client PCA
        PreventiveCareAgreement sourceClientPCA = new PreventiveCareAgreement(
            ContractPaymentAgreementId = clientPCA.ContractPaymentAgreementId,
            FacilityTitle__c = facilityTitle.Id,
            Shift__c = shiftRecord.Id,
            BonusMeasureType = 'NA',
            TargetMeasurePercent = 0,
            BonusPayout = 0
        );
        insert sourceClientPCA;
        
        // Create a cloned client PCA (has Cloned_From__c = sourceClientPCA.Id)
        PreventiveCareAgreement clonedClientPCA = new PreventiveCareAgreement(
            ContractPaymentAgreementId = clientPCA.ContractPaymentAgreementId,
            Cloned_From__c = sourceClientPCA.Id,
            FacilityTitle__c = facilityTitle.Id,
            Shift__c = shiftRecord.Id,
            BonusMeasureType = 'NA',
            TargetMeasurePercent = 0,
            BonusPayout = 0
        );
        insert clonedClientPCA;
        
        // Create a clinician PCA with Facility_Rate__c populated (matches sourceClientPCA)
        PreventiveCareAgreement testClinicianPCA2 = new PreventiveCareAgreement(
            ContractPaymentAgreementId = clinicianCPA.Id,
            Facility_Rate__c = sourceClientPCA.Id, // Case 2 condition - matches clonedClientPCA.Cloned_From__c
            FacilityTitle__c = facilityTitle.Id,
            Shift__c = shiftRecord.Id,
            BonusMeasureType = 'NA',
            TargetMeasurePercent = 0,
            BonusPayout = 0
        );
        insert testClinicianPCA2;
        
        // Create a Rate Pay Code on the cloned client PCA
        Pay_Codes__c payCode = new Pay_Codes__c(Pay_Code_Label__c = 'TEST_CASE2_CLONED_CODE');
        insert payCode;
        
        Rate_Pay_Code__c clientRPC = new Rate_Pay_Code__c(
            Preventive_Care_Agreement__c = clonedClientPCA.Id, // This has Cloned_From__c = sourceClientPCA.Id
            Pay_Code__c = payCode.Id,
            Is_Newly_Added__c = true
        );
        insert clientRPC;
        
        // Update client contract to Executed
        Contract clientContract = new Contract(Id = clientPCA.ContractPaymentAgreement.ContractId, Status = 'Executed');
        update clientContract;
        
        // Execute batch
        Test.startTest();
        Database.executeBatch(new ClinicianCoverageUpdateBatch(), 50);
        Test.stopTest();
        
        // Verify: Rate Pay Code should be cloned because Case 2 conditions are met
        // Facility_Rate__c (sourceClientPCA.Id) matches payRateCode.Preventive_Care_Agreement__r.Cloned_From__c (clonedClientPCA.Cloned_From__c = sourceClientPCA.Id)
        List<Rate_Pay_Code__c> clonedRPCs = [
            SELECT Id, Preventive_Care_Agreement__c, Pay_Code__c
            FROM Rate_Pay_Code__c
            WHERE Preventive_Care_Agreement__c = :testClinicianPCA2.Id
            AND Pay_Code__c = :payCode.Id
        ];
        System.assertEquals(1, clonedRPCs.size(), 'Rate Pay Code should be cloned when Case 2 conditions are met (Facility_Rate matches RPC PCA Cloned_From)');
    }
    
    @IsTest
    static void testShouldCloneRatePayCode_Case2_False() {
        // Test Case 2: False scenario - Facility_Rate doesn't match
        
        // Get existing test data
        PreventiveCareAgreement clientPCA = [
            SELECT Id, ContractPaymentAgreementId, ContractPaymentAgreement.ContractId
            FROM PreventiveCareAgreement
            WHERE ContractPaymentAgreement.Contract.RecordType.DeveloperName = 'Client'
            LIMIT 1
        ];
        
        ContractPaymentAgreement clinicianCPA = [
            SELECT Id, ContractId
            FROM ContractPaymentAgreement
            WHERE Contract.RecordType.DeveloperName = 'Clinician'
            LIMIT 1
        ];
        
        CodeSet facilityTitle = [SELECT Id FROM CodeSet WHERE CodeSetType = 'Facility Title' LIMIT 1];
        Shift__c shiftRecord = [SELECT Id FROM Shift__c LIMIT 1];
        
        // Create a different client PCA
        PreventiveCareAgreement differentClientPCA = new PreventiveCareAgreement(
            ContractPaymentAgreementId = clientPCA.ContractPaymentAgreementId,
            FacilityTitle__c = facilityTitle.Id,
            Shift__c = shiftRecord.Id,
            BonusMeasureType = 'NA',
            TargetMeasurePercent = 0,
            BonusPayout = 0
        );
        insert differentClientPCA;
        
        // Create a clinician PCA with Facility_Rate__c populated (different from client PCA)
        PreventiveCareAgreement testClinicianPCA3 = new PreventiveCareAgreement(
            ContractPaymentAgreementId = clinicianCPA.Id,
            Facility_Rate__c = differentClientPCA.Id, // Different from the RPC's PCA
            FacilityTitle__c = facilityTitle.Id,
            Shift__c = shiftRecord.Id,
            BonusMeasureType = 'NA',
            TargetMeasurePercent = 0,
            BonusPayout = 0
        );
        insert testClinicianPCA3;
        
        // Create a Rate Pay Code on the original client PCA (different from differentClientPCA)
        Pay_Codes__c payCode = new Pay_Codes__c(Pay_Code_Label__c = 'TEST_CASE2_FALSE_CODE');
        insert payCode;
        
        Rate_Pay_Code__c clientRPC = new Rate_Pay_Code__c(
            Preventive_Care_Agreement__c = clientPCA.Id, // Different from differentClientPCA.Id
            Pay_Code__c = payCode.Id,
            Is_Newly_Added__c = true
        );
        insert clientRPC;
        
        // Update client contract to Executed
        Contract clientContract = new Contract(Id = clientPCA.ContractPaymentAgreement.ContractId, Status = 'Executed');
        update clientContract;
        
        // Execute batch
        Test.startTest();
        Database.executeBatch(new ClinicianCoverageUpdateBatch(), 50);
        Test.stopTest();
        
        // Verify: Rate Pay Code should NOT be cloned because Facility_Rate doesn't match
        List<Rate_Pay_Code__c> clonedRPCs = [
            SELECT Id, Preventive_Care_Agreement__c, Pay_Code__c
            FROM Rate_Pay_Code__c
            WHERE Preventive_Care_Agreement__c = :testClinicianPCA3.Id
            AND Pay_Code__c = :payCode.Id
        ];
        System.assertEquals(0, clonedRPCs.size(), 'Rate Pay Code should NOT be cloned when Case 2 Facility_Rate does not match');
    }
    
    @IsTest
    static void testShouldCloneRatePayCode_BothCasesFalse() {
        // Test scenario where both Case 1 and Case 2 are false
        // PCA is not cloned (Cloned_From__c == null) and Facility_Rate__c == null
        
        // Get existing test data
        PreventiveCareAgreement clientPCA = [
            SELECT Id, ContractPaymentAgreementId, ContractPaymentAgreement.ContractId
            FROM PreventiveCareAgreement
            WHERE ContractPaymentAgreement.Contract.RecordType.DeveloperName = 'Client'
            LIMIT 1
        ];
        
        ContractPaymentAgreement clinicianCPA = [
            SELECT Id, ContractId
            FROM ContractPaymentAgreement
            WHERE Contract.RecordType.DeveloperName = 'Clinician'
            LIMIT 1
        ];
        
        CodeSet facilityTitle = [SELECT Id FROM CodeSet WHERE CodeSetType = 'Facility Title' LIMIT 1];
        Shift__c shiftRecord = [SELECT Id FROM Shift__c LIMIT 1];
        
        // Create a clinician PCA that is NOT cloned and has null Facility_Rate
        PreventiveCareAgreement testClinicianPCA4 = new PreventiveCareAgreement(
            ContractPaymentAgreementId = clinicianCPA.Id,
            Cloned_From__c = null, // Not cloned
            Facility_Rate__c = null, // Null Facility_Rate
            FacilityTitle__c = facilityTitle.Id,
            Shift__c = shiftRecord.Id,
            BonusMeasureType = 'NA',
            TargetMeasurePercent = 0,
            BonusPayout = 0
        );
        insert testClinicianPCA4;
        
        // Create a Rate Pay Code on the client PCA
        Pay_Codes__c payCode = new Pay_Codes__c(Pay_Code_Label__c = 'TEST_BOTH_FALSE_CODE');
        insert payCode;
        
        Rate_Pay_Code__c clientRPC = new Rate_Pay_Code__c(
            Preventive_Care_Agreement__c = clientPCA.Id,
            Pay_Code__c = payCode.Id,
            Is_Newly_Added__c = true
        );
        insert clientRPC;
        
        // Update client contract to Executed
        Contract clientContract = new Contract(Id = clientPCA.ContractPaymentAgreement.ContractId, Status = 'Executed');
        update clientContract;
        
        // Execute batch
        Test.startTest();
        Database.executeBatch(new ClinicianCoverageUpdateBatch(), 50);
        Test.stopTest();
        
        // Verify: Rate Pay Code should NOT be cloned because neither Case 1 nor Case 2 conditions are met
        List<Rate_Pay_Code__c> clonedRPCs = [
            SELECT Id, Preventive_Care_Agreement__c, Pay_Code__c
            FROM Rate_Pay_Code__c
            WHERE Preventive_Care_Agreement__c = :testClinicianPCA4.Id
            AND Pay_Code__c = :payCode.Id
        ];
        System.assertEquals(0, clonedRPCs.size(), 'Rate Pay Code should NOT be cloned when both Case 1 and Case 2 conditions are false');
    }
    
}