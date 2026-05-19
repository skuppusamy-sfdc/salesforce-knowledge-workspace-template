/******************************************************************************
 * Name: OpportunityTrigger
 * Description: Execution logic for the Opportunity Trigger
 *
 *
 * Change Log 
 * Item #   Date        Author          Description
 *    1     12/14/2016  Ben Logan       Created
 *    2     08/29/2017  Pete Lyons      Added logic to exempt Consulting Service and Optum Record Types
 ******************************************************************************/
trigger OpportunityTrigger on Opportunity (
    before insert, 
    before update, 
    //before delete, 
    after insert, 
    after update, 
    //after delete, 
    after undelete) {
        set<ID> OpportunityIDs = new set<ID>();
        List<Opportunity_Attachment__c> oppAttachments = new List<Opportunity_Attachment__c>();
        for(Opportunity Op:Trigger.new){
            string recType = Schema.SObjectType.Opportunity.getRecordTypeInfosById().get(Op.recordtypeid).getname(); 
            system.debug('rectype: '+recType);
            if(recType != 'Consulting Services Sales' && recType != 'Optum Sales Opportunity'){
                OpportunityIDs.add(OP.Id);
            }
        }
        
        OpportunityTriggerHandler OTH = new OpportunityTriggerHandler();
        
        if(OpportunityIDs.size() > 0){
            oppAttachments = [SELECT Id, Opportunity__c, Opportunity__r.ID, Opportunity__r.StageName, Document_Type__c, Final__c 
                                                              FROM Opportunity_Attachment__c
                                                              WHERE Opportunity__c IN : OpportunityIDs];
        }

        if(oppAttachments.size() > 0){
                                                              
            if (Trigger.isInsert){
                if(Trigger.isBefore){
                   OTH.validateDocumentTypes(trigger.new,oppAttachments);
                }
                if(Trigger.isAfter){
                
                }
            } 
            
            
            if (Trigger.isUpdate){
                if(Trigger.isBefore){
                    system.debug('in before update');
                    OTH.validateDocumentTypes(trigger.new,oppAttachments);
                    system.debug(oppAttachments);
                }
                if(Trigger.isAfter){
                
                }
            }
        }
        
}