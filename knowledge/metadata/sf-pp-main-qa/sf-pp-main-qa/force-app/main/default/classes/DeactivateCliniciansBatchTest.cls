/**
 * This class is test class for DeactivateCliniciansBatch
 * 
 * Modification Logs
 * =================================================================================
 * StoryNumber      DeveloperName       ModifiedDate        Description
 * =================================================================================
 * PR1050558-1580   Tapas              25/08/2025              
 * 
 * =================================================================================
 */

@isTest
public class DeactivateCliniciansBatchTest {

    private static Date pastDate = System.today().addMonths(-15); // 15 months ago
    private static Date recentDate = System.today().addMonths(-6); // 6 months ago
    private static final String ACTIVE_STATUS = 'Active';
    private static final String DRAFT_STATUS = 'Draft';
    private static final String EXECUTED_STATUS = 'Executed';
    private static final String INACTIVE_STATUS = 'Inactive';
    private static final String OPEN_STATUS = 'Open';
    private static final String SERVICE_RECTYPE = 'Service_Account';
    private static final String CLINICIAN_RECTYPE = 'Clinician';
    private static final String PROFILE_NAME = 'Corporate Support';  
    private static final String PERMISSION_SET_GROUP_DEVNAME = 'IT';
    private static final String TEST_USER_EMAIL = 'recruiter@scp.com.invalid';
    
    // Helper method to get Service Account RecordType Id
    private static Id getServiceAccountRecordTypeId() {
        return Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
            .get(SERVICE_RECTYPE).getRecordTypeId();
    }
    // Helper method to get Clinician Account RecordType Id
    private static Id getClinicanAccountRecordTypeId() {
        return Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
            .get(CLINICIAN_RECTYPE).getRecordTypeId();
    }
    // Helper method to get Clinician Contract RecordType Id
    private static Id getClinicanContractRecordTypeId() {
        return Schema.SObjectType.Contract.getRecordTypeInfosByName()
            .get(CLINICIAN_RECTYPE).getRecordTypeId();
    }

    @TestSetup
    static void setupTestData() {
        
        

        //Create Test Account
        Account testAcc = new Account();
        testAcc.RecordTypeId = getServiceAccountRecordTypeId();
        testAcc.Name = 'TestMainAcc';
        insert testAcc;
        
        //Create Sister Sites Acc
        //Create Test Sister Account
        Account testSisAcc = new Account();
        testSisAcc.RecordTypeId = getServiceAccountRecordTypeId();
        testSisAcc.Name = 'SisterSitesAcc';
        insert testSisAcc;
        
        //create Clinician Account
        Account clinicianTestAcc = new Account();
        clinicianTestAcc.RecordTypeId = getClinicanAccountRecordTypeId();
        clinicianTestAcc.PersonEmail = 'clinician@test.com';
        clinicianTestAcc.LastName = 'testClinican';
        clinicianTestAcc.I9_Status__pc = 'E-Verify Pending';
        insert clinicianTestAcc;
        
        Account tprsoncc = [select id, personcontactid from account where PersonEmail = 'clinician@test.com' LIMIT 1];
            
        //create party role 
        PartyRoleRelation testPartRole = new PartyRoleRelation();
        testPartRole.RoleName = 'Sister';
        testPartRole.RelationshipObjectName = 'Account_Account_Relationship';
        testPartRole.RelatedRoleName = 'Sister';
        insert testPartRole;
        
        AccountAccountRelation aar1 = new AccountAccountRelation();
        aar1.AccountId = testAcc.Id;
        aar1.RelatedAccountId = testSisAcc.Id;
        aar1.PartyRoleRelationId = testPartRole.Id;
        aar1.IsActive = true;
        insert aar1;
        
        AccountAccountRelation aar2 = new AccountAccountRelation();
        aar2.AccountId = testSisAcc.Id;
        aar2.RelatedAccountId = testAcc.Id;
        aar2.PartyRoleRelationId = testPartRole.Id;
        aar2.IsActive = true;
        insert aar2;
        
        //create HPF to main Account
        HealthcarePractitionerFacility testHpf = new HealthcarePractitionerFacility();
        testHpf.Name = 'testHpf';
        testHpf.Status__c = ACTIVE_STATUS;
        testHpf.AccountId = testAcc.Id;
        testHpf.Last_Date_Worked__c = pastDate;
        testHpf.Hospital_Privileged_Date__c = pastDate;
        testHpf.PractitionerId = tprsoncc.personcontactid;
        insert testHpf;
        
        //create HPF to Sister Acc
        HealthcarePractitionerFacility testSisHpf = new HealthcarePractitionerFacility();
        testSisHpf.Name = 'testSisHpf';
        testSisHpf.Status__c = ACTIVE_STATUS;
        testSisHpf.AccountId = testSisAcc.Id;
        testSisHpf.Last_Date_Worked__c = pastDate;
        testSisHpf.Hospital_Privileged_Date__c = pastDate;
        testSisHpf.PractitionerId = tprsoncc.personcontactid;
        insert testSisHpf;
        
        //create Test Contracts
        Contract testContrcts = new Contract();
        testContrcts.RecordTypeId = getClinicanContractRecordTypeId();
        testContrcts.AccountId = clinicianTestAcc.Id;
        testContrcts.CompanySignedDate = pastDate;
        testContrcts.Status = DRAFT_STATUS;
        insert testContrcts;
        System.debug('testCon'+testContrcts.AccountId);
        
        //create Test Contracts for Sis
        Contract testSisContrcts = new Contract();
        testSisContrcts.AccountId = testSisAcc.Id;
        testSisContrcts.CompanySignedDate = pastDate;
        testSisContrcts.Status = DRAFT_STATUS;
        insert testSisContrcts;
        
        testContrcts.Status = EXECUTED_STATUS;
        update testContrcts;
        testSisContrcts.Status = EXECUTED_STATUS;
        update testSisContrcts;
        
        //create Healthcare provider
        HealthcareProvider testProv = new HealthcareProvider();
        testProv.Name = 'testProv';
        testProv.PractitionerId = tprsoncc.personcontactid;
        insert testProv;
        
        //create Healthcare payer
        HealthcarePayerNetwork testHealthcarePayer = new HealthcarePayerNetwork();
        testHealthcarePayer.Name = 'testHealthcarePayer';
        testHealthcarePayer.PayerId = testAcc.Id;
        insert testHealthcarePayer;
        
        //create PNC
        ProviderNetworkContract tstpnc1 = new ProviderNetworkContract();
        tstpnc1.Healthcare_Practitioner_Facility__c = testHpf.Id;
        tstpnc1.ContractId = testContrcts.Id;
        tstpnc1.HealthcarePayerNetworkId = testHealthcarePayer.Id;
        tstpnc1.HealthcareProviderId = testProv.Id;
        tstpnc1.StartDate = System.today().addMonths(-15);
        tstpnc1.EndDate = System.today().addMonths(15);
        insert tstpnc1;
        Contract con = [select Id, AccountId from contract where Id =: tstpnc1.ContractId];
        
        //Create Task
        Task testTask = new Task(
            WhatId = tprsoncc.Id,
            Status =  OPEN_STATUS,
            Subject = 'Test Task 1',
            ActivityDate = System.today()
        );
        insert testTask;
        
        //Create Case
        Case testCase = new Case(
            AccountId = tprsoncc.Id,
            Status = OPEN_STATUS,
            Subject = 'Test Case 1'
        );
        insert testCase;

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
    

    @isTest
    static void testHfpWithPositiveLWD() {
        User usr = [SELECT Id FROM User WHERE Email = : TEST_USER_EMAIL];
        
        System.runAs(usr) {
            Test.startTest();
        
            DeactivateCliniciansBatch batch = new DeactivateCliniciansBatch();
            Database.executeBatch(batch,5);
        
            Test.stopTest();
            HealthcarePractitionerFacility resultsHpf = [Select Id, Status__c, Name FROM HealthcarePractitionerFacility 
                                                        Where Name = 'testClinican - TestMainAcc' LIMIT 1];
        //System.debug('resultsHpf '+resultsHpf);
            System.assertEquals(INACTIVE_STATUS, resultsHpf.Status__c, 'The Status should be updated to Inactive');
        }
      
    }
    
    @isTest
    static void testContractWithCSD() {

        User usr = [SELECT Id FROM User WHERE Email = : TEST_USER_EMAIL];
        
        System.runAs(usr) {
        
            Test.startTest();
            List <HealthcarePractitionerFacility> HpfList = [Select Id, AccountId, Last_Date_Worked__c, Hospital_Privileged_Date__c,
                                                         Status__c FROM HealthcarePractitionerFacility];
        
            for (HealthcarePractitionerFacility hpf :HpfList) {
                hpf.Last_Date_Worked__c = null;
            }
            update HpfList;
        
            DeactivateCliniciansBatch batch = new DeactivateCliniciansBatch();
            Database.executeBatch(batch,5);
        
            Test.stopTest();
        
            HealthcarePractitionerFacility resultsHpf = [Select Id, Status__c, Name FROM HealthcarePractitionerFacility 
                                                     Where Name = 'testClinican - TestMainAcc' LIMIT 1];
            System.assertEquals(INACTIVE_STATUS, resultsHpf.Status__c, 'The Status should be updated to Inactive');
        }
    }
    
    @isTest
    static void testContractWithCSDNegetive() {

        User usr = [SELECT Id FROM User WHERE Email = : TEST_USER_EMAIL];
        
        System.runAs(usr) {
        
            Test.startTest();
            List <HealthcarePractitionerFacility> HpfList = [Select Id, AccountId, Last_Date_Worked__c, Hospital_Privileged_Date__c,
                                                         Status__c FROM HealthcarePractitionerFacility];
            for (HealthcarePractitionerFacility hpf :HpfList) {
                hpf.Last_Date_Worked__c = null;
            }
            update HpfList;
        
            List <Contract> contractList = [Select Id, AccountId, CompanySignedDate FROM Contract];
            for (Contract con : contractList) {
                con.CompanySignedDate = recentDate;
            }
            update contractList;
        
        
            DeactivateCliniciansBatch batch = new DeactivateCliniciansBatch();
            Database.executeBatch(batch,5);
        
            Test.stopTest();
        }
        
        HealthcarePractitionerFacility resultsHpf = [Select Id, Status__c, Name FROM HealthcarePractitionerFacility 
                                                        Where Name = 'testClinican - TestMainAcc' LIMIT 1];
        System.assertEquals(ACTIVE_STATUS, resultsHpf.Status__c, 'The Status should not be updated to Inactive');
    }
    
    @isTest
    static void testHpfWithHPD() {
        User usr = [SELECT Id FROM User WHERE Email = : TEST_USER_EMAIL];
        
        System.runAs(usr) {
            Test.startTest();
            List <HealthcarePractitionerFacility> HpfList = [Select Id, AccountId, Last_Date_Worked__c, Hospital_Privileged_Date__c,
                                                        Status__c FROM HealthcarePractitionerFacility];
            for (HealthcarePractitionerFacility hpf :HpfList) {
                hpf.Last_Date_Worked__c = null;
                hpf.Hospital_Privileged_Date__c = pastDate;
            }
            update HpfList;
        
            List <Contract> contractList = [Select Id, CompanySignedDate, AccountId FROM Contract];
            for (Contract con : contractList) {
                con.CompanySignedDate = null;
            }
            update contractList;
    
            DeactivateCliniciansBatch batch = new DeactivateCliniciansBatch();
            Database.executeBatch(batch,5);
        
            //scehdule the batch
            String sch = '0 0 0 * * ?';//CRON time
            System.schedule('Test Scheduled Batch', sch, batch);
 
        
            Test.stopTest();
        }
        HealthcarePractitionerFacility resultsHpf = [Select Id, Status__c, Name FROM HealthcarePractitionerFacility 
                                                        Where Name = 'testClinican - TestMainAcc' LIMIT 1];
        
        System.assertEquals(INACTIVE_STATUS, resultsHpf.Status__c, 'The Status should be updated to Inactive');
    }
    
    
}