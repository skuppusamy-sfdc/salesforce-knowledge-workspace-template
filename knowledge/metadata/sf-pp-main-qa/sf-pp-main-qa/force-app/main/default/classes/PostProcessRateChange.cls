global class PostProcessRateChange {
    
    //Wrapper
    global class RateChangeEmailWrapper {
        @InvocableVariable(label='Doc Generation Batch Process Id' required=true)
        public Id docGenerationBatchProcessId;
        
        @InvocableVariable(label='Template Id' required=true)
        public Id templateId;
    }
    
    @InvocableMethod(label='Send Rate Change Email With Wrapper')
    global static void sendEmailInvocable(List<RateChangeEmailWrapper> inputs) {
        
        RateChangeService service = new RateChangeService();
        
        // Collect all batch IDs from inputs
        Set<Id> batchIds = new Set<Id>();
        for (RateChangeEmailWrapper input : inputs) {
            if (input.docGenerationBatchProcessId != null) {
                batchIds.add(input.docGenerationBatchProcessId);
            }
        }
        
        if (batchIds.isEmpty()) return;
        
        // Query all DocumentGenerationProcess records for all batch IDs at once
        List<DocumentGenerationProcess> dgps = [
            SELECT ReferenceObject, DocGenerationBatchProcessId,DocGenerationBatchProcess.description,CreatedById
            FROM DocumentGenerationProcess
            WHERE DocGenerationBatchProcessId IN :batchIds
        ];
        
        List<Clinical_Rate_Change__c> lstAgData = [SELECT id,
                                                           user_selected_IDs__c,
                                                           Non_Processed_Clinical_Ids__c,
                                                           Service_Account_ID__c ,DocGenerationBatchProcessId__c,
                                                           Contract_ID__c  FROM Clinical_Rate_Change__c 
                                                           where DocGenerationBatchProcessId__c = :dgps[0].DocGenerationBatchProcessId and Status__c = 'Open'];
        
        string previewIDslocal = dgps[0].DocGenerationBatchProcess.description;
        string createdByPerson = dgps[0].CreatedById;
        String serviceAccountId = '';
        if (!lstAgData.isEmpty()) {
            serviceAccountId = lstAgData[0].Service_Account_ID__c;
        }
        
        List<string> lstpreviewIDslocal = previewIDslocal.split(',');
        List<string> contractIds = new List<string>();
        contractIds.addall(lstpreviewIDslocal);
        
        // Map batchId -> list of contract IDs
        Map<Id, List<Id>> batchToContractIds = new Map<Id, List<Id>>();
        for (DocumentGenerationProcess dgp : dgps) {
            if (dgp.ReferenceObject != null) {
                contractIds.add(dgp.ReferenceObject);
            }
        }
      
        if (contractIds != null && !contractIds.isEmpty()) {
            Map<String, Integer> resultMap = service.sendEmailBatch(contractIds,inputs.get(0).templateId, service.getOrgWideEmailId());
            service.finalize(contractIds,serviceAccountId,resultMap,createdByPerson);
        }
    }

}