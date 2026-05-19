global with sharing class TruSalesAppController {



//    global TruSales_App_Settings__c settings {
//        get {
//            return TruSales_App_Settings__c.getOrgDefaults();
//        }
//    }


    global Discovery_Bots_Settings__c settings {
        get {
            return [SELECT Id, Active_All_Users__c, Active_Product_Fields__c, API_Endpoint__c, API_Endpoint_Profiles__c, Collector_id__c, Name, Enable_Manual_Button_on_VF__c, Enable_Opportunity_Amount__c,
                    Enable_Opportunity_Types__c, Enable_Record_Types__c, Enable_Sales_Stages__c, Enable_Sales_Stages_Values__c, Enabled_Opportunity_Stages__c, Enabled_Opportunity_Types__c, Enabled_Record_Types__c,
                    Initiative_id__c, Is_Active__c, Open_In_New_Window__c, Opportunity_Amount_Field__c, Opportunity_Amount_Fields__c, Opportunity_Amount_Value__c, Opportunity_Type_Field__c, Opportunity_Type_Sync_Field__c,
                    Opportunity_Types_Map_1__c, Opportunity_Types_Map_2__c, Opportunity_Types_Map_3__c, Outcome_Types_Map_1__c, Outcome_Types_Map_2__c, Outcome_Types_Map_3__c, Survey_Collector_Email__c, Survey_Collector_Name__c, TruVoice_API_Key__c,
                    TruVoice_Client_ID__c, TruVoiceIntegration__c, Recepient__c FROM Discovery_Bots_Settings__c LIMIT 1];
        }
    }

//    global String orgId
//    {
//        get{
//            return UserInfo.getOrganizationId();
//        }
//    }


    global TruSalesAppController(ApexPages.StandardController controller) {

    }
    @AuraEnabled
    public static String getOpportunityName(Id id){

        return [SELECT Name FROM Opportunity WHERE Id = : id LIMIT 1].Name;
    }

//    @AuraEnabled
//    public static String getOpportunityStatusApex(Id id){
//        return [SELECT StageName FROM Opportunity WHERE Id = : id LIMIT 1].StageName;
//    }
    @AuraEnabled
    public static List<String> getOpportunityStatusApex(Id id){
        List<String> opInfo = new List<String>();
        opInfo.add([SELECT StageName FROM Opportunity WHERE Id = : id LIMIT 1].StageName);
        opInfo.add(String.valueOf([SELECT Feedback_Request_Allowed__c FROM User WHERE Id = : UserInfo.getUserId() LIMIT 1].Feedback_Request_Allowed__c));

        return opInfo;
    }

    @AuraEnabled
    @RemoteAction
    global static Boolean isSuitableOpportunity(Id opportunityId) {

        if (!Schema.SObjectType.Opportunity.isAccessible() || !Schema.SObjectType.Opportunity.fields.StageName.isAccessible())
            return false;

        //TruSales_App_Settings__c appSettings = TruSales_App_Settings__c.getOrgDefaults();

        Discovery_Bots_Settings__c appSettings = [SELECT Id, Active_All_Users__c, Active_Product_Fields__c, API_Endpoint__c, API_Endpoint_Profiles__c, Collector_id__c, Name, Enable_Manual_Button_on_VF__c, Enable_Opportunity_Amount__c,
                Enable_Opportunity_Types__c, Enable_Record_Types__c, Enable_Sales_Stages__c, Enable_Sales_Stages_Values__c, Enabled_Opportunity_Stages__c, Enabled_Opportunity_Types__c, Enabled_Record_Types__c,
                Initiative_id__c, Is_Active__c, Open_In_New_Window__c, Opportunity_Amount_Field__c, Opportunity_Amount_Fields__c, Opportunity_Amount_Value__c, Opportunity_Type_Field__c, Opportunity_Type_Sync_Field__c,
                Opportunity_Types_Map_1__c, Opportunity_Types_Map_2__c, Opportunity_Types_Map_3__c, Outcome_Types_Map_1__c, Outcome_Types_Map_2__c, Outcome_Types_Map_3__c, Survey_Collector_Email__c, Survey_Collector_Name__c, TruVoice_API_Key__c,
                TruVoice_Client_ID__c, TruVoiceIntegration__c FROM Discovery_Bots_Settings__c LIMIT 1];

        List<TruSales_Product_Map_Item__c> truSalesProductMapItemsWithProduct = new List<TruSales_Product_Map_Item__c>();
        List<TruSales_Product_Map_Item__c> truSalesProductMapItemsWithOpportunity = new List<TruSales_Product_Map_Item__c>();
        List<OpportunityLineItem> resultOpportunityLineItemsForProduct = new List<OpportunityLineItem>();
        List<Opportunity> resultOpportunityLineItemsForOpportunity = new List<Opportunity>();
        Set<String> querySetWithProduct = new Set<String>();
        List<OpportunityLineItem> opportunityLineItems = new List<OpportunityLineItem>();
        String queryLineItem = 'SELECT Id,';


        if(appSettings.Active_Product_Fields__c)
        {
            truSalesProductMapItemsWithProduct = [SELECT Id, Object_Name__c,Field_Name__c,Picklist_Value__c FROM TruSales_Product_Map_Item__c WHERE Object_Name__c = 'Product2'];

            if(!truSalesProductMapItemsWithProduct.isEmpty())
            {
                for (TruSales_Product_Map_Item__c truSalesProductMapItem: truSalesProductMapItemsWithProduct)
                {
                        querySetWithProduct.add(truSalesProductMapItem.Object_Name__c + '.' + truSalesProductMapItem.Field_Name__c);
                }

                List<String> queryList = new List<String>(querySetWithProduct);

                queryLineItem += String.join(queryList, ',');

                queryLineItem += ' FROM OpportunityLineItem WHERE Opportunity.Id =: ' + 'opportunityId';

                opportunityLineItems = Database.query(queryLineItem);
            }


            if(!truSalesProductMapItemsWithProduct.isEmpty())
            {
                if(opportunityLineItems.isEmpty())
                {
                    return false;
                }
                else
                {

                    for(TruSales_Product_Map_Item__c truSalesProductMapItem: truSalesProductMapItemsWithProduct)
                    {
                        for (OpportunityLineItem opl: opportunityLineItems)
                        {
                            if(String.valueOf(opl.getSObject(truSalesProductMapItem.Object_Name__c).get(truSalesProductMapItem.Field_Name__c)).contains(String.valueOf(truSalesProductMapItem.Picklist_Value__c)))
                            {
                                resultOpportunityLineItemsForProduct.add(opl);
                            }
                        }
                    }
                }


                if(resultOpportunityLineItemsForProduct.isEmpty())
                {
                    return false;
                }

            }

        }


        truSalesProductMapItemsWithOpportunity = [SELECT Id,Object_Name__c,Field_Name__c,Picklist_Value__c FROM TruSales_Product_Map_Item__c WHERE Object_Name__c = 'Opportunity'];


        if (!appSettings.Is_Active__c)
            return false;

        Set<String> fieldsToRetrieve = new Set<String>{
                'Id', 'StageName'
        };

        for(TruSales_Product_Map_Item__c truSalesProductMapItem : truSalesProductMapItemsWithOpportunity)
        {
            fieldsToRetrieve.add(truSalesProductMapItem.Field_Name__c);
        }

        List<String> conditions = new List<String>{
                'Id = \'' + opportunityId + '\''
        };


        if (appSettings.Enable_Opportunity_Amount__c) {
            if(appSettings.Opportunity_Amount_Field__c != null && appSettings.Opportunity_Amount_Value__c != null )
            {
                if (!Schema.SObjectType.Opportunity.fields.getMap().get(appSettings.Opportunity_Amount_Field__c).getDescribe().isAccessible())
                    return false;

                conditions.add(appSettings.Opportunity_Amount_Field__c + ' >= ' + appSettings.Opportunity_Amount_Value__c);
            }
            else
            {
                return false;
            }

        }


        if (appSettings.Enable_Record_Types__c) {
            if (!Schema.SObjectType.Opportunity.fields.RecordTypeId.isAccessible())
                return false;

            fieldsToRetrieve.add('RecordTypeId');
        }


        if (appSettings.Enable_Opportunity_Types__c) {
            if (!Schema.SObjectType.Opportunity.fields.getMap().get(appSettings.Opportunity_Type_Field__c).getDescribe().isAccessible())
                return false;

            fieldsToRetrieve.add(appSettings.Opportunity_Type_Field__c);
        }


        String query = 'SELECT ' + String.join(new List<String>(fieldsToRetrieve), ',') + ' FROM Opportunity WHERE ' + String.join(conditions, ' AND ');
        List<Opportunity> opportunities = Database.query(query);

        for (Opportunity opportunity : opportunities) {
            if(appSettings.Enabled_Opportunity_Stages__c != null)
            {
                if (!appSettings.Enabled_Opportunity_Stages__c.toLowerCase().contains(opportunity.StageName.toLowerCase()))
                    return false;
            }
            else
            {
                return false;
            }

        }

        if (appSettings.Enable_Record_Types__c) {
            for (Opportunity opportunity : opportunities) {
                if(appSettings.Enable_Record_Types__c != null)
                {
                    if (!appSettings.Enabled_Record_Types__c.contains(String.valueOf(opportunity.RecordTypeId)))
                        return false;
                }
                else
                {
                    return false;
                }

            }
        }

        if (appSettings.Enable_Opportunity_Types__c) {
            for (Opportunity opportunity : opportunities) {
                if(appSettings.Enable_Record_Types__c != null)
                {
                    if (!appSettings.Enabled_Opportunity_Types__c.contains(String.valueOf(opportunity.get(appSettings.Opportunity_Type_Field__c))))
                        return false;
                }
                else {
                    return false;
                }

            }
        }


        if(appSettings.Active_Product_Fields__c)
        {
            if(!truSalesProductMapItemsWithOpportunity.isEmpty())
            {

                for(TruSales_Product_Map_Item__c truSalesProductMapItem: truSalesProductMapItemsWithOpportunity)
                {

                    for (Opportunity opportunity: opportunities)
                    {
                        if(String.valueOf(opportunity.get(truSalesProductMapItem.Field_Name__c)).contains(String.valueOf(truSalesProductMapItem.Picklist_Value__c)))
                        {
                            resultOpportunityLineItemsForOpportunity.add(opportunity);
                        }
                    }
                }

                if(resultOpportunityLineItemsForOpportunity.isEmpty())
                {
                    return false;
                }
            }

        }



        if(appSettings.Enable_Sales_Stages__c)
        {

            List<OpportunityHistory> opportunityHistoryStage = new List<OpportunityHistory>();
            opportunityHistoryStage = [SELECT StageName FROM OpportunityHistory WHERE OpportunityId IN : opportunities];
            List<OpportunityHistory> resultOpportunityHistoryStage = new List<OpportunityHistory>();

            if(appSettings.Enable_Sales_Stages_Values__c !=null || appSettings.Enable_Sales_Stages_Values__c != '')
            {
                for (OpportunityHistory oph: opportunityHistoryStage)
                {
                    if(appSettings.Enable_Sales_Stages_Values__c.contains(oph.StageName))
                    {
                        resultOpportunityHistoryStage.add(oph);
                    }
                }
            }

            if(resultOpportunityHistoryStage.isEmpty())
            {
                return false;
            }

        }



        return !opportunities.isEmpty();
    }
    @AuraEnabled
    @RemoteAction
    global static Boolean getUserInfo() {
        Id UserInf = UserInfo.getUserId();
        User bool = Database.query('SELECT Id, Feedback_Request_Allowed__c FROM User WHERE Id = :UserInf');
        List<PermissionSet> permissionSetIds = new List<PermissionSet>();
        permissionSetIds =  [SELECT Id FROM PermissionSet WHERE Label = 'Sales Feedback Requester'];
        Id permissionSetId = permissionSetIds[0].Id;
        List<PermissionSetAssignment> permissionSetAssignmentUsers = new List<PermissionSetAssignment>();
        permissionSetAssignmentUsers = [ SELECT Id,AssigneeId FROM PermissionSetAssignment WHERE PermissionSetId = :permissionSetId];
        Set<Id> assigneeId = new Set<Id>();

        List<TruSales_Users_Item__c> truSalesUsersItems = new List<TruSales_Users_Item__c>();
        truSalesUsersItems = [SELECT Select_by__c,Selected_Value__c FROM TruSales_Users_Item__c];

        if(!truSalesUsersItems.isEmpty())
        {
            for(PermissionSetAssignment permissionSetAssignment : permissionSetAssignmentUsers)
            {
                assigneeId.add(permissionSetAssignment.AssigneeId);
            }
            return assigneeId.contains(UserInf);

        }
        else
        {
            return bool.Feedback_Request_Allowed__c;
        }

    }
//    @AuraEnabled
//    @RemoteAction
//    global static TruSales_App_Settings__c getSettings() {
//        if (TruSales_App_Settings__c.getOrgDefaults().Id == null) {
//            insert new TruSales_App_Settings__c();
//        }
//        return TruSales_App_Settings__c.getOrgDefaults();
//    }



    @AuraEnabled
    @RemoteAction
    global static Discovery_Bots_Settings__c getSettings() {

        Discovery_Bots_Settings__c returnSetting = [SELECT Id, Active_All_Users__c, Active_Product_Fields__c, API_Endpoint__c, API_Endpoint_Profiles__c, Collector_id__c, Name, Enable_Manual_Button_on_VF__c, Enable_Opportunity_Amount__c,
                Enable_Opportunity_Types__c, Enable_Record_Types__c, Enable_Sales_Stages__c, Enable_Sales_Stages_Values__c, Enabled_Opportunity_Stages__c, Enabled_Opportunity_Types__c, Enabled_Record_Types__c,
                Initiative_id__c, Is_Active__c, Open_In_New_Window__c, Opportunity_Amount_Field__c, Opportunity_Amount_Fields__c, Opportunity_Amount_Value__c, Opportunity_Type_Field__c, Opportunity_Type_Sync_Field__c,
                Opportunity_Types_Map_1__c, Opportunity_Types_Map_2__c, Opportunity_Types_Map_3__c, Outcome_Types_Map_1__c, Outcome_Types_Map_2__c, Outcome_Types_Map_3__c, Survey_Collector_Email__c, Survey_Collector_Name__c, TruVoice_API_Key__c,
                TruVoice_Client_ID__c, TruVoiceIntegration__c FROM Discovery_Bots_Settings__c LIMIT 1];

        if (returnSetting.Id == null) {
            insert new Discovery_Bots_Settings__c();
        }
        return returnSetting;
    }


    @AuraEnabled
    @RemoteAction
    global static String getOrgId() {

        return UserInfo.getOrganizationId();
    }



    @AuraEnabled
    @RemoteAction
    global static Id getOwnerId(Id opportunityId) {
        if (!Opportunity.getSObjectType().getDescribe().isAccessible() ||
            !Opportunity.OwnerId.getDescribe().isAccessible()) {
            return null;
        }
        return [
            SELECT Id, OwnerId
            FROM Opportunity
            WHERE Id = :opportunityId
        ].OwnerId;
    }
    @AuraEnabled
    @RemoteAction
    global static String getEmail(Id id){
        return [
            SELECT Id, Email
            FROM User
            WHERE Id = :id

        ].Email;
    }

    @AuraEnabled
    @RemoteAction
    global static String  getJSONStringForOpportunitiesSync(String lastSyncDateString, Id ownerId, Map<String, String> truVoiceProducts) {
        Date lastSyncDate = null;

        if (String.isNotBlank(lastSyncDateString)) {
            lastSyncDate = Date.valueOf(lastSyncDateString);
        }

        if (lastSyncDate == null) {
            lastSyncDate = Date.today().addMonths(-24);
        }

//        TruSales_App_Settings__c settings = TruSales_App_Settings__c.getOrgDefaults();


        Discovery_Bots_Settings__c settings = [SELECT Id, Active_All_Users__c, Active_Product_Fields__c, API_Endpoint__c, API_Endpoint_Profiles__c, Collector_id__c, Name, Enable_Manual_Button_on_VF__c, Enable_Opportunity_Amount__c,
                Enable_Opportunity_Types__c, Enable_Record_Types__c, Enable_Sales_Stages__c, Enable_Sales_Stages_Values__c, Enabled_Opportunity_Stages__c, Enabled_Opportunity_Types__c, Enabled_Record_Types__c,
                Initiative_id__c, Is_Active__c, Open_In_New_Window__c, Opportunity_Amount_Field__c, Opportunity_Amount_Fields__c, Opportunity_Amount_Value__c, Opportunity_Type_Field__c, Opportunity_Type_Sync_Field__c,
                Opportunity_Types_Map_1__c, Opportunity_Types_Map_2__c, Opportunity_Types_Map_3__c, Outcome_Types_Map_1__c, Outcome_Types_Map_2__c, Outcome_Types_Map_3__c, Survey_Collector_Email__c, Survey_Collector_Name__c, TruVoice_API_Key__c,
                TruVoice_Client_ID__c, TruVoiceIntegration__c FROM Discovery_Bots_Settings__c LIMIT 1];


        User owner = [
            SELECT Id, FirstName, LastName, Email
            FROM User
            WHERE Id = :ownerId
        ];

        OpportunitySyncRequest request = new OpportunitySyncRequest();

        request.sender_id = owner.Id;
        request.sender_first_name = owner.FirstName;
        request.sender_last_name = owner.LastName;
        request.sender_email = owner.Email;

        Set<String> opportunityFields = new Set<String> {
            'Id', 'Name', 'CloseDate', 'Owner.Id', 'Owner.FirstName', 'Owner.LastName', 'Owner.Email', 'Account.Id', 'Account.Name', 'Account.Website', 'AccountId', 'StageName'
        };

        if(settings.Opportunity_Type_Sync_Field__c != null)
        {
            opportunityFields.add(settings.Opportunity_Type_Sync_Field__c);
        }



        List<TruSales_Product_Map_Item__c> opportunityProductMapItems = [
            SELECT Id, Field_Name__c, TruVoice_Product_Id__c, Picklist_Value__c
            FROM TruSales_Product_Map_Item__c
            WHERE Object_Name__c = 'Opportunity'
        ];
        for (TruSales_Product_Map_Item__c productMapItem : opportunityProductMapItems) {
            opportunityFields.add(productMapItem.Field_Name__c);
        }

        Set<String> productFieldsToRetrieve = new Set<String> {
            'Id', 'Product2id', 'Product2.Id'
        };
        List<TruSales_Product_Map_Item__c> productProductMapItems = [
            SELECT Id, Field_Name__c, TruVoice_Product_Id__c, Picklist_Value__c
            FROM TruSales_Product_Map_Item__c
            WHERE Object_Name__c = 'Product2'
        ];
        for (TruSales_Product_Map_Item__c productMapItem : productProductMapItems) {
            productFieldsToRetrieve.add('Product2.' + productMapItem.Field_Name__c);
        }
        opportunityFields.addAll(settings.Opportunity_Amount_Fields__c.split(';'));

        String closedStages = '';

        for (OpportunityStage opportunityStage : [
            SELECT Id, ApiName
            FROM OpportunityStage
            WHERE IsClosed = TRUE
        ]) {
            closedStages += ',\'' + opportunityStage.ApiName + '\'';
        }

        closedStages = '(' + closedStages.substring(1) + ')';

        List<String> whereClauses = new List<String> {
            'OwnerId = \'' + ownerId + '\'',
            'CreatedDate >= ' + String.valueOf(lastSyncDate) + 'T00:00:00Z',
            'StageName IN ' + closedStages
        };
    System.debug('QUERY: ' + 'SELECT ' + String.join(new List<String>(opportunityFields), ',') + ', (SELECT ' + String.join(new List<String>(productFieldsToRetrieve), ',') + ' FROM OpportunityLineItems) FROM Opportunity WHERE ' + String.join(whereClauses, ' AND '));
        List<Opportunity> opportunities = Database.query('SELECT ' + String.join(new List<String>(opportunityFields), ',') + ', (SELECT ' + String.join(new List<String>(productFieldsToRetrieve), ',') + ' FROM OpportunityLineItems) FROM Opportunity WHERE ' + String.join(whereClauses, ' AND '));
        Map<String, String> outcomeTypesMap = (Map<String, String>)JSON.deserialize(settings.Outcome_Types_Map_1__c + settings.Outcome_Types_Map_2__c + settings.Outcome_Types_Map_3__c, Map<String, String>.class);
        Map<String, String> opportunityTypesMap = (Map<String, String>)JSON.deserialize(settings.Opportunity_Types_Map_1__c + settings.Opportunity_Types_Map_2__c + settings.Opportunity_Types_Map_3__c, Map<String, String>.class);
        for (Opportunity opportunity : opportunities) {
            OpportunitySyncRequestItem requestItem = new OpportunitySyncRequestItem();

            requestItem.opportunity_id = opportunity.Id;
            requestItem.opportunity_name = opportunity.Name;
            requestItem.opportunity_close_date = opportunity.CloseDate;
            requestItem.owner_id = opportunity.Owner.Id;
            requestItem.owner_first_name = opportunity.Owner.FirstName;
            requestItem.owner_last_name = opportunity.Owner.LastName;
            requestItem.owner_email = opportunity.Owner.Email;

            if (outcomeTypesMap.containsKey(opportunity.StageName)) {
                requestItem.outcome_type = Integer.valueOf(outcomeTypesMap.get(opportunity.StageName));

                if (requestItem.outcome_type < 0) {
                    continue;
                }
            } else {
                continue;
            }

            if (opportunityTypesMap.containsKey(String.valueOf(opportunity.get(settings.Opportunity_Type_Sync_Field__c)))) {
                requestItem.opportunity_type = Integer.valueOf(opportunityTypesMap.get(String.valueOf(opportunity.get(settings.Opportunity_Type_Sync_Field__c))));

                if (requestItem.opportunity_type < 0) {
                    continue;
                }
            } else {
                continue;
            }

            requestItem.opportunity_value = 0;
            for (String fieldName : settings.Opportunity_Amount_Fields__c.split(';')) {
                if (opportunity.get(fieldName) != null) {
                    requestItem.opportunity_value += Double.valueOf(opportunity.get(fieldName));
                }
            }

            if (opportunity.AccountId != null) {
                requestItem.account_id = opportunity.Account.Id;
                requestItem.account_name = opportunity.Account.Name;
                requestItem.account_website = opportunity.Account.Website;
            }

            for (TruSales_Product_Map_Item__c productMapItem : opportunityProductMapItems) {
                if (String.valueOf(opportunity.get(productMapItem.Field_Name__c)) != productMapItem.Picklist_Value__c || productMapItem.TruVoice_Product_Id__c == 'Exclude') {
                    continue;
                }
                OpportunitySyncRequestItemProduct productItem = new OpportunitySyncRequestItemProduct();
                productItem.product_name = truVoiceProducts.get(productMapItem.TruVoice_Product_Id__c);
                productItem.tv_underscore_product_id = productMapItem.TruVoice_Product_Id__c;
                requestItem.products.add(productItem);
            }

            for (OpportunityLineItem opportunityLineItem : opportunity.OpportunityLineItems) {
                Product2 product = opportunityLineItem.Product2;

                for (TruSales_Product_Map_Item__c productMapItem : productProductMapItems) {
                    if (String.valueOf(product.get(productMapItem.Field_Name__c)) == productMapItem.Picklist_Value__c && productMapItem.TruVoice_Product_Id__c != 'Exclude') {
                        OpportunitySyncRequestItemProduct productItem = new OpportunitySyncRequestItemProduct();
                        productItem.product_name = truVoiceProducts.get(productMapItem.TruVoice_Product_Id__c);
                        productItem.tv_underscore_product_id = productMapItem.TruVoice_Product_Id__c;
                        productItem.product_id = product.Id;
                        requestItem.products.add(productItem);
                    }
                }
            }
            request.opportunities.add(requestItem);
        }
        return JSON.serialize(request);
    }

    private class OpportunitySyncRequest {
        public String sender_id;
        public String sender_first_name;
        public String sender_last_name;
        public String sender_email;
        public List<OpportunitySyncRequestItem> opportunities = new List<OpportunitySyncRequestItem>();
    }

    private class OpportunitySyncRequestItem {
        public String opportunity_id;
        public String opportunity_name;
        public Date opportunity_close_date;
        public Double opportunity_value;
        public Integer outcome_type;
        public Integer opportunity_type;
        public String owner_id;
        public String owner_first_name;
        public String owner_last_name;
        public String owner_email;
        public String account_id;
        public String account_name;
        public String account_website;
        public List<OpportunitySyncRequestItemProduct> products = new List<OpportunitySyncRequestItemProduct>();
    }

    private class OpportunitySyncRequestItemProduct {
        public String tv_underscore_product_id;
        public String product_id;
        public String product_name;
    }

}