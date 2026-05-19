/**
 * @description Skeleton invocable action for agents to clone contracts.
 * Takes accountId and contractId as input.
 */
global class CloneContractAction {

    @TestVisible private static Boolean cloneContractException = false;

    /**
     * @description Output wrapper for the invocable method. Extends RateChangeInvocableOutput with jobId.
     * success and message are redeclared here because inherited @InvocableVariable are not returned by Salesforce.
     */
    public class InvocableOutput extends RateChangeInvocableOutput {
        @InvocableVariable(label='Success' description='Whether the operation completed successfully')
        public Boolean success;
        @InvocableVariable(label='Message' description='Status or error message')
        public String message;
        @InvocableVariable(label='Job Id' description='The AsyncApexJob Id of the queued clone job')
        public String jobId;
        @InvocableVariable(label='Async Job' description='Job monitor data for progress display')
        public AsyncJobOutput asyncJob;
    }

    /**
     * @description Holds prepared inputs for RateChangeQueueable (CLONE).
     */
    private class CloneQueueableInput {
        List<Id> clinicianIds;
        String clientContractId;
        List<Clinical_Rate_Change__c> clinicalRateChangeRec;
    }

    /**
     * @description Queues a job to clone the specified contract for the given account.
     * @param inputs List of RateChangeInvocableInput containing accountId and contractId.
     * @return List of InvocableOutput with success status and job Id.
     */
    @InvocableMethod(label='Clone Contract' description='Queues a job to clone contracts for selected clinicians. Pass accountId and contractId from context.' category='Contract Management')
    public static List<InvocableOutput> cloneContract(List<RateChangeInvocableInput> inputs) {
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
            CloneQueueableInput queueableInput = prepareCloneQueueableInput(input.accountId, input.contractId);

            if (queueableInput == null) {
                output.success = false;
                output.message = 'No pending rate change or clinicians found for this account and contract. Please select clinicians first.';
                output.jobId = null;
                outputs.add(output);
                return outputs;
            }

            if (Test.isRunningTest() && cloneContractException) {
                throw new CalloutException('test');
            }
            Id jobId = System.enqueueJob(new RateChangeQueueable(
                queueableInput.clinicianIds,
                queueableInput.clientContractId,
                queueableInput.clinicalRateChangeRec
            ));

            output.success = true;
            output.message = 'Contract cloning has started. You will be notified when it completes.';
            output.jobId = String.valueOf(jobId);
            output.asyncJob = new AsyncJobOutput();
            output.asyncJob.jobType = 'clone';
            output.asyncJob.jobId = String.valueOf(jobId);
            output.asyncJob.message = output.message;
            output.asyncJob.jobLabel = 'Clone Contracts';

        } catch (Exception e) {
            output.success = false;
            output.message = 'Something went wrong. Please try again.';
            output.jobId = null;
        }

        outputs.add(output);
        return outputs;
    }

    /**
     * @description Prepares inputs for RateChangeQueueable (CLONE) from Clinical_Rate_Change__c.
     * @param accountId Service Account Id (Service_Account_ID__c)
     * @param contractId Client Contract Id (Contract_ID__c)
     * @return CloneQueueableInput or null if no records found or clinicianIds empty
     */
    private static CloneQueueableInput prepareCloneQueueableInput(String accountId, String contractId) {
        List<Clinical_Rate_Change__c> lstAgData = RateChangeQueryService.getOpenRateChanges(accountId, contractId);
        if (lstAgData == null || lstAgData.isEmpty()) {
            return null;
        }

        List<String> clinicianIdStrings = new List<String>();
        if (lstAgData[0].user_selected_IDs__c != null && String.isNotBlank(lstAgData[0].user_selected_IDs__c)) {
            Object jsonResult = JSON.deserializeUntyped(lstAgData[0].user_selected_IDs__c);
            clinicianIdStrings = IdParsingUtil.extractSelectedClinicianIds(jsonResult);
        }

        List<Id> clinicianIds = new List<Id>();
        if (clinicianIdStrings != null && !clinicianIdStrings.isEmpty()) {
            for (String idStr : clinicianIdStrings) {
                if (String.isNotBlank(idStr)) {
                    clinicianIds.add((Id) idStr);
                }
            }
        }

        if (clinicianIds.isEmpty()) {
            return null;
        }

        CloneQueueableInput result = new CloneQueueableInput();
        result.clinicianIds = clinicianIds;
        result.clientContractId = lstAgData[0].Contract_ID__c;
        result.clinicalRateChangeRec = lstAgData;
        return result;
    }

}