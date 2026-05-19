/**
 * @description Agent action to generate and attach rate change notice documents to clinician contracts.
 * Takes accountId and contractId, gets contract IDs from Clinical_Rate_Change__c.PreviewClonedContractIds__c,
 * and calls GenerateLetterService.generateAndAttachLetter.
 */
global class GenerateAndAttachLetterAction {

    /**
     * @description Output wrapper for the invocable method. Extends RateChangeInvocableOutput with batchJobSubmitted.
     * success and message are redeclared because inherited @InvocableVariable are not returned by Salesforce.
     */
    global class InvocableOutput extends RateChangeInvocableOutput {
        @InvocableVariable(label='Success' description='Whether the operation completed successfully')
        public Boolean success;
        @InvocableVariable(label='Message' description='Status or error message')
        public String message;
        @InvocableVariable(label='Batch Job Submitted' description='Whether the document generation batch job was submitted')
        public Boolean batchJobSubmitted;
        @InvocableVariable(label='Batch Process Id' description='DocGenerationBatchProcess Id for monitoring letter generation')
        public String batchProcessId;
        @InvocableVariable(label='Async Job' description='Job monitor data for Clone/Sync/Letter jobs')
        public AsyncJobOutput asyncJob;
    }

    /**
     * @description Generates and attaches rate change notice documents to clinician contracts.
     * Contract IDs are read from Clinical_Rate_Change__c.PreviewClonedContractIds__c (set by Clone Contract action).
     * @param inputs List of RateChangeInvocableInput containing accountId and contractId.
     * @return List of InvocableOutput with success status.
     */
    @InvocableMethod(label='Generate And Attach Letter' description='Generates and attaches rate change notice documents to clinician contracts. Pass accountId and contractId from context.' category='Contract Management')
    global static List<InvocableOutput> generateAndAttachLetter(List<RateChangeInvocableInput> inputs) {
        List<InvocableOutput> outputs = new List<InvocableOutput>();
        InvocableOutput output = new InvocableOutput();

        RateChangeInvocableInput.ValidationResult validation = RateChangeInvocableInput.validateAccountAndContract(inputs);
        if (!validation.isValid) {
            output.success = false;
            output.batchJobSubmitted = false;
            output.message = validation.errorMessage;
            outputs.add(output);
            return outputs;
        }

        RateChangeInvocableInput input = validation.input;

        try {
            Clinical_Rate_Change__c crc = RateChangeQueryService.getOpenRateChange(input.accountId, input.contractId);

            if (crc == null) {
                output.success = false;
                output.batchJobSubmitted = false;
                output.message = 'No pending rate change found for this account and contract.';
                outputs.add(output);
                return outputs;
            }

            List<Id> contractIds = IdParsingUtil.parseCommaSeparatedIds(crc.PreviewClonedContractIds__c);

            if (contractIds.isEmpty()) {
                output.success = false;
                output.batchJobSubmitted = false;
                output.message = 'No contracts to generate letters for. Please run Clone Contract first.';
                outputs.add(output);
                return outputs;
            }

            GenerateLetterService.GenerateAndAttachLetterResult galResult = GenerateLetterService.generateAndAttachLetter(contractIds, new List<Clinical_Rate_Change__c>{ crc }, true);

            output.success = galResult.success;
            output.batchJobSubmitted = galResult.success;
            output.batchProcessId = galResult.batchProcessId != null ? String.valueOf(galResult.batchProcessId) : null;
            output.message = galResult.success
                ? 'Generating notice letters for ' + contractIds.size() + ' contract(s). You will be notified when complete.'
                : 'Could not start letter generation. Please try again.';
            if (galResult.success && galResult.batchProcessId != null) {
                output.asyncJob = new AsyncJobOutput();
                output.asyncJob.jobType = 'letter';
                output.asyncJob.batchProcessId = String.valueOf(galResult.batchProcessId);
                output.asyncJob.message = output.message;
                output.asyncJob.jobLabel = 'Generate Notice Letters';
            }

        } catch (Exception e) {
            output.success = false;
            output.batchJobSubmitted = false;
            output.message = 'Something went wrong. Please try again.';
        }

        outputs.add(output);
        return outputs;
    }
}