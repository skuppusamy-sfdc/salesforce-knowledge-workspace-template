trigger OpportunityAttachmentTrigger on Opportunity_Attachment__c (
    before insert, 
    before update, 
    before delete, 
    after insert, 
    after update, 
    after delete, 
    after undelete) {

        OpportunityAttachmentTriggerHandler opportunityHandler = new OpportunityAttachmentTriggerHandler();
        if (Trigger.isInsert && Trigger.isBefore) {
            opportunityHandler.updateDocumentTypeVersion(Trigger.new);
        
        }
}