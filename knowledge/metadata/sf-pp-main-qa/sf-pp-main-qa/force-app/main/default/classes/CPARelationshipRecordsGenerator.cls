/**
 * @description Serves as an entry point for an InvocableMethod to start the process of generating
 * and updating Collaborative Practice Agreement (CPA) records. This class is typically called
 * from a Flow to handle the processing asynchronously via a Queueable job.
 * @author Muskan Jain
 * @version 1.0
 */
public class CPARelationshipRecordsGenerator {
    
    @InvocableMethod(label='Process Contract CPA' description='Starts the Queueable process for new/updated CPAs.')
    public static void startCPAProcessing(List<Id> contractIds) {
        if (contractIds == null || contractIds.isEmpty()) {
            return;
        }
		// Queuable for each contract
        for(Id contractId :contractIds){
            CPARelationshipRecordsGeneratorQueuable job = new CPARelationshipRecordsGeneratorQueuable(contractId);
        	System.enqueueJob(job);
        }
        
    }
}