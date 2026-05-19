public without sharing class GetPOContractByClinicianStartDate {
    
    
    public static Map<String, Object> findPOContracts(Map<string, object> inputs) {
        Map<String, Object> outputs = new Map<String, Object>();
        
        Input inp = new Input();
        inp.hpfAccountIds = (List<string>) inputs.get('hpfAccountIds'); 
        inp.clinicianContractStartDate = (String) inputs.get('clinicianContractStartDate');
        
        Date startDate = inp.clinicianContractStartDate != null
            ? Date.valueof(inp.clinicianContractStartDate)
            : Date.today();
        
        Set<String> validStatuses = new Set<String>{ 'Executed', 'Superseded' };
            
            try {
                List<Contract> contracts = [
                    SELECT Id, ContractNumber, AccountId, StartDate, EndDate, Status
                    FROM Contract
                    WHERE AccountId IN :inp.hpfAccountIds
                    AND RecordType.Name = 'Practice Operations'
                    AND Status IN :validStatuses
                    AND StartDate <= :startDate
                    AND (EndDate >= :startDate OR EndDate = NULL)
                ];
                
                Map<Id, Contract> latestByAccount = new Map<Id, Contract>();
                for (Contract c : contracts) {
                    if (!latestByAccount.containsKey(c.AccountId)) {
                        latestByAccount.put(c.AccountId, c);
                        continue;
                    }
                    Contract existing = latestByAccount.get(c.AccountId);
                    if (c.StartDate > existing.StartDate) {
                        latestByAccount.put(c.AccountId, c);
                    } else if (c.StartDate == existing.StartDate
                               && existing.Status == 'Superseded'
                               && c.Status == 'Executed') {
                                   latestByAccount.put(c.AccountId, c);
                               }
                }
                List<POContractResult> poContracts = new List<POContractResult>();
                for (Id accountId : inp.hpfAccountIds) {
                    POContractResult result = new POContractResult();
                    result.accountId = accountId;
                    if (latestByAccount.containsKey(accountId)) {
                        Contract c = latestByAccount.get(accountId);
                        result.contractId = c.Id;
                        result.contractNumber = c.ContractNumber;
                        result.startDate = c.StartDate;
                        result.endDate = c.EndDate;
                        result.status = c.Status;
                        result.found = true;
                    } else {
                        result.found = false;
                    }
                    poContracts.add(result);
                }
                outputs.put('poContracts',JSON.serialize(poContracts));
                outputs.put('success',true);
                
            } catch (Exception e) {
                outputs.put('success',false);
                outputs.put('errorMessage','Error querying PO Contracts: ' + e.getMessage() +' '+e.getStackTraceString());
            }
        
        return outputs;
    }
    
    public class Input {
        @InvocableVariable(required=true description='List of HPF Account IDs (service/facility accounts) to find PO Contracts for')
        public List<string> hpfAccountIds;
        
        @InvocableVariable(required=false description='Clinician Contract Start Date used for date range filtering. Defaults to today if not provided.')
        public String clinicianContractStartDate;
    }
    
    
    public class POContractResult {
        @InvocableVariable(description='The HPF Account ID this result corresponds to')
        public Id accountId;
        @InvocableVariable(description='True if a matching PO Contract was found')
        public Boolean found;
        @InvocableVariable(description='Contract record Id of the matching PO Contract')
        public Id contractId;
        @InvocableVariable(description='Contract Number of the matching PO Contract')
        public String contractNumber;
        @InvocableVariable(description='Start Date of the PO Contract')
        public Date startDate;
        @InvocableVariable(description='End Date of the PO Contract (may be null for open-ended)')
        public Date endDate;
        @InvocableVariable(description='Status of the PO Contract (Executed or Superseded)')
        public String status;
    }
}