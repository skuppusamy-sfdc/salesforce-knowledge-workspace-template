@IsTest
global with sharing class RequestFeedbackForControllerTest {
    @TestSetup
    static void setup(){

        List<Contact> contacts = new List<Contact>();
        Account account = new Account(Name='test');
        insert account;
        Profile p = [SELECT id FROM profile WHERE name='Standard User'];
        User user = new User(FirstName = 'testRequestFeedbackForControllerTest', LastName = 'testRequestFeedbackForControllerTest', Email = 'testRequestFeedbackForControllerTest@test.com', Alias='RFFCus', Username='RequestFeedbackForControllerTestTetststs@test.com', LocaleSidKey='en_US', EmailEncodingKey='UTF-8',
                LanguageLocaleKey='en_US', TimeZoneSidKey='Pacific/Kiritimati',  ProfileId = p.Id);
        insert user;
        Opportunity opportunity = new Opportunity(Name='test', StageName='Closed - Won', CloseDate= Date.today(), OwnerId = user.Id, Amount=5000,AccountId = account.Id);
        insert opportunity;
        Contact contact = new Contact(LastName='test', FirstName='test', Email='test@test.com', AccountId=account.Id, Phone = '1234567891');
        contacts.add(contact);
        Contact contact1 = new Contact(LastName='testCont', FirstName='testCont', Email='testCont@test.com', AccountId=account.Id, Phone = '1234567811');
        contacts.add(contact1);
        insert contacts;
        OpportunityContactRole ocr = new OpportunityContactRole(OpportunityId=opportunity.Id, ContactId= contact1.Id );
        insert ocr;
//        TruSales_App_Settings__c settings = new TruSales_App_Settings__c(
//        Api_EndPoint__c = 'https://api-releases.primary-intel.com',
//        TruVoice_API_Key__c='283742893749273894',
//        TruVoice_Client_ID__c='93458u934058u93458u90',
//        Outcome_Types_Map_1__c = '{"Closed - Won":"1","Closed - No Decision":"3","Closed - Lost to Internal":"2","Closed - Lost to Competitor":"2","Closed - Roll Up":"-1"}',
//        Opportunity_Types_Map_1__c = '{"Renewal":"1","New Business":"2","Add-on":"3","Upsell":"4"}',
//        Opportunity_Amount_Fields__c = 'Amount;ExpectedRevenue;TotalOpportunityQuantity;FiscalQuarter;FiscalYear;'
//        );
//        insert settings;


        Discovery_Bots_Settings__c settings = new Discovery_Bots_Settings__c(
                Name = 'TestSettings',
                Api_EndPoint__c = 'https://api-releases.primary-intel.com',
                TruVoice_API_Key__c = '283742893749273894',
                TruVoice_Client_ID__c = '93458u934058u93458u90',
                Outcome_Types_Map_1__c = '{"Closed - Won":"1","Closed - No Decision":"3","Closed - Lost to Internal":"2","Closed - Lost to Competitor":"2","Closed - Roll Up":"-1"}',
                Opportunity_Types_Map_1__c = '{"Renewal":"1","New Business":"2","Add-on":"3","Upsell":"4"}',
                Opportunity_Amount_Fields__c = 'Amount;ExpectedRevenue;TotalOpportunityQuantity;FiscalQuarter;FiscalYear;',
                Is_Active__c = true

        );
        insert  settings;


    }
    @isTest
    static void testgetUsers() {
        Opportunity op = [SELECT Id FROM Opportunity WHERE Name = 'test' LIMIT 1];
        List<User> users=RequestFeedbackForController.getUsers(op.id);
        System.assert(users.size()>0);
    }
    @isTest
    static void testgetOwnerId() {
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        String ownerid = RequestFeedbackForController.getOwnerId( opp.Id);
        System.assert(ownerid!=null);

    }
    @isTest
    static void testgetDataForContactSubmit(){
        Test.setMock(HttpCalloutMock.class, new HttpMock());
        Test.startTest();
        List<Contact> contacts = [SELECT Id FROM Contact];
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        User sender = [SELECT Id FROM User LIMIT 1];
        List<String> result = RequestFeedbackForController.getDataForContactSubmit(String.valueOf(contacts[0].Id)+','+String.valueOf(contacts[1].Id), opp.Id, sender.Id);
        Test.stopTest();
        System.assert(result!=null);
    }
    @isTest
    static void testgetConactNamesForIds() {
        List<Contact> contacts = [SELECT Id FROM Contact];
        List<String> ids = new List<String>();
        for (Contact contact: contacts) {
            ids.add(contact.id);
        }
        List<String> result = RequestFeedbackForController.getConactNamesForIds(ids);
        System.assert(result.size()>0);
    }
    @isTest
    static void testinsertContact() {
        Account account = [SELECT Name FROM Account LIMIT 1];
        Id oppId = [SELECT Id,Name FROM Opportunity LIMIT 1].Id;
//        RequestFeedbackForController.insertContact('0064B00000EPyklQAD', 'LastTest','FirstTest','23423423423','ceo' , 'boss','test@test.com' , '+10000000000000000000000', 'no',
//                        '+1100000000000000','222','d',  account.Name);
        RequestFeedbackForController.insertContact(oppId, 'LastTest','FirstTest','23423423423','ceo' , 'boss','test@test.com' , '+10000000000000000000000', 'no',
                '+1100000000000000','222','d',  account.Name);
        List<Contact> contact = [SELECT FirstName FROM Contact WHERE LastName='LastTest'];
        System.assert(contact.size()>0);
    }
    @isTest
    static void testGetPickListValuesIntoList() {
        List<String> values=RequestFeedbackForController.getPickListValuesIntoList();
        System.assert(values.size()>0);
        System.assert(values.contains('Executive Sponsor'));
    }
    global class HttpMock implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            System.assertEquals('GET', request.getMethod());
            HTTPResponse resp = new HTTPResponse();
            resp.setStatusCode(200);
            resp.setBody('[{"id":"23423423", "name":"test", "type_value":"2", "type_name":"test"}]');
            return resp;
        }
    }
    @isTest
    static void testGetContactRole() {
        Contact cont = [SELECT id FROM Contact WHERE LastName='testCont' LIMIT 1];
        Opportunity opp = [SELECT Id FROM Opportunity WHERE Name='test' LIMIT 1];
        OpportunityContactRole ContactRole = RequestFeedbackForController.getContactRole(cont.Id ,opp.Id);
        System.assert(ContactRole != null);
    }
    @isTest
    static void testUpdateContact() {
        Contact cont = [SELECT id, Email FROM Contact WHERE LastName='testCont' LIMIT 1];
        Opportunity opp = [SELECT Id FROM Opportunity WHERE Name='test' LIMIT 1];
        RequestFeedbackForController.updateContact(opp.id , 'lastName', 'firstName', cont.id, 'title', 'company_Rolec',
                cont.Email, 'mobilePhone', 'isPrimary', '3232326989', '3232326989',
                'phone_Extensionc', 'accountName');
    }
    @isTest
    static void testGetOpportunityAndAccountNames() {
        Opportunity opp = [SELECT Id FROM Opportunity WHERE Name='test' LIMIT 1];
        List<String> OpportunityAndAccountNames = RequestFeedbackForController.getOpportunityAndAccountNames(opp.Id);
        System.assert(OpportunityAndAccountNames.size()>0);
    }
    @isTest
    static void testGetContact() {
        Contact contTest = [SELECT id, Email FROM Contact WHERE LastName='testCont' LIMIT 1];
        Contact Cont = RequestFeedbackForController.getContact(contTest.Id);
        System.assert(Cont!=null);
    }
    @isTest
    static void testGetSettings() {
//        TruSales_App_Settings__c Setting = RequestFeedbackForController.getSettings();
        Discovery_Bots_Settings__c Setting = RequestFeedbackForController.getSettings();
        System.assert(Setting!=null);
    }
}