/**
 * A scheduler to automatically create the availability.
 * 
 * @author Salesforce Services
 * @version 1.0
 * @since 2025-05-23
 */
global class PMT_AvailabilityResourceCreation implements Schedulable{
    global void execute(SchedulableContext SC) {
        inov8.PMT_ResourceAvailabilityScheduler sch = new inov8.PMT_ResourceAvailabilityScheduler();
        sch.execute(SC);
    }
}