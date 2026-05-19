@IsTest
private class CPARelationshipRecordsGeneratorTest {
    
    private static final String PROFILE_NAME = 'Corporate Support';  
    private static final String PERMISSION_SET_GROUP_DEVNAME = 'IT';
    private static final String TEST_USER_EMAIL = 'recruiter@scp.com.invalid';

    @TestSetup
    static void setupTestData() {
        // --- 1. Account Record Types ---
        Id clinicianRTId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Clinician').getRecordTypeId();
        Id corporateEntityRTId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Corporate_Entity').getRecordTypeId();
        Id serviceAccountRTId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Service_Account').getRecordTypeId();
        Id cpaCaseRTId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Collaborative_Practice_Agreement').getRecordTypeId();
        Id clinicianContractRTId = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get('Clinician').getRecordTypeId();
        
        // --- 2. Create Accounts ---
        
        Account clinicianMD = new Account(LastName = 'Test MD Clinician', RecordTypeId = clinicianRTId);
        Account clinicianNP = new Account( LastName = 'Test NP Clinician',RecordTypeId = clinicianRTId);
        Account corporateEntity = new Account(Name  = 'Test Corporate Entity', RecordTypeId = corporateEntityRTId);
        Account serviceAccount = new Account(Name = 'Test Service Account', RecordTypeId = serviceAccountRTId);
        insert new List<Account>{clinicianMD, clinicianNP, corporateEntity, serviceAccount};
            
            // --- 3. Get the Contact IDs which are the same as the Person Account IDs
            Contact physicianContact = [SELECT Id, Professional_Title__c FROM Contact WHERE AccountId = :clinicianMD.Id];
        physicianContact.Professional_Title__c = 'MD';
        Contact npaContact = [SELECT Id, Professional_Title__c FROM Contact WHERE AccountId = :clinicianNP.Id];
        npaContact.Professional_Title__c = 'NP';
        update new List<Contact>{physicianContact, npaContact};
            
            // --- 4. Create Healthcare Payer Network ---
            HealthcarePayerNetwork healthcarePayerNetwork = new HealthcarePayerNetwork(
                Name = 'Test Payer Network',
                PayerId = corporateEntity.Id
            );
        insert healthcarePayerNetwork;

        
        
        // --- 7. Create Code Set Record ---
        CodeSet codeSet = new CodeSet(
            Name = 'Ambassador NP/PA',
            CodeSetType = 'Facility Title',
            StartDate = Date.today().addDays(-2),
            Code_Set_Sub_Type__c = 'Employee',
            Enddate = Date.today().addDays(2),
            code = 'Ambassador NP/PA'
        );
        insert codeSet;
        
        
        // --- 8. Create Healthcare Practitioner Facility (HPF) Records ---
        HealthcarePractitionerFacility physicianHPF = new HealthcarePractitionerFacility(
            Name = 'Physician HPF',
            PractitionerId = physicianContact.Id, // PractitionerId links to HealthcarePractitioner
            AccountId = serviceAccount.Id,
            //Facility_Title__c = codeSet.Id,
            Status__c = 'Prospect',
            Contracting_Corporate_Entity__c = corporateEntity.Id
        );
        HealthcarePractitionerFacility npaHPF = new HealthcarePractitionerFacility(
            Name = 'NP HPF',
            PractitionerId = npaContact.Id,
            AccountId = serviceAccount.Id,
            //Facility_Title__c = codeSet.Id,
            Status__c = 'Prospect',
            Contracting_Corporate_Entity__c = corporateEntity.Id
        );
        insert new List<HealthcarePractitionerFacility>{physicianHPF, npaHPF};
            
            // --- 9. Create Healthcare Provider records and link to Contacts ---
            HealthcareProvider physicianProvider = new HealthcareProvider(
                Name = 'Physician Provider',
                PractitionerId = physicianContact.Id
            );
        HealthcareProvider npaProvider = new HealthcareProvider(
            Name = 'NPA Provider',
            PractitionerId = npaContact.Id
        );
        insert new List<HealthcareProvider>{physicianProvider, npaProvider};
            
            // --- 10. Create Contracts ---
            Contract physicianContract = new Contract(
                AccountId = clinicianMD.Id,
                Status = 'Draft', // Will be updated to Executed in test method
                RecordTypeId = clinicianContractRTId,
                Employment_Type__c = 'Employee'
            );
        Contract npaContract = new Contract(
            AccountId = clinicianNP.Id,
            Status = 'Draft', // Will be updated to Executed in test method
            RecordTypeId = clinicianContractRTId,
            Employment_Type__c = 'Employee'
        );
        insert new List<Contract>{physicianContract, npaContract};
            
            
            // --- 11. Create Provider Network Contracts (PNC) ---
            ProviderNetworkContract physicianPNC = new ProviderNetworkContract(
                Healthcare_Practitioner_Facility__c = physicianHPF.Id,
                ContractId = physicianContract.Id,
                HealthcarePayerNetworkId = healthcarePayerNetwork.Id,
                HealthcareProviderId = physicianProvider.Id,           // Required Field
                StartDate = Date.today(),                              // Required Field
                EndDate = Date.today().addYears(1)   
            );
        ProviderNetworkContract npaPNC = new ProviderNetworkContract(
            Healthcare_Practitioner_Facility__c = npaHPF.Id,
            ContractId = npaContract.Id,
            HealthcarePayerNetworkId = healthcarePayerNetwork.Id,
            HealthcareProviderId = npaProvider.Id,           // Required Field
            StartDate = Date.today(),                              // Required Field
            EndDate = Date.today().addYears(1)   
        );
        insert new List<ProviderNetworkContract>{physicianPNC, npaPNC};
            
         Profile p = [SELECT Id FROM Profile WHERE Name= :PROFILE_NAME]; 
        
        PermissionSetGroup psg = [SELECT Id, Status FROM PermissionSetGroup WHERE DeveloperName = :PERMISSION_SET_GROUP_DEVNAME];
        if (psg.Status != 'Updated') {
            Test.calculatePermissionSetGroup(psg.Id);
        }
        
        System.runAs(new User(Id = Userinfo.getUserId())) {
            User usr = new User(Alias = 'standt', Email= TEST_USER_EMAIL, 
                EmailEncodingKey='UTF-8', LastName='SCPTestUsuer', LanguageLocaleKey='en_US', 
                LocaleSidKey='en_US', ProfileId = p.Id, 
                TimeZoneSidKey='America/Los_Angeles', UserName='scptestclassusername2025@scp.com');
            insert usr;

            PermissionSetAssignment psgAssignment = new PermissionSetAssignment(
            AssigneeId = usr.Id,
            PermissionSetGroupId = psg.Id);
            insert psgAssignment;

             // --- 6. Create Account Team Member to set Case Owner ---
            
            AccountTeamMember atm = new AccountTeamMember(
                AccountId = serviceAccount.Id,
                UserId = usr.Id,
                TeamMemberRole = 'Medical Staff Liaison - CPA'
            );
        insert atm;
        }
    }
    
    @IsTest
    static void testCPAAndCaseGenerationForMDDO() {
        User u = [SELECT id from user where email = :TEST_USER_EMAIL LIMIT 1];
        System.runAs(u) {
            // Find the record type IDs for assertions
        Id cpaCaseRTId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Collaborative_Practice_Agreement').getRecordTypeId();
        
        // Query the contracts that were created in @TestSetup
        List<Contract> contracts = [
            SELECT Id, Status FROM Contract 
            WHERE RecordType.DeveloperName = 'Clinician' and Status = 'Draft'
        ];
        
        
        // Ensure there are contracts to test
        System.assertNotEquals(0, contracts.size(), 'Contracts should have been created in @TestSetup.');
        
        // Change the status of contracts to 'Executed' to trigger the process
        for(Contract c : contracts) {
            c.Status = 'Executed';
        }
        update contracts;
    
        Test.startTest();
        // Call the invocable method with the contract IDs
        CPARelationshipRecordsGenerator.startCPAProcessing(new List<Id>{contracts[0].Id});
        Test.stopTest();
        
        // Assertions
        List<Collaborative_Practice_Agreement__c> cpas = [
            SELECT Id, Physician_Healthcare_Facility__c, Physician_Healthcare_Facility__r.PractitionerId, 
                   NP_PA_Healthcare_Practitioner_Facility__c, Supervision_Collaboration_Status__c 
            FROM Collaborative_Practice_Agreement__c
        ];
      
        
        CPAReviewCaseGenerator secondClass = new CPAReviewCaseGenerator(cpas, cpas[0].Physician_Healthcare_Facility__r.PractitionerId);
        secondClass.execute(null);
        
        // Assert that a CPA record was created for each clinician
        System.assertEquals(1, cpas.size(), 'One CPA records should have been created.');
        
        // Assert that a Case and CPA Review record were created
        List<Case> cpaCases = [SELECT Id FROM Case WHERE RecordTypeId = :cpaCaseRTId];
        System.assertEquals(1, cpaCases.size(), 'A single Case record should have been created for the facility.');
        
        Case cpaCase = cpaCases[0];
        
        List<CPA_Review__c> cpaReviews = [SELECT Id, Collaborative_Practice_Agreement__c, Case__c FROM CPA_Review__c WHERE Case__c = :cpaCase.Id];
        System.assertEquals(1, cpaReviews.size(), 'One CPA Review records should have been created.');
        
        // Verify the links between the CPA Reviews and the CPAs
        Set<Id> cpaIdsFromReviews = new Set<Id>();
        for (CPA_Review__c review : cpaReviews) {
            cpaIdsFromReviews.add(review.Collaborative_Practice_Agreement__c);
        }
        
        Set<Id> originalCpaIds = new Set<Id>();
        for (Collaborative_Practice_Agreement__c cpa : cpas) {
            originalCpaIds.add(cpa.Id);
        }
        System.assertEquals(originalCpaIds, cpaIdsFromReviews, 'All created CPA Ids should be linked to the new CPA Review records.');
        }
        
    }
    @IsTest
    static void testCPAAndCaseGenerationForNpPA() {
        User u = [SELECT id from user where email = :TEST_USER_EMAIL LIMIT 1];
        System.runAs(u) {
        // Find the record type IDs for assertions
        Id cpaCaseRTId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Collaborative_Practice_Agreement').getRecordTypeId();
        
        // Query the contracts that were created in @TestSetup
        List<Contract> contracts = [
            SELECT Id, Status FROM Contract 
            WHERE RecordType.DeveloperName = 'Clinician' and Status = 'Draft'
        ];
        
       
        
        // Ensure there are contracts to test
        System.assertNotEquals(0, contracts.size(), 'Contracts should have been created in @TestSetup.');
        
        // Change the status of contracts to 'Executed' to trigger the process
        for(Contract c : contracts) {
            c.Status = 'Executed';
        }
        update contracts;
        
        Test.startTest();
        // Call the invocable method with the contract IDs
        CPARelationshipRecordsGenerator.startCPAProcessing(new List<Id>{contracts[1].Id});
        Test.stopTest();
        
        // Assertions
        List<Collaborative_Practice_Agreement__c> cpas = [
            SELECT Id, Physician_Healthcare_Facility__c, Physician_Healthcare_Facility__r.PractitionerId, 
                   NP_PA_Healthcare_Practitioner_Facility__c, Supervision_Collaboration_Status__c 
            FROM Collaborative_Practice_Agreement__c
        ];
              
        
        CPAReviewCaseGenerator secondClass = new CPAReviewCaseGenerator(cpas, cpas[0].Physician_Healthcare_Facility__r.PractitionerId);
        
        secondClass.execute(null);
        
        
        // Assert that a CPA record was created for each clinician
        System.assertEquals(1, cpas.size(), 'One CPA records should have been created.');
        
        // Assert that a Case and CPA Review record were created
        List<Case> cpaCases = [SELECT Id FROM Case WHERE RecordTypeId = :cpaCaseRTId];
        System.assertEquals(1, cpaCases.size(), 'A single Case record should have been created for the facility.');
        
        Case cpaCase = cpaCases[0];
        
        List<CPA_Review__c> cpaReviews = [SELECT Id, Collaborative_Practice_Agreement__c, Case__c FROM CPA_Review__c WHERE Case__c = :cpaCase.Id];
        System.assertEquals(1, cpaReviews.size(), 'One CPA Review records should have been created.');
        
        // Verify the links between the CPA Reviews and the CPAs
        Set<Id> cpaIdsFromReviews = new Set<Id>();
        for (CPA_Review__c review : cpaReviews) {
            cpaIdsFromReviews.add(review.Collaborative_Practice_Agreement__c);
        }
        
        Set<Id> originalCpaIds = new Set<Id>();
        for (Collaborative_Practice_Agreement__c cpa : cpas) {
            originalCpaIds.add(cpa.Id);
        }
        System.assertEquals(originalCpaIds, cpaIdsFromReviews, 'All created CPA Ids should be linked to the new CPA Review records.');
        }
    }
    
    @IsTest
    static void testUpdateExistingCPA() {
        User u = [SELECT id from user where email = :TEST_USER_EMAIL LIMIT 1];
        System.runAs(u) {
        Id cpaCaseRTId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Collaborative_Practice_Agreement').getRecordTypeId();
        Id clinicianContractRTId = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get('Clinician').getRecordTypeId();
        Account clinicianMD = [SELECT Id FROM Account WHERE LastName = 'Test MD Clinician' LIMIT 1];
        Account clinicianNP = [SELECT Id FROM Account WHERE LastName = 'Test NP Clinician' LIMIT 1];
        HealthcarePractitionerFacility physicianHPF = [SELECT Id,PractitionerId,AccountId,Status__c,Contracting_Corporate_Entity__c FROM HealthcarePractitionerFacility WHERE PractitionerId IN (SELECT Id FROM Contact WHERE AccountId = :clinicianMD.Id)];
        HealthcarePractitionerFacility npaHPF = [SELECT Id,PractitionerId FROM HealthcarePractitionerFacility WHERE PractitionerId IN (SELECT Id FROM Contact WHERE AccountId = :clinicianNP.Id)];
        
        // Manually create an existing CPA record
        Collaborative_Practice_Agreement__c existingCpa = new Collaborative_Practice_Agreement__c(
            Physician_Healthcare_Facility__c = physicianHPF.Id,
            NP_PA_Healthcare_Practitioner_Facility__c = npaHPF.Id,
            Supervision_Collaboration_Status__c = 'Pending'

        );
        insert existingCpa;
        
        physicianHPF.Status__c = 'Active';
        update physicianHPF;
        HealthcarePractitionerFacility physicianHPFNew = new HealthcarePractitionerFacility(
            Name = 'Physician HPF New',
            PractitionerId = physicianHPF.PractitionerId, // PractitionerId links to HealthcarePractitioner
            AccountId = physicianHPF.AccountId,
            //Facility_Title__c = codeSet.Id,
            Status__c = 'Prospect',
            Contracting_Corporate_Entity__c = physicianHPF.Contracting_Corporate_Entity__c
        );
        
        insert physicianHPFNew;
        
        Contract phyContract = [SELECT Id, Status FROM Contract WHERE AccountId = :clinicianMD.Id];
        
        Contract physicianContractNew = new Contract(
            AccountId = clinicianMD.Id,
            Status = 'Draft', // Will be updated to Executed in test method
            RecordTypeId = clinicianContractRTId,
            Employment_Type__c = 'Employee',
            StartDate = System.today() + 10
        );
        insert physicianContractNew;
        
        phyContract.Status = 'Canceled';
        update phyContract;
        
       
        ProviderNetworkContract physicianPNCNew = new ProviderNetworkContract(
            Healthcare_Practitioner_Facility__c = physicianHPFNew.Id,
            ContractId = physicianContractNew.Id,
            HealthcarePayerNetworkId = [SELECT Id FROM HealthcarePayerNetwork LIMIT 1].Id,
            HealthcareProviderId = [SELECT Id FROM HealthcareProvider WHERE PractitionerId = :[SELECT Id FROM Contact WHERE AccountId = :clinicianMD.Id limit 1].Id LIMIT 1].Id,
            StartDate = Date.today() + 11,                              // Required Field
            EndDate = Date.today().addYears(1)   
        );
        
        insert physicianPNCNew ;
        
        // Simulate a contract update for the NP
        Contract phyContractNew = [SELECT Id, Status FROM Contract WHERE AccountId = :clinicianMD.Id and status = 'Draft'];
        phyContractNew.Status = 'Executed';
        
        
        Test.startTest();
            update phyContractNew;
            CPARelationshipRecordsGenerator.startCPAProcessing(new List<Id>{phyContractNew.Id});
        Test.stopTest();
        
        List<Collaborative_Practice_Agreement__c> cpas = [
            SELECT Id, Supervision_Collaboration_Status__c ,Physician_Healthcare_Facility__r.PractitionerId,Physician_Healthcare_Facility__c,
                   NP_PA_Healthcare_Practitioner_Facility__c
            FROM Collaborative_Practice_Agreement__c 
            WHERE Id = :existingCpa.Id
        ];
       
        // Pass the updated CPA IDs for update scenario
        Set<Id> updatedCPAIds = new Set<Id>{existingCpa.Id};
        CPAReviewCaseGenerator secondClass = new CPAReviewCaseGenerator(cpas, cpas[0].Physician_Healthcare_Facility__r.PractitionerId, updatedCPAIds);
        secondClass.execute(null);
        
        System.assertEquals(1, cpas.size(), 'The existing CPA record should have been found.');
        System.assertEquals('Pending', cpas[0].Supervision_Collaboration_Status__c, 'The existing CPA record should have been updated to Pending.');
        
        List<Case> cpaCases = [SELECT Id FROM Case WHERE RecordTypeId = :cpaCaseRTId];
        System.assertEquals(1, cpaCases.size(), 'A new Case should be created for the updated CPA.');
        }
    }
    
    
    @IsTest
    static void testEmptyContractIds() {
        User u = [SELECT id from user where email = :TEST_USER_EMAIL LIMIT 1];
        System.runAs(u) {
        Test.startTest();
        CPARelationshipRecordsGenerator.startCPAProcessing(new List<Id>());
        CPARelationshipRecordsGenerator.startCPAProcessing(null);
        Test.stopTest();
        
        // Assert that no new records were created
        System.assertEquals(0, [SELECT count() FROM Collaborative_Practice_Agreement__c], 'No CPA records should have been created for null or empty list.');
        System.assertEquals(0, [SELECT count() FROM Case WHERE RecordType.DeveloperName = 'Collaborative_Practice_Agreement'], 'No Case records should have been created.');
    
        }
    }
}