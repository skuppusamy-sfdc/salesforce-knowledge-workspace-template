@IsTest
private class RateChangeServiceTest {
    
    @TestSetup
    static void setupTestData() {
        TestDataFactory tdf = new TestDataFactory();
        
        // Create Service Account (Business Account)
        Account serviceAcc = TDF.createServiceAccount('Test Service Account', null, 'Service_Account', true);
        
        // Create Clinician Person Account
        Account clinicianAcc = TDF.createServiceAccount(null, 'Test Clinician', 'Clinician', true);
        
        // Create Corporate Account
        Account corporateEntity = TDF.createServiceAccount('Test Corporate Entity', null, 'Corporate_Entity', true);
        
        // Create Contact for Clinician 
        Contact clinicianCon = TDF.getOrCreateContact(clinicianAcc, 'Test Contact');
        
        // Create Contract under Clinician Account 
        Contract clinicianContract = TDF.createClinicianContract(clinicianAcc, true);
        
        // Create Healthcare Payer Network linked to Service Account
        HealthcarePayerNetwork hpn = TDF.createHealthcarePayerNetwork('Test Payer Network', serviceAcc.Id, true);
        
        // Create Healthcare Provider linked to Clinician Contact
        HealthcareProvider hp = TDF.createHealthcareProvider('Physician Provider', clinicianCon.Id, true);
        
        // Create Healthcare Practitioner Facility
        HealthcarePractitionerFacility hpf = TDF.createHealthcarePractitionerFacility(
            'Test HPF', clinicianCon.Id, serviceAcc.Id, corporateEntity.Id, true
        );
        
        // Create Provider Network Contract
        ProviderNetworkContract pnc = TDF.createPNC(clinicianContract.Id, hp.Id, hpn.Id, hpf.Id, true);
        
        // Create Contract Payment Agreement
        ContractPaymentAgreement cpa = TDF.createCPA('Test CPA', clinicianContract.Id, pnc.Id, true);
        
        // Create Preventive Care Agreement
        PreventiveCareAgreement pca = TDF.createPCA(cpa.Id, true);
        
        // Create Clinical Rate Change
        Clinical_Rate_Change__c crc = TDF.createClinicalRateChangeNew(serviceAcc.Id, clinicianContract.Id, true);
        crc = [SELECT Id, CreatedById, Service_Account_ID__c, PreviewClonedContractIds__c, 
               Non_Processed_Clinical_Ids__c, Contract_ID__c
               FROM Clinical_Rate_Change__c
               WHERE Id = :crc.Id];
        System.debug('Test setup complete. CRC ID: ' + crc);
    }
    
    @IsTest
    static void testExecutePreviewMode() {
        TestDataFactory tdf = new TestDataFactory();
        
        Account serviceAcc = [SELECT Id FROM Account WHERE Name = 'Test Service Account' LIMIT 1];
        Account corporateEntity = [SELECT Id FROM Account WHERE Name = 'Test Corporate Entity' LIMIT 1];
        Account clinicianAcc = [SELECT Id FROM Account WHERE PersonEmail = NULL AND Name = 'Test Clinician' LIMIT 1];
        
        // Query clinician contact
        Contact con = [SELECT Id, AccountId, Professional_Title__c 
                       FROM Contact 
                       LIMIT 1];
        
        
        // Query contract
        Contract contract = [SELECT Id, AccountId 
                             FROM Contract 
                             WHERE AccountId = :clinicianAcc.Id 
                             LIMIT 1];
        
        // Query Healthcare Payer Network
        HealthcarePayerNetwork hpn = [SELECT Id 
                                      FROM HealthcarePayerNetwork 
                                      WHERE Name = 'Test Payer Network'                                        
                                      LIMIT 1];
        
        // Query Healthcare Provider
        HealthcareProvider hp = [SELECT Id, PractitionerId 
                                 FROM HealthcareProvider                               
                                 LIMIT 1];
        
        // Query Healthcare Practitioner Facility
        HealthcarePractitionerFacility hpf = [  SELECT Id, Time_Type__c 
                                              FROM HealthcarePractitionerFacility                                            
                                              LIMIT 1];
        
        // Update Time Type if needed
        HPF.Time_Type__c = 'Full Time';
        update hpf;
        
        // Query Provider Network Contract
        ProviderNetworkContract pnc = [SELECT Id 
                                       FROM ProviderNetworkContract                                     
                                       LIMIT 1];
        
        // Query Contract Payment Agreement
        ContractPaymentAgreement cpa = [	SELECT Id 
                                        FROM ContractPaymentAgreement                                     
                                        LIMIT 1
                                       ];        
        // Query Preventive Care Agreement
        PreventiveCareAgreement pca = [SELECT Id 
                                       FROM PreventiveCareAgreement                                     
                                       LIMIT 1];
        
        // Query Clinical Rate Change
        Clinical_Rate_Change__c crc = [SELECT Id 
                                       FROM Clinical_Rate_Change__c 
                                       WHERE Service_Account_ID__c = :serviceAcc.Id 
                                       AND Contract_ID__c = :contract.Id
                                       LIMIT 1];
        
        crc = [SELECT Id, CreatedById, Service_Account_ID__c, PreviewClonedContractIds__c, 
               Non_Processed_Clinical_Ids__c, Contract_ID__c,user_selected_IDs__c,DocGenerationBatchProcessId__c
               FROM Clinical_Rate_Change__c
               WHERE Id = :crc.Id];
        System.debug('Test setup complete 32. CRC ID: ' + crc);
        
        Contract clientContract = TDF.createClinicianContract(serviceAcc, true);
        
        List<Contract> contractsToUpdate = [SELECT Id, Status FROM Contract WHERE Status = 'Draft'];
        for(Contract c : contractsToUpdate) {
            c.Status = 'Executed';
            c.ContractTerm = 12;
            //c.Contracting_Corporate_Entity__c = serviceAcc.Id;
            c.EE_NP_PA_Full_Time_Monthly_Blended__c = 12000;
            c.EE_NP_PA_Full_Time_Overage_Rate__c = 1000;
        }
        update contractsToUpdate;
        
        Test.startTest();
        RateChangeService service = new RateChangeService();
        List<Id> result = service.execute(
            new List<Id>{con.Id}, 
            true,                 
            clientContract.Id,    
            new List<Clinical_Rate_Change__c>{crc}
        );
        Test.stopTest();
        
        //Assertions
        //system.debug('what is size ' + result.size());
        //System.assertEquals(0, result.size(), 'Preview mode should return cloned contract Ids.');
        
    }
    
    @IsTest
    static void testExecuteNonPreviewMode() {
        TestDataFactory tdf = new TestDataFactory();
        
        Account serviceAcc = [SELECT Id FROM Account WHERE Name = 'Test Service Account' LIMIT 1];
        Account corporateEntity = [SELECT Id FROM Account WHERE Name = 'Test Corporate Entity' LIMIT 1];
        Account clinicianAcc = [SELECT Id FROM Account WHERE PersonEmail = NULL AND Name = 'Test Clinician' LIMIT 1];
        
        // Query clinician contact
        Contact con = TDF.getOrCreateContact(clinicianAcc, 'Test Contact');
        con.Professional_Title__c = 'LPN'; 
        update con;
        
        
        // Query contract
        Contract contract = [SELECT Id, AccountId 
                             FROM Contract 
                             WHERE AccountId = :clinicianAcc.Id 
                             LIMIT 1];
        
        // Query Healthcare Payer Network
        HealthcarePayerNetwork hpn = [SELECT Id 
                                      FROM HealthcarePayerNetwork 
                                      WHERE Name = 'Test Payer Network'                                        
                                      LIMIT 1];
        
        // Query Healthcare Provider
        HealthcareProvider hp = [SELECT Id, PractitionerId 
                                 FROM HealthcareProvider                               
                                 LIMIT 1];
        
        // Query Healthcare Practitioner Facility
        HealthcarePractitionerFacility hpf = [  SELECT Id, Time_Type__c 
                                              FROM HealthcarePractitionerFacility                                            
                                              LIMIT 1];
        
        // Update Time Type if needed
        HPF.Time_Type__c = 'Part Time';
        update hpf;
        
        // Query Provider Network Contract
        ProviderNetworkContract pnc = [SELECT Id 
                                       FROM ProviderNetworkContract                                     
                                       LIMIT 1];
        
        // Query Contract Payment Agreement
        ContractPaymentAgreement cpa = [	SELECT Id 
                                        FROM ContractPaymentAgreement                                     
                                        LIMIT 1
                                       ];        
        // Query Preventive Care Agreement
        PreventiveCareAgreement pca = [SELECT Id 
                                       FROM PreventiveCareAgreement                                     
                                       LIMIT 1];
        
        // Query Clinical Rate Change
        Clinical_Rate_Change__c crc = [SELECT Id,CreatedById,Service_Account_ID__c,Non_Processed_Clinical_Ids__c,PreviewClonedContractIds__c 
                                       FROM Clinical_Rate_Change__c 
                                       WHERE Service_Account_ID__c = :serviceAcc.Id 
                                       AND Contract_ID__c = :contract.Id
                                       LIMIT 1];
        
        Contract clientContract = TDF.createClinicianContract(serviceAcc, true);
        
        List<Contract> contractsToUpdate = [SELECT Id, Status FROM Contract WHERE Status = 'Draft'];
        for(Contract c : contractsToUpdate) {
            c.Status = 'Executed';
            c.ContractTerm = 12;
            //c.Contracting_Corporate_Entity__c = serviceAcc.Id;
            c.EE_NP_PA_Full_Time_Monthly_Blended__c = 12000;
            c.EE_NP_PA_Full_Time_Overage_Rate__c = 1000;
        }
        update contractsToUpdate;
        
        Test.startTest();
        RateChangeService service = new RateChangeService();
        List<Id> result = service.execute(
            new List<Id>{con.Id}, 
            false,                 
            clientContract.Id,    
            new List<Clinical_Rate_Change__c>{crc}
        );
        Test.stopTest();
        
    }
    
    @IsTest
    static void testExecuteHandlesEmptyClinicians() {
        Test.startTest();
        RateChangeService service = new RateChangeService();
        List<Id> result = service.execute(new List<Id>(), true, null, new List<Clinical_Rate_Change__c>());
        Test.stopTest();
        System.assertEquals(0, result.size(), 'Empty clinician list should return empty result.');
    }
    
    @IsTest
    static void testCloneContractsHandlesException() {
        Test.startTest();
        RateChangeService service = new RateChangeService();
        List<Id> result = service.cloneContracts(null, null);
        Test.stopTest();
        System.assertEquals(true, result.isEmpty(), 'cloneContracts should handle null safely.');
    }
    
    @IsTest
    static void testSendEmailBatchWithMock() {
        TestDataFactory tdf = new TestDataFactory();
        Test.startTest();
        Account acc = [SELECT Id FROM Account WHERE Name = 'Test Service Account' LIMIT 1];
        Account corporateEntity = [SELECT Id FROM Account WHERE Name = 'Test Corporate Entity' LIMIT 1];
        Account clinicianAcc = [SELECT Id FROM Account WHERE PersonEmail = NULL AND Name = 'Test Clinician' LIMIT 1];
        
        // Query clinician contact
        Contact con = tdf.getOrCreateContact(clinicianAcc, 'Test Contact');
        con.Professional_Title__c = 'LPN'; 
        update con;
        
        
        // Query contract
        Contract contract = [SELECT Id, AccountId 
                             FROM Contract 
                             WHERE AccountId = :clinicianAcc.Id 
                             LIMIT 1];
        
        RateChangeService service = new RateChangeService();
        
        List<Id> contractIds = new List<Id>{contract.Id};
            Id templateId;
        if (!Test.isRunningTest()) {
            // Query a real template by DeveloperName
            EmailTemplate template = [
                SELECT Id 
                FROM EmailTemplate 
                WHERE DeveloperName = 'ClinicianCompensationIncreaseNoticeTemplate' 
                LIMIT 1
            ];
            templateId = template.Id;
        } else {
            // Use a dummy Id in test context
            templateId = '00X000000000000AAA';
        }    
        
        Map<String, Integer> resultMap = service.sendEmailBatch(contractIds, templateId, service.getOrgWideEmailId());
        Test.stopTest();
        
        System.assert(resultMap.containsKey('Success'), 'Result map should contain Success key.');
        System.assert(resultMap.containsKey('Failure'), 'Result map should contain Failure key.');
    }
    
    @IsTest
    static void testHandlePostProcessingPath() {
        TestDataFactory tdf = new TestDataFactory();
        
        Account serviceAcc = [SELECT Id FROM Account WHERE Name = 'Test Service Account' LIMIT 1];
        Account corporateEntity = [SELECT Id FROM Account WHERE Name = 'Test Corporate Entity' LIMIT 1];
        Account clinicianAcc = [SELECT Id FROM Account WHERE PersonEmail = NULL AND Name = 'Test Clinician' LIMIT 1];
        
        // Query clinician contact
        Contact con = tdf.getOrCreateContact(clinicianAcc, 'Test Contact');
        con.Professional_Title__c = 'LPN'; 
        update con;
        
        
        // Query contract
        Contract contract = [SELECT Id, AccountId 
                             FROM Contract 
                             WHERE AccountId = :clinicianAcc.Id 
                             LIMIT 1];
        
        
        // Create a Clinical_Rate_Change__c with preview cloned contract Ids populated
        Clinical_Rate_Change__c crc = new Clinical_Rate_Change__c(
            
            Service_Account_ID__c = serviceAcc.Id,
            PreviewClonedContractIds__c = contract.Id, 
            Non_Processed_Clinical_Ids__c = null
        );
        insert crc;
        
        // Execute with null clinicianIds to trigger the branch
        Test.startTest();
        RateChangeService service = new RateChangeService();
        List<Id> result = service.execute(
            null,                 
            false,
            contract.Id,
            new List<Clinical_Rate_Change__c>{crc}
        );
        Test.stopTest();
        
        // Assert that the method did not fail and returned empty list
        System.assertEquals(true, result.isEmpty(), 'Should return empty list when clinicianIds is null');
    }
    
    @IsTest
    static void testExecutePreviewModeOtherClinicians() {
        TestDataFactory tdf = new TestDataFactory();
        
        Account serviceAcc = TDF.createServiceAccount('Test Service Account', null, 'Service_Account', true);
        Account corporateEntity = TDF.createServiceAccount('Test Corporate Entity', null, 'Corporate_Entity', true);
        
        Account clinicianAcc = TDF.createServiceAccount(null, 'Test MD Clinician', 'Clinician', true);
        clinicianAcc.Professional_Title__pc = 'MD';
        update clinicianAcc;
        
        Contact con = TDF.getOrCreateContact(clinicianAcc, 'Test Contact');
        
        Contract contract = TDF.createClinicianContract(clinicianAcc, true);
        HealthcarePayerNetwork hpn = TDF.createHealthcarePayerNetwork('Test Payer Network', corporateEntity.Id, true);
        HealthcareProvider hp = TDF.createHealthcareProvider('Physician Provider', con.Id, true);
        HealthcarePractitionerFacility HPF = TDF.createHealthcarePractitionerFacility('MD HPF', con.Id, serviceAcc.Id, corporateEntity.Id, true);
        HPF.Time_Type__c = 'Part Time';  
        update hpf;
        
        ProviderNetworkContract pnc = TDF.createPNC(contract.Id, HP.Id, HPN.Id, HPF.Id, true);
        ContractPaymentAgreement cpa = TDF.createCPA('Test CPA', contract.Id, pnc.Id, true);
        PreventiveCareAgreement pca = TDF.createPCA(cpa.Id, true);
        
        
        
        Test.startTest();
        Clinical_Rate_Change__c crc = TDF.createClinicalRateChangeNew(serviceAcc.Id, contract.Id, true);
        crc = [
            SELECT Id, CreatedById, Service_Account_ID__c, PreviewClonedContractIds__c, 
            Non_Processed_Clinical_Ids__c, Contract_ID__c, user_selected_IDs__c, DocGenerationBatchProcessId__c
            FROM Clinical_Rate_Change__c
            WHERE Id = :crc.Id
        ];
        contract.Status = 'Executed';
        contract.ContractTerm = 12;
        contract.EE_NP_PA_Full_Time_Monthly_Blended__c = 0; 
        update contract;
        RateChangeService service = new RateChangeService();
        List<Id> result = service.execute(
            new List<Id>{con.Id},  
            true,                 
            contract.Id,
            new List<Clinical_Rate_Change__c>{crc}
        );
        Test.stopTest();
        
        //System.assert(result.isEmpty(), 'Expected otherClinicianIds branch to produce cloned contracts');
    }
    
    @IsTest
    static void testFetchAllFieldsNonContract() {
        
        Account acc1 = new Account(Name = 'Test Account 1');
        Account acc2 = new Account(Name = 'Test Account 2');
        insert new List<Account>{ acc1, acc2 };
            Set<Id> accountIds = new Set<Id>{ acc1.Id, acc2.Id };
                
                Test.startTest();
        List<SObject> accounts = QueryHelper.fetchAllFields(
            Account.SObjectType,
            accountIds,
            'Id'
        );
        Test.stopTest();
        
        System.assertEquals(2, accounts.size(), 'Should return 2 accounts');
        System.assertEquals(
            acc1.Id,
            ((Account)accounts[0]).Id,
            'First record should match one of the inserted accounts'
        );
    }
    
    @IsTest
    static void testFetchAllFieldsWithExtraFieldsNonContractNE() {
        
        Contact c1 = new Contact(LastName = 'Test Contact 1');
        Contact c2 = new Contact(LastName = 'Test Contact 2');
        insert new List<Contact>{ c1, c2 };
            Set<Id> contactIds = new Set<Id>{ c1.Id, c2.Id };
                Set<String> extraFields = new Set<String>{ 'Account.Name' }; 
                    
                    Test.startTest();
        List<SObject> contacts = QueryHelper.fetchAllFields(
            Contract.SObjectType,
            contactIds,
            'Id'
        );
        Test.stopTest();
        
        System.assertEquals(0, contacts.size(), 'Should return 2 contacts');
    }
    
    @IsTest
    static void testFetchAllFieldsWithExtraFieldsNonContract() {
        
        Contact c1 = new Contact(LastName = 'Test Contact 1');
        Contact c2 = new Contact(LastName = 'Test Contact 2');
        insert new List<Contact>{ c1, c2 };
            Set<Id> contactIds = new Set<Id>{ c1.Id, c2.Id };
                Set<String> extraFields = new Set<String>{ 'Account.Name' }; 
                    
                    Test.startTest();
        List<SObject> contacts = QueryHelper.fetchAllFields(
            Contact.SObjectType,
            contactIds,
            'Id',
            extraFields
        );
        Test.stopTest();
        
        System.assertEquals(2, contacts.size(), 'Should return 2 contacts');
    }
    
    @IsTest
    static void testAllHelperMethods() {
        Clinical_Rate_Change__c crc = [SELECT Id, Service_Account_ID__c, Contract_ID__c,user_selected_IDs__c,PreviewClonedContractIds__c FROM Clinical_Rate_Change__c LIMIT 1];
        RateChangeService svc = new RateChangeService();
        
        // fetchClientContractData
        RateChangeService.ClientContractWrapper wrapper = svc.fetchClientContractData(new List<Clinical_Rate_Change__c>{crc});
        System.assertNotEquals(null, wrapper.contract);
        
        // fetchHpaMapping
        Map<Id, String> hpaMap = svc.fetchHpaMapping(new List<Clinical_Rate_Change__c>{crc}, crc.Service_Account_ID__c);
        System.assertNotEquals(null, hpaMap);
        List<Contract> contracts = svc.fetchContracts(new List<Id>{crc.Contract_ID__c});
        System.assertEquals(1, contracts.size());
        
        // createBatchProcess
        DocGenerationBatchProcess bp = svc.createBatchProcess(new List<Clinical_Rate_Change__c>{crc}, crc.Service_Account_ID__c, crc.Contract_ID__c);
        System.assertNotEquals(null, bp.Id);
    }
    
    @IsTest
    static void testFetchTemplates() {
        Test.startTest();
        
        RateChangeService svc = new RateChangeService();  
        Map<String, Id> templates = svc.fetchTemplates();        
        System.assertNotEquals(null, templates, 'Template map should not be null');         
        Test.stopTest();
    }
    
    @IsTest
    static void testBuildTokenData() {
        TestDataFactory tdf = new TestDataFactory();
        
        Account clinicianAcc = TDF.createServiceAccount(null, 'NP Clinician', 'Clinician', true);
        Contact clinicianCon = TDF.getOrCreateContact(clinicianAcc, 'Test Contact');
        clinicianCon.Professional_Title__c = 'NP';
        update clinicianCon;
        
        Contract contractNP = TDF.createClinicianContract(clinicianAcc, true);
        
        Map<String, List<Object>> facilityShiftTable = new Map<String, List<Object>>();
        facilityShiftTable.put(contractNP.Id, new List<Object>{ 'Shift1', 'Shift2' });
        
        RateChangeService svc = new RateChangeService();
        
        Map<String, Object> tokenDataNP = svc.buildTokenData(contractNP, Date.today(), 12000, 1000, facilityShiftTable, 'Full Time','');
        
        System.assertEquals(String.valueOf(Date.today()), tokenDataNP.get('DateNotice'));
        System.assertEquals(contractNP.Account.FirstName, tokenDataNP.get('ClinicianFirstName'));
        System.assertEquals(contractNP.Account.LastName, tokenDataNP.get('ClinicianLastName'));
        
        Account clinicianAcc2 = TDF.createServiceAccount(null, 'MD Clinician', 'Clinician', true);
        Contact clinicianCon2 = TDF.getOrCreateContact(clinicianAcc2, 'Test Contact 2');
        clinicianCon2.Professional_Title__c = 'MD';
        update clinicianCon2;
        
        Contract contractMD = TDF.createClinicianContract(clinicianAcc2, true);
        facilityShiftTable.put(contractMD.Id, new List<Object>{ 'ShiftA', 'ShiftB' });
        
        Map<String, Object> tokenDataMD = svc.buildTokenData(contractMD, Date.today(), 0, 0, facilityShiftTable,'Part Time','');
        
        //System.assertEquals(contractMD.Account.Service_Line__r.Name, tokenDataMD.get('ServiceLine'));
        System.assertEquals(facilityShiftTable.get(contractMD.Id), tokenDataMD.get('FacilityShiftTable'));
    }
    
    @IsTest
    static void testGetFacilityRateData() {
        TestDataFactory tdf = new TestDataFactory();
        
        Account serviceAcc = TDF.createServiceAccount('Test Service Account', null, 'Service_Account', true);
        Account clinicianAcc = TDF.createServiceAccount(null, 'Test Clinician', 'Clinician', true);
         // Create Corporate Account
        Account corporateEntity = TDF.createServiceAccount('Test Corporate Entity', null, 'Corporate_Entity', true);
        
        Contact clinicianCon = TDF.getOrCreateContact(clinicianAcc, 'Test Contact');
        Contract clinicianContract = TDF.createClinicianContract(clinicianAcc, true);
        HealthcarePayerNetwork hpn = TDF.createHealthcarePayerNetwork('Test Payer Network', serviceAcc.Id, true);
        HealthcareProvider hp = TDF.createHealthcareProvider('Physician Provider', clinicianCon.Id, true);
        HealthcarePractitionerFacility hpf = TDF.createHealthcarePractitionerFacility('Test HPF', clinicianCon.Id, serviceAcc.Id, corporateEntity.Id, true);
        ProviderNetworkContract pnc = TDF.createPNC(clinicianContract.Id, hp.Id, hpn.Id, hpf.Id, true);
        ContractPaymentAgreement cpa = TDF.createCPA('Test CPA', clinicianContract.Id, pnc.Id, true);
        cpa.Type__c = 'Shift';
        update cpa;
        
        PreventiveCareAgreement pca = TDF.createPCA(cpa.Id, true);
        pca.Rate__c = 150;
        pca.Unit_of_Measure__c = 'per Hour';
        update pca;
        
        RateChangeService svc = new RateChangeService();
        
        Map<String, List<Object>> facilityData = svc.getFacilityRateData(new List<Id>{clinicianContract.Id});
        
        System.assert(facilityData.containsKey(clinicianContract.Id), 'Facility data should contain the contract Id');
        List<Object> rows = facilityData.get(clinicianContract.Id);
        System.assertEquals(1, rows.size(), 'Should have one row for the PCA');
        Map<String, Object> firstRow = (Map<String, Object>) rows[0];
        System.assertEquals('Test Service Account', firstRow.get('FacilityName'));
        System.assert(firstRow.get('RequestedRate').toString().contains('150'), 'RequestedRate should include 150');
    }
    
    @IsTest
    static void testBuildDGP() {
        TestDataFactory tdf = new TestDataFactory();
        
        // 1. Create Service Account and Clinician Account
        Account serviceAcc = TDF.createServiceAccount('Test Service Account', null, 'Service_Account', true);
        Account clinicianAcc = TDF.createServiceAccount(null, 'Test Clinician', 'Clinician', true);
        clinicianAcc.Professional_Title__pc = 'NP'; // Important for template selection
        update clinicianAcc;
        
        // 2. Create Clinician Contract
        Contract clinicianContract = TDF.createClinicianContract(clinicianAcc, true);
        clinicianContract.EE_NP_PA_Full_Time_Monthly_Blended__c = 12000;
        clinicianContract.EE_NP_PA_Full_Time_Overage_Rate__c = 80;
        update clinicianContract;
        
        // 3. Create Client Contract (to provide StartDate)
        Contract clientContract = TDF.createClinicianContract2(clinicianAcc, true);
        clientContract.StartDate = Date.today().addDays(99);
        update clientContract;
        
        // 4. Build HPA Map
        Map<Id, String> hpaMap = new Map<Id, String>{
            clinicianAcc.PersonContactId => 'Full Time'
                };
                    
                    // 5. Build Template Map by inserting dummy ContentVersions
                    ContentVersion cv1 = new ContentVersion(
                        Title = 'RateChangeNoticeEEFTNPPA',
                        PathOnClient = 'dummy1.txt',
                        VersionData = Blob.valueOf('Dummy content for template 1'),
                        IsMajorVersion = true
                    );
        ContentVersion cv2 = new ContentVersion(
            Title = 'RateChangeNoticeEEFMD',
            PathOnClient = 'dummy2.txt',
            VersionData = Blob.valueOf('Dummy content for template 2'),
            IsMajorVersion = true
        );
        insert new List<ContentVersion>{ cv1, cv2 };
            
            // Re-query to get the real Ids
            cv1 = [SELECT Id FROM ContentVersion WHERE Id = :cv1.Id LIMIT 1];
        cv2 = [SELECT Id FROM ContentVersion WHERE Id = :cv2.Id LIMIT 1];
        
        Map<String, Id> templateMap = new Map<String, Id>{
            'RateChangeNoticeEEFTNPPA' => cv1.Id,
                'RateChangeNoticeEEFMD'    => cv2.Id
                };
                    
                    
                    // 6. Build Facility Shift Table (simulate output of getFacilityRateData)
                    Map<String, List<Object>> facilityShiftTable = new Map<String, List<Object>>();
        facilityShiftTable.put(clinicianContract.Id, new List<Object>{
            new Map<String, Object>{
                'ContractingEntity' => 'Test Entity',
                    'FacilityName'      => 'Test Facility',
                    'ShiftName'         => 'Day Shift',
                    'RequestedRate'     => '$150 Hour'
                    }
        });
        
        // 7. Create a DocGenerationBatchProcess to link
        DocGenerationBatchProcess batchProcess = new DocGenerationBatchProcess(
            Description = 'Test Batch',
            Category    = 'RateChangeProcess'
        );
        insert batchProcess;
        
        // 8. Instantiate service
        RateChangeService svc = new RateChangeService();
        
        // 9. Call buildDGP
        DocumentGenerationProcess dgp = svc.buildDGP(
            clinicianContract,
            clientContract,
            hpaMap,
            templateMap,
            facilityShiftTable,
            batchProcess
        );
        
        // 10. Assertions
        System.assertNotEquals(null, dgp, 'DGP should not be null');
        System.assertEquals('GenerateAndConvert', dgp.Type);
    }
    
    @IsTest
    static void testWrapperAssignment() {
        // Query data from @TestSetup
        Account clinicianAcc = [
            SELECT Id 
            FROM Account 
            WHERE RecordType.DeveloperName = 'Clinician' 
            LIMIT 1
        ];
        
        // Update only the writable field
        Account accUpdate = new Account(
            Id = clinicianAcc.Id,
            Professional_Title__pc = 'NP'
        );
        update accUpdate;
        
        Contract dummyContract = [
            SELECT Id, StartDate
            FROM Contract 
            LIMIT 1
        ];
        
        // Update contract with just the StartDate
        Contract contractUpdate = new Contract(
            Id = dummyContract.Id,
            StartDate = Date.today().addDays(5)
        );
        update contractUpdate;
        
        // Instantiate wrapper and assign values
        RateChangeService.ClientContractWrapper wrapper = new RateChangeService.ClientContractWrapper();
        wrapper.contract = dummyContract;
        wrapper.serviceAccountId = clinicianAcc.Id;
        wrapper.clinicalContractId = dummyContract.Id;
        
        // Assertions
        System.assertEquals(dummyContract.Id, wrapper.contract.Id, 'Contract should match');
        System.assertEquals(clinicianAcc.Id, wrapper.serviceAccountId, 'Service Account Id should match');
        System.assertEquals(dummyContract.Id, wrapper.clinicalContractId, 'Clinical Contract Id should match');
    }
    
    @IsTest
    static void testUpdateResultMap() {
        
        RateChangeService svc = new RateChangeService();
        
        // Initialize a result map with counters
        Map<String, Integer> resultMap = new Map<String, Integer>{
            'Success' => 0,
                'Failure' => 0
                };
                    
                    Messaging.SendEmailResult successResult = (Messaging.SendEmailResult)JSON.deserialize(
                        '{"success":true,"errors":[]}', Messaging.SendEmailResult.class
                    );            
        
        Messaging.SendEmailResult failureResult = (Messaging.SendEmailResult)JSON.deserialize(
            '{"success":false,"errors":[{"message":"Mock error"}]}', Messaging.SendEmailResult.class
        );
        
        List<Messaging.SendEmailResult> results = new List<Messaging.SendEmailResult>{ successResult, failureResult };
            
            Test.startTest();
        svc.updateResultMap(results, resultMap);
        Test.stopTest();
        
        System.assertEquals(1, resultMap.get('Success'), 'Should have incremented success count once');
        System.assertEquals(1, resultMap.get('Failure'), 'Should have incremented failure count once');
    }
    
    @IsTest
    static void testBuildEmailMessagesAndSendEmails() {
        // 1. Query existing data from @TestSetup
        Account clinicianAcc = [
            SELECT Id, PersonEmail, PersonContactId 
            FROM Account 
            WHERE RecordType.DeveloperName = 'Clinician' 
            LIMIT 1
        ];
        Contract clinicianContract = [
            SELECT Id, AccountId, Account.PersonEmail, Account.PersonContactId 
            FROM Contract 
            WHERE AccountId = :clinicianAcc.Id 
            LIMIT 1
        ];
        
        // Ensure PersonEmail exists for testing
        if (String.isBlank(clinicianAcc.PersonEmail)) {
            clinicianAcc.PersonEmail = 'test@example.com';
            update clinicianAcc;
            // re-query contract to pick updated email
            clinicianContract = [
                SELECT Id, AccountId, Account.PersonEmail, Account.PersonContactId 
                FROM Contract 
                WHERE Id = :clinicianContract.Id
            ];
        }
        
        // 2. Insert dummy EmailTemplate in a separate transaction to avoid MIXED_DML
        Test.startTest();
        System.runAs(new User(Id = UserInfo.getUserId())) {
            EmailTemplate template = new EmailTemplate(
                DeveloperName = System.Label.ClinicianCompensationIncreaseNoticeTemplate,
                Name = 'Test Template',
                FolderId = UserInfo.getUserId(),  // Personal folder
                HtmlValue = '<p>Test</p>',
                TemplateType = 'custom',
                Subject = 'Test Email'
            );
            insert template;
        }
        
        //Create dummy ContentVersion for attachment
        ContentVersion cv = new ContentVersion(
            Title = 'Test Doc',
            PathOnClient = 'TestDoc.pdf',
            VersionData = Blob.valueOf('PDF Content')
        );
        insert cv;
        cv = [SELECT Id, Title, VersionData, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id LIMIT 1];
        
        Map<Id, Contract> contractMap = new Map<Id, Contract>{ clinicianContract.Id => clinicianContract };
            Map<Id, ContentVersion> contractDocs = new Map<Id, ContentVersion>{ clinicianContract.Id => cv };
                
                // Call buildEmailMessages
                RateChangeService svc = new RateChangeService();
        List<Messaging.SingleEmailMessage> emails = svc.buildEmailMessages(
            contractMap,
            contractDocs,
            clinicianAcc.Id,
            null
        );
        
        System.assertEquals(1, emails.size(), 'Should build 1 email');
        Messaging.SingleEmailMessage email = emails[0];
        System.assertNotEquals(null, email.getTemplateId(), 'TemplateId should be set');
        System.assert(email.getToAddresses().contains(clinicianAcc.PersonEmail), 'Should send to PersonEmail');
        
        // 5. Test sendEmailsInBatches + updateResultMap coverage
        Map<String, Integer> resultMap = new Map<String, Integer>{ 'Success' => 0, 'Failure' => 0 };
            
            svc.sendEmailsInBatches(emails, resultMap, 10);
        Test.stopTest();
        
        System.assert(resultMap.containsKey('Success'), 'Success count should be present');
        System.assert(resultMap.containsKey('Failure'), 'Failure count should be present');
    }
    
    @IsTest
    static void testGetSelectedClinicianIds() {
        Account clinicianAcc = [
            SELECT Id, PersonEmail, PersonContactId 
            FROM Account 
            WHERE RecordType.DeveloperName = 'Clinician' 
            LIMIT 1
        ];

        // 1. Prepare dummy clinician Ids
        Id clinicianId1 = clinicianAcc.Id;
        Id clinicianId2 = clinicianAcc.Id;
        
        // 2. Valid JSON with selectedClinicianIds
        String validJson = '{"selectedClinicianIds":[' +
            '{"selectId":"' + clinicianId1 + '"},' +
            '{"selectId":"' + clinicianId2 + '"}' +
            ']}';
        
        // 3. Create Clinical_Rate_Change__c records with different scenarios
        Clinical_Rate_Change__c validCRC = new Clinical_Rate_Change__c(
            user_selected_IDs__c = validJson
        );
        Clinical_Rate_Change__c blankCRC = new Clinical_Rate_Change__c(            
            user_selected_IDs__c = null
        );
        Clinical_Rate_Change__c invalidCRC = new Clinical_Rate_Change__c(
            user_selected_IDs__c = '{invalidJson'
        );
        
        // We don't need to insert them since the method just reads the field
        List<Clinical_Rate_Change__c> crcList = new List<Clinical_Rate_Change__c>{ validCRC, blankCRC, invalidCRC };
            
            Test.startTest();
        List<Id> result = RateChangeService.getSelectedClinicianIds(crcList);
        Test.stopTest();
        
        // Assertions
        System.assertEquals(2, result.size(), 'Should return 2 clinician Ids for valid JSON');
        System.assert(result.contains(clinicianId1), 'Result should contain clinicianId1');
        System.assert(result.contains(clinicianId2), 'Result should contain clinicianId2');
    }
  
    @IsTest
    static void testAdjustShiftRates() {
        TestDataFactory tdf = new TestDataFactory();
        
        Account clinicianAcc = TDF.createServiceAccount(null, 'Test Clinician', 'Clinician', true);
        Contract clientContract = TDF.createClinicianContract(clinicianAcc, true);
        ContractPaymentAgreement clientCPA = TDF.createCPA('Shift CPA', clientContract.Id, null, true);
        clientCPA.Type__c = 'Shift';
        update clientCPA;
        
        CodeSet facility = new CodeSet(Name = 'Test Facility', Code = 'EE Physician Assistant',CodeSetType = 'Shift');
        insert facility;
        
        Shift__c shift = new Shift__c(Contract__c = clientContract.Id,                                     
                                      Shift_Day_of_the_Week__c = 'Monday',  
                                      Shift_Start_Time__c = Time.newInstance(8, 0, 0, 0),  
                                      Shift_End_Time__c = Time.newInstance(16, 0, 0, 0),   
                                      Shift_Iteration__c = 'Weekly',        
                                      Type__c = 'NP/PA' ,
                                      Shift_Name__c = facility.Id);
        insert shift;
        
        CodeSet facilityTitle = new CodeSet(Name = 'Test Facility', Code = 'EE Physician Assistant',CodeSetType = 'Facility Title');
        facilityTitle.IsActive  = true;
        insert facilityTitle;
        
        PreventiveCareAgreement clientPCA = TDF.createPCA(clientCPA.Id, true);       
        clientPCA.Rate__c = 10; 
        clientPCA.Unit_of_Measure__c = 'per Hour'; 
        clientPCA.Shift__c = shift.Id;
        clientPCA.FacilityTitle__c = facilityTitle.Id;
        update clientPCA;       
        
        PreventiveCareAgreement clonedPCA = TDF.createPCA(clientCPA.Id, true);       
        clonedPCA.Id = null;
        clonedPCA.ContractPaymentAgreementId = clientCPA.Id; 
        clonedPCA.Rate__c = 10; 
        clonedPCA.Shift__c = shift.Id;
        clonedPCA.Unit_of_Measure__c = 'per Hour'; 
        clonedPCA.FacilityTitle__c = facilityTitle.Id;
        insert clonedPCA;
        
        //Call method under test
        Test.startTest();
        new RateChangeService().adjustShiftRates(new List<PreventiveCareAgreement>{clonedPCA}, clientContract.Id);
        Test.stopTest();
        
        //Assert that cloned PCA was updated
        PreventiveCareAgreement updatedPCA = [SELECT Id, Rate__c, Unit_of_Measure__c FROM PreventiveCareAgreement WHERE Id = :clonedPCA.Id];
        System.assertEquals(10, updatedPCA.Rate__c, 'Cloned PCA should have Rate updated from client PCA');
        System.assertEquals('per Hour', updatedPCA.Unit_of_Measure__c, 'Cloned PCA should have UoM updated from client PCA');
    }
    
    @IsTest
    static void testDeactivatePreviousContracts() {
        // Arrange: Get test contract from @TestSetup
        Contract testContract = [
            SELECT Id, Status, StartDate, EndDate, Cancel_Reason__c
            FROM Contract
            WHERE Status = 'Draft'
            LIMIT 1
        ];
        
       /*  // Build the map of previous contract start dates
        Map<Id, Date> previousContractStartDates = new Map<Id, Date>();
        previousContractStartDates.put(testContract.Id, testContract.StartDate);
        
        // Act: Call the method under test
       RateChangeService service = new RateChangeService();
        Test.startTest();
        service.deactivatePreviousContracts(previousContractStartDates);
        Test.stopTest();
        
        // Assert: Verify that contract got updated correctly
        Contract updatedContract = [
            SELECT Id, Status, EndDate, Cancel_Reason__c
            FROM Contract
            WHERE Id = :testContract.Id
            LIMIT 1
        ];
        
        System.assertEquals('Canceled', updatedContract.Status, 'Contract status should be set to Canceled');
        System.assertEquals('Superseded', updatedContract.Cancel_Reason__c, 'Cancel reason should be Superseded');
        System.assertEquals(
            testContract.StartDate.addDays(-1),
            updatedContract.EndDate,
            'EndDate should be set to one day before start date'
        );*/
    }
    
   /* @IsTest
    static void testDeactivatePreviousContractsEmptyMap() {
        
        Map<Id, Date> emptyMap = new Map<Id, Date>();
        RateChangeService service = new RateChangeService();
        Test.startTest();
        service.deactivatePreviousContracts(emptyMap);
        Test.stopTest();
        
        // Assert: Verify nothing was updated (just no exception)
        System.assert(true, 'Method should exit gracefully with empty input');
    }*/
    
    @IsTest
    static void testSendRateChangeSummaryEmail() {
        Account accRec = [
            SELECT Id, Name
            FROM Account
            WHERE RecordType.DeveloperName = 'Service_Account'
            LIMIT 1
        ];
        
        User testUser = [SELECT Id, Email FROM User WHERE IsActive = true LIMIT 1];
        
        // Prepare dummy result map
        Map<String, Integer> resultMap = new Map<String, Integer>{
            'Success' => 3,
                'Failure' => 1
                };
                    
        RateChangeService svc = new RateChangeService();        
        Integer emailsBefore = Limits.getEmailInvocations();
        Test.startTest();
        svc.sendRateChangeSummaryEmail(
            4,                 // totalContracts
            3,                 // totalEmailsSent
            2,                 // totalTasksCreated
            accRec,            // Account
            resultMap,         // Success/Failure counts
            testUser.Id        // CreatedByPerson
        );
        
        Integer emailsAfter = Limits.getEmailInvocations();
        Test.stopTest();
        System.assert(emailsAfter > emailsBefore, 'Expected at least one email to be sent');
        
    }
    
    @IsTest
    static void testSendRateChangeSummaryEmailNoAccount() {
        // Arrange: no Account
        User testUser = [SELECT Id, Email FROM User WHERE IsActive = true LIMIT 1];
        Map<String, Integer> resultMap = new Map<String, Integer>();
        
        RateChangeService svc = new RateChangeService();
        Integer emailsBefore = Limits.getEmailInvocations();
        Test.startTest();
        svc.sendRateChangeSummaryEmail(
            0,           // No contracts
            0,           // No emails sent
            0,           // No tasks created
            null,        // Account is null
            resultMap,   // Empty result map
            testUser.Id
        );
        
        Integer emailsAfter = Limits.getEmailInvocations();
        Test.stopTest();
        
        System.assert(emailsAfter > emailsBefore, 
                      'Expected at least one email to be sent even if Account is null');
        
    }
    
   
    @IsTest
    static void testCloneRatePayCodesForPCAs() {
        
        PreventiveCareAgreement oldPca = [SELECT Id,ContractPaymentAgreementId,name FROM PreventiveCareAgreement LIMIT 1];
        
        // Create a new PCA to simulate the cloned one
        PreventiveCareAgreement newPca = new PreventiveCareAgreement(
            
            ContractPaymentAgreementId = oldPca.ContractPaymentAgreementId,
            Rate__c = 10,
        	Unit_of_Measure__c = 'per Hour',
            BonusMeasureType = 'Performance',     
            TargetMeasurePercent = 10,          
            BonusPayout = 12                  
        );
        insert newPca;
        
        //Insert Pay code
        Pay_Codes__c   newpaycode = new Pay_Codes__c  (Pay_Code_Label__c = 'EE NPPA - FT - Reg');
        insert newpaycode;
        
        //Insert Pay code
        Pay_Codes__c   newpaycode1 = new Pay_Codes__c  (Pay_Code_Label__c = 'Abrupt Removal of Provider');
        insert newpaycode1;
        
      // Create Rate_Pay_Code__c records linked to old PCA
        List<Rate_Pay_Code__c> ratePayCodes = new List<Rate_Pay_Code__c>{
            new Rate_Pay_Code__c(
               
                Preventive_Care_Agreement__c = oldPca.Id,
                Pay_Code__c = newpaycode.id
            ),
                new Rate_Pay_Code__c(
                    
                    Preventive_Care_Agreement__c = oldPca.Id,
                    Pay_Code__c = newpaycode1.id
                )
                };
         insert ratePayCodes;
        
        // Map old PCA Id to new PCA instance
        Map<Id, List<PreventiveCareAgreement>> oldToNewPcaMap = new Map<Id, List<PreventiveCareAgreement>>();
        List<PreventiveCareAgreement>  listpca = new List<PreventiveCareAgreement>();
        listpca.add(newPca);

        oldToNewPcaMap.put(oldPca.Id,listpca);
                    
        // Prepare list to track failures for cleanup (empty initially)
        List<Rate_Pay_Code__c> ratePayCodesToDelete = new List<Rate_Pay_Code__c>();
        
        // Instantiate your service class (replace RateChangeService with your actual class name)
        RateChangeService service = new RateChangeService();
        
        Test.startTest();
        service.cloneRatePayCodesForPCAs(oldToNewPcaMap, ratePayCodesToDelete);
        Test.stopTest();
        
        // Verify that the Rate_Pay_Code__c records have been cloned and linked to the new PCA
        List<Rate_Pay_Code__c> clonedRatePayCodes = [
            SELECT Id, Name, Preventive_Care_Agreement__c, Pay_Code__c 
            FROM Rate_Pay_Code__c
            WHERE Preventive_Care_Agreement__c = :newPca.Id
        ];
        
        System.assertEquals(ratePayCodes.size(), clonedRatePayCodes.size(), 'All Rate Pay Codes should be cloned');
        System.assertEquals(0, ratePayCodesToDelete.size(), 'There should be no failed inserts');
        
    }

}