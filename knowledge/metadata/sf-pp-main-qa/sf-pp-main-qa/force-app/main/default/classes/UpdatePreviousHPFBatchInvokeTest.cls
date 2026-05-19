@IsTest
public class UpdatePreviousHPFBatchInvokeTest {

    @IsTest
    static void testRunprocessHPFupdatesBactchClassBatch() {


        Test.startTest();
            // Invoke the Invocable Method
            UpdatePreviousHPFBatchInvoke.runprocessHPFupdatesBactchClassBatch();
        Test.stopTest();

        // Verify a batch job was enqueued
        List<AsyncApexJob> jobs = [
            SELECT Id, Status, JobType
            FROM AsyncApexJob
            WHERE JobType = 'BatchApex'
            ORDER BY CreatedDate DESC
            LIMIT 1
        ];

        System.assertEquals(1, jobs.size(), 'Batch job should be created');
        System.assertEquals('BatchApex', jobs[0].JobType);
    }
}