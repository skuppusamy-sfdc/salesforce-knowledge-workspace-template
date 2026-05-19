public class RateChangeFinalProcessing {
    @InvocableMethod(
        label='Final Processing' 
        description='Process of final records after displaying message \'Your request has been submitted\' to user'
        category='File Management'
    )
    public static List<FinalOutput> finalProcessRateChange(List<FinalInput> requests) {
        List<FinalOutput> lstFinalOut = new List<FinalOutput>();
        List<Clinical_Rate_Change__c> lstAgData = new List<Clinical_Rate_Change__c>();
        List<Id> returnedContractIds = new List<Id>();
        List<String> allSelectedIdsListString;
        list<string> PreviewClonedContractIds = new list<string>();
        
        FinalInput request = requests[0];
        
        lstAgData = [SELECT id,
                     user_selected_IDs__c,
                     Service_Account_ID__c ,
                     PreviewClonedContractIds__c,
                     Non_Processed_Clinical_Ids__c,
                     Contract_ID__c,
                     CreatedById
                     FROM Clinical_Rate_Change__c 
                     WHERE  Service_Account_ID__c= :request.accountId and Contract_ID__c = :request.contractId and Status__c = 'Open'];
        
        if(lstAgData!=NULL && lstAgData.size()>0){
            if(lstAgData[0].Non_Processed_Clinical_Ids__c !=NULL && String.ISNOTBlank(lstAgData[0].Non_Processed_Clinical_Ids__c)){
            Object jsonResult = JSON.deserializeUntyped(lstAgData[0].Non_Processed_Clinical_Ids__c);
            allSelectedIdsListString =  fileToLinkGenerator.extractSelectedClinicianIds(jsonResult);
            }
        }
        
        //converting List<String> allSelectedIdsListString to List<Id> allSelectedIdsList
        List<Id> allSelectedIdsList = new List<Id>();
        String userSelectedContractId;
        if(allSelectedIdsListString!=null && allSelectedIdsListString.size()>0){
            for (String idStr : allSelectedIdsListString) {
                    if (String.isNotBlank(idStr)) {
                        allSelectedIdsList.add((Id)idStr);
                    }
            }
        }
		 
        if(!lstAgData.isEmpty())
        userSelectedContractId = lstAgData[0].Contract_ID__c; 
        
        // if userConsent is True 
        if(request.userConsent ){   
            RateChangeService rcsObj = new RateChangeService();
            
            if(lstAgData.size()>0){
                returnedContractIds  = rcsObj.execute(allSelectedIdsList,False,userSelectedContractId,lstAgData);
            } 
        }
        
        FinalOutput finalOut = new FinalOutput();
        finalOut.message = 'Successfully executed';
        finalOut.isSuccess = TRUE;
        lstFinalOut.add(finalOut);
        return lstFinalOut;
    }
    
    public class FinalInput{
        @InvocableVariable(label='user consent' description='user consent after generate preview link is displayed' required=true)
        public Boolean userConsent;
        
        @InvocableVariable(label='selected account id' description='id of the selected account record id' required=true)
        public String accountId;
        
        @InvocableVariable(label='selected contract id' description='id of the selected contract record id' required=true)
        public String contractId;
    }
    public class FinalOutput{
        @InvocableVariable(label='message' description='message for the success or Error' required=true)
        public String message;
        @InvocableVariable(label='is Success' description='Boolean variable if request was success or failed' required=true)
        public Boolean isSuccess;
    }
    
}