/**
 * @description Shared input wrapper for rate change invocable actions.
 * Used by Clone Contract, Generate And Attach Letter, Get Contracts To Send,
 * Post Process Rate Change, and Check Pending Rate Change actions.
 * Centralizes accountId/contractId validation.
 */
global with sharing class RateChangeInvocableInput {
    /** Error message when inputs are null, empty, or missing accountId/contractId. */
    public static final String ERROR_SELECT_ACCOUNT_AND_CONTRACT = 'Please select a service account and contract.';

    @InvocableVariable(label='Account Id' description='Service Account Id (Service_Account_ID__c)' required=true)
    public String accountId;

    @InvocableVariable(label='Contract Id' description='Client Contract Id (Contract_ID__c)' required=true)
    public String contractId;

    /**
     * @description Validation result for rate change input.
     */
    public class ValidationResult {
        public Boolean isValid;
        public RateChangeInvocableInput input;
        public String errorMessage;
    }

    /**
     * @description Validates that inputs list has at least one element with non-blank accountId and contractId.
     * @param inputs List of RateChangeInvocableInput from invocable method
     * @return ValidationResult with isValid, input, and errorMessage
     */
    public static ValidationResult validateAccountAndContract(List<RateChangeInvocableInput> inputs) {
        ValidationResult result = new ValidationResult();
        result.isValid = false;
        result.errorMessage = ERROR_SELECT_ACCOUNT_AND_CONTRACT;

        if (inputs == null || inputs.isEmpty()) {
            return result;
        }

        RateChangeInvocableInput input = inputs[0];
        if (String.isBlank(input.accountId) || String.isBlank(input.contractId)) {
            return result;
        }

        result.isValid = true;
        result.input = input;
        result.errorMessage = null;
        return result;
    }
}