global  with sharing class RequestFeedbackForController {
    @AuraEnabled
    public static List<User> getUsers(Id oppId)
    {
        Opportunity opp = [SELECT OwnerId FROM Opportunity WHERE Id =: oppId LIMIT 1];
        User owner = [SELECT Email, Name FROM User WHERE Id=:opp.OwnerId Limit 1];
        User loggedInUser = [SELECT Email, Name FROM User WHERE Id=:UserInfo.getUserId() LIMIT 1];
        User userCollector = new User();
        Discovery_Bots_Settings__c discoveryBotsSettings = [SELECT Id, Active_All_Users__c, Active_Product_Fields__c, API_Endpoint__c, API_Endpoint_Profiles__c, Collector_id__c, Name, Enable_Manual_Button_on_VF__c, Enable_Opportunity_Amount__c,
                Enable_Opportunity_Types__c, Enable_Record_Types__c, Enable_Sales_Stages__c, Enable_Sales_Stages_Values__c, Enabled_Opportunity_Stages__c, Enabled_Opportunity_Types__c, Enabled_Record_Types__c,
                Initiative_id__c, Is_Active__c, Open_In_New_Window__c, Opportunity_Amount_Field__c, Opportunity_Amount_Fields__c, Opportunity_Amount_Value__c, Opportunity_Type_Field__c, Opportunity_Type_Sync_Field__c,
                Opportunity_Types_Map_1__c, Opportunity_Types_Map_2__c, Opportunity_Types_Map_3__c, Outcome_Types_Map_1__c, Outcome_Types_Map_2__c, Outcome_Types_Map_3__c, Survey_Collector_Email__c, Survey_Collector_Name__c, TruVoice_API_Key__c,
                TruVoice_Client_ID__c, TruVoiceIntegration__c FROM Discovery_Bots_Settings__c LIMIT 1];

//        userCollector.Email = TruSales_App_Settings__c.getOrgDefaults().Survey_Collector_Email__c;
//        userCollector.FirstName = TruSales_App_Settings__c.getOrgDefaults().Survey_Collector_Name__c;


        userCollector.Email = discoveryBotsSettings.Survey_Collector_Email__c;
        userCollector.FirstName = discoveryBotsSettings.Survey_Collector_Name__c;
//        userCollector.LastName = 'asd';

        List<User> users = new List<User>();
        users.add(owner);
        users.add(loggedInUser);
        users.add(userCollector);
        return users;
       /* return [SELECT Name, Id, Email
                FROM User];*/
    }
//    global TruSales_App_Settings__c settings {
//        get {
//            return TruSales_App_Settings__c.getInstance();
//            }
//    }


    global Discovery_Bots_Settings__c settings {
        get {
            return [SELECT Id, Active_All_Users__c, Active_Product_Fields__c, API_Endpoint__c, API_Endpoint_Profiles__c, Collector_id__c, Name, Enable_Manual_Button_on_VF__c, Enable_Opportunity_Amount__c,
                    Enable_Opportunity_Types__c, Enable_Record_Types__c, Enable_Sales_Stages__c, Enable_Sales_Stages_Values__c, Enabled_Opportunity_Stages__c, Enabled_Opportunity_Types__c, Enabled_Record_Types__c,
                    Initiative_id__c, Is_Active__c, Open_In_New_Window__c, Opportunity_Amount_Field__c, Opportunity_Amount_Fields__c, Opportunity_Amount_Value__c, Opportunity_Type_Field__c, Opportunity_Type_Sync_Field__c,
                    Opportunity_Types_Map_1__c, Opportunity_Types_Map_2__c, Opportunity_Types_Map_3__c, Outcome_Types_Map_1__c, Outcome_Types_Map_2__c, Outcome_Types_Map_3__c, Survey_Collector_Email__c, Survey_Collector_Name__c, TruVoice_API_Key__c,
                    TruVoice_Client_ID__c, TruVoiceIntegration__c FROM Discovery_Bots_Settings__c LIMIT 1];
        }
    }

    @AuraEnabled
    public static String getOwnerId(Id oppid){
        
        return [SELECT OwnerId FROM Opportunity WHERE Id =: oppid LIMIT 1].OwnerId;
        
    }
    @AuraEnabled
    public static Discovery_Bots_Settings__c getSettings() {

        Discovery_Bots_Settings__c sett = [SELECT Id, Active_All_Users__c, Active_Product_Fields__c, API_Endpoint__c, API_Endpoint_Profiles__c, Collector_id__c, Name, Enable_Manual_Button_on_VF__c, Enable_Opportunity_Amount__c,
                Enable_Opportunity_Types__c, Enable_Record_Types__c, Enable_Sales_Stages__c, Enable_Sales_Stages_Values__c, Enabled_Opportunity_Stages__c, Enabled_Opportunity_Types__c, Enabled_Record_Types__c,
                Initiative_id__c, Is_Active__c, Open_In_New_Window__c, Opportunity_Amount_Field__c, Opportunity_Amount_Fields__c, Opportunity_Amount_Value__c, Opportunity_Type_Field__c, Opportunity_Type_Sync_Field__c,
                Opportunity_Types_Map_1__c, Opportunity_Types_Map_2__c, Opportunity_Types_Map_3__c, Outcome_Types_Map_1__c, Outcome_Types_Map_2__c, Outcome_Types_Map_3__c, Survey_Collector_Email__c, Survey_Collector_Name__c, TruVoice_API_Key__c,
                TruVoice_Client_ID__c, TruVoiceIntegration__c FROM Discovery_Bots_Settings__c LIMIT 1];

        if (sett.Id == null) {
            insert new Discovery_Bots_Settings__c();
        }

        return sett;

        //TruSales_App_Settings__c sett = TruSales_App_Settings__c.getInstance();
        //return TruSales_App_Settings__c.getOrgDefaults();

    }

//    @AuraEnabled
//    public static TruSales_App_Settings__c getSettings() {
//        if (TruSales_App_Settings__c.getOrgDefaults().Id == null) {
//            insert new TruSales_App_Settings__c();
//        }
//        TruSales_App_Settings__c sett = TruSales_App_Settings__c.getInstance();
//        //return TruSales_App_Settings__c.getOrgDefaults();
//        return sett;
//    }


    @AuraEnabled
    public static Contact getContact(Id id){
        String queryContact = 'SELECT LastName, FirstName, Id, Title, Company_Role__c, Email, MobilePhone, Phone, Phone_Extension__c, pi__notes__c FROM Contact WHERE Id=:id LIMIT 1';
        Contact contact = Database.query(queryContact);
        return contact;
    }
    @AuraEnabled
    public static List<String> getOpportunityAndAccountNames(Id oppid)
    {
        List<String> returnList = new List<String>();
        returnList.add([SELECT Name FROM Opportunity WHERE Id=:oppid LIMIT 1].Name);
        returnList.add([SELECT Account.Name FROM Opportunity WHERE Id=:oppid LIMIT 1].Account.Name);
        return returnList;
    }
    
    @AuraEnabled
    public static void insertContact(String oppId, String lastName,String firstName,String id,String title, String company_Rolec,String email, String mobilePhone, String isPrimary,
                                     String phone,String phone_Extensionc,String Pi_notesc, String accountName){
        Account account = [SELECT Id FROM Account WHERE Name=:accountName LIMIT 1];
        Contact contact = new Contact(LastName=lastName, FirstName=firstName,  AccountId=account.Id, Title=title, Email=email,
                MobilePhone=mobilePhone, Phone=phone);
        contact.put('pi__notes__c', Pi_notesc);
        contact.put('Phone_Extension__c', phone_Extensionc);
        insert contact;

        OpportunityContactRole role = new OpportunityContactRole(ContactId=contact.Id, OpportunityId=oppId, Role=company_Rolec);
        if (isPrimary=='yes') role.IsPrimary=true; else role.IsPrimary=false;
        insert role;
        
    }
    @AuraEnabled
    public static void updateContact(String oppId, String lastName,String firstName,String id,String title, String company_Rolec,String email, String mobilePhone, String isPrimary,
                                     String phone,String phone_Extensionc,String Pi_notesc, String accountName){
        Contact contact = new Contact(LastName=lastName, FirstName=firstName, Id=id,
        Title=title,  Email=email, MobilePhone=mobilePhone, Phone=phone);
        contact.put('Phone_Extension__c', phone_Extensionc);
        contact.put('pi__notes__c', Pi_notesc);
        upsert contact;
            if (oppId!='1111') {
                OpportunityContactRole ocr = [SELECT ContactId, Role, OpportunityId FROM OpportunityContactRole WHERE ContactId=:Id AND OpportunityId=:oppId LIMIT 1];
                ocr.Role=company_Rolec;
                upsert ocr;
            }
    }
    @AuraEnabled
    public static List<String> getPickListValuesIntoList(){
        List<String> pickListValuesList = new List<String>();
        Schema.DescribeFieldResult fieldResult = OpportunityContactRole.Role.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
            
        }     
        return pickListValuesList;
    }
    @AuraEnabled
    public static OpportunityContactRole getContactRole(Id contactId, Id oppId){
        OpportunityContactRole ocr = [SELECT ContactId, Role, OpportunityId FROM OpportunityContactRole WHERE ContactId=:contactId AND OpportunityId=:oppId LIMIT 1];
        if (ocr==null){
            return new OpportunityContactRole(ContactId='1111', OpportunityId='1111');
        }else{
            return ocr;
        }
    }
//    @AuraEnabled
//    public static String getDataForContactSubmit(String contactList, Id oppId, Id senderId){
//       TruSales_App_Settings__c settings = TruSales_App_Settings__c.getInstance();
//       String[] ctcList = new List<String>();
//         if(String.isNotBlank(contactList)) {
//          for(String eachStr : contactList.split(',')) {
//            ctcList.add(eachStr);
//             }
//         }
//         User sender = [SELECT FirstName, LastName, Email, Phone, Title, CompanyName,Extension FROM User WHERE Id=:senderId];
//        List<Contact> contacts = [SELECT Id, FirstName, LastName, Email, Phone, Phone_Extension__c, MobilePhone, Title, Company_Role__c,pi__notes__c FROM Contact WHERE Id IN : ctcList];
//        List<rest_Contact> restContacts = new List<rest_Contact>();
//        for (Contact contact: contacts) {
//            rest_Contact ctc = new rest_Contact();
//            ctc.contact_id = contact.Id;
//            ctc.first_name = contact.FirstName;
//            ctc.last_name = contact.LastName;
//            ctc.Email = contact.Email;
//            ctc.phone_ext = contact.Phone_Extension__c;
//            ctc.Phone = contact.Phone;
//            ctc.mobile_phone = contact.MobilePhone;
//            ctc.Title = contact.Title;
//            ctc.Role = contact.Company_Role__c;
//            ctc.notes = '';
//            ctc.customer_type = 1;
//            restContacts.add(ctc);
//        }
//        Set<String> oppFieldList = Schema.getGlobalDescribe().get('Opportunity').getDescribe().fields.getMap().keySet();
//        List<String> strList = new List<String>();
//        strList.addAll(oppFieldList);
//        strList.add('Account.Id,Account.Name,Account.Website,Owner.FirstName,Owner.LastName,Owner.Email');
//        String fields = string.join(strList,',');
//        String query = 'SELECT ' + fields + ' FROM Opportunity WHERE Id = \'' + oppId + '\' LIMIT 1';
//        Opportunity opportunity = Database.query(query);
//        requestBody body = new requestBody();
//        body.contact = restContacts;
//        body.opportunity_id = opportunity.Id;
//        body.opportunity_name = opportunity.Name;
//        body.opportunity_close_date = String.valueOfGmt(opportunity.CloseDate);
//        body.account_id = opportunity.Account.Id;
//        body.account_name = opportunity.Account.Name;
//        body.account_website = opportunity.Account.Website;
//        body.research_type = 1;
//        body.send_email_from = sender.email;
//        body.owner_id = opportunity.Owner.Id;
//        body.owner_first_name = opportunity.Owner.FirstName;
//        body.owner_last_name = opportunity.Owner.LastName;
//        body.owner_email = opportunity.Owner.Email;
//        body.sender_id = sender.Id;
//        body.sender_first_name = sender.FirstName;
//        body.sender_last_name = sender.LastName;
//        body.sender_email = sender.Email;
//        body.sender_phone = sender.Phone;
//        body.sender_extension = sender.Extension;
//        body.sender_title = sender.Title;
//        body.sender_company = sender.CompanyName;
//
//        System.debug(settings.Opportunity_Amount_Field__c);
//
//        Double opportunity_value = 0;
//        for (String fieldName : settings.Opportunity_Amount_Fields__c.split(';')) {
//            System.debug(fieldName);
//            if (opportunity.get(fieldName) != null) {
//                opportunity_value += Double.valueOf(opportunity.get(fieldName));
//            }
//        }
//        body.opportunity_value = String.valueOf(opportunity_value);
//
//        Map<String, String> outcomeTypesMap = (Map<String, String>)JSON.deserialize(settings.Outcome_Types_Map_1__c + settings.Outcome_Types_Map_2__c + settings.Outcome_Types_Map_3__c, Map<String, String>.class);
//        Integer outcome_type = 0;
//        if (outcomeTypesMap.containsKey(opportunity.StageName)) {
//            outcome_type = Integer.valueOf(outcomeTypesMap.get(opportunity.StageName));
//            }
//        body.opportunity_outcome = outcome_type;
//        Integer program_type = 0;
//        Http http = new Http();
//        HttpRequest request = new HttpRequest();
//        request.setEndpoint(settings.Api_Endpoint__c + '/sfa/clients/' + settings.TruVoice_Client_ID__c + '/programs');
//        request.setMethod('GET');
//        request.setHeader('apikey', settings.TruVoice_API_Key__c);
//        request.setHeader('x-truvoice-client', settings.TruVoice_Client_ID__c);
//        HttpResponse response = http.send(request);
//        if (response.getStatusCode()==200) {
//            System.debug(response.getBody());
//            List<Program> programList = (List<Program>)JSON.deserialize(response.getBody(), List<Program>.class);
//            for(Program program:programList) {
//                if (program.id==settings.Initiative_id__c) program_type = program.type_value;
//            }
//
//        }
//        else System.debug(response.getStatusCode());
//        body.program_type = program_type;
//        List<TruSales_Product_Map_Item__c> tpmic = [SELECT TruVoice_Product_Id__c FROM TruSales_Product_Map_Item__c WHERE Object_Name__c = 'Opportunity'];
//        List<String> product_ids =new List<String>();
//        for (TruSales_Product_Map_Item__c tp:tpmic) {
//            product_ids.add(tp.TruVoice_Product_Id__c);
//        }
//        body.product_ids = product_ids;
//        body.product_id = '';
//        System.debug(JSON.serialize(body));
//        return JSON.serialize(body);
//
//
//
//    }

    @AuraEnabled
    public static List<String> getDataForContactSubmit(String contactList, Id oppId, Id senderId){

       System.debug('<<<<<<<<<<getDataForContactSubmitStart>>>>>');
       List<String> returnJsonList =new List<String>();

       //TruSales_App_Settings__c settings = TruSales_App_Settings__c.getInstance();


        Discovery_Bots_Settings__c settings = [SELECT Id, Active_All_Users__c, Active_Product_Fields__c, API_Endpoint__c, API_Endpoint_Profiles__c, Collector_id__c, Name, Enable_Manual_Button_on_VF__c, Enable_Opportunity_Amount__c,
                Enable_Opportunity_Types__c, Enable_Record_Types__c, Enable_Sales_Stages__c, Enable_Sales_Stages_Values__c, Enabled_Opportunity_Stages__c, Enabled_Opportunity_Types__c, Enabled_Record_Types__c,
                Initiative_id__c, Is_Active__c, Open_In_New_Window__c, Opportunity_Amount_Field__c, Opportunity_Amount_Fields__c, Opportunity_Amount_Value__c, Opportunity_Type_Field__c, Opportunity_Type_Sync_Field__c,
                Opportunity_Types_Map_1__c, Opportunity_Types_Map_2__c, Opportunity_Types_Map_3__c, Outcome_Types_Map_1__c, Outcome_Types_Map_2__c, Outcome_Types_Map_3__c, Survey_Collector_Email__c, Survey_Collector_Name__c, TruVoice_API_Key__c,
                TruVoice_Client_ID__c, TruVoiceIntegration__c FROM Discovery_Bots_Settings__c LIMIT 1];

       String[] ctcList = new List<String>();
         if(String.isNotBlank(contactList)) {
          for(String eachStr : contactList.split(',')) {
            ctcList.add(eachStr);
             }
         }
         User sender = [SELECT FirstName, LastName, Email, Phone, Title, CompanyName,Extension FROM User WHERE Id=:senderId];

        String queryContacts = 'SELECT Id, FirstName, LastName, Email, Phone, Phone_Extension__c, MobilePhone, Title, Company_Role__c,pi__notes__c FROM Contact WHERE Id IN : ctcList';
        List<SObject> contacts = Database.query(queryContacts);

        List<rest_Contact> restContacts = new List<rest_Contact>();
        for (SObject contact: contacts) {
            rest_Contact ctc  = new rest_Contact();
            ctc.contact_id    = (String)contact.get('Id');
            ctc.first_name    = (String)contact.get('FirstName');
            ctc.last_name     = (String)contact.get('LastName');
            ctc.Email         = (String)contact.get('Email');
            ctc.phone_ext     = (String)contact.get('Phone_Extension__c');
            ctc.Phone         = (String)contact.get('Phone');
            ctc.mobile_phone  = (String)contact.get('MobilePhone');
            ctc.Title         = (String)contact.get('Title');
            ctc.Role          = (String)contact.get('Company_Role__c');
            ctc.notes         = '';
            ctc.customer_type = 1;
            restContacts.add(ctc);
        }
        Set<String> oppFieldList = Schema.getGlobalDescribe().get('Opportunity').getDescribe().fields.getMap().keySet();
        List<String> strList = new List<String>();
        strList.addAll(oppFieldList);
        strList.add('Account.Id,Account.Name,Account.Website,Owner.FirstName,Owner.LastName,Owner.Email');
        String fields = String.join(strList,',');
        String query = 'SELECT ' + fields + ' FROM Opportunity WHERE Id = \'' + oppId + '\' LIMIT 1';
        Opportunity opportunity = Database.query(query);
        requestBody body = new requestBody();

        body.opportunity_id = opportunity.Id;
        body.opportunity_name = opportunity.Name;
        body.opportunity_close_date = String.valueOfGmt(opportunity.CloseDate);
        body.account_id = opportunity.Account.Id;
        body.account_name = opportunity.Account.Name;
        body.account_website = opportunity.Account.Website;
        body.research_type = 1;
        body.send_email_from = sender.email;
        body.owner_id = opportunity.Owner.Id;
        body.owner_first_name = opportunity.Owner.FirstName;
        body.owner_last_name = opportunity.Owner.LastName;
        body.owner_email = opportunity.Owner.Email;
        body.sender_id = sender.Id;
        body.sender_first_name = sender.FirstName;
        body.sender_last_name = sender.LastName;
        body.sender_email = sender.Email;
        body.sender_phone = sender.Phone;
        body.sender_extension = sender.Extension;
        body.sender_title = sender.Title;
        body.sender_company = sender.CompanyName;

        System.debug(settings.Opportunity_Amount_Field__c);

        Double opportunity_value = 0;
        for (String fieldName : settings.Opportunity_Amount_Fields__c.split(';')) {
            System.debug(fieldName);
            if (opportunity.get(fieldName) != null) {
                opportunity_value += Double.valueOf(opportunity.get(fieldName));
            }
        }
        body.opportunity_value = String.valueOf(opportunity_value);

        Map<String, String> outcomeTypesMap = (Map<String, String>)JSON.deserialize(settings.Outcome_Types_Map_1__c + settings.Outcome_Types_Map_2__c + settings.Outcome_Types_Map_3__c, Map<String, String>.class);
        Integer outcome_type = 0;
        if (outcomeTypesMap.containsKey(opportunity.StageName)) {
            outcome_type = Integer.valueOf(outcomeTypesMap.get(opportunity.StageName));
            }
        body.opportunity_outcome = outcome_type;
        Integer program_type = 0;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(settings.Api_Endpoint__c + '/sfa/clients/' + settings.TruVoice_Client_ID__c + '/programs');
        request.setMethod('GET');
        request.setHeader('apikey', settings.TruVoice_API_Key__c);
        request.setHeader('x-truvoice-client', settings.TruVoice_Client_ID__c);
        HttpResponse response = http.send(request);
        if (response.getStatusCode()==200) {
            System.debug(response.getBody());
            List<Program> programList = (List<Program>)JSON.deserialize(response.getBody(), List<Program>.class);
            for(Program program:programList) {
                if (program.id==settings.Initiative_id__c) program_type = program.type_value;
            }

        }
        else System.debug(response.getStatusCode());
        body.program_type = program_type;
        List<TruSales_Product_Map_Item__c> tpmic = [SELECT TruVoice_Product_Id__c FROM TruSales_Product_Map_Item__c WHERE Object_Name__c = 'Opportunity'];
        List<String> product_ids =new List<String>();
        for (TruSales_Product_Map_Item__c tp:tpmic) {
            product_ids.add(tp.TruVoice_Product_Id__c);
        }
        body.product_ids = product_ids;
        body.product_id = '';

        List<requestBody> bodyList=new List<RequestFeedbackForController.requestBody>();
        for(Integer i=0; i<restContacts.size(); i++){
            body.contact=restContacts.get(i);
            bodyList.add(body);
            returnJsonList.add(JSON.serialize(bodyList.get(i)));

//            System.debug(JSON.serialize(bodyList.get(i)));
        }

        for(String str:returnJsonList){
            System.debug(str);
        }
        System.debug('END');

        System.debug('returnJsonList: ' + returnJsonList);
        return returnJsonList;
    }


    @AuraEnabled
    public static List<String> getConactNamesForIds(List<Id> ids){
        List<String> returnList = new List<String>();  
        List<Contact> contacts = [SELECT Name FROM Contact WHERE Id IN :ids];
        for (Contact contact:contacts){
            returnList.add(contact.Name);
        }
         return returnList;
        
    }
    private class Program {
        public String id;
        public String name;
        public Integer type_value;
        public String type_name;
    }
    private class rest_Contact {
        public String contact_id;
        public String first_name;
        public String last_name;
        public String email;
        public String phone;
        public String phone_ext;
        public String mobile_phone;
        public String title;
        public String role;
        public String notes;
        public Integer customer_type;
    }
    private class requestBody {
        public String opportunity_id;
        public String opportunity_name;
        public String opportunity_close_date;
        public String account_id;
        public String account_name;
        public String account_website;
        public String owner_id;
        public String owner_first_name;
        public String owner_last_name;
        public String owner_email;
        public String sender_id;
        public String sender_first_name;
        public String sender_last_name;
        public String sender_email;
        public String sender_phone;
        public String sender_extension;
        public String sender_title;
        public String sender_company;
        public String send_email_from;
        public String opportunity_value;
        public Integer opportunity_outcome;
        public Integer program_type;
        public Integer research_type;
        public String  product_id ;
        public List<String> product_ids;
//        public List<rest_Contact> contact;
        public rest_Contact contact;

    }


}