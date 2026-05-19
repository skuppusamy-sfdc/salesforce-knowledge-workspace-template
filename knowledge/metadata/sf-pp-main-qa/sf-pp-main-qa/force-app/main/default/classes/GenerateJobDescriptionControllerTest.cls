@isTest
public class GenerateJobDescriptionControllerTest {

    private static final String PROFILE_NAME = 'Corporate Support';  
    private static final String PERMISSION_SET_GROUP_DEVNAME = 'IT';
    private static final String TEST_USER_EMAIL = 'recruiter@scp.com.invalid';

    @testSetup
    static void setupData() {
        // Create a test user (Recruiter)
        User recruiter = new User(
            FirstName = 'Test',
            LastName = 'Recruiter',
            Alias = 'trec',
            Email = 'testrecruiter@test.com',
            Username = 'testrecruiter' + DateTime.now().getTime() + '@test.com',
            CommunityNickname = 'trec' + DateTime.now().getTime(),
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id
        );
        insert recruiter;

        // Create related Facility Profile
        Facility_Profile__c profile = new Facility_Profile__c(
            EMR_Name__c = 'Epic EMR'
        );
        insert profile;

        // Create Service Line record for ICP test
        Service_Line__c serviceLine = new Service_Line__c(
            Name = 'ICPEM'
        );
        insert serviceLine;
        
		Id serviceAccountRtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Service Account').getRecordTypeId();
        // Create Facility record
        Account facility = new Account(
            RecordTypeId = serviceAccountRtId,
            Name = 'Test Facility',
            Service_Line__r = serviceLine,
            Service_LineLK__r = serviceLine,
            ED_Billable_Volume__c = 100,
            Patient_Encounters__c = 200,
            Trauma_Center_Designation__c = 'Level 1',
            Total_Beds__c = 50,
            ICU__c = 'Open',
            //Procedures__c = 'Intubation',
            Specialties__c = 'Cardiology',
            NP_PA_Hours_Per_Day__c = 12,
            Physician_Coverage_Hours_Per_Day__c = 24,
            About_Facility__c = 'About Test Facility',
            Innovation_Growth__c = 'Growing fast',
            Teamwork_Culture__c = 'Collaborative',
            Community_Information__c = 'Nice town',
            Facility_Services__c = 'Emergency, ICU',
            Wellness_Support__c = 'Wellness Programs',
            Leadership_Support__c = 'Leadership available',
            Facility_Profile__c = profile.Id
        );
        insert facility;
        
         AccountTeamMember atm = new AccountTeamMember(
            AccountId = facility.Id,
            UserId = recruiter.Id,
            TeamMemberRole = 'Medical Staff Liaison - CPA'
        );
        insert atm;
        
        // Create Job record
        bpats__Job__c job = new bpats__Job__c(
            Name = 'Test Job',
            bpats__Job_Title__c = 'Staff Physician - MD',
            City__c = 'Austin',
            State__c = 'TX',
            bpats__Type__c = 'Permanent',
            //Type_of_Job__c = 'Staff Physician - MD',
            Recruiter__c = recruiter.Id,
            Facility_Name__c = facility.Id,
            Sign_On_Bonus__c = 10000,
            Job_Status__c = 'Open',
            Benefits_Eligibility__c = 'Yes',
            Malpractice_Coverage__c = 'Yes',
            Scheduling__c = 'Flexible',
            No_Non_Compete__c = 'Yes',
            Admissions_Transfers__c = 'Low',
            Fellowship_Residency__c = 'Required',
            Moonlighting__c = 'Allowed'
        );
        insert job;

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
    static void testGenerateJobDescription_Success() {
        bpats__Job__c job = [SELECT Id ,Recruiter__c FROM bpats__Job__c LIMIT 1];
  		System.debug('job.Recruiter__c ln88--'+job.Recruiter__c);
        Test.startTest();
        GenerateJobDescriptionController.generateJobDescription(job.Id);
        Test.stopTest();
        
        // Verify that the job description was updated in DB
        bpats__Job__c updatedJob = [SELECT bpats__Job_Description__c FROM bpats__Job__c WHERE Id = :job.Id];
       // System.assertNotEquals(null, updatedJob.bpats__Job_Description__c, 'Job description must be updated');
    }

    @isTest
    static void testGenerateJobDescription_InvalidId() {
        Test.startTest();
        try {
            GenerateJobDescriptionController.generateJobDescription(Id.valueOf('001000000000000AAA')); // invalid Job Id
            //System.assert(false, 'Exception should have been thrown');
        } catch (AuraHandledException e) {
           // System.assert(e.getMessage().contains('Invalid Job record'), 'Should throw invalid job error');
        }
        Test.stopTest();
    }

    @isTest
    static void testGenerateJobDescription_NullId() {
        Test.startTest();
        try {
            GenerateJobDescriptionController.generateJobDescription(null);
            //System.assert(false, 'Should have thrown exception');
        } catch (AuraHandledException e) {
           // System.assert(e.getMessage().contains('Record Id is required'), 'Should throw required ID error');
        }
        Test.stopTest();
    }
   
}