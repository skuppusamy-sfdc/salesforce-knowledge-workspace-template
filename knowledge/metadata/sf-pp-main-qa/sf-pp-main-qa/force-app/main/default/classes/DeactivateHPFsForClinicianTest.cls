/**
* This class is test class for DeactivateHPFsForClinician
* 
* Modification Logs
* =================================================================================
* StoryNumber      DeveloperName       ModifiedDate        Description
* =================================================================================
* PR1050558-1580   Tapas              31/03/2026 
* =================================================================================
*/
@isTest
public class DeactivateHPFsForClinicianTest {
    
    private static Date moreThan365 = System.today().addMonths(-15); 
    private static Date moreThan270 = System.today().addMonths(-10);
    private static Date lessThan270 = System.today().addMonths(-6);
    private static final String ACTIVE_STATUS = 'Active';
    private static final String DRAFT_STATUS = 'Draft';
    private static final String INACTIVE_STATUS = 'Inactive';
    private static final String OPEN_STATUS = 'Open';
    private static final String CLOSED_STATUS = 'Closed';
    private static final String SERVICE_RECTYPE = 'Service_Account';
    private static final String CLINICIAN_RECTYPE = 'Clinician';
    private static final String PROFILE_NAME = 'Corporate Support';  
    private static final String PERMISSION_SET_GROUP_DEVNAME = 'IT';
    private static final String TEST_USER_EMAIL = 'recruiter@scp.com.invalid';
    
    
    // Helper method to get Clinician Account RecordType Id
    private static Id getClinicanAccountRecordTypeId() {
        return Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
            .get(CLINICIAN_RECTYPE).getRecordTypeId();
    }
    
    @TestSetup
    static void setupTestData() {
        TestDataFactory testDataFactory = new TestDataFactory();
        
        
        List<Account> accList = new List<Account>();
        //Create Test Account
        Account testAcc = testDataFactory.createServiceAccount('TestMainAcc', 'TestMainAcc', SERVICE_RECTYPE, false);
        
        Account testSisAcc1 = testDataFactory.createServiceAccount('TestSisAcc1', 'TestSisAcc1', SERVICE_RECTYPE, false);
        
        //Create Sister Sites Acc
        //Create Test Sister Account
        Account testSisAcc2 = testDataFactory.createServiceAccount('TestSisAcc2', 'TestSisAcc2', SERVICE_RECTYPE, false);
        
        Account corporateEntity = testDataFactory.createServiceAccount(
            'Test Corporate Entity',
            null,                    
            'Corporate_Entity',      
            false                     
        );
        accList.addAll(new List<Account>{ testAcc, testSisAcc1, testSisAcc2, corporateEntity });
        insert accList;
        
        /* ===================== CLINICIAN ACCOUNTS ===================== */
        Account clinicianTestAcc = new Account(
            RecordTypeId = getClinicanAccountRecordTypeId(),
            PersonEmail = 'clinician@test.com',
            LastName = 'testClinican',
            I9_Status__pc = 'E-Verify Pending'
        );
        insert clinicianTestAcc;
        
        Account clinicianTestAcc1 = new Account(
            RecordTypeId = getClinicanAccountRecordTypeId(),
            PersonEmail = 'clinician2@test.com',
            LastName = 'testClinican2',
            I9_Status__pc = 'E-Verify Pending'
        );
        insert clinicianTestAcc1;
        
        Account tprsoncc = [SELECT Id, PersonContactId, PersonEmail FROM Account WHERE PersonEmail ='clinician@test.com'];
        System.debug('tprsoncc '+tprsoncc);
        Account tprsoncc2 = [SELECT Id, PersonContactId, PersonEmail FROM Account WHERE PersonEmail ='clinician2@test.com'];
        
        //create party role 
        PartyRoleRelation testPartRole = new PartyRoleRelation();
        testPartRole.RoleName = 'Sister';
        testPartRole.RelationshipObjectName = 'Account_Account_Relationship';
        testPartRole.RelatedRoleName = 'Sister';
        insert testPartRole;
        
        /* ===================== ACCOUNT-ACCOUNT RELATIONS ===================== */
        List<AccountAccountRelation> aarList = new List<AccountAccountRelation>();
        
        aarList.add(new AccountAccountRelation(
            AccountId = testSisAcc1.Id,
            RelatedAccountId = testSisAcc2.Id,
            PartyRoleRelationId = testPartRole.Id,
            IsActive = true
        ));
        
        aarList.add(new AccountAccountRelation(
            AccountId = testSisAcc2.Id,
            RelatedAccountId = testSisAcc1.Id,
            PartyRoleRelationId = testPartRole.Id,
            IsActive = true
        ));
        
        insert aarList;
        
        /* ===================== HPF RECORDS ===================== */
        List<HealthcarePractitionerFacility> hpfList = new List<HealthcarePractitionerFacility>();
        
        // 365 scenarios
        HealthcarePractitionerFacility testHpf = testDataFactory.createHealthcarePractitionerFacility(
            'testHpf1', tprsoncc.PersonContactId, testAcc.Id, corporateEntity.Id, false);
        testHpf.Status__c = ACTIVE_STATUS;
        testHpf.Last_Date_Worked__c = moreThan365;
        testHpf.Hospital_Privileged_Date__c = null;
        
        HealthcarePractitionerFacility testHpf2 = testDataFactory.createHealthcarePractitionerFacility(
            'testHpf2', tprsoncc.PersonContactId, testAcc.Id, corporateEntity.Id, false);
        testHpf2.Status__c = ACTIVE_STATUS;
        testHpf2.Last_Date_Worked__c = null;
        testHpf2.Hospital_Privileged_Date__c = moreThan365;
        
        HealthcarePractitionerFacility testSisHpf1 = testDataFactory.createHealthcarePractitionerFacility(
            'testSisHpf1', tprsoncc.PersonContactId, testSisAcc1.Id, corporateEntity.Id, false);
        testSisHpf1.Status__c = ACTIVE_STATUS;
        testSisHpf1.Last_Date_Worked__c = moreThan365;
        testSisHpf1.Hospital_Privileged_Date__c = moreThan365;
        
        // 270 scenarios
        HealthcarePractitionerFacility testHpf3 = testDataFactory.createHealthcarePractitionerFacility(
            'testHpf3', tprsoncc.PersonContactId, testAcc.Id, corporateEntity.Id, false);
        testHpf3.Status__c = ACTIVE_STATUS;
        testHpf3.Last_Date_Worked__c = null;
        testHpf3.Hospital_Privileged_Date__c = moreThan270;
        
        HealthcarePractitionerFacility testHpf4 = testDataFactory.createHealthcarePractitionerFacility(
            'testHpf4', tprsoncc.PersonContactId, testAcc.Id, corporateEntity.Id, false);
        testHpf4.Status__c = ACTIVE_STATUS;
        testHpf4.Last_Date_Worked__c = moreThan270;
        testHpf4.Provider_Next_Scheduled_Date__c = moreThan270.addDays(-365);
        
        HealthcarePractitionerFacility testHpf5 = testDataFactory.createHealthcarePractitionerFacility(
            'testHpf5', tprsoncc.PersonContactId, testAcc.Id, corporateEntity.Id, false);
        testHpf5.Status__c = ACTIVE_STATUS;
        testHpf5.Last_Date_Worked__c = moreThan270;
        testHpf5.Provider_Next_Scheduled_Date__c = null;
        
        // create sister sistes
        HealthcarePractitionerFacility testHpf6 = testDataFactory.createHealthcarePractitionerFacility(
            'testHpf6', tprsoncc.PersonContactId, testSisAcc1.Id, corporateEntity.Id, false);
        testHpf6.Status__c = ACTIVE_STATUS;
        testHpf6.Last_Date_Worked__c = moreThan270;
        testHpf6.Provider_Next_Scheduled_Date__c = moreThan270;
        
        //create hpf for closing cases and tasks
        HealthcarePractitionerFacility testHpf7 = testDataFactory.createHealthcarePractitionerFacility(
            'testHpf7', tprsoncc2.PersonContactId, testAcc.Id, corporateEntity.Id, false);
        testHpf7.Status__c = ACTIVE_STATUS;
        testHpf7.Last_Date_Worked__c = moreThan365;
        testHpf7.Hospital_Privileged_Date__c = moreThan365;
        
        HealthcarePractitionerFacility testHpf8 = testDataFactory.createHealthcarePractitionerFacility(
            'testHpf8', tprsoncc2.PersonContactId, testAcc.Id, corporateEntity.Id, false);
        testHpf8.Status__c = ACTIVE_STATUS;
        testHpf8.Last_Date_Worked__c = moreThan365;
        testHpf8.Hospital_Privileged_Date__c = moreThan365;
        
        
        HealthcarePractitionerFacility testHpf9 = testDataFactory.createHealthcarePractitionerFacility(
            'testHpf9', tprsoncc.PersonContactId, testAcc.Id, corporateEntity.Id, false);
        testHpf9.Status__c = ACTIVE_STATUS;
        testHpf9.Last_Date_Worked__c = null;
        testHpf9.Hospital_Privileged_Date__c = moreThan270;
        
        
        //testHpf, testHpf2, testSisHpf1, testHpf3, testHpf4, testHpf5, testHpf6, 
        //testHpf, testHpf2, testSisHpf1, testHpf3, testHpf4, testHpf5, testHpf6, testHpf7, testHpf8, 
        hpfList.addAll(new List<HealthcarePractitionerFacility>{
            testHpf, testHpf2, testSisHpf1, testHpf3, testHpf4, testHpf5, testHpf6, testHpf7, testHpf8,testHpf9
                });
        
        insert hpfList;
        System.debug(' hpfList '+hpfList);
        
        
        /* ===================== CONTRACTS ===================== */
        List<Contract> contractList = new List<Contract>();
        
        Contract testContrcts = testDataFactory.createClinicianContract(clinicianTestAcc, false);
        testContrcts.Initial_Effective_Date__c = moreThan270;
        testContrcts.Status = DRAFT_STATUS;
        testContrcts.StartDate = Date.today();
        
        Contract testSisContrcts = testDataFactory.createClinicianContract(testSisAcc1, false);
        testSisContrcts.CompanySignedDate = moreThan365;
        testSisContrcts.Status = DRAFT_STATUS;
        
        contractList.addAll(new List<Contract>{ testContrcts, testSisContrcts });
        insert contractList;
        
        //create Healthcare provider
        HealthcareProvider testProv = testDataFactory.createHealthcareProvider('testProv', tprsoncc.personcontactid, true);
        
        //create Healthcare payer
        HealthcarePayerNetwork testHealthcarePayer = testDataFactory.createHealthcarePayerNetwork
            ('testHealthcarePayer',corporateEntity.Id,false);
        testHealthcarePayer.PayerId = testAcc.Id;
        insert testHealthcarePayer;
        
        //create PNC
        ProviderNetworkContract tstpnc1 = testDataFactory.createPNC
            (testContrcts.Id, testProv.Id, testHealthcarePayer.Id, testHpf.Id, true);
        
        Contract con = [select Id, AccountId from contract where Id =: tstpnc1.ContractId];
        
        //Create Task
        Task testTask = new Task(WhatId = tprsoncc2.Id,Status =  OPEN_STATUS,Subject = 'Test Task 1',
                                 ActivityDate = System.today());
        insert testTask;
        
        //Create Case
        Case testCase = new Case(
            ContactId = tprsoncc2.personcontactid,
            Status = OPEN_STATUS,
            Subject = 'Test Case 1'
        );
        insert testCase;
        Case testChCase = new Case(
            ContactId = tprsoncc.personcontactid,
            Status = OPEN_STATUS,
            Subject = 'Test Case 1',
            ParentId = testCase.Id
        );
        insert testChCase;
        
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
        }
    }
    /* This is the method to validate the 360 days inactivity and also the closing of cases and task for clinician*/
    @isTest
    static void testValidate365DaysInactivity() {
        User usr = [SELECT Id FROM User WHERE Email = : TEST_USER_EMAIL];
        
        System.runAs(usr) {
            
            Test.startTest();
            
            DeactivateHPFsForClinician batch = new DeactivateHPFsForClinician();
            Database.executeBatch(batch, 10);
            
            Test.stopTest();
            HealthcarePractitionerFacility resultsHpf = [Select Id, Status__c, Name FROM HealthcarePractitionerFacility 
                                                         Where Name = 'testClinican - TestMainAcc' LIMIT 1];
            Case tstCase = [Select Id, Status From Case Where Subject = 'Test Case 1' LIMIT 1];
            
            System.assertEquals(INACTIVE_STATUS, resultsHpf.Status__c, 'The Status should be updated to Inactive');
            System.assertEquals(CLOSED_STATUS, tstCase.Status, 'The Status should be updated to Closed');
        }
    }
    
    /* This is the method to validate the 270 days inactivity */
    @isTest
    static void testValidate270DaysInactivity() {
        User usr = [SELECT Id FROM User WHERE Email = : TEST_USER_EMAIL];
        
        System.runAs(usr) {
            
            Test.startTest();
            
            DeactivateHPFsForClinician batch = new DeactivateHPFsForClinician();
            Database.executeBatch(batch, 10);
            
            Test.stopTest();
            List<HealthcarePractitionerFacility> resultsHpf = [Select Id, Name, Status__c
                                                               FROM HealthcarePractitionerFacility 
                                                               WHERE Inactivity_Qualified_270__c = true
                                                               AND Name = 'testClinican - TestMainAcc'
                                                              ];
            
            System.debug('resultsHpf. '+resultsHpf);
            System.assertEquals(1, resultsHpf.size(), '1 record should be marked as 270 days inactive');
        }
    }
    
    
    
}