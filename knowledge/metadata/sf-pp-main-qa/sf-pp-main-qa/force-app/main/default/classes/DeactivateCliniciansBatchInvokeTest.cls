/**
* This class is test class for DeactivateCliniciansBatchInvoke
* 
* Modification Logs
* =================================================================================
* StoryNumber      DeveloperName       ModifiedDate        Description
* =================================================================================
* PR1050558-1580   Tapas              1/04/2026 
* =================================================================================
*/
@isTest
public class DeactivateCliniciansBatchInvokeTest {
    @isTest
    static void startProcessingBatchTest(){
        Test.startTest();
        DeactivateCliniciansBatchInvoke.startProcessingBatch();
        Test.stopTest();
    }

}