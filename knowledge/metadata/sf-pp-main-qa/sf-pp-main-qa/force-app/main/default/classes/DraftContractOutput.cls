/**
 * @description Output wrapper for a single draft contract.
 * Used by GetContractsToSend and draftContractOutput Lightning type.
 */
public with sharing class DraftContractOutput {
    @InvocableVariable(label='Account Id' description='Service Account Id for post-processing')
    public String accountId;
    @InvocableVariable(label='Client Contract Id' description='Clinical_Rate_Change__c.Contract_ID__c for post-processing')
    public String clientContractId;
    @InvocableVariable(label='Contract Id')
    public String contractId;
    @InvocableVariable(label='Contract Number')
    public String contractNumber;
    @InvocableVariable(label='Start Date')
    public String startDate;
    @InvocableVariable(label='Clinician Name')
    public String clinicianName;
}