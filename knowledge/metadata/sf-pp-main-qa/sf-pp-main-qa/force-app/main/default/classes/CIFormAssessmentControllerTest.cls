/**
 * This class represents the test class for ClinicianIntakeFormAssessmentController
 * * @author Salesforce Services
 * @version 1.1
 * @since 09/03/2025
 */
@isTest(SeeAllData=false)
private class CIFormAssessmentControllerTest {

    @testSetup
    static void setupTestData() {
        // Get Person Account RecordType
        RecordType personAccountRt = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND IsPersonType = true AND DeveloperName = 'Clinician' LIMIT 1];
        RecordType serviceAccountRt = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName = 'Service_Account' LIMIT 1];

        // Create Person Account (Clinician)
        Account personAcct = new Account(
            RecordTypeId = personAccountRt.Id,
            FirstName = 'Test',
            LastName = 'Clinician',
            PersonMailingState = 'California',
            Service_State__c = 'CA',
            Professional_Title__pc = 'DO'
        );
        insert personAcct;

        // Get linked Contact (Person Accounts automatically create a contact)
        Contact con = [SELECT Id FROM Contact WHERE AccountId = :personAcct.Id LIMIT 1];

        // Create CodeSet record (Mapped to Job's Facility_Title_Lookup__c)
        TestDataFactory testDataFactory = new TestDataFactory();
        CodeSet code = testDataFactory.createCodeSet('Employee Title', '21112', 'Facility Title', false);
        code.Code_Set_Sub_Type__c = 'Employee';
        insert code;
        
        
        // Define Service Lines
        List<Service_Line__c> serviceLines = new List<Service_Line__c>{
            new Service_Line__c(Name = 'Virtual Health', Description__c = 'Virtual Health'),
            new Service_Line__c(Name = 'Emergency Medicine', Description__c = 'Emergency Medicine'),
            new Service_Line__c(Name = 'Post Acute Provider Services', Description__c = 'Post Acute Provider Services'),
            new Service_Line__c(Name = 'Critical Care', Description__c = 'Critical Care (formerly ISV)'),
            new Service_Line__c(Name = 'Pediatrics', Description__c = 'Pediatric - Hospital Medicine'),
            new Service_Line__c(Name = 'Urgent Care', Description__c = 'Urgent Care')
        };
        insert serviceLines;

        // Service Accounts and corresponding Jobs
        List<Account> serviceAccounts = new List<Account>();
        for (Service_Line__c sl : serviceLines) {
            serviceAccounts.add(new Account(
                RecordTypeId = serviceAccountRt.Id,
                Name = 'SvcAcct - ' + sl.Name,
                Service_State__c = 'CA',
                Service_Line__c = sl.Id
            ));
        }
        insert serviceAccounts;

        // Create Jobs (traversed by controller logic)
        List<bpats__Job__c> jobList = new List<bpats__Job__c>();
        for (Account svcAcct : serviceAccounts) {
            jobList.add(new bpats__Job__c(
                Facility_Name__c = svcAcct.Id,
                Facility_Title_Lookup__c = code.Id
            ));
        }
        insert jobList;

        List<bpats__ATS_Stage__c> stageList = new List<bpats__ATS_Stage__c>();
        for (bpats__Job__c job : jobList) {
            bpats__ATS_Stage__c stage = new bpats__ATS_Stage__c();
            stage.bpats__Stage_Type__c  = 'Internal Review';
            stage.bpats__Sequence__c  = 1;
            stage.bpats__Job__c = job.Id;
            stageList.add(stage);
        }
        insert stageList;
		
        List<bpats__ATS_Applicant__c> applicantList = new List<bpats__ATS_Applicant__c>();
        for (bpats__ATS_Stage__c stage : stageList) {
            applicantList.add(new bpats__ATS_Applicant__c(
                bpats__ATS_Applicant__c = con.Id,
                bpats__Stage__c = stage.Id,
                bpats__Job__c = stage.bpats__Job__c
            ));
        }
        insert applicantList;
    }

    @isTest
    static void testSetupAssessmentSingleCase() {
        // Arrange
        Contact con = [SELECT Id FROM Contact LIMIT 1];
        Case cs = new Case(ContactId = con.Id, Subject = 'Test Case');
        insert cs;

        // Mocking OmniProcesses (Needed for getRelatedOmniscriptIds method)
        List<String> docNames = new List<String>{
            'ClinicianProfileUpdates', 'CCPADoc'
        };

        List<OmniProcess> omniProcesses = new List<OmniProcess>();
        for (String docName : docNames) {
            omniProcesses.add(new OmniProcess(Name = docName, UniqueName = docName, Type = 'Competency',SubType=docName,language='English', IsActive = false));
        }
        insert omniProcesses;

        // Act
        Test.startTest();
        ClinicianIntakeFormAssessmentController.setupAssessment(new List<Case>{cs});
        Test.stopTest();

        // Assert
        List<AssessmentEnvelope> envelopes = [SELECT Id FROM AssessmentEnvelope WHERE RequestReferenceId = :cs.Id];
        System.assertEquals(1, envelopes.size(), 'One Assessment Envelope should be created');
        
        List<AssessmentEnvelopeItem> items = [SELECT Id FROM AssessmentEnvelopeItem WHERE AssessmentEnvelopeId = :envelopes[0].Id];
        System.assert(items.size() > 0, 'Assessment items should have been created');
    }

    @isTest
    static void testExceptionHandling() {
        // Arrange: Create a Case without ContactId to trigger potential error/catch block
        Case cs = new Case(Subject = 'NoContact');
        insert cs;

        // Act
        Test.startTest();
        ClinicianIntakeFormAssessmentController.setupAssessment(new List<Case>{cs});
        Test.stopTest();

        // Assert: The try-catch in controller prevents crash, but no envelope is created
        Integer cnt = [SELECT COUNT() FROM AssessmentEnvelope WHERE RequestReferenceId = :cs.Id];
        System.assertEquals(0, cnt, 'No envelope should be created for invalid case data');
    }
}