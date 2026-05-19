public class PCATriggerHandler {
    
    public Static void createPlatformEvt(List<PreventiveCareAgreement> pcaList) {
        List<CapturePCA__e> peList = new List <CapturePCA__e>();
        
        
        for (PreventiveCareAgreement pca : pcaList) {
            CapturePCA__e pe = new CapturePCA__e();
            if (pca.Rate__c != null && pca.Unit_of_Measure__c == 'per Hour') {
                pe.CPAId__c = pca.contractId__c ;
                pe.PCAId__c = pca.Id;
                peList.add(pe);
            }
        }
        // Publish the events
        
        Database.SaveResult[] srList = EventBus.publish(peList);
        // Iterate through each returned result
        for (Database.SaveResult sr : srList) {
            if (sr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully inserted : ' + sr.getId());
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {                   
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                }
            }
            
        }
    }
    
    
}