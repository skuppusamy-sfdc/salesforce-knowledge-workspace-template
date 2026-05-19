/**
 * Created by srinivasseri on 1/20/16.
 */

@IsTest(seeAllData=true)
private class OpportunityTriggerHandlerTest {
    static OpportunityTriggerHandler opportunityTriggerHandler = new OpportunityTriggerHandler();

   static testMethod void itShouldCopyOpptyAttachmentsToAccount() {
        Test.startTest();

        Opportunity opportunity = getOpportunity('Marketing Qualified Lead');

        insertOpportunityAttachment(opportunity, TRUE, 'MOU');
        insertOpportunityAttachment(opportunity, FALSE, 'MOU');

        opportunityTriggerHandler.attachOpportunityAttachmentsToAccount(opportunity);

        List<Attachment> accountAttachments = [SELECT Id, Body, Name FROM Attachment WHERE ParentId =: opportunity.AccountId];
        System.assertEquals(accountAttachments.size(), 2);

        Test.stopTest();
    }

    static testMethod void itShouldNotCopyOpptyAttachmentsToAccount() {
        Test.startTest();

        Opportunity opportunity = getOpportunity('Marketing Qualified Lead');

        insertOpportunityAttachment(opportunity, FALSE, 'MOU');

        opportunityTriggerHandler.attachOpportunityAttachmentsToAccount(opportunity);

        List<Attachment> accountAttachments = [SELECT Id, Body, Name FROM Attachment WHERE ParentId =: opportunity.AccountId];
        System.assertEquals(accountAttachments.size(), 1);

        Test.stopTest();
    }

    
    static testMethod void testMarketingQualifiedLead_Stage() {
        Test.startTest();

        Opportunity opportunity = getOpportunity('Marketing Qualified Lead');

        Test.stopTest();
    }
    
    static testMethod void testSalesQualifiedOpportunity_Stage() {
        Test.startTest();

        Opportunity opportunity = getOpportunity('Sales Qualified Opportunity');
        
        Test.stopTest();
    }
    
    static testMethod void testProposalRequest_Stage() {
        
        Opportunity opportunity = getOpportunity('Sales Qualified Opportunity');
        insertOpportunityAttachment(opportunity, FALSE, 'Movie Plan Worksheet');

        opportunityTriggerHandler.attachOpportunityAttachmentsToAccount(opportunity);

        Test.startTest();

        opportunity.StageName='Proposal Request';

        List<Attachment> accountAttachments = [SELECT Id, Body, Name FROM Attachment WHERE ParentId =: opportunity.AccountId];
        System.assertEquals(accountAttachments.size(), 1);

        Test.stopTest();
    }

    static testMethod void testProposalDevelopment_Stage() {
        
        Opportunity opportunity = getOpportunity('Sales Qualified Opportunity');

        insertOpportunityAttachment(opportunity, FALSE, 'Client Needs Assessment');
        insertOpportunityAttachment(opportunity, FALSE, 'Movie Plan Worksheet');
        
        opportunityTriggerHandler.attachOpportunityAttachmentsToAccount(opportunity);
        
        Test.startTest();

        opportunity.StageName='Proposal Development';

        List<Attachment> accountAttachments = [SELECT Id, Body, Name FROM Attachment WHERE ParentId =: opportunity.AccountId];
        System.assertEquals(accountAttachments.size(), 2);

        Test.stopTest();
    }
    
    static testMethod void testProposalPresented_Stage() {
        
        Opportunity opportunity = getOpportunity('Sales Qualified Opportunity');

        insertOpportunityAttachment(opportunity, TRUE, 'Pro Forma');
        insertOpportunityAttachment(opportunity, TRUE, 'Proposal');
        insertOpportunityAttachment(opportunity, FALSE, 'Client Needs Assessment');
        insertOpportunityAttachment(opportunity, FALSE, 'Movie Plan Worksheet');
        
        opportunityTriggerHandler.attachOpportunityAttachmentsToAccount(opportunity);
        
        Test.startTest();
        
        opportunity.StageName='Proposal Presented';

        List<Attachment> accountAttachments = [SELECT Id, Body, Name FROM Attachment WHERE ParentId =: opportunity.AccountId];
        System.assertEquals(accountAttachments.size(), 4);

        Test.stopTest();
    }
    
    static testMethod void testDownSelect_Stage() {
        Opportunity opportunity = getOpportunity('Sales Qualified Opportunity');

        insertOpportunityAttachment(opportunity, FALSE, 'Movie Plan Worksheet');
        insertOpportunityAttachment(opportunity, FALSE, 'Client Needs Assessment');
        insertOpportunityAttachment(opportunity, TRUE, 'Proposal');
        insertOpportunityAttachment(opportunity, TRUE, 'Pro Forma');

        opportunityTriggerHandler.attachOpportunityAttachmentsToAccount(opportunity);
        
        Test.startTest();
        
        opportunity.StageName='Down Select';

        List<Attachment> accountAttachments = [SELECT Id, Body, Name FROM Attachment WHERE ParentId =: opportunity.AccountId];
        System.assertEquals(accountAttachments.size(), 4);

        Test.stopTest();
    }
    
        
    static testMethod void testVerbalAward_Stage() {
        Opportunity opportunity = getOpportunity('Sales Qualified Opportunity');

        insertOpportunityAttachment(opportunity, FALSE, 'Movie Plan Worksheet');
        insertOpportunityAttachment(opportunity, FALSE, 'Client Needs Assessment');
        insertOpportunityAttachment(opportunity, TRUE, 'Proposal');
        insertOpportunityAttachment(opportunity, TRUE, 'Pro Forma');

        opportunityTriggerHandler.attachOpportunityAttachmentsToAccount(opportunity);
        
        Test.startTest();
        
        Opportunity.StageName='Verbal Award';

        List<Attachment> accountAttachments = [SELECT Id, Body, Name FROM Attachment WHERE ParentId =: opportunity.AccountId];
        System.assertEquals(accountAttachments.size(), 4);

        Test.stopTest();
    }
    
    static testMethod void testMOUSigned_Stage() {
        Opportunity opportunity = getOpportunity('Sales Qualified Opportunity');

        insertOpportunityAttachment(opportunity, FALSE, 'Movie Plan Worksheet');
        insertOpportunityAttachment(opportunity, FALSE, 'Client Needs Assessment');
        insertOpportunityAttachment(opportunity, TRUE, 'Proposal');
        insertOpportunityAttachment(opportunity, TRUE, 'Pro Forma');
        insertOpportunityAttachment(opportunity, TRUE, 'MOU');

        opportunityTriggerHandler.attachOpportunityAttachmentsToAccount(opportunity);
        
        Test.startTest();
        
        Opportunity.StageName='MOU Signed';
        
        List<Attachment> accountAttachments = [SELECT Id, Body, Name FROM Attachment WHERE ParentId =: opportunity.AccountId];
        System.assertEquals(accountAttachments.size(), 5);

        Test.stopTest();
    }
    
    static testMethod void testContractSigned_Stage() {
        Opportunity opportunity = getOpportunity('Sales Qualified Opportunity');
        
        insertOpportunityAttachment(opportunity, FALSE, 'Movie Plan Worksheet');
        insertOpportunityAttachment(opportunity, FALSE, 'Client Needs Assessment');
        insertOpportunityAttachment(opportunity, TRUE, 'Proposal');
        insertOpportunityAttachment(opportunity, TRUE, 'Pro Forma');
        insertOpportunityAttachment(opportunity, TRUE, 'MOU');
        insertOpportunityAttachment(opportunity, TRUE, 'Contract');
         insertOpportunityAttachment(opportunity, TRUE, 'Proforma at Contract Signature');

        //opportunityTriggerHandler.attachOpportunityAttachmentsToAccount(opportunity);
        
        Test.startTest();


        
        Opportunity.StageName='Contract Signed';
        Opportunity.MOU_Sign_Date__c = System.today();
        Opportunity.Expected_Sign_Date__c = System.today();
        Opportunity.Contract_Customer_Signed_Date__c = System.today();
        Opportunity.Actual_Start_Date__c = System.today();
        
        update Opportunity;
        
    
        //List<Attachment> accountAttachments = [SELECT Id, Body, Name FROM Attachment WHERE ParentId =: opportunity.AccountId];
        //System.assertEquals(accountAttachments.size(), 6);

        Test.stopTest();
    }
    

    
    /*static testMethod void testValidateDocumentTypesSuccess() {
        Test.startTest();

        Opportunity opportunity = getOpportunity();
        insertOpportunityAttachment(opportunity, TRUE, 'MOU');
        insertOpportunityAttachment(opportunity, TRUE, 'Pro Forma');
        insertOpportunityAttachment(opportunity, TRUE, 'Proposal');

        opportunity.StageName='Started';
        update(opportunity);

        Test.stopTest();
    }
    static testMethod void testValidateDocumentTypesSemiSuccess() {
        Test.startTest();

        Opportunity opportunity = getOpportunity();
        insertOpportunityAttachment(opportunity, TRUE, 'MOU');
        insertOpportunityAttachment(opportunity, TRUE, 'Pro Forma');
        insertOpportunityAttachment(opportunity, TRUE, 'Proposal');

        opportunity.StageName='Started';
        try{
            update(opportunity);
        } catch (DmlException dml)  {
            System.debug('dml ex: '+ dml.getMessage());
            System.assert(dml.getMessage().contains('Final Version of'));
        }

        Test.stopTest();
    }*/


    private static Id getRecordTypeId()    {
        RecordType rtOpp = [Select Name, DeveloperName From RecordType
        Where SObjectType = 'Opportunity' and Name = 'HM Sales Opportunity'];
        return rtOpp.Id;
    }

    private static Opportunity getOpportunity(String stage)   {
        Account acc1 = new Account(Name='Opportunity Account');
        insert acc1;

        Opportunity opportunity = new Opportunity (
                Name = 'Opp-Test',
                CloseDate = Date.today(),
                //StageName = 'Marketing Qualified Lead',
                StageName = stage,
                Created_from_Lead__c = true,
                //Service_s__c  = 'HM;WW',
                AccountId = acc1.Id,
                RecordTypeId = getRecordTypeId()
        );
        insert opportunity;
        System.debug('Opportunity: ' + opportunity);
        return opportunity;
    }

    private static void insertOpportunityAttachment(Opportunity opportunity, Boolean finalFlag, String documentType)  {
        Attachment attachment = new Attachment();
        attachment.parentId = opportunity.Id;
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body' + opportunity.Id + finalFlag);
        attachment.body = bodyBlob;
        attachment.name = 'test attachment';
        System.debug('attachment: ' + attachment);
        insert(attachment);

        Opportunity_Attachment__c obj = new Opportunity_Attachment__c();
        obj.opportunity__c = opportunity.Id;
        obj.description__c = 'test';
        obj.version__c = 'V01';
        obj.final__c = finalFlag;
        obj.document_Type__c = documentType;
        obj.name = attachment.name;
        obj.Attachment__c = attachment.Id;
        insert(obj);
    }
    
}