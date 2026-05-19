/**
 * @description
 * Schedulable class to schedule the Contract Termination Batch
 * to run daily. This can be scheduled via the Developer Console or Setup.
 *
 * Usage:
 * ContractTerminationScheduler scheduler = new ContractTerminationScheduler();
 * String cronExpression = '0 0 20 * * ?'; // Daily at 8:00 PM UTC (20:00)
 * System.schedule('Contract Termination Daily', cronExpression, scheduler);
 *
 * @author Salesforce Developer
 * @date 2026-02-03
 * @since 1.0
 */
public class ContractTerminationScheduler implements Schedulable {
    
    /**
     * @description
     * Execute method that runs the batch job when scheduled.
     *
     * @param sc SchedulableContext
     */
    public void execute(SchedulableContext sc) {
        ContractTerminationBatch batch = new ContractTerminationBatch();
        Database.executeBatch(batch, 200);
    }
}