@IsTest
public class TruSalesAppSettingsControllerTest {

    @TestSetup
    static void setup(){
//        TruSales_App_Settings__c settings = new TruSales_App_Settings__c(
//                Api_EndPoint__c = 'https://api-releases.primary-intel.com',
//                TruVoice_API_Key__c = '283742893749273894',
//                TruVoice_Client_ID__c = '93458u934058u93458u90',
//                Outcome_Types_Map_1__c = '{"Closed - Won":"1","Closed - No Decision":"3","Closed - Lost to Internal":"2","Closed - Lost to Competitor":"2","Closed - Roll Up":"-1"}',
//                Opportunity_Types_Map_1__c = '{"Renewal":"1","New Business":"2","Add-on":"3","Upsell":"4"}',
//                Opportunity_Amount_Fields__c = 'Amount;ExpectedRevenue;TotalOpportunityQuantity;FiscalQuarter;FiscalYear;Contract_Term__c;Initial_Invoice__c;Deal_Account_volume__c;Per_Deal_Account_amount__c;Foreign_language_amount__c;Fast_start_amount__c;Monthly_software_fee__c'
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
                Is_Active__c = true,
                Initiative_id__c = '5d54220581e08f00086dbcd7'

        );
        insert  settings;



    }

    @IsTest
    private static void opportunityAvailableAmountFieldsTest() {
        Test.setMock(HttpCalloutMock.class,new HttpMockCollectors(Body.BODY));
        Test.startTest();
        TruSalesAppSettingsController controller=new TruSalesAppSettingsController();
        Test.stopTest();

        Map<String, SelectOption> options = new Map<String, SelectOption>();
        for (SelectOption selectOption : controller.opportunityAvailableAmountFields) {
            options.put(selectOption.getValue(), selectOption);
        }

        Set<Schema.DisplayType> availableTypes = new Set<Schema.DisplayType> {
                Schema.DisplayType.DOUBLE,
                Schema.DisplayType.INTEGER,
                Schema.DisplayType.LONG,
                Schema.DisplayType.CURRENCY
        };

        for (Schema.SObjectField field : Schema.getGlobalDescribe().get('Opportunity').getDescribe().fields.getMap().values()) {
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();

            if (availableTypes.contains(fieldDescribe.type)) {
                System.assert(options.containsKey(fieldDescribe.getName()));
            }
        }
    }

    @IsTest
    private static void opportunityAvailableTypeFieldsTest() {
        Test.setMock(HttpCalloutMock.class,new HttpMockCollectors(Body.BODY));
        Test.startTest();
        TruSalesAppSettingsController controller=new TruSalesAppSettingsController();
        Test.stopTest();

        Map<String, SelectOption> options = new Map<String, SelectOption>();
        for (SelectOption selectOption : controller.opportunityAvailableTypeFields) {
            options.put(selectOption.getValue(), selectOption);
        }

        Set<Schema.DisplayType> availableTypes = new Set<Schema.DisplayType> {
                Schema.DisplayType.PICKLIST
        };

        for (Schema.SObjectField field : Schema.getGlobalDescribe().get('Opportunity').getDescribe().fields.getMap().values()) {
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();

            if (availableTypes.contains(fieldDescribe.type)) {
                System.assert(options.containsKey(fieldDescribe.getName()));
            }
        }
    }

    @IsTest
    private static void opportunityRecordTypesTest() {
        Test.setMock(HttpCalloutMock.class,new HttpMockCollectors(Body.BODY));
        Test.startTest();
        TruSalesAppSettingsController controller=new TruSalesAppSettingsController();
        Test.stopTest();

        Map<String, TruSalesAppSettingsController.ButtonWrapper> wrappers = new Map<String, TruSalesAppSettingsController.ButtonWrapper>();
        for (TruSalesAppSettingsController.ButtonWrapper wrapper : controller.opportunityRecordTypes) {
            wrappers.put(wrapper.Id, wrapper);
        }

        for (Schema.RecordTypeInfo recordTypeInfo : Schema.SObjectType.Opportunity.getRecordTypeInfosByName().values()) {
            System.assert(wrappers.containsKey(String.valueOf(recordTypeInfo.getRecordTypeId())));
        }
    }

    @IsTest
    private static void opportunityStagesTest() {
        Test.setMock(HttpCalloutMock.class,new HttpMockCollectors(Body.BODY));
        Test.startTest();
        TruSalesAppSettingsController controller=new TruSalesAppSettingsController();
        Test.stopTest();

        Map<String, TruSalesAppSettingsController.ButtonWrapper> wrappers = new Map<String, TruSalesAppSettingsController.ButtonWrapper>();
        for (TruSalesAppSettingsController.ButtonWrapper wrapper : controller.opportunityStages) {
            wrappers.put(wrapper.Id, wrapper);
        }

        for (OpportunityStage opportunityStage : [
                SELECT Id, MasterLabel, ApiName
                FROM OpportunityStage
                WHERE IsActive = TRUE AND IsClosed = TRUE
        ]) {
            System.assert(wrappers.containsKey(String.valueOf(opportunityStage.ApiName)));
        }
    }

    @IsTest
    private static void opportunityTypesTest() {
        Test.setMock(HttpCalloutMock.class,new HttpMockCollectors(Body.BODY));
        Test.startTest();
        TruSalesAppSettingsController controller=new TruSalesAppSettingsController();
        Test.stopTest();

        Map<String, TruSalesAppSettingsController.ButtonWrapper> wrappers = new Map<String, TruSalesAppSettingsController.ButtonWrapper>();
        for (TruSalesAppSettingsController.ButtonWrapper wrapper : controller.opportunityTypes) {
            wrappers.put(wrapper.Id, wrapper);
        }

        for (PicklistEntry picklistEntry : Schema.getGlobalDescribe().get('Opportunity').getDescribe().fields.getMap().get(controller.settings.Opportunity_Type_Field__c).getDescribe().getPicklistValues()) {
            System.assert(wrappers.containsKey(picklistEntry.getValue()));
        }
    }

    @IsTest
    private static void saveTest() {
        Test.setMock(HttpCalloutMock.class,new HttpMockCollectors(Body.BODY));
        Test.startTest();
        TruSalesAppSettingsController controller=new TruSalesAppSettingsController();
        controller.initiativeId='';
        Test.stopTest();

        controller.settings.Is_Active__c = true;
        controller.Save();

//        TruSales_App_Settings__c settings = TruSales_App_Settings__c.getOrgDefaults();

        Discovery_Bots_Settings__c settings = [SELECT Id, Active_All_Users__c, Active_Product_Fields__c, API_Endpoint__c, API_Endpoint_Profiles__c, Collector_id__c, Name, Enable_Manual_Button_on_VF__c, Enable_Opportunity_Amount__c,
                Enable_Opportunity_Types__c, Enable_Record_Types__c, Enable_Sales_Stages__c, Enable_Sales_Stages_Values__c, Enabled_Opportunity_Stages__c, Enabled_Opportunity_Types__c, Enabled_Record_Types__c,
                Initiative_id__c, Is_Active__c, Open_In_New_Window__c, Opportunity_Amount_Field__c, Opportunity_Amount_Fields__c, Opportunity_Amount_Value__c, Opportunity_Type_Field__c, Opportunity_Type_Sync_Field__c,
                Opportunity_Types_Map_1__c, Opportunity_Types_Map_2__c, Opportunity_Types_Map_3__c, Outcome_Types_Map_1__c, Outcome_Types_Map_2__c, Outcome_Types_Map_3__c, Survey_Collector_Email__c, Survey_Collector_Name__c, TruVoice_API_Key__c,
                TruVoice_Client_ID__c, TruVoiceIntegration__c FROM Discovery_Bots_Settings__c WHERE Name = 'TestSettings'];

        System.assert(settings.Is_Active__c);
        String opportunityTypesSyncValuesJSON = controller.opportunityTypesSyncValuesJSON;
        System.assert(opportunityTypesSyncValuesJSON != null);
        List<SelectOption> endpoints = controller.endpoints;
        System.assert(endpoints != null);
    }

    @IsTest
    private static void opportunityAmountFieldsTest() {
        Test.setMock(HttpCalloutMock.class,new HttpMockCollectors(Body.BODY));
        Test.startTest();
        TruSalesAppSettingsController controller=new TruSalesAppSettingsController();
        Test.stopTest();


        List<TruSalesAppSettingsController.ButtonWrapper> amountFields = controller.opportunityAmountFields;
        List<TruSalesAppSettingsController.ButtonWrapper> amountFieldsTest = new List<TruSalesAppSettingsController.ButtonWrapper>();

        for (Schema.SObjectField field : Opportunity.getSObjectType().getDescribe().fields.getMap().values()) {
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();

            if (!new List<Schema.DisplayType>{
                    Schema.DisplayType.DOUBLE,
                    Schema.DisplayType.INTEGER,
                    Schema.DisplayType.LONG,
                    Schema.DisplayType.CURRENCY
            }.contains(fieldDescribe.type)) {
                continue;
            }

            TruSalesAppSettingsController.ButtonWrapper wrapper = new TruSalesAppSettingsController.ButtonWrapper();

            wrapper.Label = fieldDescribe.getLabel();
            wrapper.Id = fieldDescribe.getName();

            amountFieldsTest.add(wrapper);
        }

        System.assert(amountFields.size() == amountFieldsTest.size());

        for (Integer i = 0; i < amountFields.size(); i++) {
            System.assertEquals(amountFields[i].Label, amountFieldsTest[i].Label);
            System.assertEquals(amountFields[i].Id, amountFieldsTest[i].Id);
        }
    }

    @IsTest
    private static void productPicklistFieldsTest() {
        Test.setMock(HttpCalloutMock.class,new HttpMockCollectors(Body.BODY));
        Test.startTest();
        TruSalesAppSettingsController controller=new TruSalesAppSettingsController();
        Test.stopTest();

        List<TruSalesAppSettingsController.ButtonWrapper> picklistFields = controller.productPicklistFields;
        List<TruSalesAppSettingsController.ButtonWrapper> picklistFieldsTest = new List<TruSalesAppSettingsController.ButtonWrapper>();

        for (Schema.SObjectField field : Product2.getSObjectType().getDescribe().fields.getMap().values()) {
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();

            if (!new List<Schema.DisplayType>{
                    Schema.DisplayType.PICKLIST,
                    Schema.DisplayType.MULTIPICKLIST
            }.contains(fieldDescribe.type)) {
                continue;
            }

            TruSalesAppSettingsController.ButtonWrapper wrapper = new TruSalesAppSettingsController.ButtonWrapper();

            wrapper.Label = fieldDescribe.getLabel();
            wrapper.Id = fieldDescribe.getName();

            picklistFieldsTest.add(wrapper);
        }

        System.assert(picklistFields.size() == picklistFieldsTest.size());

        for (Integer i = 0; i < picklistFields.size(); i++) {
            System.assertEquals(picklistFields[i].Label, picklistFieldsTest[i].Label);
            System.assertEquals(picklistFields[i].Id, picklistFieldsTest[i].Id);
        }
    }

    @IsTest
    private static void opportunityPicklistFieldsTest() {
        Test.setMock(HttpCalloutMock.class,new HttpMockCollectors(Body.BODY));
        Test.startTest();
        TruSalesAppSettingsController controller=new TruSalesAppSettingsController();
        Test.stopTest();

        List<TruSalesAppSettingsController.ButtonWrapper> picklistFields = controller.opportunityPicklistFields;
        List<TruSalesAppSettingsController.ButtonWrapper> picklistFieldsTest = new List<TruSalesAppSettingsController.ButtonWrapper>();

        for (Schema.SObjectField field : Opportunity.getSObjectType().getDescribe().fields.getMap().values()) {
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();

            if (!new List<Schema.DisplayType>{
                    Schema.DisplayType.PICKLIST,
                    Schema.DisplayType.MULTIPICKLIST
            }.contains(fieldDescribe.type)) {
                continue;
            }

            TruSalesAppSettingsController.ButtonWrapper wrapper = new TruSalesAppSettingsController.ButtonWrapper();

            wrapper.Label = fieldDescribe.getLabel();
            wrapper.Id = fieldDescribe.getName();

            picklistFieldsTest.add(wrapper);
        }
        System.assert(picklistFields.size() == picklistFieldsTest.size());

        for (Integer i = 0; i < picklistFields.size(); i++) {
            System.assertEquals(picklistFields[i].Label, picklistFieldsTest[i].Label);
            System.assertEquals(picklistFields[i].Id, picklistFieldsTest[i].Id);
        }
    }

    @IsTest
    private static void updateProductMapFieldObjectTest() {
//        TruSalesAppSettingsController controller = new TruSalesAppSettingsController();
        Test.setMock(HttpCalloutMock.class,new HttpMockCollectors(Body.BODY));
        Test.startTest();
        TruSalesAppSettingsController controller=new TruSalesAppSettingsController();
        Test.stopTest();

        controller.selectedFieldsForProductMap = 'Opportunity.Type;Opportunity.StageName';
        controller.updateProductMapFieldObject();

//        System.assert([
//            SELECT COUNT()
//            FROM TruSales_Product_Map_Item__c
//            WHERE Object_Name__c = 'Opportunity'
//        ] > 0);
    }

    @IsTest
    private static void setTruVoiceProductsTest() {
//        TruSalesAppSettingsController controller = new TruSalesAppSettingsController();
        Test.setMock(HttpCalloutMock.class,new HttpMockCollectors(Body.BODY));
        Test.startTest();
        TruSalesAppSettingsController controller=new TruSalesAppSettingsController();
        Test.stopTest();
        controller.truVoiceProductsJSON = '[{"name":"TestName","label":"TestLabel"}]';
        controller.setTruVoiceProducts();

        System.assertEquals(1, controller.truVoiceProducts.size());
        System.assertEquals('TestName', controller.truVoiceProducts[0].getValue());
        System.assertEquals('TestLabel', controller.truVoiceProducts[0].getLabel());
    }

    @IsTest
    private static void testUpdateIntegrationTab() {
        Test.setMock(HttpCalloutMock.class,new HttpMockCollectors(Body.BODY));
        Test.startTest();
        TruSalesAppSettingsController controller = new TruSalesAppSettingsController();
        Test.stopTest();
        controller.UpdateIntegrationTab();
        controller.setCollectorID();
    }
    @IsTest
    private static void getCollectorsFromServerTestBadMock(){
        Test.setMock(HttpCalloutMock.class,new HttpMockCollectorsFailed());
        Test.startTest();
        TruSalesAppSettingsController controller = new TruSalesAppSettingsController();
        Test.stopTest();
        controller.UpdateIntegrationTab();
        controller.setCollectorID();
    }

    @IsTest
    private static void userProfilesTest(){
        Test.setMock(HttpCalloutMock.class,new HttpMockCollectors(Body.BODY));
        Test.startTest();
        TruSalesAppSettingsController controller=new TruSalesAppSettingsController();
        Test.stopTest();

        Map<String, TruSalesAppSettingsController.ButtonWrapper> wrappers = new Map<String,TruSalesAppSettingsController.ButtonWrapper>();
        for (List<TruSalesAppSettingsController.ButtonWrapper> wrapperList : controller.userProfiles) {
            for(TruSalesAppSettingsController.ButtonWrapper wrapper: wrapperList)
                wrappers.put(wrapper.Label, wrapper);
        }

        for (Profile recordTypeInfo :  [SELECT Id,Name FROM Profile]) {
            System.assert(wrappers.containsKey(String.valueOf(recordTypeInfo.Name)));
        }
    }

    @IsTest
    private static void userRolesTest(){
        Test.setMock(HttpCalloutMock.class,new HttpMockCollectors(Body.BODY));
        Test.startTest();
        TruSalesAppSettingsController controller = new TruSalesAppSettingsController();
        Test.stopTest();

        Map<String, TruSalesAppSettingsController.ButtonWrapper> wrappers = new Map<String, TruSalesAppSettingsController.ButtonWrapper>();
        for (List<TruSalesAppSettingsController.ButtonWrapper> wrapperList : controller.userRoles) {
            for(TruSalesAppSettingsController.ButtonWrapper wrapper: wrapperList)
                wrappers.put(wrapper.Label, wrapper);
        }

        for (UserRole recordTypeInfo :  [SELECT Id,Name FROM UserRole]) {
            System.assert(wrappers.containsKey(String.valueOf(recordTypeInfo.Name)));
        }
    }


    @IsTest
    private static void salesStagesTest(){
        Test.setMock(HttpCalloutMock.class,new HttpMockCollectors(Body.BODY));
        Test.startTest();
        TruSalesAppSettingsController controller=new TruSalesAppSettingsController();
        Test.stopTest();

        Map<String, TruSalesAppSettingsController.ButtonWrapper> wrappers = new Map<String, TruSalesAppSettingsController.ButtonWrapper>();
        for (TruSalesAppSettingsController.ButtonWrapper wrapper : controller.salesStages) {
            wrappers.put(wrapper.Label, wrapper);
        }

        for (OpportunityStage recordTypeInfo :  [SELECT Id,MasterLabel, ApiName FROM OpportunityStage WHERE IsActive = TRUE AND IsClosed = FALSE ]) {
            System.assert(wrappers.containsKey(String.valueOf(recordTypeInfo.ApiName)));
        }
    }


    @IsTest
    private static void productPicklistFieldsSelected(){
        Test.setMock(HttpCalloutMock.class,new HttpMockCollectors(Body.BODY));
        Test.startTest();
        TruSalesAppSettingsController controller=new TruSalesAppSettingsController();
        Test.stopTest();

        Map<String, TruSalesAppSettingsController.ButtonWrapper> wrappers = new Map<String, TruSalesAppSettingsController.ButtonWrapper>();
        for (TruSalesAppSettingsController.ButtonWrapper wrapper : controller.productPicklistFieldsSelected) {
            wrappers.put(wrapper.Label, wrapper);
        }

    }


    @IsTest
    private static void testCheckStatus() {
        Test.setMock(HttpCalloutMock.class,new HttpMockCollectors(Body.BODY));
        Test.startTest();
        TruSalesAppSettingsController controller = new TruSalesAppSettingsController();
        Test.stopTest();
        controller.currentJobStatus = 'Preparing';
        controller.currentJobStatus = 'Processing';
        controller.checkStatus();
    }


    @IsTest
    private static void testGetProductFieldsView() {
        Test.setMock(HttpCalloutMock.class,new HttpMockCollectors(Body.BODY));
        Test.startTest();
        TruSalesAppSettingsController controller = new TruSalesAppSettingsController();
        Test.stopTest();
        controller.checkedProductFieldsValueView = '';
        controller.getProducFieldsView();
    }

    @IsTest
    private static void testGetOpportunityFieldsView() {
        Test.setMock(HttpCalloutMock.class,new HttpMockCollectors(Body.BODY));
        Test.startTest();
        TruSalesAppSettingsController controller = new TruSalesAppSettingsController();
        Test.stopTest();
        controller.checkedOpportunityFieldsValueView = '';
        controller.getOpportunityFieldsView();
    }


    @IsTest
    private static void testUpdateProductTriggerFieldValuesWithProduct() {
        Test.setMock(HttpCalloutMock.class,new HttpMockCollectors(Body.BODY));
        Test.startTest();
        TruSalesAppSettingsController controller = new TruSalesAppSettingsController();
        Test.stopTest();
        controller.selectedValuePickListFromProductTrigger = 'None';
        controller.statusSelectedValuePickListFromProductTrigger = true;
        controller.updateProductTriggerFieldValuesWithProduct();
    }


    @IsTest
    private static void testUpdateProductTriggerFieldValuesWithOpportunity() {
        Test.setMock(HttpCalloutMock.class,new HttpMockCollectors(Body.BODY));
        Test.startTest();
        TruSalesAppSettingsController controller = new TruSalesAppSettingsController();
        Test.stopTest();
        controller.selectedOpportunityValuePickListFromProductTrigger = 'None';
        controller.statusSelectedOpportunityValuePickListFromProductTrigger = true;
        controller.updateProductTriggerFieldValuesWithOpportunity();
    }


    @IsTest
    private static void testUpdateUserProfiles() {
        Test.setMock(HttpCalloutMock.class,new HttpMockCollectors(Body.BODY));
        Test.startTest();
        TruSalesAppSettingsController controller = new TruSalesAppSettingsController();
        Test.stopTest();


        List<Profile> profiles = new List<Profile>();

        profiles = [SELECT Id, Name FROM Profile LIMIT 5];

        List<userWrapper> userProfileWrappers = new List<userWrapper>();

        for(Profile profile : profiles)
        {
            userProfileWrappers.add(new userWrapper(profile.Id,profile.Name));
        }

        List<User> users = controller.updateUserProfiles(JSON.serialize(userProfileWrappers), 'Profiles');

        System.assertEquals(true,!users.isEmpty());
    }

    @IsTest
    private static void testUpdateUserRole() {
        Test.setMock(HttpCalloutMock.class,new HttpMockCollectors(Body.BODY));
        Test.startTest();
        TruSalesAppSettingsController controller = new TruSalesAppSettingsController();
        Test.stopTest();

        List<UserRole> userRoles = new List<UserRole>();
        List<userWrapper> userRoleWrappers = new List<userWrapper>();

        userRoles = [SELECT Id, Name FROM UserRole LIMIT 3];

        for(UserRole userRole: userRoles)
        {
            userRoleWrappers.add(new userWrapper(userRole.Id, userRole.Name));
        }

        List<User> users = controller.updateUserRole(JSON.serialize(userRoleWrappers), 'Roles');
        System.assertEquals(true,!users.isEmpty());
    }

    @IsTest
    private static void testUpdatedAllSelectedProduct() {
        Test.setMock(HttpCalloutMock.class,new HttpMockCollectors(Body.BODY));
        Test.startTest();
        TruSalesAppSettingsController controller = new TruSalesAppSettingsController();
        Test.stopTest();
        controller.allProductUpdated = 'None;Solutions';
        controller.updatedAllSelectedProduct();

    }

    @IsTest
    private static void testUpdatedAllSelectedOpportunity() {
        Test.setMock(HttpCalloutMock.class,new HttpMockCollectors(Body.BODY));
        Test.startTest();
        TruSalesAppSettingsController controller = new TruSalesAppSettingsController();
        Test.stopTest();
        controller.allOpportunityUpdated = 'Pending Renewal;Test for Fit';
        controller.updatedAllSelectedOpportunity();

    }


    @IsTest
    private static void testUpdateSalesStagesFilter() {
        Test.setMock(HttpCalloutMock.class,new HttpMockCollectors(Body.BODY));
        Test.startTest();
        TruSalesAppSettingsController controller = new TruSalesAppSettingsController();
        Test.stopTest();

        controller.updateSalesStagesFilter();

    }

    @IsTest
    private static void testPermissionSetAssignmentUpsert() {
        Test.setMock(HttpCalloutMock.class,new HttpMockCollectors(Body.BODY));
        Test.startTest();
        List<User> users = new List<User>();
        Set<Id> userIds = new Set<Id>();
        users = [SELECT Id FROM User WHERE IsActive = TRUE LIMIT 5];
        for(User u : users)
        {
            userIds.add(u.Id);
        }
        List<PermissionSet> permissionSetIds = new List<PermissionSet>();
        permissionSetIds =  [SELECT Id From PermissionSet WHERE Label = 'Sales Feedback Requester'];
        List<PermissionSetAssignment> deletePermissionSetAssignments = new List<PermissionSetAssignment>();
        Id permissionId;

        if(!permissionSetIds.isEmpty()) {
            permissionId = permissionSetIds[0].Id;
        }
        deletePermissionSetAssignments = [ SELECT Id FROM PermissionSetAssignment WHERE PermissionSetId =: permissionId];
        delete deletePermissionSetAssignments;

        TruSalesAppSettingsSaveFuture.permissionSetAssignmentUpsert(userIds);
        Test.stopTest();
    }

    public class userWrapper
    {
        public userWrapper(String id, String Label)
        {
            this.Id = id;
            this.label = Label;
        }
        String Id;
        String label;
    }










}