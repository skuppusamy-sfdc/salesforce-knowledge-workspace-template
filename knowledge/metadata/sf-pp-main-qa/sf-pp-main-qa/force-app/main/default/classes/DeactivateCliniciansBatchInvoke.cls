/***************************************************************************************************************************
 * Class Name    : DeactivateCliniciansBatchInvoke
 * Description   : Invoker Class
 * Author        : Tapas
 * Created Date  : 1-Apr-2026
 * Last Modified : 
 ***************************************************************************************************************************/
public class DeactivateCliniciansBatchInvoke {
    @InvocableMethod(label='Process HPFs' description='Start batch for processing hpf')
    public static void startProcessingBatch() {
        // Instantiate the batch class
        DeactivateHPFsForClinician batchInstance = new DeactivateHPFsForClinician();
        Database.executeBatch(batchInstance);
    }
}