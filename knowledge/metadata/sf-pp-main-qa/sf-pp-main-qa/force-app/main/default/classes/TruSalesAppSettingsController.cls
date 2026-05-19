public with sharing class TruSalesAppSettingsController {

    //public TruSales_App_Settings__c settings { get; private set; }

    public 	Discovery_Bots_Settings__c settings { get; private set;}

    //private static TruSales_App_Settings__c settingsStatic;
    private static Discovery_Bots_Settings__c settingsStatic;
    public List<Collector> collectors_ids { get; set; }
    private static List<Collector> collectors_idsStatic;


    public String initiativeId { get; set; }
    private static String initiativeIdStatic;
    public String selectedAPI { get; set; }
    public Boolean showErrorMsg { get; set; }

    public Id settingsStaticId;
    public List<Id> usersIds = new List<Id>();

    public List<User> UsersFields = new List<User>();
    public List<List<User>> UsersFieldsList { get; set; }
    private static List<List<User>> UsersFieldsListStatic;
    private static List<List<User>> userWithFeedbackRequestAllowed{get;set;}


    public List<TruSales_Product_Map_Item__c> productMapItems { get; private set; }
    private static List<TruSales_Product_Map_Item__c> productMapItemsStatic;

    public List<SelectOption> truVoiceProducts { get; set; }
    public String truVoiceProductsJSON { get; set; }

    public String outcomeTypesMap { get; set; }
    private static String outcomeTypesMapStatic;
    public String opportunityTypesMap { get; set; }
    private static String opportunityTypesMapStatic;

    public Id jobId{get;set;}
   // public AsyncApexJob jobInf{get;set;}

    private List<Id> productMapItemsIds;


    public String currentJobStatus {get;set;}

//    public String collerctorId {get; set;}
//    public String selectedCollector {get; set;}



    //Bar
    public Decimal deProgressBarWidth {get;set;}
    public Integer iCount {get;set;}
    public String strStatus {get;set;}
    public Boolean bProcess {get;set;}
    private Integer requestCount = 1;


    //Product Triggers
    public String checkedProductFieldsValueView {get; set;}
    public String checkedOpportunityFieldsValueView {get; set;}
    public List<String> valuesForViewFromProduct {get;set;}
    public List<String> valuesForViewFromOpportunity {get;set;}


    public Map<String,List<String>> fieldNameValueMap {get;set;}
    public String selectedValuePickListFromProductTrigger{get;set;}
    public Boolean statusSelectedValuePickListFromProductTrigger {get;set;}

    public String selectedOpportunityValuePickListFromProductTrigger{get;set;}
    public Boolean statusSelectedOpportunityValuePickListFromProductTrigger {get;set;}




    //Sales Stage
    public String selectedSalesStages{get;set;}
    public static String selectedSalesStagesString{get;set;}
    public String currentlySelectedSalesStages{get;set;}

    public Boolean enableSelectedSalesStages{get;set;}


    //User
    public String selectByValue {get;set;}


    //Profiles for user
    public String UserProfilesSelected {get;set;}

    //Role for user
    public String UserRolesSelected{get;set;}


    //innit selectList for users tab
    public String selectedUserValueForUserFilterSelect {get;set;}




    //Issue 45
    //Updated All Product From Product Trigger
    public String allProductUpdated{get;set;}
    public String allOpportunityUpdated{get;set;}









    //Email
//    private List<User> testListUsers {get;set;}
//    public List<String> testListStrings {get;set;}
//
//    public String recepients {get;set;}
//    public String emailBody {get;set;}
//    public String emailSubject {get;set;}




    private List<Discovery_Bots_Settings__c> discoveryBotsSettingsDeleted = new List<Discovery_Bots_Settings__c>();


    public TruSalesAppSettingsController() {

//        emailBody = [SELECT Id, Name, TemplateType, Body, Subject,HtmlValue  From EmailTemplate WHERE Name = 'TestEmailTmp' LIMIT 1].HtmlValue;
//        recepients = null;
//
//        testListStrings = new List<String>();
//        testListUsers = new List<User>();
//
//        testListUsers = [SELECT Name, Email FROM User];
//
//        if(!testListUsers.isEmpty())
//        {
//            for (User u : testListUsers)
//            {
//                testListStrings.add(u.Name + '\n' + u.Email);
//            }
//        }


        System.debug('TruSalesAppSettingsController');
        if (Test.isRunningTest()) {
            checkSettingsExisting();
        }

        deProgressBarWidth = 0;
        strStatus = 'Started';
        bProcess = false;
        iCount = 0;


        List<TruSales_Users_Item__c> truSalesUsersItems = new List<TruSales_Users_Item__c>();
        truSalesUsersItems = [SELECT Select_by__c FROM TruSales_Users_Item__c LIMIT 1];

        if(!truSalesUsersItems.isEmpty())
        {
            selectedUserValueForUserFilterSelect = truSalesUsersItems[0].Select_by__c;
        }
        else {
            selectedUserValueForUserFilterSelect = 'Users';
        }


        //List<TruSales_App_Settings__c> truSalesAppSettings = new List<TruSales_App_Settings__c>();


        List<Discovery_Bots_Settings__c> truSalesAppSettings = new List<Discovery_Bots_Settings__c>();
        //truSalesAppSettings = [SELECT Enable_Sales_Stages_Values__c FROM TruSales_App_Settings__c LIMIT 1];
        truSalesAppSettings = [SELECT Enable_Sales_Stages_Values__c FROM Discovery_Bots_Settings__c LIMIT 1];

        if(!truSalesAppSettings.isEmpty())
        {
            selectedSalesStages = truSalesAppSettings[0].Enable_Sales_Stages_Values__c;
        }
        else
        {
            selectedSalesStages = '';
        }

    }



    public SelectOption[] getSelectOptionFromUserFilterSelect()
    {
        return new SelectOption[]
        {
                new SelectOption('Users','Users'),
                new SelectOption('Profiles','Profiles'),
                new SelectOption('Roles','Roles')
        };

    }


    public List<SelectOption> opportunityAvailableAmountFields {
        get {
            List<SelectOption> result = new List<SelectOption>();

            Set<Schema.DisplayType> availableTypes = new Set<Schema.DisplayType>{
                    Schema.DisplayType.DOUBLE,
                    Schema.DisplayType.INTEGER,
                    Schema.DisplayType.LONG,
                    Schema.DisplayType.CURRENCY
            };

            /* for (Schema.DescribeFieldResult field : getFieldsByType('Opportunity', availableTypes)) {
                   result.add(new SelectOption(field.getName(), field.getLabel()));

               }*/
            for (Schema.DescribeFieldResult field : getFieldsByType('Opportunity', availableTypes)) {
                result.add(new SelectOption(field.getName(), field.getLabel()));
            }

            return result;
        }
    }
    public void setCollectorID() {

        for (Collector collector:collectors_ids) {
            if (initiativeId == collector.collector_id) {
                settings.Collector_id__c = collector.collector_id;
                settings.Initiative_id__c = collector.initiative_id;
            }
        }
    }
    public List<SelectOption> selectValuesCollectors { get; set; }

    public List<SelectOption> getCollectorsFromServer() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        List<Collector> collectors = new List<Collector>();
        List<SelectOption> options = new List<SelectOption>();
        settings.API_Endpoint__c = selectedAPI;
        System.debug('settings.API_Endpoint__c: ' + settings.API_Endpoint__c);
        collectors_ids = new List<Collector>();

        request.setEndpoint(settings.API_Endpoint__c + '/rest/clients/' + settings.TruVoice_Client_ID__c + '/collectors');
        request.setMethod('GET');
        request.setHeader('apiKey', settings.TruVoice_API_Key__c != null ? settings.TruVoice_API_Key__c : '');
        request.setHeader('x-truvoice-client', settings.TruVoice_Client_ID__c != null ? settings.TruVoice_Client_ID__c : '') ;
        HttpResponse response = http.send(request);
        System.debug('REQUEST: ' + request);
        if (response.getStatusCode() == 200) {

            System.debug('RESPONSE: ' + response.getBody());
            collectors = (List<Collector>) JSON.deserialize(response.getBody(), List<Collector>.class);
            System.debug('!!!collectors: ' + collectors);

            for (Collector collector:collectors) {
                SelectOption option = new SelectOption(collector.collector_id, collector.collector_name);
                collectors_ids.add(collector);
                options.add(option);
                System.debug('CollectorFOR: ' + collector);
                System.debug('OPTIONFOR : ' + option);
            }
        } else {
            SelectOption option = new SelectOption('Error', 'ERROR: Need to setup a Survey Collector for ' + settings.TruVoice_Client_ID__c);
            options.add(option);
            showErrorMsg = true;
            System.debug('<<<<<<<<<<SHOW ERROR>>>>>> ' + showErrorMsg);
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'ERROR: Need to setup a Survey Collector for ' + settings.TruVoice_Client_ID__c));
            initiativeId = '';
        }
        return options;
    }

    public class Collector {
        public String initiative_id { get; set; }
        public String collector_id { get; set; }
        public String collector_name { get; set; }
        public String from_email { get; set; }
//        public String date_created {get; set;}
//        public String date_survey_start {get; set;}
//        public Boolean is_active {get; set;}
//        public Time_zone time_zone {get; set;}
//        public Boolean is_email_confirmed {get; set;}

    }
//    private class Time_zone {
//        public String utc {get; set;}
//        public String text {get; set;}
//    }

    public List<SelectOption> opportunityAvailableTypeFields {
        get {
            List<SelectOption> result = new List<SelectOption>();

            Set<Schema.DisplayType> availableTypes = new Set<Schema.DisplayType>{
                    Schema.DisplayType.PICKLIST
            };

            for (Schema.DescribeFieldResult field : getFieldsByType('Opportunity', availableTypes)) {
                result.add(new SelectOption(field.getName(), field.getLabel()));
            }

            return result;
        }
    }

//    Sales STAGES TEST BUTTONS
    public PageReference updateSalesStagesFilter(){
        Boolean filterEnabled;
        if (Apexpages.currentPage().getParameters().containsKey('filterEnabled')){
            filterEnabled = Boolean.valueOf(Apexpages.currentPage().getParameters().get('filterEnabled'));

            enableSelectedSalesStages = filterEnabled;

        }

        return null;
    }


    public PageReference updateSalesStages(){
        String response = '';

        if (Apexpages.currentPage().getParameters().containsKey('salesStagesList')){
            response = Apexpages.currentPage().getParameters().get('salesStagesList');

            selectedSalesStages = response;

        }

        return null;
    }



    public List<ButtonWrapper> salesStages {
        get {

            List<ButtonWrapper> salesRecords = new List<ButtonWrapper>();

            List<OpportunityStage> selectActiveOpportunityStage = new List<OpportunityStage>();

            selectActiveOpportunityStage = [SELECT Id,MasterLabel, ApiName FROM OpportunityStage WHERE IsActive = TRUE AND IsClosed = FALSE ];

            List<Schema.PicklistEntry> allOpportunityStage = Opportunity.StageName.getDescribe().getPicklistValues();

            List<Schema.PicklistEntry> activeOpportunityStage = new List<PicklistEntry>();


            for(PicklistEntry ple : allOpportunityStage)
            {
                for(OpportunityStage ops: selectActiveOpportunityStage)
                {

                    if(ple.getLabel() == ops.MasterLabel)
                    {
                        activeOpportunityStage.add(ple);
                    }
                }
            }


            if(!activeOpportunityStage.isEmpty())
            {
                for (PicklistEntry a : activeOpportunityStage)
                {
                    ButtonWrapper wrapper = new ButtonWrapper();
                    wrapper.Label = a.getLabel();
                    wrapper.Id = a.getValue();

                    if(selectedSalesStages!=null)
                    {
                        wrapper.isSelected = selectedSalesStages.contains(String.valueOf(a.getValue()));
                    }
                    else
                    {
                        wrapper.isSelected = false;
                    }

                    salesRecords.add(wrapper);
                }
            }
            return salesRecords;
        }

    }

    public List<ButtonWrapper> opportunityRecordTypes {
        get {
            List<ButtonWrapper> recordTypes = new List<ButtonWrapper>();

            if (settings.Enabled_Record_Types__c == null)
                settings.Enabled_Record_Types__c = '';

            for (Schema.RecordTypeInfo recordTypeInfo : Schema.SObjectType.Opportunity.getRecordTypeInfosByName().values()) {
                ButtonWrapper wrapper = new ButtonWrapper();

                wrapper.Label = recordTypeInfo.getName();
                wrapper.Id = recordTypeInfo.getRecordTypeId();
                wrapper.isSelected = settings.Enabled_Record_Types__c.contains(String.valueOf(wrapper.Id));

                recordTypes.add(wrapper);
            }

            return recordTypes;
        }
    }

    public List<ButtonWrapper> opportunityStages {
        get {
            List<ButtonWrapper> stages = new List<ButtonWrapper>();

            if (settings.Enabled_Opportunity_Stages__c == null)
                settings.Enabled_Opportunity_Stages__c = '';

            for (OpportunityStage opportunityStage : [
                    SELECT Id, MasterLabel, ApiName
                    FROM OpportunityStage
                    WHERE IsActive = TRUE AND IsClosed = TRUE
            ]) {
                ButtonWrapper wrapper = new ButtonWrapper();

                wrapper.Label = opportunityStage.MasterLabel;
                wrapper.Id = opportunityStage.ApiName;
                wrapper.isSelected = settings.Enabled_Opportunity_Stages__c.contains(String.valueOf(wrapper.Id));

                stages.add(wrapper);
            }

            return stages;
        }
    }

    public List<ButtonWrapper> opportunityAmountFields {
        get {
            List<ButtonWrapper> result = new List<ButtonWrapper>();

            Set<Schema.DisplayType> availableTypes = new Set<Schema.DisplayType>{
                    Schema.DisplayType.DOUBLE,
                    Schema.DisplayType.INTEGER,
                    Schema.DisplayType.LONG,
                    Schema.DisplayType.CURRENCY
            };

            List<String> selectedFields = settings.Opportunity_Amount_Fields__c != null ? settings.Opportunity_Amount_Fields__c.split(';') : new List<String>();

            for (Schema.DescribeFieldResult field : getFieldsByType('Opportunity', availableTypes)) {
                ButtonWrapper wrapper = new ButtonWrapper();

                wrapper.Label = field.getLabel();
                wrapper.Id = field.getName();
                wrapper.isSelected = selectedFields.contains(String.valueOf(wrapper.Id));

                result.add(wrapper);
            }
            return result;
        }
    }

    public List<ButtonWrapper> productPicklistFields {
        get {
            List<ButtonWrapper> result = new List<ButtonWrapper>();

            Set<Schema.DisplayType> availableTypes = new Set<Schema.DisplayType>{
                    Schema.DisplayType.PICKLIST,
                    Schema.DisplayType.MULTIPICKLIST
            };

            Set<String> selectedFields = new Set<String>();

            for (AggregateResult mapItem : [
                    SELECT Field_Name__c
                    FROM TruSales_Product_Map_Item__c
                    WHERE Object_Name__c = 'Product2'
                    GROUP BY Field_Name__c
            ]) {
                selectedFields.add(String.valueOf(mapItem.get('Field_Name__c')));
            }

            for (Schema.DescribeFieldResult field : getFieldsByType('Product2', availableTypes)) {
                ButtonWrapper wrapper = new ButtonWrapper();

                wrapper.Label = field.getLabel();
                wrapper.Id = field.getName();
                wrapper.isSelected = selectedFields.contains(wrapper.Id);

                result.add(wrapper);
            }

            return result;
        }
    }


    public List<ButtonWrapper> productPicklistFieldsSelected {

        get
        {

            Map<String,List<String>> objNamePicklistValue  = new Map<String, List<String>>();


            List<String> picklistNames = new List<String>();
            List<String> allFieldValuesProduct = new List<String>();
            List<String> selectedpicklistValueToStrings = new List<String>();
            List<TruSales_Product_Map_Item__c> truSalesProductMapItems = new List<TruSales_Product_Map_Item__c>();
            List<String> allFieldValuesProductOpp = new List<String>();
            List<ButtonWrapper> resultWrappers = new List<ButtonWrapper>();


            //Get all values from Product picklist

            Map<String, SObjectField> customFields = Schema.getGlobalDescribe().get('Product2').getDescribe().fields.getMap();
            for (String field: customFields.keySet()){
                SObjectField myField = customFields.get(field);
                String mtype = String.valueOf(myField.getDescribe().type);
                if (mtype.equals('PICKLIST') || mtype.equals('MULTIPICKLIST')){
                    picklistNames.add(myField.getDescribe().localName);

                }
            }



            List<TruSales_Product_Map_Item__c> fieldNames = [SELECT Field_Name__c,Object_Name__c,Picklist_Value__c FROM TruSales_Product_Map_Item__c WHERE Object_Name__c = 'Product2' AND Field_Name__c IN : picklistNames];
            Set<String> selectedFieldsNameFromProduct = new Set<String>();

            for(TruSales_Product_Map_Item__c tr: fieldNames)
            {
                selectedFieldsNameFromProduct.add(tr.Field_Name__c);
            }

            Schema.SObjectType targetType = Schema.getGlobalDescribe().get('Product2');
            Sobject Object_name = targetType.newSObject();
            Schema.sObjectType sobject_type = Object_name.getSObjectType();
            Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
            Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();

            for (String name: selectedFieldsNameFromProduct)
            {

                List<Schema.PicklistEntry> pick_list_values = field_map.get(name).getDescribe().getPickListValues();

                for(Schema.PicklistEntry value : pick_list_values)
                {
                    allFieldValuesProduct.add(value.getValue());
                }

            }


            objNamePicklistValue.put('Product2',allFieldValuesProduct);


            //Get selected value from picklist from product
            if(!picklistNames.isEmpty())
            {
                truSalesProductMapItems = [SELECT Object_Name__c, Field_Name__c, Picklist_Value__c FROM TruSales_Product_Map_Item__c WHERE Object_Name__c = 'Product2' AND Field_Name__c IN : picklistNames];

            }



            //get picklist value
            if(!truSalesProductMapItems.isEmpty())
            {
                for (TruSales_Product_Map_Item__c truSalesProductMapItem: truSalesProductMapItems)
                {
                    selectedPicklistValueToStrings.add(truSalesProductMapItem.Picklist_Value__c);
                }
            }




            //Opportynity
            List<String> picklistNamesOpp = new List<String>();
            List<String> allFieldValuesFromOpp = new List<String>();
            List<String> selectedpicklistValueToStringsOpp = new List<String>();
            List<TruSales_Product_Map_Item__c> truSalesProductMapItemsOpp = new List<TruSales_Product_Map_Item__c>();



            //Get all values from Product picklist

            Map<String, SObjectField> customFieldsOpp = Schema.getGlobalDescribe().get('Opportunity').getDescribe().fields.getMap();
            for (String field: customFieldsOpp.keySet()){
                SObjectField myField = customFieldsOpp.get(field);
                String mtype = String.valueOf(myField.getDescribe().type);
                if (mtype.equals('PICKLIST') || mtype.equals('MULTIPICKLIST')){
                    picklistNamesOpp.add(myField.getDescribe().localName);

                }
            }



            List<TruSales_Product_Map_Item__c> fieldNamesOpp = [SELECT Field_Name__c,Object_Name__c,Picklist_Value__c FROM TruSales_Product_Map_Item__c WHERE Object_Name__c = 'Opportunity' AND Field_Name__c IN : picklistNamesOpp];
            Set<String> selectedFieldsNameFromProductOpp = new Set<String>();

            for(TruSales_Product_Map_Item__c tr: fieldNamesOpp)
            {
                selectedFieldsNameFromProductOpp.add(tr.Field_Name__c);
            }

            Schema.SObjectType targetTypeOpp = Schema.getGlobalDescribe().get('Opportunity');
            Sobject Object_nameOpp = targetTypeOpp.newSObject();
            Schema.sObjectType sobject_typeOpp = Object_nameOpp.getSObjectType();
            Schema.DescribeSObjectResult sobject_describeOpp = sobject_typeOpp.getDescribe();
            Map<String, Schema.SObjectField> field_mapOpp = sobject_describeOpp.fields.getMap();

            for (String name: selectedFieldsNameFromProductOpp)
            {

                List<Schema.PicklistEntry> pick_list_values = field_mapOpp.get(name).getDescribe().getPickListValues();

                for(Schema.PicklistEntry value : pick_list_values)
                {
                    allFieldValuesFromOpp.add(value.getValue());
                }

            }


            objNamePicklistValue.put('Opportunity',allFieldValuesFromOpp);

            //Get selected value from picklist from product
            if(!picklistNamesOpp.isEmpty())
            {
                truSalesProductMapItemsOpp = [SELECT Object_Name__c, Field_Name__c, Picklist_Value__c FROM TruSales_Product_Map_Item__c WHERE Object_Name__c = 'Opportunity' AND Field_Name__c IN : picklistNamesOpp];

            }



            //get picklist value
            if(!truSalesProductMapItemsOpp.isEmpty())
            {
                for (TruSales_Product_Map_Item__c truSalesProductMapItem: truSalesProductMapItemsOpp)
                {
                    selectedpicklistValueToStrings.add(truSalesProductMapItem.Picklist_Value__c);
                }
            }


            for(String oppfield : allFieldValuesFromOpp)
            {
                allFieldValuesProductOpp.add(oppfield);
            }

            for(String productfield : allFieldValuesProduct)
            {
                allFieldValuesProductOpp.add(productfield);
            }



            List<TruSales_Product_Map_Item__c> allValuesFromOppProduct = new List<TruSales_Product_Map_Item__c>();

            allValuesFromOppProduct.addAll(truSalesProductMapItemsOpp);
            allValuesFromOppProduct.addAll(truSalesProductMapItems);


            for(String str: objNamePicklistValue.keySet())
            {
                for(String picklist : objNamePicklistValue.get(str))
                {
                    ButtonWrapper wrapper = new ButtonWrapper();
                    wrapper.Label = picklist;
                    wrapper.Id = str +'.' + picklist;
                    wrapper.isSelected = selectedPicklistValueToStrings.contains(picklist) ? true : false;
                    resultWrappers.add(wrapper);
                }
            }

            return resultWrappers;


        }
    }






    public List<ButtonWrapper> opportunityPicklistFields {
        get {
            List<ButtonWrapper> result = new List<ButtonWrapper>();

            Set<Schema.DisplayType> availableTypes = new Set<Schema.DisplayType>{
                    Schema.DisplayType.PICKLIST,
                    Schema.DisplayType.MULTIPICKLIST
            };

            Set<String> selectedFields = new Set<String>();

            for (AggregateResult mapItem : [
                    SELECT Field_Name__c
                    FROM TruSales_Product_Map_Item__c
                    WHERE Object_Name__c = 'Opportunity'
                    GROUP BY Field_Name__c
            ]) {
                selectedFields.add(String.valueOf(mapItem.get('Field_Name__c')));
            }

            for (Schema.DescribeFieldResult field : getFieldsByType('Opportunity', availableTypes)) {
                ButtonWrapper wrapper = new ButtonWrapper();

                wrapper.Label = field.getLabel();
                wrapper.Id = field.getName();
                wrapper.isSelected = selectedFields.contains(wrapper.Id);

                result.add(wrapper);
            }


            return result;
        }
    }



    public List<ButtonWrapper> opportunityTypes {
        get {
            List<ButtonWrapper> types = new List<ButtonWrapper>();

            if (settings.Enabled_Opportunity_Types__c == null)
                settings.Enabled_Opportunity_Types__c = '';

            if (settings.Opportunity_Type_Field__c == null)
                settings.Opportunity_Type_Field__c = 'Type';

            for (PicklistEntry picklistEntry : Schema.getGlobalDescribe().get('Opportunity').getDescribe().fields.getMap().get(settings.Opportunity_Type_Field__c).getDescribe().getPicklistValues()) {
                ButtonWrapper wrapper = new ButtonWrapper();

                wrapper.Label = picklistEntry.label;
                wrapper.Id = picklistEntry.value;
                wrapper.isSelected = settings.Enabled_Opportunity_Types__c.contains(picklistEntry.value);

                types.add(wrapper);
            }
            return types;
        }
    }


    public List<List<ButtonWrapper>> userProfiles
    {
        get
        {

            List<TruSales_Users_Item__c> selectedUsersItemsProfiles = new List<TruSales_Users_Item__c>();
            List<List<ButtonWrapper>> wrappersProfiles = new List<List<ButtonWrapper>>();
            Set<String> selectedValuesSet = new Set<String>();
            List<ButtonWrapper> littleWrapperProfiles = new List<ButtonWrapper>();
            List<Profile> userProfiles = new List<Profile>();


            selectedUsersItemsProfiles = [SELECT  Select_by__c, Selected_Value__c FROM TruSales_Users_Item__c];


            for(TruSales_Users_Item__c tr: selectedUsersItemsProfiles)
            {
                selectedValuesSet.add(tr.Selected_Value__c);
            }


            userProfiles = [SELECT Id,Name FROM Profile];


            for(Profile pr : userProfiles)
            {
                ButtonWrapper wrapper = new ButtonWrapper();
                wrapper.Label = pr.Name;
                wrapper.Id = pr.Id;
                wrapper.isSelected = selectedValuesSet.contains(wrapper.Label);
                littleWrapperProfiles.add(wrapper);

                if(littleWrapperProfiles.size() == 1000)
                {
                    wrappersProfiles.add(littleWrapperProfiles);
                    littleWrapperProfiles = new List<ButtonWrapper>();
                }
            }
            wrappersProfiles.add(littleWrapperProfiles);
            return wrappersProfiles;
        }

    }





    public List<List<ButtonWrapper>> userRoles
    {
        get
        {

            List<TruSales_Users_Item__c> selectedUsersItemsRoles = new List<TruSales_Users_Item__c>();

            selectedUsersItemsRoles = [SELECT  Select_by__c, Selected_Value__c FROM TruSales_Users_Item__c];
            Set<String> selectedValuesSet = new Set<String>();

            for(TruSales_Users_Item__c tr: selectedUsersItemsRoles)
            {
                selectedValuesSet.add(tr.Selected_Value__c);
            }

            List<List<ButtonWrapper>> wrappersRoles = new List<List<ButtonWrapper>>();
            List<ButtonWrapper> littleWrapperRoles = new List<ButtonWrapper>();
            List<UserRole> userRoles = new List<UserRole>();
            userRoles = [SELECT Id,Name FROM UserRole];


            for(UserRole rl : userRoles)
            {
                ButtonWrapper wrapper = new ButtonWrapper();
                wrapper.Label = rl.Name;
                wrapper.Id = rl.Id;
                wrapper.isSelected = selectedValuesSet.contains(wrapper.Label);
                littleWrapperRoles.add(wrapper);
                if(littleWrapperRoles.size() == 1000)
                {
                    wrappersRoles.add(littleWrapperRoles);
                    littleWrapperRoles = new List<ButtonWrapper>();
                }
            }
            wrappersRoles.add(littleWrapperRoles);


            return wrappersRoles;
        }

    }




    public List<SelectOption> endpoints {
        get {
            return new List<SelectOption>{
                    new SelectOption('https://api.primary-intel.com', 'TruVoice Production'),
                    new SelectOption('https://api-releases.primary-intel.com', 'TruVoice Test (Next)'),
                    new SelectOption('https://api-test.primary-intel.com', 'TruVoice Test (TV1)'),
                    new SelectOption('https://api-hf.primary-intel.com', 'TruVoice Test (HF)')
            };
        }
    }


    public String opportunityTypesSyncValuesJSON {
        get {
            List<String> result = new List<String>();

            if (settings.Opportunity_Type_Sync_Field__c == null)
                settings.Opportunity_Type_Sync_Field__c = 'Type';

            for (PicklistEntry picklistEntry : Schema.getGlobalDescribe().get('Opportunity').getDescribe().fields.getMap().get(settings.Opportunity_Type_Sync_Field__c).getDescribe().getPicklistValues()) {
                result.add(picklistEntry.getValue());
            }
            return JSON.serialize(result);
        }
    }

    public String openIn { get; set; }

    private static List<Schema.DescribeFieldResult> getFieldsByType(String objectName, Set<Schema.DisplayType> types) {
        List<Schema.DescribeFieldResult> result = new List<DescribeFieldResult>();

        for (Schema.SObjectField field : Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().values()) {
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();

            if (types.contains(fieldDescribe.type)) {
                result.add(fieldDescribe);
            }
        }
        return result;
    }


    public void checkSettingsExisting() {
//        settings = TruSales_App_Settings__c.getOrgDefaults();

//        if (settings.Id == null) {
////            insert new TruSales_App_Settings__c();
//            settings = TruSales_App_Settings__c.getOrgDefaults();
//        }

        List<Discovery_Bots_Settings__c> settingsList = [SELECT Id, Active_All_Users__c, Active_Product_Fields__c, API_Endpoint__c, API_Endpoint_Profiles__c, Collector_id__c, Name, Enable_Manual_Button_on_VF__c, Enable_Opportunity_Amount__c,
                Enable_Opportunity_Types__c, Enable_Record_Types__c, Enable_Sales_Stages__c, Enable_Sales_Stages_Values__c, Enabled_Opportunity_Stages__c, Enabled_Opportunity_Types__c, Enabled_Record_Types__c,
                Initiative_id__c, Is_Active__c, Open_In_New_Window__c, Opportunity_Amount_Field__c, Opportunity_Amount_Fields__c, Opportunity_Amount_Value__c, Opportunity_Type_Field__c, Opportunity_Type_Sync_Field__c,
                Opportunity_Types_Map_1__c, Opportunity_Types_Map_2__c, Opportunity_Types_Map_3__c, Outcome_Types_Map_1__c, Outcome_Types_Map_2__c, Outcome_Types_Map_3__c, Survey_Collector_Email__c, Survey_Collector_Name__c, TruVoice_API_Key__c,
                TruVoice_Client_ID__c, TruVoiceIntegration__c, Enable_Automated_Email__c FROM Discovery_Bots_Settings__c];


        if(settingsList.isEmpty())
        {
            settings = new Discovery_Bots_Settings__c();
        }
        else
        {
            for (Discovery_Bots_Settings__c discoveryBotsSettings: settingsList)
            {
                if(discoveryBotsSettings.TruVoice_Client_ID__c != null  && discoveryBotsSettings.TruVoice_API_Key__c != null && discoveryBotsSettings.Initiative_id__c != null)
                {
                    settings = discoveryBotsSettings;
                }
                else {
                    discoveryBotsSettingsDeleted.add(discoveryBotsSettings);
                }
            }

            if(settings == null)
            {
                settings = new Discovery_Bots_Settings__c();
            }

        }



        if (settings.Id == null || settings.API_Endpoint__c == null || settings.API_Endpoint__c == '') {
            settings.API_Endpoint__c = 'https://api.primary-intel.com';
        }

        if (settings.Id == null || settings.Opportunity_Type_Sync_Field__c == null) {
            settings.Opportunity_Type_Sync_Field__c = 'Type';
        }

        if (settings.Open_In_New_Window__c) {
            openIn = 'NewWindow';
        }

        if (!settings.Open_In_New_Window__c) {
            openIn = 'DialogWindow';
        }

        showErrorMsg = false;
        selectedAPI = settings.API_Endpoint__c;
//        this.initiativeId=settings.Initiative_id__c;
        this.initiativeId = settings.Collector_id__c;

        this.selectValuesCollectors = getCollectorsFromServer();


        String outcomeTypesMapField = 'Outcome_Types_Map';
        Integer index = 1;

        outcomeTypesMap = '';
        while (settings.get(outcomeTypesMapField + '_' + index + '__c') != null) {
            outcomeTypesMap += settings.get(outcomeTypesMapField + '_' + index + '__c');
            index++;
        }

        String opportunityTypesMapField = 'Opportunity_Types_Map';
        index = 1;

        opportunityTypesMap = '';
        while (settings.get(opportunityTypesMapField + '_' + index + '__c') != null) {
            opportunityTypesMap += settings.get(opportunityTypesMapField + '_' + index + '__c');
            index++;
        }

        if (TruSales_Product_Map_Item__c.getSObjectType().getDescribe().isAccessible()
                && TruSales_Product_Map_Item__c.Picklist_Value__c.getDescribe().isAccessible()
                && TruSales_Product_Map_Item__c.TruVoice_Product_Id__c.getDescribe().isAccessible()) {
            productMapItems = [
                    SELECT Id, Picklist_Value__c, TruVoice_Product_Id__c
                    FROM TruSales_Product_Map_Item__c
                    ORDER BY Picklist_Value__c ASC
            ];
        }

//        UsersFields = [
//            SELECT Id, Name, Feedback_Request_Allowed__c
//            FROM User WHERE IsActive = true
//        ];

        UsersFieldsList = new List<List<User>>();
        for (User user : [SELECT Id, Name, Feedback_Request_Allowed__c FROM User WHERE IsActive = true]) {
            UsersFields.add(user);

            if (UsersFields.size() == 1000) {//limit of vf repeat components
                UsersFieldsList.add(UsersFields);
                UsersFields = new List<User>();
            }
        }
        UsersFieldsList.add(UsersFields);

//        userRoles = new List<UserRole>();
//        userRoles = [SELECT Id,Name FROM UserRole];


//        userProfiles = new List<Profile>();
//        userProfiles = [SELECT Id,Name FROM Profile];



    }







    public PageReference UpdateIntegrationTab() {
        this.selectValuesCollectors = getCollectorsFromServer();
        System.debug('<<<<<<>>>>>>');
        System.debug(selectValuesCollectors);
        this.initiativeId = (String) selectValuesCollectors[0].getValue();
        System.debug(initiativeId);
        return null;
    }


    private void deleteSettings (List<Discovery_Bots_Settings__c> deleteList)
    {
        delete deleteList;
    }



    public PageReference Save() {

        if(!discoveryBotsSettingsDeleted.isEmpty())
        {
            deleteSettings(discoveryBotsSettingsDeleted);
        }

        UsersFieldsListStatic = new List<List<User>>();

        switch on selectByValue
        {
            when 'Users'
            {
                ClearTruSalesUsersItem();
                clearPermissionSetAssignment();

                userWithFeedbackRequestAllowed = UsersFieldsList;
            }
            when 'Profiles'
            {
                if(UserProfilesSelected != null && !UserProfilesSelected.equals(''))
                {
                    UsersFieldsListStatic = new List<List<User>>();
                    UsersFieldsListStatic.add(updateUserProfiles(UserProfilesSelected,selectByValue));

                }

            }
            when 'Roles'
            {
                if(UserRolesSelected != null && !UserRolesSelected.equals(''))
                {

                    UsersFieldsListStatic = new List<List<User>>();
                    UsersFieldsListStatic.add(updateUserRole(UserRolesSelected,selectByValue));

                }
            }
        }


        if(!UsersFieldsListStatic.isEmpty() && settings.Active_All_Users__c == false)
        {
            Set<Id> userIds = new Set<Id>();
            for (List<User> usersList : UsersFieldsListStatic)
            {
                for(User user: usersList)
                {
                    userIds.add(user.Id);
                }
            }
            clearPermissionSetAssignment();
            TruSalesAppSettingsSaveFuture.permissionSetAssignmentUpsert(userIds);
        }

        if(settings.Active_All_Users__c)
        {
            ClearTruSalesUsersItem();
            clearPermissionSetAssignment();
            userWithFeedbackRequestAllowed = UsersFieldsList;
        }

        if(enableSelectedSalesStages != null)
        {

            settings.Enable_Sales_Stages__c = enableSelectedSalesStages;
        }



        if(selectedSalesStages != null || selectedSalesStages != '')
        {
            selectedSalesStagesString = selectedSalesStages;
        }
        else
        {
            selectedSalesStagesString = '';

        }

        settings.Open_In_New_Window__c = openIn == 'NewWindow';
        ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Saving your changes now. Please wait until the save process has completed before making further changes to the settings or moving away from this page. In large Salesforce environments additional time is required to properly update your settings. Making additional changes after the save process has begun, or navigating to a different page may result in Salesforce not saving the new settings properly.'));

        settings.API_Endpoint__c = selectedAPI;

        settingsStatic = settings;
        initiativeIdStatic = initiativeId;
        collectors_idsStatic = collectors_ids;
        outcomeTypesMapStatic = outcomeTypesMap;
        opportunityTypesMapStatic = opportunityTypesMap;
        productMapItemsStatic = productMapItems;
        
        String settingsStaticString = JSON.serialize(settings);
        String collectors_idsStaticString = JSON.serialize(collectors_idsStatic);
        String usersFieldsListStaticString = JSON.serialize(userWithFeedbackRequestAllowed);
        String productMapItemsStaticString = JSON.serialize(productMapItemsStatic);

        //saveFuture(settingsStaticString, usersFieldsListStaticString, initiativeIdStatic,  collectors_idsStaticString, outcomeTypesMapStatic, opportunityTypesMapStatic, productMapItemsStaticString);
        bProcess = true;
        requestCount = 1;
        deProgressBarWidth = 0;
        strStatus = 'Started';




        jobId = System.enqueueJob(new TruSalesAppSettingsSave(settingsStaticString, usersFieldsListStaticString, initiativeIdStatic,  collectors_idsStaticString, outcomeTypesMapStatic, opportunityTypesMapStatic, productMapItemsStaticString,selectedSalesStagesString));

        return null;
    }


    // STATUS BAR
    public PageReference checkStatus()
    {
        System.debug('checkStatus START');
        deProgressBarWidth = 0;

        if(jobId != null)
        {
            AsyncApexJob jobInf = null;
            jobInf = [SELECT Status,NumberOfErrors FROM AsyncApexJob WHERE Id=:jobId];
            currentJobStatus = jobInf.Status;
        }


        if(currentJobStatus != null)
        {


            if(currentJobStatus == 'Failed')
            {
                deProgressBarWidth = 0;
                strStatus = 'Failed';

            }
            else
            {

                if (currentJobStatus == 'Queued' || requestCount == 1)
                {
                    System.debug('Queued');
                    deProgressBarWidth = 25;
                    strStatus = 'Queued';
                    requestCount +=1;

                }
                else if(currentJobStatus == 'Preparing' || requestCount == 2)
                {
                    System.debug('Preparing');

                    deProgressBarWidth = 50;
                    strStatus = 'Preparing';
                    strStatus = 'Preparing';
                    requestCount +=1;

                }
                else if(currentJobStatus == 'Processing' || requestCount == 3)
                {
                    System.debug('Processing');

                    deProgressBarWidth = 75;
                    strStatus = 'Processing';
                    strStatus = 'Processing...';
                    requestCount +=1;

                }
                else if(currentJobStatus == 'Completed')
                {
                    System.debug('Completed');
                    deProgressBarWidth = 100;
                    strStatus = 'Completed';
                    bProcess = false;
                }
            }

        }

        return null;
    }

//    @future
//    public static void saveFuture(String settingsStaticString, String usersFieldsListStaticString, String initiativeIdStatic, String collectors_idsStaticString, String outcomeTypesMapStatic, String opportunityTypesMapStatic,String productMapItemsStaticString) {
//        List<User> userList = new List<User>();
//
//
//        settingsStatic = (TruSales_App_Settings__c) JSON.deserialize(settingsStaticString, TruSales_App_Settings__c.class);
//        collectors_idsStatic = (List<Collector>) JSON.deserialize(collectors_idsStaticString, List<Collector>.class);
//        UsersFieldsListStatic =(List<List<User>>) JSON.deserialize(usersFieldsListStaticString,List<List<User>>.class);
//        productMapItemsStatic = (List<TruSales_Product_Map_Item__c> ) JSON.deserialize(productMapItemsStaticString,List<TruSales_Product_Map_Item__c>.class);
//
//
//        if (settingsStatic.Active_All_Users__c) {
//
//            for (List<User> UsersFieldsList : UsersFieldsListStatic) {
//                for (User us : UsersFieldsList) {
//                    if (us.Feedback_Request_Allowed__c == false) {
//                        us.Feedback_Request_Allowed__c = true;
//                        userList.add(us);
//                    }
//                }
//            }
//        } else {
//            for (List<User> UsersList : UsersFieldsListStatic) {
//                for (User us : UsersList) {
//                    userList.add(us);
//                }
//            }
//
//        }
//
//        Database.update(userList, false);
//
//        if (initiativeIdStatic.equals('Error')) initiativeIdStatic = '';
//        settingsStatic.Collector_id__c = initiativeIdStatic;
//        for (Collector collector : collectors_idsStatic) {
//            if (initiativeIdStatic == collector.collector_id) {
//                settingsStatic.Initiative_id__c = collector.initiative_id;
//                settingsStatic.Survey_Collector_Email__c = collector.from_email;
//                settingsStatic.Survey_Collector_Name__c = collector.collector_name;
//            }
//        }
//
//        // Save outcome types map
//        String outcomeTypesMapField = 'Outcome_Types_Map';
//        Integer index = 1;
//        while (settingsStatic.get(outcomeTypesMapField + '_' + index + '__c') != null) {
//            settingsStatic.put(outcomeTypesMapField + '_' + index + '__c', null);
//            index++;
//
//        }
//
//        index = 1;
//        Matcher matcher = Pattern.compile('(.{1,255})').matcher(outcomeTypesMapStatic);
//        while (matcher.find()) {
//            settingsStatic.put(outcomeTypesMapField + '_' + index + '__c', matcher.group());
//            index++;
//        }
//
//        // Save opportunity types map
//        String opportunityTypesMapField = 'Opportunity_Types_Map';
//        index = 1;
//        while (settingsStatic.get(opportunityTypesMapField + '_' + index + '__c') != null) {
//            settingsStatic.put(opportunityTypesMapField + '_' + index + '__c', null);
//            index++;
//
//        }
//
//        index = 1;
//        matcher = Pattern.compile('(.{1,255})').matcher(opportunityTypesMapStatic);
//        while (matcher.find()) {
//            settingsStatic.put(opportunityTypesMapField + '_' + index + '__c', matcher.group());
//            index++;
//
//        }
//
//        upsert settingsStatic;
//
//        upsert productMapItemsStatic;
//    }

    public String selectedFieldsForProductMap { get; set; }



    public static void clearProductFields()
    {
        delete [
                SELECT Object_Name__c,Picklist_Value__c,Field_Name__c FROM TruSales_Product_Map_Item__c WHERE Object_Name__c = 'Product2'
        ];
    }



    public static void clearOpportunityFields()
    {
        delete [
                SELECT Object_Name__c,Picklist_Value__c,Field_Name__c FROM TruSales_Product_Map_Item__c WHERE Object_Name__c = 'Opportunity'
        ];
    }



    public PageReference updateProductMapFieldObject() {


        delete [
                SELECT Object_Name__c,Picklist_Value__c,Field_Name__c FROM TruSales_Product_Map_Item__c
        ];

        List<String> fields = selectedFieldsForProductMap.split(';');
        List<TruSales_Product_Map_Item__c> mapItems = new List<TruSales_Product_Map_Item__c>();
        List<TruSales_Product_Map_Item__c> productMapItemsForSave = new List<TruSales_Product_Map_Item__c>();
        List<TruSales_Product_Map_Item__c> productMapItemsForSaveWithOpp = new List<TruSales_Product_Map_Item__c>();
        Map<String, SObjectType> schemaDescribe = Schema.getGlobalDescribe();
        Set<String> fieldsNameWithOutProduct = new Set<String>();



        for (String field : fields) {
            String objectName = field.substringBefore('.');
            String fieldName = field.substringAfter('.');

            if(settings.TruVoiceIntegration__c)
            {

                for (PicklistEntry picklistEntry : schemaDescribe.get(objectName).getDescribe().fields.getMap().get(fieldName).getDescribe().getPicklistValues()) {

                    fieldsNameWithOutProduct.add(objectName);

                    mapItems.add(new TruSales_Product_Map_Item__c(
                            Object_Name__c = objectName,
                            Field_Name__c = fieldName,
                            Picklist_Value__c = picklistEntry.getValue()
                    ));

                }
            }
            else
            {

                delete [
                        SELECT Object_Name__c,Picklist_Value__c,Field_Name__c FROM TruSales_Product_Map_Item__c WHERE Object_Name__c != 'Product2'
                ];

                if(objectName == 'Opportunity')
                {

                    productMapItemsForSaveWithOpp.add(new TruSales_Product_Map_Item__c(
                            Object_Name__c = objectName,
                            Field_Name__c = fieldName,
                            Picklist_Value__c = null
                    ));

                }
                else if(objectName == 'Product2')
                {
                    productMapItemsForSave.add(new TruSales_Product_Map_Item__c(
                            Object_Name__c = objectName,
                            Field_Name__c = fieldName,
                            Picklist_Value__c = null
                    ));
                }


            }

        }

        List<TruSales_Product_Map_Item__c> deleteTruSalesProductMapItemsWithoutProduct = new List<TruSales_Product_Map_Item__c>();

        deleteTruSalesProductMapItemsWithoutProduct = [ SELECT Id FROM TruSales_Product_Map_Item__c WHERE Object_Name__c IN: fieldsNameWithOutProduct];

        delete deleteTruSalesProductMapItemsWithoutProduct;


        if(!productMapItemsForSave.isEmpty())
        {
            SaveProduct(productMapItemsForSave);
        }


        if(!productMapItemsForSaveWithOpp.isEmpty())
        {
            insert productMapItemsForSaveWithOpp;
        }

        //insert mapItems;

        if (TruSales_Product_Map_Item__c.getSObjectType().getDescribe().isAccessible()
                && TruSales_Product_Map_Item__c.Picklist_Value__c.getDescribe().isAccessible()
                && TruSales_Product_Map_Item__c.TruVoice_Product_Id__c.getDescribe().isAccessible()) {
            productMapItems = [
                    SELECT Id, Picklist_Value__c, TruVoice_Product_Id__c
                    FROM TruSales_Product_Map_Item__c
                    ORDER BY Picklist_Value__c ASC
            ];
        }
        return null;
    }


    public static void SaveProduct(List<TruSales_Product_Map_Item__c> productMapItemsForSave)
    {

        insert productMapItemsForSave;

    }



    public PageReference setTruVoiceProducts() {
        List<Object> products = (List<Object>) JSON.deserializeUntyped(truVoiceProductsJSON);

        truVoiceProducts = new List<SelectOption>();

        for (Object mapItemObject : products) {
            Map<String, Object> mapItem = (Map<String, Object>) mapItemObject;
            truVoiceProducts.add(new SelectOption(String.valueOf(mapItem.get('name')), String.valueOf(mapItem.get('label'))));
        }

        if (TruSales_Product_Map_Item__c.getSObjectType().getDescribe().isAccessible()
                && TruSales_Product_Map_Item__c.Picklist_Value__c.getDescribe().isAccessible()
                && TruSales_Product_Map_Item__c.TruVoice_Product_Id__c.getDescribe().isAccessible()) {
            productMapItems = [
                    SELECT Id, Picklist_Value__c, TruVoice_Product_Id__c
                    FROM TruSales_Product_Map_Item__c
                    ORDER BY Picklist_Value__c ASC
            ];
        }

        return null;
    }




    public PageReference getProducFieldsView()
    {

        valuesForViewFromProduct = new List<String>();

        if(checkedProductFieldsValueView != null)
        {
            List<String> checkedProductDieldsValueViewParse = new List<String>();
            checkedProductDieldsValueViewParse = checkedProductFieldsValueView.split(',');
            String obj = 'Product2';

            Schema.SObjectType targetType = Schema.getGlobalDescribe().get(obj);
            Sobject Object_name = targetType.newSObject();
            Schema.sObjectType sobject_type = Object_name.getSObjectType();
            Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
            Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();

            for (String str : checkedProductDieldsValueViewParse)
            {

                if(str != null && !str.equals(''))
                {

                    List<Schema.PicklistEntry> pick_list_values = field_map.get(str).getDescribe().getPickListValues();
                    List<String> FieldValues = new List<String>();
                    for (Schema.PicklistEntry a : pick_list_values)
                    {

                        valuesForViewFromProduct.add(a.getValue());
                        FieldValues.add(a.getValue());
                    }

                }
            }

        }

        return null;
    }






    public PageReference getOpportunityFieldsView()
    {

        valuesForViewFromOpportunity = new List<String>();

        if(checkedOpportunityFieldsValueView != null)
        {
            List<String> checkedProductDieldsValueViewParse = new List<String>();
            checkedProductDieldsValueViewParse = checkedOpportunityFieldsValueView.split(',');
            String obj = 'Opportunity';

            Schema.SObjectType targetType = Schema.getGlobalDescribe().get(obj);
            Sobject Object_name = targetType.newSObject();
            Schema.sObjectType sobject_type = Object_name.getSObjectType();
            Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
            Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();

            for (String str : checkedProductDieldsValueViewParse)
            {

                if(str != null && !str.equals(''))
                {

                    List<Schema.PicklistEntry> pick_list_values = field_map.get(str).getDescribe().getPickListValues();
                    List<String> FieldValues = new List<String>();
                    for (Schema.PicklistEntry a : pick_list_values)
                    {

                        valuesForViewFromOpportunity.add(a.getValue());
                        FieldValues.add(a.getValue());
                    }

                }
            }

        }

        return null;
    }





    public PageReference updateProductTriggerFieldValuesWithProduct() {

        System.debug('updateProductTriggerFieldValuesWithProduct');

        List<TruSales_Product_Map_Item__c> productWithNull = new List<TruSales_Product_Map_Item__c>();
        List<TruSales_Product_Map_Item__c> allTruSalesProductMapItems = new List<TruSales_Product_Map_Item__c>();
        List<String> deletedList = new List<String>();




        if(selectedValuePickListFromProductTrigger != null && !selectedValuePickListFromProductTrigger.equals(''))
        {



            fieldNameValueMap = new Map<String, List<String>>();
            fieldNameValueMap = getPicklistNameValue('Product2');



            for(String picklistName: fieldNameValueMap.keySet())
            {
                if(fieldNameValueMap.get(picklistName).contains(selectedValuePickListFromProductTrigger))
                {
                    if(statusSelectedValuePickListFromProductTrigger)
                    {


                        TruSales_Product_Map_Item__c truSalesProductMapItem = new TruSales_Product_Map_Item__c(
                                Object_Name__c = 'Product2',
                                Field_Name__c = picklistName,
                                Picklist_Value__c = selectedValuePickListFromProductTrigger
                        );

                        insert truSalesProductMapItem;
                    }
                    else
                    {
                        delete [
                                SELECT Id FROM TruSales_Product_Map_Item__c WHERE Picklist_Value__c =: selectedValuePickListFromProductTrigger AND Field_Name__c =: picklistName AND Object_Name__c = 'Product2'
                        ];
                    }

                }
            }

        }

        allTruSalesProductMapItems = [SELECT Object_Name__c,Picklist_Value__c,Field_Name__c FROM TruSales_Product_Map_Item__c WHERE Object_Name__c = 'Product2'];

        for(TruSales_Product_Map_Item__c truSalesProductMapItem : allTruSalesProductMapItems)
        {

            if(truSalesProductMapItem.Picklist_Value__c != null)
            {
                deletedList.add(truSalesProductMapItem.Field_Name__c);
            }
        }


        if(!deletedList.isEmpty())
        {
            productWithNull=[SELECT Id,Object_Name__c, Field_Name__c, Picklist_Value__c FROM TruSales_Product_Map_Item__c
            WHERE Object_Name__c = 'Product2' AND Picklist_Value__c =null AND Field_Name__c IN: deletedList];
        }


        if(!productWithNull.isEmpty())
        {
            delete productWithNull;
        }
        return null;
    }







    public PageReference updateProductTriggerFieldValuesWithOpportunity() {


        System.debug('updateProductTriggerFieldValuesWithOpportunity');

        List<TruSales_Product_Map_Item__c> opportunityWithNull = new List<TruSales_Product_Map_Item__c>();
        List<TruSales_Product_Map_Item__c> allTruSalesOpportunityMapItems = new List<TruSales_Product_Map_Item__c>();
        List<String> deletedListOpportunity = new List<String>();

        if(selectedOpportunityValuePickListFromProductTrigger != null && !selectedOpportunityValuePickListFromProductTrigger.equals(''))
        {

            fieldNameValueMap = new Map<String, List<String>>();
            fieldNameValueMap = getPicklistNameValue('Opportunity');

            for(String picklistName: fieldNameValueMap.keySet())
            {
                if(fieldNameValueMap.get(picklistName).contains(selectedOpportunityValuePickListFromProductTrigger))
                {
                    if(statusSelectedOpportunityValuePickListFromProductTrigger)
                    {


                        TruSales_Product_Map_Item__c truSalesProductMapItem = new TruSales_Product_Map_Item__c(
                                Object_Name__c = 'Opportunity',
                                Field_Name__c = picklistName,
                                Picklist_Value__c = selectedOpportunityValuePickListFromProductTrigger
                        );

                        insert truSalesProductMapItem;
                    }
                    else
                    {
                        delete [
                                SELECT Id FROM TruSales_Product_Map_Item__c WHERE Picklist_Value__c =: selectedOpportunityValuePickListFromProductTrigger AND Field_Name__c =: picklistName AND Object_Name__c = 'Opportunity'
                        ];
                    }

                }
            }

        }

        allTruSalesOpportunityMapItems = [SELECT Object_Name__c,Picklist_Value__c,Field_Name__c FROM TruSales_Product_Map_Item__c WHERE Object_Name__c = 'Opportunity'];

        for(TruSales_Product_Map_Item__c truSalesProductMapItem : allTruSalesOpportunityMapItems)
        {

            if(truSalesProductMapItem.Picklist_Value__c != null)
            {
                deletedListOpportunity.add(truSalesProductMapItem.Field_Name__c);
            }
        }


        if(!deletedListOpportunity.isEmpty())
        {
            opportunityWithNull=[SELECT Id,Object_Name__c, Field_Name__c, Picklist_Value__c FROM TruSales_Product_Map_Item__c
            WHERE Object_Name__c = 'Opportunity' AND Picklist_Value__c =null AND Field_Name__c IN: deletedListOpportunity];
        }


        if(!opportunityWithNull.isEmpty())
        {
            delete opportunityWithNull;
        }
        return null;
    }







    //User Profiles updated
    public List<User> updateUserProfiles(String UserProfilesSelected, String selectByValue) {

        ClearTruSalesUsersItem();

        System.debug('updateUserProfiles');


        List<Object> objectsUserProfiles = (List<Object>) JSON.deserializeUntyped(UserProfilesSelected);
        List<TruSales_Users_Item__c> updateListSalesUsersItems = new List<TruSales_Users_Item__c>();
        Set<Id>profilesIds = new Set<Id>();
        List<User> resultUsers = new List<User>();

        for(Object obj : objectsUserProfiles)
        {
            Map<String,Object> o = (Map<String,Object>) obj;
            TruSales_Users_Item__c truSalesUsersItem = new TruSales_Users_Item__c();

            truSalesUsersItem.Select_by__c = selectByValue;
            truSalesUsersItem.Selected_Value__c = String.valueOf(o.get('label'));

            updateListSalesUsersItems.add(truSalesUsersItem);
            profilesIds.add((Id)o.get('Id'));
        }

        insert updateListSalesUsersItems;

        resultUsers = [SELECT Id, ProfileId,Feedback_Request_Allowed__c FROM User WHERE ProfileId IN: profilesIds AND IsActive = TRUE];

        return resultUsers;

    }



    //User Role updated
    public List<User> updateUserRole(String UserRolesSelected, String selectByValue) {

        ClearTruSalesUsersItem();


        List<Object> objectsUserProfiles = (List<Object>) JSON.deserializeUntyped(UserRolesSelected);
        List<TruSales_Users_Item__c> updateListSalesUsersItems = new List<TruSales_Users_Item__c>();
        List<User> resultUsers = new List<User>();
        Set<Id> roleIds = new Set<Id>();



        for(Object obj : objectsUserProfiles)
        {
            Map<String,Object> o = (Map<String,Object>) obj;
            TruSales_Users_Item__c truSalesUsersItem = new TruSales_Users_Item__c();

            truSalesUsersItem.Select_by__c = selectByValue;
            truSalesUsersItem.Selected_Value__c = String.valueOf(o.get('label'));

            updateListSalesUsersItems.add(truSalesUsersItem);
            roleIds.add((Id)o.get('Id'));
        }

        insert updateListSalesUsersItems;

        resultUsers = [SELECT Id,Name,UserRoleId,Feedback_Request_Allowed__c FROM User WHERE UserRoleId IN : roleIds AND IsActive = TRUE];


        return resultUsers;
    }


    public static void ClearTruSalesUsersItem()
    {
        delete[
                SELECT  Select_by__c, Selected_Value__c FROM TruSales_Users_Item__c
        ];
    }




    public PageReference updatedAllSelectedProduct()
    {
        System.debug('updatedAllSelectedProduct');
        delete [
                SELECT Object_Name__c,Picklist_Value__c,Field_Name__c FROM TruSales_Product_Map_Item__c WHERE Object_Name__c = 'Product2'
        ];

        if(allProductUpdated!= null && !allProductUpdated.equals(''))
        {

            List<String> allProductUpdatedList = new List<String>();
            List<TruSales_Product_Map_Item__c> updatedProductList = new List<TruSales_Product_Map_Item__c>();
            fieldNameValueMap = new Map<String, List<String>>();

            allProductUpdatedList = allProductUpdated.split(';');
            fieldNameValueMap = getPicklistNameValue('Product2');


            for(String picklistName: fieldNameValueMap.keySet())
            {

                for(String picklistValue: allProductUpdatedList)
                {
                    if(fieldNameValueMap.get(picklistName).contains(picklistValue))
                    {
                        TruSales_Product_Map_Item__c truSalesProductMapItem = new TruSales_Product_Map_Item__c(
                                Object_Name__c = 'Product2',
                                Field_Name__c = picklistName,
                                Picklist_Value__c = picklistValue
                        );

                        updatedProductList.add(truSalesProductMapItem);
                    }
                }
            }
            if(!updatedProductList.isEmpty())
            {
                insert updatedProductList;
            }


        }


        return null;
    }


    public PageReference updatedAllSelectedOpportunity()
    {
        System.debug('updatedAllSelectedOpportunity');
        delete [
                SELECT Object_Name__c,Picklist_Value__c,Field_Name__c FROM TruSales_Product_Map_Item__c WHERE Object_Name__c = 'Opportunity'
        ];

        if(allOpportunityUpdated!= null && !allOpportunityUpdated.equals(''))
        {

            List<String> allOpportunityUpdatedList = new List<String>();
            List<TruSales_Product_Map_Item__c> updatedOpportunityList = new List<TruSales_Product_Map_Item__c>();
            fieldNameValueMap = new Map<String, List<String>>();


            allOpportunityUpdatedList = allOpportunityUpdated.split(';');
            fieldNameValueMap = getPicklistNameValue('Opportunity');


            for(String picklistName: fieldNameValueMap.keySet())
            {

                for(String picklistValue: allOpportunityUpdatedList)
                {
                    if(fieldNameValueMap.get(picklistName).contains(picklistValue))
                    {
                        TruSales_Product_Map_Item__c truSalesProductMapItem = new TruSales_Product_Map_Item__c(
                                Object_Name__c = 'Opportunity',
                                Field_Name__c = picklistName,
                                Picklist_Value__c = picklistValue
                        );

                        updatedOpportunityList.add(truSalesProductMapItem);
                    }
                }
            }

            if (!updatedOpportunityList.isEmpty())
            {
                insert updatedOpportunityList;

            }

        }



        return null;
    }



    public static Map<String, List<String>> getPicklistNameValue(String objectName)
    {
        Map<String, List<String>> mapPicklistNameValues = new Map<String, List<String>>();

        List<String> namePicklist = new List<String>();

        Map<String, SObjectField> customFields = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
        for (String field: customFields.keySet()){
            SObjectField myField = customFields.get(field);
            String mtype = String.valueOf(myField.getDescribe().type);
            if (mtype.equals('PICKLIST') || mtype.equals('MULTIPICKLIST')){
                namePicklist.add(myField.getDescribe().localName);

            }
        }

        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(objectName);
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();

        for (String name: namePicklist)
        {
            List<Schema.PicklistEntry> pick_list_values = field_map.get(name).getDescribe().getPickListValues();
            List<String> fieldValues = new List<String>();

            for(Schema.PicklistEntry value : pick_list_values)
            {
                fieldValues.add(value.getValue());
            }

            mapPicklistNameValues.put(name,fieldValues);
        }

        return mapPicklistNameValues;

    }



    public static void clearPermissionSetAssignment()
    {
        List<PermissionSet> permissionSetIds = new List<PermissionSet>();
        permissionSetIds =  [SELECT Id From PermissionSet WHERE Label = 'Sales Feedback Requester'];
        List<PermissionSetAssignment> deletePermissionSetAssignments = new List<PermissionSetAssignment>();
        Id permissionId;

        if(!permissionSetIds.isEmpty()) {
            permissionId = permissionSetIds[0].Id;
        }
        deletePermissionSetAssignments = [ SELECT Id FROM PermissionSetAssignment WHERE PermissionSetId =: permissionId];
        delete deletePermissionSetAssignments;
    }







    public class ButtonWrapper {
        public String Label { get; set; }
        public String Id { get; set; }
        public Boolean isSelected { get; set; }

        public ButtonWrapper() {
            Label = '';
            Id = '';
            isSelected = false;
        }
    }




}