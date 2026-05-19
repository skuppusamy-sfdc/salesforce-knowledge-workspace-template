/**
 * Created by srinivasseri on 1/25/16.
 */

@IsTest(seeAllData=true)
private class OpportunityAttachmentControllerTest {
    static testMethod void testUploadProcess() {
        Test.startTest();

        Opportunity opportunity = OpportunityTestDataHelper.getOpportunity();

        ApexPages.StandardController oppStdController = new ApexPages.StandardController(opportunity);
        OpportunityAttachmentController controller = new OpportunityAttachmentController(oppStdController);
        controller.description='test file attachment';
        controller.version='V01';
        controller.finalVersion=TRUE;
        controller.selectedType='MOU';
        controller.fileBody=Blob.valueOf('Unit Test Attachment Body' + opportunity.Id);
        controller.fileName ='attachment.jpg';
        PageReference pageReference = controller.processUpload();

        List<Opportunity_Attachment__c> opptyAttachments = [SELECT Id, Name, Version__c, Final__c FROM Opportunity_Attachment__c
                                                WHERE opportunity__c =: opportunity.Id];
        System.assertEquals(opptyAttachments.size(), 1);
        System.assertEquals(opptyAttachments.get(0).Name, 'attachment.jpg');
        System.assertEquals(opptyAttachments.get(0).Version__c, 'V01');
        System.assertEquals(opptyAttachments.get(0).Final__c, TRUE);

        Test.stopTest();
    }

    static testMethod void testGetDocumentTypeList() {
        Opportunity opportunity = OpportunityTestDataHelper.getOpportunity();

        ApexPages.StandardController oppStdController = new ApexPages.StandardController(opportunity);
        OpportunityAttachmentController controller = new OpportunityAttachmentController(oppStdController);
        List<SelectOption> dSelectOptions = controller.getDocumentTypeList();
        System.assert(dSelectOptions.size() > 1);

        PageReference pageReference = controller.back();
        System.debug('PageReference: ' + pageReference.getUrl());
        System.assertEquals(pageReference.getUrl(), ('/'+opportunity.Id));

    }

}