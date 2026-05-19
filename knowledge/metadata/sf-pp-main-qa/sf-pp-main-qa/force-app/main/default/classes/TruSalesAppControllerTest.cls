@IsTest
public with sharing class TruSalesAppControllerTest {

    @TestSetup
    private static void createTestData() {
        Account account = new Account(Name = 'test');
        insert account;
        Opportunity opportunity = new Opportunity(
                CloseDate = Date.today().addDays(1),
                RecordTypeId = [
                        SELECT Id
                        FROM RecordType
                        WHERE SobjectType = 'Opportunity'
                        LIMIT 1
                ].Id,
                Amount = 1000,
                StageName = [
                        SELECT Id, MasterLabel, ApiName
                        FROM OpportunityStage
                        WHERE IsActive = TRUE AND IsClosed = TRUE
                        LIMIT 1
                ].ApiName,
                Name = 'Test opportunity',
                Type = Opportunity.Type.getDescribe().getPicklistValues()[0].getValue(),
                AccountId = account.Id
        );
        opportunity.put('Proposed_Amount__c', 1000);
        insert opportunity;

//        TruSales_Product_Map_Item__c pmi = new TruSales_Product_Map_Item__c(Object_Name__c = 'Opportunity', Field_Name__c='Id');
//        insert pmi;
//        TruSales_Product_Map_Item__c pmi1 = new TruSales_Product_Map_Item__c(Object_Name__c = 'Product2', Field_Name__c='Id');
//        insert pmi1;

        Profile p = [SELECT Id FROM Profile WHERE Name ='Standard User'];
        User user = new User(FirstName = 'testTruSalesAppControllerTest', LastName = 'testTruSalesAppControllerTest', Email = 'TruSalesAppControllerTesttest@test.com', Alias='AUser', Username='TruSalesAppControllerTesttetststs@test.com', LocaleSidKey = 'en_US', EmailEncodingKey='UTF-8',
                LanguageLocaleKey ='en_US', TimeZoneSidKey = 'Pacific/Kiritimati', ProfileId = p.Id);
        insert user;


    }

    @IsTest
    private static void suitableTest_IsActive() {
        Test.startTest();
        Opportunity opportunity = [
                SELECT Id
                FROM Opportunity
                LIMIT 1
        ];

        Discovery_Bots_Settings__c settings = new Discovery_Bots_Settings__c(
                Name = 'TestSettings',
                Is_Active__c = true,
                Enabled_Opportunity_Stages__c = [
                        SELECT Id, MasterLabel, ApiName
                        FROM OpportunityStage
                        WHERE IsActive = TRUE AND IsClosed = TRUE
                        LIMIT 1
                ].ApiName
        );
        insert  settings;
        //System.assertEquals(false, TruSalesAppController.isSuitableOpportunity(opportunity.Id));

//        TruSales_App_Settings__c settings = new TruSales_App_Settings__c(
//            Is_Active__c = true,
//            Enabled_Opportunity_Stages__c = [
//                SELECT Id, MasterLabel, ApiName
//                FROM OpportunityStage
//                WHERE IsActive = TRUE AND IsClosed = TRUE
//                LIMIT 1
//            ].ApiName
//        );
//        insert settings;
        Test.stopTest();


        System.assertEquals(true, TruSalesAppController.isSuitableOpportunity(opportunity.Id));
    }

    @IsTest
    private static void suitableTest_Amount() {
        Test.startTest();
        Opportunity opportunity = [
                SELECT Id
                FROM Opportunity
                LIMIT 1
        ];

//        TruSales_App_Settings__c settings = new TruSales_App_Settings__c(
//            Is_Active__c = true,
//            Enabled_Opportunity_Stages__c = [
//                SELECT Id, MasterLabel, ApiName
//                FROM OpportunityStage
//                WHERE IsActive = TRUE AND IsClosed = TRUE
//                LIMIT 1
//            ].ApiName,
//            Enable_Opportunity_Amount__c = true,
//            Opportunity_Amount_Field__c = 'Amount',
//            Opportunity_Amount_Value__c = 999
//        );
//        insert settings;

        Discovery_Bots_Settings__c settings = new Discovery_Bots_Settings__c(
                Name = 'TestSettings',
                Is_Active__c = true,
                Enabled_Opportunity_Stages__c = [
                        SELECT Id, MasterLabel, ApiName
                        FROM OpportunityStage
                        WHERE IsActive = TRUE AND IsClosed = TRUE
                        LIMIT 1
                ].ApiName,
                Enable_Opportunity_Amount__c = true,
                Opportunity_Amount_Field__c = 'Amount',
                Opportunity_Amount_Value__c = 999,
                Active_Product_Fields__c = true,
                Enable_Sales_Stages__c = true
        );
        insert  settings;

        Test.stopTest();


        System.assertEquals(false, TruSalesAppController.isSuitableOpportunity(opportunity.Id));
    }

    @IsTest
    private static void suitableTest_RecordTypes() {
        Test.startTest();
        Opportunity opportunity = [
                SELECT Id
                FROM Opportunity
                LIMIT 1
        ];

//        TruSales_App_Settings__c settings = new TruSales_App_Settings__c(
//            Is_Active__c = true,
//            Enabled_Opportunity_Stages__c = [
//                SELECT Id, MasterLabel, ApiName
//                FROM OpportunityStage
//                WHERE IsActive = TRUE AND IsClosed = TRUE
//                LIMIT 1
//            ].ApiName,
//            Enable_Record_Types__c = true,
//            Enabled_Record_Types__c = [
//                SELECT Id
//                FROM RecordType
//                WHERE SobjectType = 'Opportunity'
//                LIMIT 1
//            ].Id
//        );
//        insert settings;


        Discovery_Bots_Settings__c settings = new Discovery_Bots_Settings__c(
                Name = 'TestSettings',
                Is_Active__c = true,
                Enabled_Opportunity_Stages__c = [
                        SELECT Id, MasterLabel, ApiName
                        FROM OpportunityStage
                        WHERE IsActive = TRUE AND IsClosed = TRUE
                        LIMIT 1
                ].ApiName,
                Enable_Record_Types__c = true,
                Enabled_Record_Types__c = [
                        SELECT Id
                        FROM RecordType
                        WHERE SobjectType = 'Opportunity'
                        LIMIT 1
                ].Id
        );
        insert  settings;

        Test.stopTest();

        System.assertEquals(true, TruSalesAppController.isSuitableOpportunity(opportunity.Id));
    }

    @IsTest
    private static void suitableTest_Types() {
        Test.startTest();
        Opportunity opportunity = [
                SELECT Id, Type
                FROM Opportunity
                LIMIT 1
        ];

//        TruSales_App_Settings__c settings = new TruSales_App_Settings__c(
//            Is_Active__c = true,
//            Enabled_Opportunity_Stages__c = [
//                SELECT Id, MasterLabel, ApiName
//                FROM OpportunityStage
//                WHERE IsActive = TRUE AND IsClosed = TRUE
//                LIMIT 1
//            ].ApiName,
//            Enable_Opportunity_Types__c = true,
//            Enabled_Opportunity_Types__c = opportunity.Type,
//            Opportunity_Type_Field__c = 'Type'
//        );
//        insert settings;


        Discovery_Bots_Settings__c settings = new Discovery_Bots_Settings__c(
                Name = 'TestSettings',
                Is_Active__c = true,
                Enabled_Opportunity_Stages__c = [
                        SELECT Id, MasterLabel, ApiName
                        FROM OpportunityStage
                        WHERE IsActive = TRUE AND IsClosed = TRUE
                        LIMIT 1
                ].ApiName,
                Enable_Opportunity_Types__c = true,
                Enabled_Opportunity_Types__c = opportunity.Type,
                Opportunity_Type_Field__c = 'Type'
        );
        insert  settings;

        Test.stopTest();



        System.assertEquals(true, TruSalesAppController.isSuitableOpportunity(opportunity.Id));
    }

    @IsTest
    private static void suitableTest_withSettings() {
        Opportunity opportunity = [
                SELECT Id, Type
                FROM Opportunity
                LIMIT 1
        ];

//        TruSales_App_Settings__c settings = new TruSales_App_Settings__c(
//            Is_Active__c = true,
//            Enabled_Opportunity_Stages__c = [
//                SELECT Id, MasterLabel, ApiName
//                FROM OpportunityStage
//                WHERE IsActive = TRUE AND IsClosed = TRUE
//                LIMIT 1
//            ].ApiName,
//            Enable_Opportunity_Types__c = true,
//            Enabled_Opportunity_Types__c = opportunity.Type,
//            Opportunity_Type_Field__c = 'Type'
//        );
//        insert settings;


        Discovery_Bots_Settings__c settings = new Discovery_Bots_Settings__c(
                Name = 'TestSettings',
                Is_Active__c = true,
                Enabled_Opportunity_Stages__c = [
                        SELECT Id, MasterLabel, ApiName
                        FROM OpportunityStage
                        WHERE IsActive = TRUE AND IsClosed = TRUE
                        LIMIT 1
                ].ApiName,
                Enable_Opportunity_Types__c = true,
                Enabled_Opportunity_Types__c = opportunity.Type,
                Opportunity_Type_Field__c = 'Type'
        );
        insert  settings;

        System.assertNotEquals(null, TruSalesAppController.getSettings());

        ApexPages.StandardController sc = new ApexPages.StandardController(settings);
        System.assertNotEquals(null, new TruSalesAppController(sc).settings);
    }

//    @IsTest
//    private static void suitableTest_withoutSettings() {
//        System.debug('suitableTest_withoutSettings()!!!!!!');
//        System.debug('suitableTest_withoutSettings()' + TruSalesAppController.getSettings());
//       Opportunity opportunity = [
//            SELECT Id, Type
//            FROM Opportunity
//            LIMIT 1
//        ];
//        System.assertNotEquals(null, TruSalesAppController.getSettings());
//    }

    @IsTest
    private static void notSuitableTest_Stage() {
        Account account = [SELECT Id,Name FROM Account WHERE Name ='test'];
        Opportunity opp = new Opportunity(
                CloseDate = Date.today().addDays(1),
                RecordTypeId = [
                        SELECT Id
                        FROM RecordType
                        WHERE SobjectType = 'Opportunity'
                        LIMIT 1
                ].Id,
                Amount = 1000,
                StageName = 'Procurement',
                Name = 'Test opportunity 1',
                Type = Opportunity.Type.getDescribe().getPicklistValues()[0].getValue(),
                AccountId = account.Id
        );
        opp.put('Proposed_Amount__c', 1000);
        insert opp;

//        TruSales_App_Settings__c settings = new TruSales_App_Settings__c(
//            Is_Active__c = true,
//            Enabled_Opportunity_Stages__c = [
//                SELECT Id, MasterLabel, ApiName
//                FROM OpportunityStage
//                WHERE IsActive = TRUE AND IsClosed = TRUE
//                LIMIT 1
//            ].ApiName,
//            Enable_Opportunity_Types__c = true,
//            Enabled_Opportunity_Types__c = opp.Type,
//            Opportunity_Type_Field__c = 'Type'
//        );
//        insert settings;


        Discovery_Bots_Settings__c settings = new Discovery_Bots_Settings__c(
                Name = 'TestSettings',
                Is_Active__c = true,
                Enabled_Opportunity_Stages__c = [
                        SELECT Id, MasterLabel, ApiName
                        FROM OpportunityStage
                        WHERE IsActive = TRUE AND IsClosed = TRUE
                        LIMIT 1
                ].ApiName,
                Enable_Opportunity_Types__c = true,
                Enabled_Opportunity_Types__c = opp.Type,
                Opportunity_Type_Field__c = 'Type'
        );
        insert  settings;

        System.assertEquals(false, TruSalesAppController.isSuitableOpportunity(opp.Id));
    }

    @IsTest
    private static void notSuitableTest_Type() {
        Account account = [SELECT Id,Name FROM Account WHERE Name ='test'];
        Opportunity opp = new Opportunity(
                CloseDate = Date.today().addDays(1),
                RecordTypeId = [
                        SELECT Id
                        FROM RecordType
                        WHERE SobjectType = 'Opportunity'
                        LIMIT 1
                ].Id,
                Amount = 1000,
                StageName = [
                        SELECT Id, MasterLabel, ApiName
                        FROM OpportunityStage
                        WHERE IsActive = TRUE AND IsClosed = TRUE
                        LIMIT 1
                ].ApiName,
                Name = 'Test opportunity 1',
                Type = Opportunity.Type.getDescribe().getPicklistValues()[0].getValue(),
                AccountId = account.Id);
        opp.put('Proposed_Amount__c', 1000);
        insert opp;

//        TruSales_App_Settings__c settings = new TruSales_App_Settings__c(
//            Is_Active__c = true,
//            Enabled_Opportunity_Stages__c = [
//                SELECT Id, MasterLabel, ApiName
//                FROM OpportunityStage
//                WHERE IsActive = TRUE AND IsClosed = TRUE
//                LIMIT 1
//            ].ApiName,
//            Enable_Opportunity_Types__c = true,
//            Enabled_Opportunity_Types__c = 'Type',
//            Opportunity_Type_Field__c = 'Type'
//        );
//        insert settings;


        Discovery_Bots_Settings__c settings = new Discovery_Bots_Settings__c(
                Name = 'TestSettings',
                Is_Active__c = true,
                Enabled_Opportunity_Stages__c = [
                        SELECT Id, MasterLabel, ApiName
                        FROM OpportunityStage
                        WHERE IsActive = TRUE AND IsClosed = TRUE
                        LIMIT 1
                ].ApiName,
                Enable_Opportunity_Types__c = true,
                Enabled_Opportunity_Types__c = 'Type',
                Opportunity_Type_Field__c = 'Type'
        );
        insert  settings;

        System.assertEquals(false, TruSalesAppController.isSuitableOpportunity(opp.Id));
    }

    @IsTest
    private static void notSuitableTest_RecordTypes() {

        List<TruSales_Product_Map_Item__c> truSalesProductMapItems = new List<TruSales_Product_Map_Item__c>();

        TruSales_Product_Map_Item__c truSalesProductMapItem1 = new TruSales_Product_Map_Item__c(Field_Name__c = 'StageName',
                Picklist_Value__c = [
                        SELECT Id, MasterLabel, ApiName
                        FROM OpportunityStage
                        WHERE IsActive = TRUE AND IsClosed = TRUE
                        LIMIT 1
                ].ApiName,
                Object_Name__c = 'Opportunity');



        TruSales_Product_Map_Item__c truSalesProductMapItem2 = new TruSales_Product_Map_Item__c(Field_Name__c = 'Family',
                Picklist_Value__c = 'Solutions',
                Object_Name__c = 'Product2');

        truSalesProductMapItems.add(truSalesProductMapItem1);
        truSalesProductMapItems.add(truSalesProductMapItem2);

        insert truSalesProductMapItems;

        Account account = [SELECT Id,Name FROM Account WHERE Name ='test'];
        Opportunity opp = new Opportunity(
                CloseDate = Date.today().addDays(1),
                RecordTypeId = [
                        SELECT Id
                        FROM RecordType
                        WHERE SobjectType = 'Opportunity'
                        LIMIT 1
                ].Id,
                Amount = 1000,
                StageName = [
                        SELECT Id, MasterLabel, ApiName
                        FROM OpportunityStage
                        WHERE IsActive = TRUE AND IsClosed = TRUE
                        LIMIT 1
                ].ApiName,
                Name = 'Test opportunity 1',
                Type = Opportunity.Type.getDescribe().getPicklistValues()[0].getValue(),
                AccountId = account.Id);
        opp.put('Proposed_Amount__c', 1000);

        insert opp;

        Id pricebookId = Test.getStandardPricebookId();

        Product2 prod = new Product2(
                Name = 'Product X',
                ProductCode = 'Pro-X',
                Family = 'Solutions',
                isActive = true
        );
        insert prod;

        PricebookEntry pbEntry = new PricebookEntry(
                Pricebook2Id = pricebookId,
                Product2Id = prod.Id,
                UnitPrice = 100.00,
                IsActive = true
        );
        insert pbEntry;

        OpportunityLineItem opportunityLineItem = new OpportunityLineItem(OpportunityId = opp.Id, Quantity = 1, TotalPrice = 1000, PricebookEntryId = pbEntry.Id);
        insert opportunityLineItem;


        Discovery_Bots_Settings__c settings = new Discovery_Bots_Settings__c(
                Name = 'TestSettings',
                Is_Active__c = true,
                Enabled_Opportunity_Stages__c = [
                        SELECT Id, MasterLabel, ApiName
                        FROM OpportunityStage
                        WHERE IsActive = TRUE AND IsClosed = TRUE
                        LIMIT 1
                ].ApiName,

                Opportunity_Type_Field__c = 'Type',
                Enable_Record_Types__c = true,
                Enabled_Record_Types__c = 'Type',
                Enable_Opportunity_Amount__c = true,
                Opportunity_Amount_Field__c = 'Amount',
                Opportunity_Amount_Value__c = 5000,
                Active_Product_Fields__c = true,
                Enabled_Opportunity_Types__c = 'Renewal',
                Enable_Sales_Stages__c = true,
                Enable_Sales_Stages_Values__c = opp.StageName
        );
        insert  settings;

        System.assertEquals(false, TruSalesAppController.isSuitableOpportunity(opp.Id));

//        TruSales_App_Settings__c settings = new TruSales_App_Settings__c(
//            Is_Active__c = true,
//            Enabled_Opportunity_Stages__c = [
//                SELECT Id, MasterLabel, ApiName
//                FROM OpportunityStage
//                WHERE IsActive = TRUE AND IsClosed = TRUE
//                LIMIT 1
//            ].ApiName,
//            Enable_Opportunity_Types__c = true,
//            Enabled_Opportunity_Types__c = opp.Type,
//            Opportunity_Type_Field__c = 'Type',
//            Enable_Record_Types__c = true,
//            Enabled_Record_Types__c = 'Type'
//        );
//        insert settings;





    }
    @IsTest
    private static void testGetSettings() {
//        TruSales_App_Settings__c settings = new TruSales_App_Settings__c(
//        Api_EndPoint__c = 'https://api-releases.primary-intel.com',
//        Outcome_Types_Map_1__c = '{"Closed - Won":"1","Closed - No Decision":"3","Closed - Lost to Internal":"2","Closed - Lost to Competitor":"2","Closed - Roll Up":"-1"}',
//        Opportunity_Types_Map_1__c = '{"Renewal":"1","New Business":"2","Add-on":"3","Upsell":"4"}',
//        Opportunity_Amount_Fields__c = 'Amount;ExpectedRevenue;TotalOpportunityQuantity;FiscalQuarter;FiscalYear;Contract_Term__c;Initial_Invoice__c;Deal_Account_volume__c;Per_Deal_Account_amount__c;Foreign_language_amount__c;Fast_start_amount__c;Monthly_software_fee__c'
//        );
//        insert settings;
//        TruSales_App_Settings__c setts = TruSalesAppController.getSettings();

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

        Discovery_Bots_Settings__c setts = TruSalesAppController.getSettings();
        System.assertEquals('https://api-releases.primary-intel.com', setts.Api_EndPoint__c);


    }
    @IsTest
    private static void testGetOwnerId() {
        Opportunity opp = [SELECT Id, OwnerId FROM Opportunity LIMIT 1];
        System.assertEquals(opp.OwnerId, TruSalesAppController.getOwnerId(opp.Id));

    }
    @IsTest
    private static void testGetJSONStringForOpportunitiesSync() {
//        TruSales_App_Settings__c settings = new TruSales_App_Settings__c(
//        Api_EndPoint__c = 'https://api-releases.primary-intel.com',
//        Outcome_Types_Map_1__c = '{"Closed - Won":"1","Closed - No Decision":"3","Closed - Lost to Internal":"2","Closed - Lost to Competitor":"2","Closed - Roll Up":"-1"}',
//        Opportunity_Types_Map_1__c = '{"Renewal":"1","New Business":"2","Add-on":"3","Upsell":"4"}',
//        Opportunity_Amount_Fields__c = 'Amount;ExpectedRevenue;TotalOpportunityQuantity;FiscalQuarter;FiscalYear;'
//        );
//        insert settings;


        Discovery_Bots_Settings__c settings = new Discovery_Bots_Settings__c(
                Name = 'TestSettings',
                Api_EndPoint__c = 'https://api-releases.primary-intel.com',
                Outcome_Types_Map_1__c = '{"Closed - Won":"1","Closed - No Decision":"3","Closed - Lost to Internal":"2","Closed - Lost to Competitor":"2","Closed - Roll Up":"-1"}',
                Opportunity_Types_Map_1__c = '{"Renewal":"1","New Business":"2","Add-on":"3","Upsell":"4"}',
                Opportunity_Amount_Fields__c = 'Amount;ExpectedRevenue;TotalOpportunityQuantity;FiscalQuarter;FiscalYear;',
                Opportunity_Type_Sync_Field__c = 'Type',
                Is_Active__c = true,
                Active_Product_Fields__c = true

        );
        insert  settings;
        List<TruSales_Product_Map_Item__c> truSalesProductMapItems = new List<TruSales_Product_Map_Item__c>();

        TruSales_Product_Map_Item__c truSalesProductMapItem1 = new TruSales_Product_Map_Item__c(Field_Name__c = 'StageName',
                Picklist_Value__c = [
                        SELECT Id, MasterLabel, ApiName
                        FROM OpportunityStage
                        WHERE IsActive = TRUE AND IsClosed = TRUE
                        LIMIT 1
                ].ApiName,
                Object_Name__c = 'Opportunity');



        TruSales_Product_Map_Item__c truSalesProductMapItem2 = new TruSales_Product_Map_Item__c(Field_Name__c = 'Family',
                Picklist_Value__c = 'Solutions',
                Object_Name__c = 'Product2');

        truSalesProductMapItems.add(truSalesProductMapItem1);
        truSalesProductMapItems.add(truSalesProductMapItem2);


        insert truSalesProductMapItems;

        Account account = [SELECT Id,Name FROM Account WHERE Name ='test'];
        Opportunity opp = new Opportunity(
                CloseDate = Date.today().addDays(1),
                RecordTypeId = [
                        SELECT Id
                        FROM RecordType
                        WHERE SobjectType = 'Opportunity'
                        LIMIT 1
                ].Id,
                Amount = 1000,
                StageName = [
                        SELECT Id, MasterLabel, ApiName
                        FROM OpportunityStage
                        WHERE IsActive = TRUE AND IsClosed = TRUE
                        LIMIT 1
                ].ApiName,
                Name = 'Test opportunity 1',
                Type = Opportunity.Type.getDescribe().getPicklistValues()[0].getValue(),
                AccountId = account.Id);
        opp.put('Proposed_Amount__c', 1000);
        //opp.put('Program_Type__c', 'Not Applicable');

        insert opp;
        Id OwnerId = [SELECT Id, OwnerId FROM Opportunity LIMIT 1].OwnerId;
        Map<String, String> truVoiceProducts =  new Map<String, String>();
        truVoiceProducts.put('test', 'test1');

        String response = TruSalesAppController.getJSONStringForOpportunitiesSync('', OwnerId, truVoiceProducts);
        System.debug(response);
        System.assertNotEquals(null, response);
    }

    @IsTest
    private static void testGetOpportunityName() {
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        System.assertNotEquals(null, TruSalesAppController.getOpportunityName(opp.Id));
    }
    @IsTest
    private static void testGetEmail() {
        User user = [SELECT Id FROM User LIMIT 1];
        System.assertNotEquals(null, TruSalesAppController.getEmail(user.Id));
    }

    @IsTest
    private static void testGetUserInfo() {

        List<Profile> profiles = new List<Profile>();
        profiles = [SELECT Id,Name FROM Profile];
        User u = new User(
                ProfileId = profiles[0].Id,
                Username = 'testGetUserInfo1234423@test.com',
                Alias = 'usertest',
                Email='testGetUserInfo1234423@test.com',
                EmailEncodingKey='UTF-8',
                FirstName='FirstNameUser',
                LastName='LastNameUser',
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_US',
                TimeZoneSidKey='America/Chicago',
                Feedback_Request_Allowed__c = true
        );
        insert u;

        User u1 = [SELECT Id, Feedback_Request_Allowed__c, ProfileId From User WHERE Username = 'testGetUserInfo1234423@test.com' LIMIT 1];
        System.runAs(u1){
            System.assertEquals(true, TruSalesAppController.getUserInfo());
        }
    }

    @IsTest
    private static void testGetOpportunityStatusApex() {
        Account account = [SELECT Id,Name FROM Account WHERE Name ='test'];
        Opportunity opp = new Opportunity(
                CloseDate = Date.today().addDays(1),
                RecordTypeId = [
                        SELECT Id
                        FROM RecordType
                        WHERE SobjectType = 'Opportunity'
                        LIMIT 1
                ].Id,
                Amount = 1000,
                StageName = [
                        SELECT Id, MasterLabel, ApiName
                        FROM OpportunityStage
                        WHERE IsActive = TRUE AND IsClosed = TRUE
                        LIMIT 1
                ].ApiName,
                Name = 'Test opportunity 1',
                Type = Opportunity.Type.getDescribe().getPicklistValues()[0].getValue(),
                AccountId = account.Id
        );

        insert opp;
        List<String> testStrings =  TruSalesAppController.getOpportunityStatusApex(opp.Id);
        System.assert(!testStrings.isEmpty());

    }
}