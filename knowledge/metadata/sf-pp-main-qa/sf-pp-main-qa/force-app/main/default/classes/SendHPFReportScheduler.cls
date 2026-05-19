/**
 * @description
 * Schedulable class to schedule the Send HPF Report Batch
 * to run daily. This can be scheduled via the Developer Console or Setup.
 *
 * Usage:
 * SendHPFReportScheduler scheduler = new SendHPFReportScheduler();
 * String cronExpression = '0 0 10 * * ?'; // Daily at 10:00 AM UTC
 * System.schedule('Send HPF Report Daily', cronExpression, scheduler);
 *
 * @author Salesforce Developer
 * @date 2026-02-03
 * @since 1.0
 */
public class SendHPFReportScheduler implements Schedulable {
    
    /**
     * @description
     * Execute method that runs the batch job when scheduled.
     *
     * @param sc SchedulableContext
     */
    public void execute(SchedulableContext sc) {
        SendHPFReportBatch batch = new SendHPFReportBatch();
        Database.executeBatch(batch, 200);
    }
}