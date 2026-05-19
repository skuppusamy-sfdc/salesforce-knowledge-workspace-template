/***************************************************************************************************************************
 * Class Name    : PracticeOperationChangeQueueableInvoker
 * Description   : Invoker Class
 * Author        : Srishty Sharma
 * Created Date  : 16-Oct-2025
 * Last Modified : 
 ***************************************************************************************************************************/
public class PracticeOperationChangeQueueableInvoker {

    @InvocableMethod(label='Trigger Practice Operation Change Queueable')
    public static void runQueueable(List<Id> contractIds) {
           if(contractIds == null || contractIds.isEmpty()) return;
        
           System.enqueueJob(new PracticeOperationChangeQueueable(contractIds));
        
    }
}