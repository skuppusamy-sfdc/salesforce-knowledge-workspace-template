/**
 * @description Output for async job monitoring. Used by Clone Contract, Contract Sync,
 * and Generate And Attach Letter actions. Rendered by jobMonitor LWC.
 */
public with sharing class AsyncJobOutput {
    @InvocableVariable(label='Job Type' description='clone | sync | letter')
    public String jobType;
    @InvocableVariable(label='Job Id' description='AsyncApexJob Id for clone/sync')
    public String jobId;
    @InvocableVariable(label='Batch Process Id' description='DocGenerationBatchProcess Id for letter')
    public String batchProcessId;
    @InvocableVariable(label='Message' description='Status message')
    public String message;
    @InvocableVariable(label='Job Label' description='Display label for the job')
    public String jobLabel;
}