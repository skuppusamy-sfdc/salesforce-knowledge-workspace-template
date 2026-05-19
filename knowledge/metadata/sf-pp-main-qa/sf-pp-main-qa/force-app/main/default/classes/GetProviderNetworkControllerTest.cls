@istest

/**
 * This class is test class for GetProviderNetworkController
 * 
 * Modification Logs
 * =================================================================================
 * StoryNumber      DeveloperName       ModifiedDate        Description
 * =================================================================================
 * PR1050558-4203   Gagandeep              16/12/2025              
 * 
 * =================================================================================
 */
public class GetProviderNetworkControllerTest {
    private static Date pastDate = System.today().addMonths(-15); // 15 months ago
    private static final String DRAFT_STATUS = 'Draft';
    private static final String ACTIVE_STATUS = 'Active';
    private static final String INACTIVE_STATUS = 'Inactive';
    private static final String PROFILE_NAME = 'Corporate Support';  
    private static final String PERMISSION_SET_GROUP_DEVNAME = 'IT';
    private static final String TEST_USER_EMAIL = 'recruiter@scp.com.invalid';
    private static final String GETPNC = 'getPNC';
    
    @TestSetup
    static void setupTestData() {

		//Create Test Account
        Account testAcc = new Account();
        testAcc.Name = 'TestMainAcc';
        insert testAcc;
        
        //create Contract
        Contract testContrcts = new Contract();
        testContrcts.AccountId = testAcc.Id;
        testContrcts.CompanySignedDate = pastDate;
        testContrcts.Status = DRAFT_STATUS;
        insert testContrcts;
        
        
        //create HPF to main Account
        HealthcarePractitionerFacility testHpf = new HealthcarePractitionerFacility();
        testHpf.Name = 'testHpf';
        testHpf.Status__c = ACTIVE_STATUS;
        testHpf.AccountId = testAcc.Id;
        testHpf.Last_Date_Worked__c = pastDate;
        testHpf.Hospital_Privileged_Date__c = pastDate;
        //testHpf.PractitionerId = tprsoncc.personcontactid;
        insert testHpf;
        
        //create Healthcare provider
        HealthcareProvider testProv = new HealthcareProvider();
        testProv.Name = 'testProv';
        //testProv.PractitionerId = tprsoncc.personcontactid;
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
        
        Profile p = [SELECT Id FROM Profile WHERE Name= :PROFILE_NAME]; 
        
        PermissionSetGroup psg = [SELECT Id,Status FROM PermissionSetGroup WHERE DeveloperName = :PERMISSION_SET_GROUP_DEVNAME];
        
        // force calculation of the PSG if it is not already Updated
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
    static void testFetchPNC() {

        User usr = [SELECT Id FROM User WHERE Email = : TEST_USER_EMAIL];
        
        System.runAs(usr) {
        List<Account> accList = [Select id from account where name = 'TestMainAcc'];
            String contextID = accList[0].Id;
            Test.startTest();
            GetProviderNetworkController obj = new GetProviderNetworkController();
            Map<String, Object> args = new Map<String, Object> ();
            Map<String, Object> input = new Map<String, Object> ();
            Map<String, Object> output = new Map<String, Object>();
            Map<String, Object> options = new Map<String, Object> ();
            input.put('ContextId',contextID);
        	input.put('currentOffsetValue','0');
        	input.put('disablePrev',false);
        	input.put('disableNext',false);
        	input.put('sortOrder','DESC');
            input.put('reverseOrder','true');
        	input.put('sortRow','contract.startdate');
            args.put('input',input);
            args.put('output',output);
            obj.call(GETPNC, args);
            Test.stopTest();
        	Map<String,object> resultPnc = (Map<String,object>)args.get('output');
            List<ProviderNetworkContract> pncRecords = (List<ProviderNetworkContract>)resultPnc.get('pncRecords');
            System.assertEquals(pncRecords.size(), 1);
        }
    }
    @isTest
    static void testFetchPNCOffset() {

        User usr = [SELECT Id FROM User WHERE Email = : TEST_USER_EMAIL];
        
        System.runAs(usr) {
        List<Account> accList = [Select id from account where name = 'TestMainAcc'];
            String contextID = accList[0].Id;
            Test.startTest();
            GetProviderNetworkController obj = new GetProviderNetworkController();
            Map<String, Object> args = new Map<String, Object> ();
            Map<String, Object> input = new Map<String, Object> ();
            Map<String, Object> output = new Map<String, Object>();
            Map<String, Object> options = new Map<String, Object> ();
            input.put('ContextId',contextID);
        	input.put('currentOffsetValue','0');
        	input.put('disablePrev',false);
        	input.put('disableNext',false);
        	input.put('sortOrder','ASC');
            input.put('selectedAction','next');
        	input.put('sortRow','contract.startdate');
            args.put('input',input);
            args.put('output',output);
            obj.call(GETPNC, args);
            Test.stopTest();
        	Map<String,object> resultPnc = (Map<String,object>)args.get('output');
            List<ProviderNetworkContract> pncRecords = (List<ProviderNetworkContract>)resultPnc.get('pncRecords');
            System.assertEquals(pncRecords.size(), 0);
        }
    }

}