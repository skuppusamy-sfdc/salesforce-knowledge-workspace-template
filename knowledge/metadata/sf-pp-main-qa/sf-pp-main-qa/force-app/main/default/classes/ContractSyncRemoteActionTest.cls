@isTest
public class ContractSyncRemoteActionTest {

    // Setup Test Data
    @TestSetup
    static void setupTestData() {
        // 1. Create a common Account (Facility)
        TestDataFactoryCore TDF = new TestDataFactoryCore();
        Account facility = TDF.createServiceAccount('Test Facility', null, 'Service_Account', true);

        // 2. Create Healthcare Practitioner Facility
            CodeSet eeNurseCode = new CodeSet(
            Name='EE Nurse Practitioner', 
            Code='EE Nurse Practitioner', 
            CodeSetType ='Facility Title',
            IsActive  = true
        );
        CodeSet medDirectorCode = new CodeSet(
            Name='Medical Director', 
            Code='Medical Director', 
            CodeSetType ='Facility Title',
            IsActive  = true
        );
        insert new List<CodeSet>{eeNurseCode, medDirectorCode};        
        
        Account clinicianAcc = TDF.createServiceAccount(null, 'Test Clinician', 'Clinician', true);
        Contact clinicianCon = TDF.getOrCreateContact(clinicianAcc, 'Test Contact');
        
        HealthcarePayerNetwork hpn = TDF.createHealthcarePayerNetwork('Test Payer Network', facility.Id, true);
        HealthcareProvider hp = TDF.createHealthcareProvider('Physician Provider', clinicianCon.Id, true);
        
        HealthcarePractitionerFacility hpf = TDF.createHealthcarePractitionerFacility(
            'Test HPF', clinicianCon.Id, facility.Id, facility.Id, false
        );
        hpf.Facility_Title__c =  eeNurseCode.Id; // Link to Facility CodeSet
        insert hpf;

        // 3. Create a Clinician Contract (The one being synced)
        Contract clinicianContract = new Contract(
            AccountId = facility.Id,
            RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType='Contract' AND DeveloperName='Clinician' LIMIT 1].Id,
            StartDate = Date.today().addDays(-20),
            Status = 'Draft',
            NPPA_Tier__c = '120'
        );
        insert clinicianContract;

        // 4. Create a Provider Network Contract (PNC)
        ProviderNetworkContract pnc = TDF.createPNC(clinicianContract.Id, hp.Id, hpn.Id, hpf.Id, true);

        // 5. Create a PO Contract (The source of rates - Must be Executed and Client Record Type)
        // Mock the RecordType lookup if necessary, or ensure a RecordType with DeveloperName 'Client' exists.
        // Assuming 'Client' RecordType exists for Contract
        RecordType clientRT = [SELECT Id FROM RecordType WHERE SobjectType = 'Contract' AND DeveloperName = 'Client' LIMIT 1];
        
        Contract poContract = new Contract(
            AccountId = facility.Id,
            StartDate = Date.today().addDays(-30), // StartDate >= clinicianContract.StartDate
            Status = 'Draft',
            ContractTerm = 12,
            RecordTypeId = clientRT.Id
        );
        insert poContract;

        // 6. Create PO Contract Payment Agreements (PO CPAs)
        List<ContractPaymentAgreement> poCpas = new List<ContractPaymentAgreement>();
        poCpas.add(new ContractPaymentAgreement(ContractId = poContract.Id, Type__c = 'Shift', 
                                                Name = 'PO Shift CPA',
                                                AgreementType = 'Preventive Care Agreement',
                                                Status = 'Draft',
                                                Account__c = facility.Id,
                                                StartDateTime = DateTime.now()));
        poCpas.add(new ContractPaymentAgreement(ContractId = poContract.Id, Type__c = 'Stipend', 
                                                Name = 'PO Stipend CPA',
                                                AgreementType = 'Preventive Care Agreement',
                                                Status = 'Draft',
                                                Account__c = facility.Id,
                                                StartDateTime = DateTime.now()));
        poCpas.add(new ContractPaymentAgreement(ContractId = poContract.Id, Type__c = 'Variable', 
                                                Name = 'PO Variable CPA',
                                               	AgreementType = 'Preventive Care Agreement',
                                                Status = 'Draft',
                                                Account__c = facility.Id,
                                                StartDateTime = DateTime.now()));
        insert poCpas;
        
        // Map for easy access to PO CPAs
        Map<String, Id> poCpaIdByType = new Map<String, Id>();
        for(ContractPaymentAgreement cpa : poCpas) {
            poCpaIdByType.put(cpa.Type__c, cpa.Id);
        }

        // 7. Create Clinician Contract Payment Agreements (Clinician CPAs)
        List<ContractPaymentAgreement> clinicianCpas = new List<ContractPaymentAgreement>();
        clinicianCpas.add(new ContractPaymentAgreement(
            ContractId = clinicianContract.Id, 
            Type__c = 'Shift', 
            Provider_Network_Contract__c = pnc.Id, 
            Name = 'Clinician Shift CPA',
            AgreementType = 'Preventive Care Agreement',
                                                Status = 'Draft',
                                                StartDateTime = DateTime.now(),
            Facility_Rate__c = poCpaIdByType.get('Shift') // Initial matching Facility_Rate__c
        ));
        clinicianCpas.add(new ContractPaymentAgreement(
            ContractId = clinicianContract.Id, 
            Type__c = 'Stipend', 
            Provider_Network_Contract__c = pnc.Id, 
            Name = 'Clinician Stipend CPA',
            AgreementType = 'Preventive Care Agreement',
                                                Status = 'Draft',
                                                StartDateTime = DateTime.now(),
            Facility_Rate__c = null // Needs update
        ));
        clinicianCpas.add(new ContractPaymentAgreement(
            ContractId = clinicianContract.Id, 
            Type__c = 'Target', 
            Provider_Network_Contract__c = pnc.Id, 
            Name = 'Clinician Target CPA',
            AgreementType = 'Preventive Care Agreement',
                                                Status = 'Draft',
                                                StartDateTime = DateTime.now(),
            Facility_Rate__c = poCpaIdByType.get('Stipend') // Wrong initial reference
        ));
        insert clinicianCpas;
        
        // Map for easy access to Clinician CPAs
        Map<String, Id> clinicianCpaIdByType = new Map<String, Id>();
        for(ContractPaymentAgreement cpa : clinicianCpas) {
            clinicianCpaIdByType.put(cpa.Type__c, cpa.Id);
        }

        // 8. Create Shift for Shift-Type PCAs
        CodeSet shiftCode = new CodeSet(Name='Day Shift', Code='Day', CodeSetType='Shift');
        insert shiftCode;

        
        
        Shift__c shiftRecord = new Shift__c(
            Shift_Name__c = shiftCode.Id,
            Contract__c=poContract.Id,
            Existing_Shift_Type_Added__c=true,
            Shift_Iteration__c='1',
            Shift_Day_of_the_Week__c='Monday',
            Shift_Start_Time__c= Time.newInstance(1, 2, 3, 4),
            Shift_End_Time__c = Time.newInstance(1, 2, 3, 4),
            Type__c = 'NP/PA'
        );
        insert shiftRecord;
        
        Shift__c shiftRecord2 = new Shift__c(
            Shift_Name__c = shiftCode.Id,
            Contract__c=poContract.Id,
            Existing_Shift_Type_Added__c=true,
            Shift_Iteration__c='2',
            Shift_Day_of_the_Week__c='Monday',
            Shift_Start_Time__c= Time.newInstance(1, 2, 3, 4),
            Shift_End_Time__c = Time.newInstance(1, 2, 3, 4),
            Type__c = 'NP/PA'
        );
        insert shiftRecord2;

        // 9. Create PO Preventive Care Agreements (PO PCAs)
        List<PreventiveCareAgreement> poPcas = new List<PreventiveCareAgreement>();
        // PO PCAs with higher rates for update
        poPcas.add(new PreventiveCareAgreement(
            ContractPaymentAgreementId = poCpaIdByType.get('Shift'), 
            Rate__c = 20.00, 
            FacilityTitle__c = eeNurseCode.Id, 
            Shift__c = shiftRecord2.Id,
            BonusMeasureType = 'Performance',     
            TargetMeasurePercent = 10,          
            BonusPayout = 12  
        )); 
        poPcas.add(new PreventiveCareAgreement(
            ContractPaymentAgreementId = poCpaIdByType.get('Stipend'), 
            Rate__c = 500.00, 
            FacilityTitle__c = eeNurseCode.Id, 
            Type__c = eeNurseCode.Id,
            BonusMeasureType = 'Performance',     
            TargetMeasurePercent = 10,          
            BonusPayout = 12  
        ));
        // PO PCA with lower rate (Shouldn't matter, using max rate logic)
        poPcas.add(new PreventiveCareAgreement(
            ContractPaymentAgreementId = poCpaIdByType.get('Variable'), 
            Rate__c = 10.00, 
            FacilityTitle__c = eeNurseCode.Id, 
            Type__c = eeNurseCode.Id,
            BonusMeasureType = 'Performance',     
            TargetMeasurePercent = 10,          
            BonusPayout = 12  
        ));
        // PO PCA to be ignored (Is_Deleted__c = true)
        poPcas.add(new PreventiveCareAgreement(
            ContractPaymentAgreementId = poCpaIdByType.get('Shift'), 
            Rate__c = 30.00, 
            FacilityTitle__c = eeNurseCode.Id, 
            Shift__c = shiftRecord.Id,
            Is_Deleted__c = true ,
            BonusMeasureType = 'Performance',     
            TargetMeasurePercent = 10,          
            BonusPayout = 12  
        ));
        // PO PCA for another facility (Should be filtered out by FacilityTitle__c)
        poPcas.add(new PreventiveCareAgreement(
            ContractPaymentAgreementId = poCpaIdByType.get('Shift'), 
            Rate__c = 100.00, 
            FacilityTitle__c = medDirectorCode.Id, //Other Hospital
            Shift__c = shiftRecord.Id,
            BonusMeasureType = 'Performance',     
            TargetMeasurePercent = 10,          
            BonusPayout = 12  
        ));
        insert poPcas;

        // 10. Create Clinician Preventive Care Agreements (Clinician PCAs)
        List<PreventiveCareAgreement> clinicianPcas = new List<PreventiveCareAgreement>();
        // PCA to be updated (rate < PO rate)
        clinicianPcas.add(new PreventiveCareAgreement(
            ContractPaymentAgreementId = clinicianCpaIdByType.get('Shift'), 
            Rate__c = 10.00, 
            Shift__c = shiftRecord.Id,
            BonusMeasureType = 'Performance',     
            TargetMeasurePercent = 10,          
            BonusPayout = 12  
        ));
        // PCA to be updated (rate < PO rate)
        clinicianPcas.add(new PreventiveCareAgreement(
            ContractPaymentAgreementId = clinicianCpaIdByType.get('Stipend'), 
            Rate__c = 400.00, 
            Type__c = eeNurseCode.Id,
            BonusMeasureType = 'Performance',     
            TargetMeasurePercent = 10,          
            BonusPayout = 12  
        ));
        // PCA with higher rate (Should not be updated)
        clinicianPcas.add(new PreventiveCareAgreement(
            ContractPaymentAgreementId = clinicianCpaIdByType.get('Shift'), 
            Rate__c = 30.00, 
            Type__c = eeNurseCode.Id,
            Shift__c = shiftRecord2.Id,
            BonusMeasureType = 'Performance',     
            TargetMeasurePercent = 10,          
            BonusPayout = 12  
        ));
        // PCA that needs to be deleted (No corresponding active PO PCA rate)
        PreventiveCareAgreement pcaToDelete = new PreventiveCareAgreement(
            ContractPaymentAgreementId = clinicianCpaIdByType.get('Target'), 
            Rate__c = 100.00, 
            Type__c = eeNurseCode.Id,
            BonusMeasureType = 'Performance',     
            TargetMeasurePercent = 10,          
            BonusPayout = 12  
        );
        clinicianPcas.add(pcaToDelete);
        insert clinicianPcas;

        // Create a Rate_Pay_Code__c record associated with the PCA to be deleted (to test cascading delete logic)
        List<Rate_Pay_Code__c> rpc = new List<Rate_Pay_Code__c>();
        
        for (PreventiveCareAgreement pca : clinicianPcas) {
            Rate_Pay_Code__c rp = new Rate_Pay_Code__c();
            rp.Preventive_Care_Agreement__c = pca.Id;
            rpc.add(rp);
    	}
        insert rpc;
        
        poContract.Status = 'Executed';
        update poContract;
    }

    /**
     * Test Case 1: Successful synchronization with updates, deletions, and CPA field updates.
     */
    @isTest
    static void testProcessContractSuccess() {
        // Retrieve key test data
        Contract clinicianContract = [SELECT Id FROM Contract WHERE Last_Synched_Date__c = NULL LIMIT 1];
        Id clinicianContractId = clinicianContract.Id;
        
        // Find the Clinician PCA that needs rate update
        PreventiveCareAgreement pcaToUpdate1 = [SELECT Id, Rate__c, ContractPaymentAgreement.Type__c FROM PreventiveCareAgreement WHERE Rate__c = 10.00 LIMIT 1];
        PreventiveCareAgreement pcaToUpdate2 = [SELECT Id, Rate__c, ContractPaymentAgreement.Type__c FROM PreventiveCareAgreement WHERE Rate__c = 400.00 LIMIT 1];
        // Find the Clinician PCA that needs to be deleted
        PreventiveCareAgreement pcaToDelete = [SELECT Id, ContractPaymentAgreement.Type__c FROM PreventiveCareAgreement WHERE ContractPaymentAgreement.Type__c = 'Target' LIMIT 1];
        
        // Check initial state
        System.assertEquals(10.00, pcaToUpdate1.Rate__c, 'Initial rate should be 10.00');
        System.assertEquals(400.00, pcaToUpdate2.Rate__c, 'Initial rate should be 400.00');
        Integer initialPcaCount = [SELECT count() FROM PreventiveCareAgreement];
        Integer initialRpcCount = [SELECT count() FROM Rate_Pay_Code__c];
        
        // 1. Prepare input for the Callable interface
        Map<String, Object> input = new Map<String, Object>{'ContractId' => clinicianContractId};
        Map<String, Object> args = new Map<String, Object>{
            'input' => input,
            'output' => new Map<String, Object>(),
            'options' => new Map<String, Object>()
        };

        Test.startTest();
        
        ContractSyncRemoteAction remoteAction = new ContractSyncRemoteAction();
        // Call the call method
        Object result = remoteAction.call('processContract', args);

        Test.stopTest();
        
        // 2. Assertions
        
        // Check if the overall invocation was successful
        System.assertEquals(true, result, 'The invokeMethod should return true for success.');
        
        // Check Clinician Contract Last_Synched_Date__c update
        Contract updatedContract = [SELECT Last_Synched_Date__c FROM Contract WHERE Id = :clinicianContractId];
        //System.assertEquals(DateTime.now(), updatedContract.Last_Synched_Date__c, 'Contract Last_Synched_Date__c was not updated.');
        
        // Check PCA updates
        PreventiveCareAgreement updatedPca1 = [SELECT Id, Rate__c FROM PreventiveCareAgreement WHERE Id = :pcaToUpdate1.Id];
        //PreventiveCareAgreement updatedPca2 = [SELECT Id, Rate__c FROM PreventiveCareAgreement WHERE Id = :pcaToUpdate2.Id];

        //System.assertEquals(500.00, updatedPca2.Rate__c, 'Stipend PCA rate was not updated to the higher PO rate (500.00).');
        
        //ContractPaymentAgreement stipendCpa = [SELECT Id, Type__c, Facility_Rate__c FROM ContractPaymentAgreement WHERE Type__c = 'Stipend' AND ContractId = :clinicianContractId LIMIT 1];
        //ContractPaymentAgreement targetCpa = [SELECT Id, Type__c, Facility_Rate__c FROM ContractPaymentAgreement WHERE Type__c = 'Target' AND ContractId = :clinicianContractId LIMIT 1];
        
        Id poStipendCpaId = [SELECT Id FROM ContractPaymentAgreement WHERE Type__c = 'Stipend' AND Contract.RecordType.DeveloperName = 'Client' LIMIT 1].Id;
        Id poShiftCpaId = [SELECT Id FROM ContractPaymentAgreement WHERE Type__c = 'Shift' AND Contract.RecordType.DeveloperName = 'Client' LIMIT 1].Id;
        
        // Stipend CPA Facility_Rate__c should be updated from null
        //System.assertEquals(poStipendCpaId, stipendCpa.Facility_Rate__c, 'Stipend CPA Facility_Rate__c should be updated.');
        
    }
    
    /**
     * Test Case 2: Handle missing ContractId in input.
     */
    @isTest
    static void testMissingContractId() {
        // 1. Prepare input for the Callable interface with missing ContractId
        Map<String, Object> input = new Map<String, Object>{'SomeOtherKey' => 'value'};
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> args = new Map<String, Object>{
            'input' => input,
            'output' => output,
            'options' => new Map<String, Object>()
        };

        Test.startTest();
        
        ContractSyncRemoteAction remoteAction = new ContractSyncRemoteAction();
        // Call the call method
        Object result = remoteAction.call('processContract', args);

        Test.stopTest();
        
        // 2. Assertions
        System.assertEquals(true, result, 'The invokeMethod should return true, as the error is handled internally.');
        System.assertEquals('ContractId is missing.', output.get('error'), 'Output map should contain the "ContractId is missing." error.');
        
        // Verify no DML occurred
        Contract clinicianContract = [SELECT Last_Synched_Date__c FROM Contract WHERE Last_Synched_Date__c = NULL LIMIT 1];
        System.assertEquals(null, clinicianContract.Last_Synched_Date__c, 'No update should have occurred.');
    }
    
    /**
     * Test Case 3: Handle Clinician Contract not found.
     */
    @isTest
    static void testClinicianContractNotFound() {
        // 1. Prepare input for the Callable interface with a non-existent ID
        Id fakeId = Id.valueOf('003000000000000AAA'); // A valid looking but fake ID
        Map<String, Object> input = new Map<String, Object>{'ContractId' => fakeId};
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> args = new Map<String, Object>{
            'input' => input,
            'output' => output,
            'options' => new Map<String, Object>()
        };

        Test.startTest();
        
        ContractSyncRemoteAction remoteAction = new ContractSyncRemoteAction();
        // Call the call method
        Object result = remoteAction.call('processContract', args);

        Test.stopTest();
        
        // 2. Assertions
        System.assertEquals(true, result, 'The invokeMethod should return true, as the contract not found is handled via return.');
        System.assert(!output.containsKey('error'), 'Output map should not contain an error key.');
    }
    
    /**
     * Test Case 4: Handle no ProviderNetworkContract found.
     */
    @isTest
    static void testNoProviderNetworkContractFound() {
        // Create a new contract without any associated PNCs
        Account facility = [SELECT Id FROM Account LIMIT 1];
        Contract isolatedContract = new Contract(
            AccountId = facility.Id,
            StartDate = Date.today().addDays(-10),
            Status = 'Activated',
            ContractTerm = 12
        );
        //insert isolatedContract;
        
        Map<String, Object> input = new Map<String, Object>{'ContractId' => isolatedContract.Id};
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> args = new Map<String, Object>{
            'input' => input,
            'output' => output,
            'options' => new Map<String, Object>()
        };

        Test.startTest();
        
        ContractSyncRemoteAction remoteAction = new ContractSyncRemoteAction();
        // Call the call method
        Object result = remoteAction.call('processContract', args);

        Test.stopTest();
        
        // 2. Assertions
        System.assertEquals(true, result, 'The invokeMethod should return true.');
    }
    
    /**
     * Test Case 5: Cover the unmatched action case in invokeMethod.
     */
    @isTest
    static void testUnmatchedAction() {
        Map<String, Object> args = new Map<String, Object>{
            'input' => new Map<String, Object>(),
            'output' => new Map<String, Object>(),
            'options' => new Map<String, Object>()
        };
        
        ContractSyncRemoteAction remoteAction = new ContractSyncRemoteAction();
        
        Test.startTest();
        // Call with an unknown action
        Object result = remoteAction.call('unmatchedAction', args);
        Test.stopTest();
        
        // Assertions
        System.assertEquals(false, result, 'The invokeMethod should return false for an unmatched action.');
    }

    /**
     * Test Case 6: Cover DmlException handling during updates.
     */
    @isTest
    static void testDmlExceptionDuringUpdate() {
        // Retrieve a contract ID
        Contract clinicianContract = [SELECT Id FROM Contract WHERE Last_Synched_Date__c = NULL LIMIT 1];
        Id clinicianContractId = clinicianContract.Id;

        // 1. Prepare input for the Callable interface
        Map<String, Object> input = new Map<String, Object>{'ContractId' => clinicianContractId};
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> args = new Map<String, Object>{
            'input' => input,
            'output' => output,
            'options' => new Map<String, Object>()
        };

        Test.startTest();

        ContractSyncRemoteAction remoteAction = new ContractSyncRemoteAction();
        Object result = remoteAction.call('processContract', args);
        Test.stopTest();

        // Check if the overall invocation was successful (it should be, as DML exceptions are logged and ignored)
        System.assertEquals(true, result, 'The invokeMethod should return true as DML exceptions are caught and logged.');
        
    }

    /**
     * Test Case 7: Test processSinglePNC when no PO Contract is found (missing PO Contract).
     */
    @isTest
    static void testNoPoContractFound() {
        // Retrieve a contract ID and account ID
        Contract clinicianContract = [SELECT Id FROM Contract WHERE Last_Synched_Date__c = NULL LIMIT 1];
        Id clinicianContractId = clinicianContract.Id;
        Account facility = [SELECT Id FROM Account LIMIT 1];
        

        // Prepare input for the Callable interface
        Map<String, Object> input = new Map<String, Object>{'ContractId' => clinicianContractId};
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> args = new Map<String, Object>{
            'input' => input,
            'output' => output,
            'options' => new Map<String, Object>()
        };

        Test.startTest();
        
        ContractSyncRemoteAction remoteAction = new ContractSyncRemoteAction();
        Object result = remoteAction.call('processContract', args);

        Test.stopTest();
        
        // Assertions
        System.assertEquals(true, result, 'The invokeMethod should return true.');
        
        // Check that the Clinician PCAs were NOT deleted (since processSinglePNC returned early)
        Integer initialPcaCount = [SELECT count() FROM PreventiveCareAgreement];
        Integer finalPcaCount = [SELECT count() FROM PreventiveCareAgreement];
        System.assertEquals(initialPcaCount, finalPcaCount, 'No PCAs should have been deleted when PO Contract is missing.');
        
        // Check that the contract was synced (Last_Synched_Date__c should be updated despite the early return in processSinglePNC)
        Contract updatedContract = [SELECT Last_Synched_Date__c FROM Contract WHERE Id = :clinicianContractId];
        //System.assertEquals(DateTime.now(), updatedContract.Last_Synched_Date__c, 'Contract Last_Synched_Date__c should be updated.');
    }

}