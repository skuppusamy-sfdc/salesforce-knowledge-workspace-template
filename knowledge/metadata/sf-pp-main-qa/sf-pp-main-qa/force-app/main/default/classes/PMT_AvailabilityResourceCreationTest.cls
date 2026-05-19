/**
 * A Test class for scheduler class : PMT_AvailabilityResourceCreation
 * 
 * @author Salesforce Services
 * @version 1.0
 * @since 2025-05-23
 */
@isTest
private class PMT_AvailabilityResourceCreationTest {

    @isTest
    static void testScheduledExecution() {
        // Set a CRON expression for 11 PM daily
        String cronExp = '0 0 23 * * ?';

        // Schedule the job and store the job ID
        String jobId = System.schedule('Test PMT Availability Scheduler', cronExp, new PMT_AvailabilityResourceCreation());

        // Verify that the job was scheduled
        System.assertNotEquals(null, jobId, 'The job ID should not be null');
        
        // Query the CronTrigger object to verify the job was created
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime 
                          FROM CronTrigger WHERE Id = :jobId];
        
        System.assertEquals(cronExp, ct.CronExpression, 'Cron expression should match 11 PM daily');
    }
}