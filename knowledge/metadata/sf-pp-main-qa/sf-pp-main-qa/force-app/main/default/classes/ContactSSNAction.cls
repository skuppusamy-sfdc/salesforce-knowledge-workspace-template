public class ContactSSNAction {
    
    @InvocableMethod(label='Get_Last_Four_Digits_SSN')
    public static List<String> getLastFourDigitsSSN(List<Id> conIds) {
        List<String> conSSNOutputs = new List<String>();
        String conSSNOutput;
        for (Contact con : [SELECT Id,SSN_Encrypted__c FROM Contact WHERE Id IN :conIds]){
            String conSSNInput = con.SSN_Encrypted__c;
            if (String.isNotBlank(conSSNInput)){
        		conSSNOutput = conSSNInput.right(4);
            	conSSNOutputs.add(conSSNOutput);
            } else {
                conSSNOutputs.add(conSSNOutput);
            }
        }
        return conSSNOutputs;
    }
}