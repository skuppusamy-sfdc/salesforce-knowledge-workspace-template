/**
 * Created by srinivasseri on 1/19/16.
 */

@IsTest(seeAllData=true)
private class OpportunityAttachmentTriggerHandlerTest {
    static OpportunityAttachmentTriggerHandler handler = new OpportunityAttachmentTriggerHandler();

    static testMethod void testGetHigherVersion() {
        Integer versionNumber = handler.getHigherVersion(1, 'V02');
        System.assertEquals(versionNumber, 2);
    }

    static testMethod void testSetVersion() {
        Opportunity opportunity = OpportunityTestDataHelper.getOpportunity();

        Opportunity_Attachment__c oac = new Opportunity_Attachment__c();
        oac.Opportunity__c = opportunity.Id;
        oac.Version__c = 'V03';
        oac.Document_Type__c  = 'MOU';
        Map<String, Integer> versionsMap = new Map<String, Integer>();

        handler.setVersion(oac, versionsMap);
        System.assertEquals(oac.Version__c, 'V01');

        versionsMap.put('MOU', 3);
        handler.setVersion(oac, versionsMap);
        System.assertEquals(oac.Version__c, 'V04');

        versionsMap.clear();
        versionsMap.put('Proposal', 2);
        handler.setVersion(oac, versionsMap);
        System.assertEquals(oac.Version__c, 'V01');
    }

    static testMethod void testUpdateFinalFlag() {
        Opportunity opportunity = OpportunityTestDataHelper.getOpportunity();

        Opportunity_Attachment__c oac = new Opportunity_Attachment__c();
        oac.Opportunity__c = opportunity.Id;
        oac.Version__c = 'V03';
        oac.Document_Type__c  = 'MOU';

        Opportunity_Attachment__c oa1 = new Opportunity_Attachment__c();
        oa1.Opportunity__c = opportunity.Id;
        oa1.Version__c = '';
        oa1.Document_Type__c  = 'MOU';
        oa1.Final__c = TRUE;
        insert(oa1);

        Opportunity_Attachment__c oa2 = new Opportunity_Attachment__c();
        oa2.Opportunity__c = opportunity.Id;
        oa2.Version__c = '';
        oa2.Document_Type__c  = 'MOU';
        oa2.Final__c = TRUE;
        insert(oa2);

        Opportunity_Attachment__c inserted = [select Version__c, Final__c from Opportunity_Attachment__c where Id =: oa1.Id];
        System.debug('inserted.Version__c: ' + inserted.Version__c);
        System.debug('inserted.Final__c: ' + inserted.Final__c);
        System.assertEquals(inserted.Version__c, 'V01');
        System.assertEquals(inserted.Final__c, FALSE);

        Opportunity_Attachment__c inserted1 = [select Version__c, Final__c from Opportunity_Attachment__c where Id =: oa2.Id];
        System.debug('inserted1.Version__c: ' + inserted1.Version__c);
        System.debug('inserted1.Final__c: ' + inserted1.Final__c);
        System.assertEquals(inserted1.Version__c, 'V02');
        System.assertEquals(inserted1.Final__c, TRUE);

        Opportunity_Attachment__c attachmentProposal = new Opportunity_Attachment__c();
        attachmentProposal.Opportunity__c = opportunity.Id;
        attachmentProposal.Version__c = 'V02';
        attachmentProposal.Document_Type__c  = 'Proposal';
        attachmentProposal.Final__c = TRUE;
        insert(attachmentProposal);

        Opportunity_Attachment__c apAttachment = [select Version__c, Final__c from Opportunity_Attachment__c where Id =: attachmentProposal.Id];
        System.debug('apAttachment.Version__c: ' + apAttachment.Version__c);
        System.debug('apAttachment.Final__c: ' + apAttachment.Final__c);
        System.assertEquals(apAttachment.Version__c, 'V01');
        System.assertEquals(apAttachment.Final__c, TRUE);

    }

}