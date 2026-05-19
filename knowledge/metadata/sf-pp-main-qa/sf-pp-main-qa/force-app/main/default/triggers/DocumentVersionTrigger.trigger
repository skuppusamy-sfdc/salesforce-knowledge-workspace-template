trigger DocumentVersionTrigger on Apttus__DocumentVersion__c (after insert) {
    if (Trigger.isAfter && Trigger.isInsert) {
        DocumentVersionTriggerHandler.handleAfterInsert(Trigger.new);
    }
}