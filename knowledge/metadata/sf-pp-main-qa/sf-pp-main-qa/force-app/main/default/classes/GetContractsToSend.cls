/**
 * @description Agent action to get contracts ready to send for an open Clinical_Rate_Change__c.
 * Returns only draft contracts that have Compensation Change Notice Letter attached.
 * Uses DocGenerationBatchProcessId__c to find contracts via DocumentGenerationProcess.
 */
public with sharing class GetContractsToSend {
    @TestVisible private static Boolean exceptionForTest = false;

    /**
     * @description Output wrapper for the invocable method. Extends RateChangeInvocableOutput with accountId, contractId, draftContracts.
     * success and message are redeclared because inherited @InvocableVariable are not returned by Salesforce.
     */
    public class InvocableOutput extends RateChangeInvocableOutput {
        @InvocableVariable(label='Success' description='Whether the operation completed successfully')
        public Boolean success;
        @InvocableVariable(label='Message' description='Status or error message')
        public String message;
        @InvocableVariable(label='Account Id' description='Service Account Id (Service_Account_ID__c)')
        public String accountId;
        @InvocableVariable(label='Contract Id' description='Client Contract Id (Contract_ID__c)')
        public String contractId;
        @InvocableVariable(label='Draft Contracts' description='List of draft contracts with Compensation notice letter attached')
        public List<DraftContractOutput> draftContracts;
    }

    /**
     * @description Finds Open Clinical_Rate_Change__c, gets contract IDs from DocumentGenerationProcess,
     * and returns only draft contracts that have Compensation Change Notice Letter attached.
     * @param inputs List of RateChangeInvocableInput containing accountId and contractId
     * @return List of InvocableOutput with contract details
     */
    @InvocableMethod(label='Get Contracts To Send' description='Returns draft contracts that have Compensation Change Notice Letter attached. Pass accountId and contractId from context.' category='Contract Management')
    public static List<InvocableOutput> getContractsToSend(List<RateChangeInvocableInput> inputs) {
        List<InvocableOutput> outputs = new List<InvocableOutput>();
        InvocableOutput output = new InvocableOutput();

        RateChangeInvocableInput.ValidationResult validation = RateChangeInvocableInput.validateAccountAndContract(inputs);
        if (!validation.isValid) {
            output.success = false;
            output.message = validation.errorMessage;
            output.draftContracts = new List<DraftContractOutput>();
            outputs.add(output);
            return outputs;
        }

        String accountId = validation.input.accountId;
        String contractId = validation.input.contractId;

        try {
            if (Test.isRunningTest() && exceptionForTest) {
                throw new CalloutException('test');
            }
            List<Id> contractIds = getContractIdsFromClinicalRateChange(accountId, contractId);

            if (contractIds == null || contractIds.isEmpty()) {
                output.success = false;
                output.message = 'No pending rate change found for this account and contract. Please run Clone Contract first to generate draft contracts.';
                output.draftContracts = new List<DraftContractOutput>();
                outputs.add(output);
                return outputs;
            }

            List<Contract> draftContracts = [
                SELECT Id, ContractNumber, StartDate, Account.Name
                FROM Contract
                WHERE Id IN :contractIds
                AND Status = 'Draft'
                ORDER BY Account.Name, ContractNumber
            ];

            Set<Id> contractsWithLetter = RateChangeContractUtil.getContractsWithCompensationNoticeLetter(draftContracts);
            List<DraftContractOutput> draftOutputs = new List<DraftContractOutput>();

            for (Contract c : draftContracts) {
                if (!contractsWithLetter.contains(c.Id)) {
                    continue;
                }
                DraftContractOutput dco = new DraftContractOutput();
                dco.accountId = accountId;
                dco.clientContractId = contractId;
                dco.contractId = c.Id != null ? String.valueOf(c.Id) : null;
                dco.contractNumber = c.ContractNumber;
                dco.startDate = c.StartDate != null ? String.valueOf(c.StartDate) : null;
                dco.clinicianName = c.Account != null ? c.Account.Name : null;
                draftOutputs.add(dco);
            }

            output.success = true;
            output.message = 'Found ' + draftOutputs.size() + ' contract(s) ready to send.';
            output.accountId = accountId;
            output.contractId = contractId;
            output.draftContracts = draftOutputs;

        } catch (Exception e) {
            output.success = false;
            output.message = 'Something went wrong. Please try again.';
            output.draftContracts = new List<DraftContractOutput>();
        }

        outputs.add(output);
        return outputs;
    }

    /**
     * @description Gets contract IDs from Clinical_Rate_Change__c and DocumentGenerationProcess (same logic as PostProcessRateChangeAction).
     */
    private static List<Id> getContractIdsFromClinicalRateChange(String accountId, String contractId) {
        Clinical_Rate_Change__c crc = RateChangeQueryService.getOpenRateChange(accountId, contractId);
        if (crc == null) {
            return null;
        }

        Id docGenerationBatchProcessId = crc.DocGenerationBatchProcessId__c;
        if (docGenerationBatchProcessId == null) {
            return null;
        }

        List<DocumentGenerationProcess> dgps = [
            SELECT ReferenceObject
            FROM DocumentGenerationProcess
            WHERE DocGenerationBatchProcessId = :docGenerationBatchProcessId
        ];

        if (dgps == null || dgps.isEmpty()) {
            return null;
        }

        List<Id> contractIds = new List<Id>();
        for (DocumentGenerationProcess dgp : dgps) {
            if (dgp.ReferenceObject != null) {
                contractIds.add(dgp.ReferenceObject);
            }
        }

        return contractIds.isEmpty() ? null : contractIds;
    }
}