public with sharing class SelectContactsController {
    @AuraEnabled
    public static List<Contact> getAccountContacs(Id oppId, String filterValue) {
        List<OpportunityContactRole> roles = [SELECT ContactId FROM OpportunityContactRole WHERE OpportunityId = :oppId];
        List<Id> notInId = new List<Id>();
        for(OpportunityContactRole ocr:roles) {
            notInId.add(ocr.ContactId);
        }
        Id accId = [SELECT AccountId FROM Opportunity WHERE Id = : oppId LIMIT 1].AccountId;
        if (filterValue != '') {
            filterValue = '%'+filterValue+'%';
            return [
                SELECT Id, Name 
            FROM Contact 
            WHERE Id 
            NOT IN : notInId
            AND AccountId = : accId
            AND Name LIKE :filterValue
            ];
        } else {
            return [
            SELECT Id, Name 
            FROM Contact 
            WHERE Id 
            NOT IN : notInId
            AND AccountId = : accId
        ];

        }
               
      
          
    }
    @AuraEnabled
    public static List<Contact> getOppotrunityContacts(Id oppId, String filterValue) {
        List<OpportunityContactRole> roles = [SELECT ContactId FROM OpportunityContactRole WHERE OpportunityId = :oppId];
        List<Id> contactsIds = new List<Id>();
        for(OpportunityContactRole ocr:roles) {
            contactsIds.add(ocr.ContactId);
        }
        if (filterValue != '') {
            filterValue = '%'+filterValue+'%';
            return [
                SELECT Id, Name 
            FROM Contact 
            WHERE Id 
            IN : contactsIds
            AND Name LIKE :filterValue
            ];
        } else {
            return [
            SELECT Id, Name 
            FROM Contact 
            WHERE Id 
            IN : contactsIds
        ];

        }
               
    }
}