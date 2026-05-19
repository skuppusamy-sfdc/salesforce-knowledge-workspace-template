/**
 * @description Invocable action to retrieve and format Account details for agent workflows.
 * Returns Name, Global Facility ID, and Service Line for the selected Account.
 */
public with sharing class AccountDetails {
    /**
     * @description The wrapper class for the input parameter of the invocable method.
     * It holds the ID of the Account to retrieve details for.
     */
    public class InvocableInput {
        @InvocableVariable(label='Account Id selected by the user' required=true)
        public String accountId;
    }

    /**
     * @description The wrapper class for the output response of the invocable method.
     * It holds the formatted string of the account's details.
     */
    public class InvocableOutput {
        @InvocableVariable(label='Formatted Details')
        public String details;
        @InvocableVariable(label='selected AccountId')
        public String returnedAccountId;
    }
    
     

    /**
     * @description Main invocable method that retrieves and formats the Account details.
     * @param inputs A list of InvocableInput objects containing the Account ID.
     * @return A list of InvocableOutput objects containing the formatted details.
     */
    @InvocableMethod(label='Get Account Details' description='returns the details such as Name,Service_Line__c, GlobalFacilityID__c')
    public static List<InvocableOutput> getFormattedAccountDetails(List<InvocableInput> inputs) {
        
        List<InvocableOutput> outputs = new List<InvocableOutput>();
        List<Account> accounts =[SELECT Id, Name,Service_Line__r.Name, Global_Facility_ID__c  from Account 
                         WHERE Id = :inputs[0].AccountId];
        if(accounts!= NULL && !accounts.isEmpty()){
            Account foundAccount = accounts[0];
        	String formattedDetails = 'Account Details: \n' +
                                      'Name: ' + foundAccount.Name + '\n' +
                                      'Global AccountID: ' + (foundAccount.Global_Facility_ID__c!=null ? foundAccount.Global_Facility_ID__c : null) + '\n' +
									  'Service Line: ' + (foundAccount.Service_Line__r.Name != null ? String.valueOf(foundAccount.Service_Line__r.Name) : '');
            InvocableOutput output = new InvocableOutput();
            output.details = formattedDetails;
            output.returnedAccountId = accounts[0].Id;
            outputs.add(output);
        }
        return outputs;
    }
         
}