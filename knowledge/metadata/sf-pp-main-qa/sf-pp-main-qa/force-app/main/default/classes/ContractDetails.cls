/**
 * @description Invocable action to retrieve and format Contract details by contract number.
 * Returns account name, start date, status, and service line for agent workflows.
 */
public class ContractDetails {
    /**
     * @description Wrapper class for the input parameter of the invocable method.
     * Holds the Contract Number (or Name) to retrieve details for.
     */
    public class InvocableInput {
        @InvocableVariable(label='Contract Name' required=true)
        public String contractNumber;
    }

    /**
     * @description Wrapper class for the output response of the invocable method.
     * Holds the formatted string of the contract details and returned contract Id.
     */
    public class InvocableOutput {
        @InvocableVariable(label='Formatted contract Details')
        public String contractDetails;
        @InvocableVariable(label='selected ContractId')
        public String returnedContractId;
    }
    
    

    /**
     * @description Main invocable method that retrieves and formats Contract details by contract number.
     * @param inputs List of InvocableInput objects containing the Contract Number
     * @return List of InvocableOutput objects containing formatted contract details and returned contract Id
     */
    @InvocableMethod(label='Get Contract Details' description = 'displays Contract account name , Contract StartDate and Service line')
    public static List<InvocableOutput> getFormattedAccountDetails(List<InvocableInput> inputs) {
        List<InvocableOutput> outputs = new List<InvocableOutput>();
        try{
		// We expect only one input per invocation, so we process the first one.
        String contractNo = inputs[0].contractNumber;
        List<contract> contracts =[SELECT 
                                   Id,
                                   Account.Name, 
                                   contractNumber, 
                                   Account.Service_Line__r.Name, Status,
                                   StartDate from Contract 
                         		   WHERE contractNumber = :contractNo];
        if (contracts== Null && contracts[0].Id == null) {
            /*InvocableOutput errorOutput = new InvocableOutput();
            errorOutput.contractDetails = 'Error: No Contract ID was provided.';
            outputs.add(errorOutput);*/
            return outputs;
        }

        InvocableOutput output = new InvocableOutput();

        if (contracts.isEmpty()) {
            output.contractDetails = 'Could not find a matching account with that ID.';
        } else {
            // Get the first (and only) account from the list.
            Contract foundContract = contracts[0];

            // Build a nicely formatted string with the required fields.
            String formattedDetails = 'Contract Details: \n' +
                                      'Name: ' + foundContract.Account.Name + '\n' +
                                      'Start Date: ' + (foundContract.StartDate != null ? String.valueOf(foundContract.StartDate) : '') + '\n' +
                                      'Status: ' + (foundContract.Status != null ? String.valueOf(foundContract.Status) : '') + '\n' +
									  'Service Line: ' + (foundContract.Account.Service_Line__r.Name != null ? String.valueOf(foundContract.Account.Service_Line__r.Name) : '');
            output.contractDetails = formattedDetails;
            output.returnedContractId = contracts[0].Id;
        }
        outputs.add(output);            
        }Catch(Exception e){
            System.debug('Exception======>'+e.getLinenumber()+e.getMessage());
        }
        return outputs;
    }
}