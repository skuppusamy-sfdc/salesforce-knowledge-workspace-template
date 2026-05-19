public class TruSalesAppSettingsSave implements Queueable
{
    //TruSales_App_Settings__c settingsStatic{get;set;}
    Discovery_Bots_Settings__c settingsStatic {get;set;}

    List<TruSalesAppSettingsController.Collector> collectors_idsStatic {get;set;}
    List<List<User>> UsersFieldsListStatic {get;set;}
    List<TruSales_Product_Map_Item__c> productMapItemsStatic {get;set;}
    String settingsStaticString;
    String usersFieldsListStaticString;
    String initiativeIdStatic;
    String collectors_idsStaticString;
    String outcomeTypesMapStatic;
    String opportunityTypesMapStatic;
    String productMapItemsStaticString;
    String selectedSalesStagesString;


    public TruSalesAppSettingsSave(String settingsStaticString, String usersFieldsListStaticString, String initiativeIdStatic, String collectors_idsStaticString, String outcomeTypesMapStatic, String opportunityTypesMapStatic,String productMapItemsStaticString, String selectedSalesStagesString)
    {
        this.settingsStaticString = settingsStaticString;
        this.usersFieldsListStaticString = usersFieldsListStaticString;
        this.initiativeIdStatic = initiativeIdStatic;
        this.collectors_idsStaticString = collectors_idsStaticString;
        this.outcomeTypesMapStatic = outcomeTypesMapStatic;
        this.opportunityTypesMapStatic = opportunityTypesMapStatic;
        this.productMapItemsStaticString = productMapItemsStaticString;
        this.selectedSalesStagesString = selectedSalesStagesString;

    }

    public void execute(QueueableContext context)
    {
        List<User> userList = new List<User>();

        //settingsStatic = (TruSales_App_Settings__c) JSON.deserialize(settingsStaticString, TruSales_App_Settings__c.class);
        settingsStatic = (Discovery_Bots_Settings__c) JSON.deserialize(settingsStaticString, Discovery_Bots_Settings__c.class);
        collectors_idsStatic = (List<TruSalesAppSettingsController.Collector>) JSON.deserialize(collectors_idsStaticString, List<TruSalesAppSettingsController.Collector>.class);
        UsersFieldsListStatic =(List<List<User>>) JSON.deserialize(usersFieldsListStaticString,List<List<User>>.class);
        productMapItemsStatic = (List<TruSales_Product_Map_Item__c> ) JSON.deserialize(productMapItemsStaticString,List<TruSales_Product_Map_Item__c>.class);


        if (settingsStatic.Active_All_Users__c) {
            TruSalesAppSettingsController.clearPermissionSetAssignment();
            for (List<User> UsersFieldsList : UsersFieldsListStatic) {
                for (User us : UsersFieldsList) {
                    if (us.Feedback_Request_Allowed__c == false) {
                        us.Feedback_Request_Allowed__c = true;
                        userList.add(us);
                    }
                }
            }
        }
        else {

            if(UsersFieldsListStatic != null)
            {
                for (List<User> UsersList : UsersFieldsListStatic) {
                    for (User us : UsersList) {
                        userList.add(us);
                    }
                }
            }
        }

        if(!userList.isEmpty())
        {

            Database.update(userList, false);

        }


        if (initiativeIdStatic.equals('Error')) initiativeIdStatic = '';
        settingsStatic.Collector_id__c = initiativeIdStatic;
        for (TruSalesAppSettingsController.Collector collector : collectors_idsStatic) {
            if (initiativeIdStatic == collector.collector_id) {
                settingsStatic.Initiative_id__c = collector.initiative_id;
                settingsStatic.Survey_Collector_Email__c = collector.from_email;
                settingsStatic.Survey_Collector_Name__c = collector.collector_name;
            }
        }

        // Save outcome types map
        String outcomeTypesMapField = 'Outcome_Types_Map';
        Integer index = 1;
        while (settingsStatic.get(outcomeTypesMapField + '_' + index + '__c') != null) {
            settingsStatic.put(outcomeTypesMapField + '_' + index + '__c', null);
            index++;

        }

        index = 1;
        Matcher matcher = Pattern.compile('(.{1,255})').matcher(outcomeTypesMapStatic);
        while (matcher.find()) {
            settingsStatic.put(outcomeTypesMapField + '_' + index + '__c', matcher.group());
            index++;
        }

        // Save opportunity types map
        String opportunityTypesMapField = 'Opportunity_Types_Map';
        index = 1;
        while (settingsStatic.get(opportunityTypesMapField + '_' + index + '__c') != null) {
            settingsStatic.put(opportunityTypesMapField + '_' + index + '__c', null);
            index++;

        }

        index = 1;
        matcher = Pattern.compile('(.{1,255})').matcher(opportunityTypesMapStatic);
        while (matcher.find()) {
            settingsStatic.put(opportunityTypesMapField + '_' + index + '__c', matcher.group());
            index++;

        }

        settingsStatic.Enable_Sales_Stages_Values__c = selectedSalesStagesString;


        upsert settingsStatic;

    }
}