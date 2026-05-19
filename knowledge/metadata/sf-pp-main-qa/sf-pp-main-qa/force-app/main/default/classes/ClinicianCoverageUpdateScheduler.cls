/********************************************************************************************************************************
 * Class Name		: ClinicianCoverageUpdateScheduler
 * Description	 	: Scheduler class for ClinicianCoverageUpdateBatch.    
 * Author        	: Srishty Sharma
 * Created Date		: 30-Sept-2025
 * Last Modified	: 
 *******************************************************************************************************************************/
global class ClinicianCoverageUpdateScheduler implements Schedulable {

    global void execute(SchedulableContext sc) {
        // Read batch scope from custom label
        Integer scopeSize = String.isBlank(Label.ClinicianCoverageUpdateBatchScope) ? 200 : Integer.valueOf(Label.ClinicianCoverageUpdateBatchScope);
        // Execute batch
        Database.executeBatch(new ClinicianCoverageUpdateBatch(), scopeSize);
    }

    /**
     * Schedules the batch job using CRON expression from Custom Label
     * and batch size also from Custom Label
     */
    public static void scheduleJob() {
        String cronExp = String.isBlank(Label.ClinicianCoverageUpdateCronExp) ? '0 0 2 * * ?' : Label.ClinicianCoverageUpdateCronExp;
        System.schedule('Clinician Coverage Update Job', cronExp, new ClinicianCoverageUpdateScheduler());
    }
}