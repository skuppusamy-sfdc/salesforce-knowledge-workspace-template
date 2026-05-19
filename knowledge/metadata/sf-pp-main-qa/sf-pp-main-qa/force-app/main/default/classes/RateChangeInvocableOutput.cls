/**
 * @description Base output wrapper for rate change invocable actions with success and message.
 * Extended by Clone Contract, Generate And Attach Letter, Get Contracts To Send, and Post Process Rate Change.
 * PendingRateChangeChecker uses a different output structure (hasPendingRun, formattedMessage, draftContractCount).
 */
public virtual with sharing class RateChangeInvocableOutput {
    @InvocableVariable(label='Success' description='Whether the operation completed successfully')
    public Boolean success;

    @InvocableVariable(label='Message' description='Status or error message')
    public String message;
}