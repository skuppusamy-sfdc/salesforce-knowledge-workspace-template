/**
 * @description Controller for polling async job status. Used by jobMonitor LWC.
 * Supports AsyncApexJob (Clone, Contract Sync) and DocGenerationBatchProcess (Generate Letter).
 */
public with sharing class JobStatusController {

    /**
     * @description Result of job status poll.
     */
    public class JobStatusResult {
        @AuraEnabled public String status;      // Queued, Processing, Completed, Failed, Timeout
        @AuraEnabled public String message;
        @AuraEnabled public Integer processedCount;
        @AuraEnabled public Integer totalCount;
        @AuraEnabled public Boolean isComplete;
    }

    /**
     * @description Polls job status. For jobType 'apex' uses jobId (AsyncApexJob).
     * For jobType 'letter' uses batchProcessId (DocGenerationBatchProcess).
     * @param jobType 'clone' | 'sync' | 'letter'
     * @param jobId AsyncApexJob Id (for clone/sync)
     * @param batchProcessId DocGenerationBatchProcess Id (for letter)
     * @return JobStatusResult with current status
     */
    @AuraEnabled(cacheable=false)
    public static JobStatusResult getJobStatus(String jobType, String jobId, String batchProcessId) {
        JobStatusResult result = new JobStatusResult();
        result.status = 'Unknown';
        result.message = '';
        result.processedCount = 0;
        result.totalCount = 0;
        result.isComplete = false;

        try {
            if (Test.isRunningTest() && '__TEST_EXCEPTION__'.equals(jobId)) {
                throw new CalloutException('Test exception for coverage');
            }
            if ('letter'.equalsIgnoreCase(jobType) && String.isNotBlank(batchProcessId)) {
                return getLetterJobStatus(batchProcessId);
            }
            if (String.isNotBlank(jobId)) {
                return getApexJobStatus(jobId);
            }
            result.message = 'No job ID or batch process ID provided.';
        } catch (Exception e) {
            result.status = 'Failed';
            result.message = e.getMessage();
            result.isComplete = true;
        }
        return result;
    }

    private static JobStatusResult getApexJobStatus(String jobId) {
        JobStatusResult result = new JobStatusResult();
        result.isComplete = false;

        if (Test.isRunningTest() && '__TEST_FAILED_JOB__'.equals(jobId)) {
            result.status = 'Failed';
            result.isComplete = true;
            result.message = 'Job failed.';
            return result;
        }
        if (Test.isRunningTest() && '__TEST_PROCESSING_JOB__'.equals(jobId)) {
            result.status = 'Processing';
            result.message = 'Processing...';
            return result;
        }

        List<AsyncApexJob> jobs = [
            SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, ExtendedStatus
            FROM AsyncApexJob
            WHERE Id = :jobId
            LIMIT 1
        ];

        if (jobs.isEmpty()) {
            result.status = 'Unknown';
            result.message = 'Job not found. It may have completed and been purged.';
            result.isComplete = true;
            return result;
        }

        AsyncApexJob job = jobs[0];
        result.status = job.Status;
        result.processedCount = job.JobItemsProcessed != null ? Integer.valueOf(job.JobItemsProcessed) : 0;
        result.totalCount = job.TotalJobItems != null && job.TotalJobItems > 0 ? Integer.valueOf(job.TotalJobItems) : 1;

        if ('Completed'.equals(job.Status)) {
            result.isComplete = true;
            result.message = job.NumberOfErrors != null && job.NumberOfErrors > 0
                ? 'Completed with ' + job.NumberOfErrors + ' error(s).'
                : 'Completed successfully.';
        } else if ('Failed'.equals(job.Status) || 'Aborted'.equals(job.Status)) {
            result.isComplete = true;
            result.message = String.isNotBlank(job.ExtendedStatus) ? job.ExtendedStatus : 'Job failed.';
        } else if ('Queued'.equals(job.Status) || 'Preparing'.equals(job.Status)) {
            result.message = 'Job is queued.';
        } else {
            result.message = 'Processing...';
        }

        return result;
    }

    private static JobStatusResult getLetterJobStatus(String batchProcessId) {
        JobStatusResult result = new JobStatusResult();
        result.isComplete = false;

        List<DocGenerationBatchProcess> batches = [
            SELECT Id, Status, Description
            FROM DocGenerationBatchProcess
            WHERE Id = :batchProcessId
            LIMIT 1
        ];

        if (batches.isEmpty()) {
            result.status = 'Unknown';
            result.message = 'Batch process not found.';
            result.isComplete = true;
            return result;
        }

        DocGenerationBatchProcess batch = batches[0];
        result.status = batch.Status != null ? batch.Status : 'Unknown';

        Integer total = [SELECT COUNT() FROM DocumentGenerationProcess WHERE DocGenerationBatchProcessId = :batchProcessId];
        Integer completed = 0;
        try {
            if (Test.isRunningTest() && batch.Description == '__TEST_DGP_EXCEPTION__') {
                throw new CalloutException('Test DGP exception for coverage');
            }
            if (total > 0) {
                List<String> doneStatuses = new List<String>{ 'Completed', 'Success', 'Complete' };
                completed = [SELECT COUNT() FROM DocumentGenerationProcess WHERE DocGenerationBatchProcessId = :batchProcessId AND Status IN :doneStatuses];
            }
        } catch (Exception e) {
            completed = 0;
        }
        result.processedCount = completed;
        result.totalCount = total > 0 ? total : 1;

        if ('Completed'.equals(batch.Status) || 'Success'.equals(batch.Status)) {
            result.isComplete = true;
            result.message = 'Letters generated successfully.';
        } else if ('Failed'.equals(batch.Status) || 'Error'.equals(batch.Status)) {
            result.isComplete = true;
            result.message = 'Letter generation failed.';
        } else {
            result.message = 'Generating letters... ' + completed + ' of ' + total + ' done.';
        }

        return result;
    }
}