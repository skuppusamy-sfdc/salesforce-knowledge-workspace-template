trigger PCATrigger on PreventiveCareAgreement (before insert, before update, before delete, after insert, after update, after delete) {
    
    
    if (trigger.isAfter) {
        if (trigger.isDelete) {
            PCATriggerHandler.createPlatformEvt(trigger.old);
        }
    }

}