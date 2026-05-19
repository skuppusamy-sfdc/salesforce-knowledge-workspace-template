@IsTest
public class ClinicianCoverageUpdateSchedulerTest {

    @IsTest
    static void testScheduleJob() {
        // --------------------------
        // Test the scheduleJob static method
        // --------------------------
        Test.startTest();

        // Schedule the job
        ClinicianCoverageUpdateScheduler.scheduleJob();

        // Verify that a job has been scheduled
        List<CronTrigger> jobs = [SELECT Id, CronExpression, TimesTriggered, NextFireTime, CronJobDetail.Name 
                                  FROM CronTrigger WHERE CronJobDetail.Name = 'Clinician Coverage Update Job'];
        System.assert(!jobs.isEmpty(), 'Scheduler should schedule a job.');
        System.assertEquals('Clinician Coverage Update Job', jobs[0].CronJobDetail.Name, 'Job name should match.');

        Test.stopTest();
    }
}