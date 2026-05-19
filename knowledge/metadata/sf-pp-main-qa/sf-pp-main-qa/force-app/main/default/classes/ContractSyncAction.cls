/**
 * @description Invocable action to sync clinician contracts with practice organization data.
 * Uses contract IDs from Clinical_Rate_Change__c.PreviewClonedContractIds__c (set by Clone Contract)
 * and invokes ContractSyncRemoteAction for each in a bulkified queueable.
 */
public with sharing class ContractSyncAction {
    @TestVisible private static Boolean exceptionForTest = false;

    /**
     * @description Output wrapper for the invocable method. Extends RateChangeInvocableOutput with jobId.
     * success and message are redeclared because inherited @InvocableVariable are not returned by Salesforce.
     */
    public class InvocableOutput extends RateChangeInvocableOutput {
        @InvocableVariable(label='Success' description='Whether the operation completed successfully')
        public Boolean success;
        @InvocableVariable(label='Message' description='Status or error message')
        public String message;
        @InvocableVariable(label='Job Id' description='The AsyncApexJob Id of the queued sync job')
        public String jobId;
        @InvocableVariable(label='Async Job' description='Job monitor data for progress display')
        public AsyncJobOutput asyncJob;
    }

    /**
     * @description Queues a job to sync clinician contracts for the given account and contract.
     * Gets contract IDs from Clinical_Rate_Change__c.PreviewClonedContractIds__c (populated by Clone Contract).
     * @param inputs List of RateChangeInvocableInput containing accountId and contractId
     * @return List of InvocableOutput with success status and job Id
     */
    @InvocableMethod(label='Sync Clinician Contracts' description='Syncs contracts from Clinical_Rate_Change__c.PreviewClonedContractIds__c. Pass accountId and contractId from context.' category='Contract Management')
    public static List<InvocableOutput> syncContracts(List<RateChangeInvocableInput> inputs) {
        List<InvocableOutput> outputs = new List<InvocableOutput>();
        InvocableOutput output = new InvocableOutput();

        RateChangeInvocableInput.ValidationResult validation = RateChangeInvocableInput.validateAccountAndContract(inputs);
        if (!validation.isValid) {
            output.success = false;
            output.message = validation.errorMessage;
            outputs.add(output);
            return outputs;
        }

        RateChangeInvocableInput input = validation.input;

        try {
            if (Test.isRunningTest() && exceptionForTest) {
                throw new CalloutException('test');
            }
            ContractIdsAndCrc result = getContractIdsFromPreview(input.accountId, input.contractId);

            if (result == null || result.contractIds == null || result.contractIds.isEmpty()) {
                output.success = false;
                output.message = 'No contracts found to sync. Please run Clone Contract first to create the contracts you want to sync.';
                output.jobId = null;
                outputs.add(output);
                return outputs;
            }

            Id jobId = System.enqueueJob(new RateChangeQueueable(result.contractIds, result.crcId));

            output.success = true;
            output.message = 'Contract sync has started for ' + result.contractIds.size() + ' contract(s).';
            output.jobId = String.valueOf(jobId);
            output.asyncJob = new AsyncJobOutput();
            output.asyncJob.jobType = 'sync';
            output.asyncJob.jobId = String.valueOf(jobId);
            output.asyncJob.message = output.message;
            output.asyncJob.jobLabel = 'Sync Clinician Contracts';

        } catch (Exception e) {
            output.success = false;
            output.message = 'We couldn\'t start the contract sync. Please try again.';
            output.jobId = null;
        }

        outputs.add(output);
        return outputs;
    }

    /**
     * @description Result of getContractIdsFromPreview.
     */
    private class ContractIdsAndCrc {
        private List<Id> contractIds;
        private Id crcId;
    }

    /**
     * @description Gets contract IDs from Clinical_Rate_Change__c.PreviewClonedContractIds__c.
     * @param accountId Service Account Id (Service_Account_ID__c)
     * @param contractId Client Contract Id (Contract_ID__c)
     * @return ContractIdsAndCrc with contractIds and crcId, or null if none found
     */
    private static ContractIdsAndCrc getContractIdsFromPreview(String accountId, String contractId) {
        Clinical_Rate_Change__c crc = RateChangeQueryService.getOpenRateChange(accountId, contractId);
        if (crc == null || String.isBlank(crc.PreviewClonedContractIds__c)) {
            return null;
        }
        ContractIdsAndCrc result = new ContractIdsAndCrc();
        result.contractIds = IdParsingUtil.parseCommaSeparatedIds(crc.PreviewClonedContractIds__c);
        result.crcId = crc.Id;
        return result.contractIds.isEmpty() ? null : result;
    }
}