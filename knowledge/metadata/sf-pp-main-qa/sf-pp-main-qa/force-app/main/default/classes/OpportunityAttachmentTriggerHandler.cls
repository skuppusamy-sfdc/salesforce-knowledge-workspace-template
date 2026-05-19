public with sharing class OpportunityAttachmentTriggerHandler {
    private static Set<String> DOCUMENT_TYPES = new Set<String> { 'MOU', 'Pro Forma', 'Proposal' };

    public OpportunityAttachmentTriggerHandler() {
		
	}

	public void updateDocumentTypeVersion(List<Opportunity_Attachment__c> attachments)	{
		Set<Id> allIds = new Set<Id>();
		List<Opportunity_Attachment__c> existingAttachments = new List<Opportunity_Attachment__c>();
		
		for(Opportunity_Attachment__c a : attachments){
			allIds.add(a.Opportunity__c);
		}
        System.debug('allIds: ' + allIds);


		existingAttachments = [	SELECT 
									Id, Opportunity__c, Document_Type__c, Final__c, Version__c
								FROM 
									Opportunity_Attachment__c 
								WHERE 
									Opportunity__c IN : allIds
                                AND
                                    Final__c = TRUE];
        System.debug('existingAttachments: ' + existingAttachments);
        List<Opportunity_Attachment__c> updatedList  = updateFinalFlag(existingAttachments, attachments);
        update(updatedList);

	}

    /**
     * validate the opportunity attachments if the attachment opportunity Contract.Contract_Active__c is TRUE
     * validate if the attached document is marked as final if the document type is either MOU, Pro Forma or Proposal
     */
    @TestVisible private void validateDocumentTypes(Set<Id> oppIds, List<Opportunity_Attachment__c> attachments) {
        List<Contract> oppContracts = [SELECT Id, Contract_Active__c, Opportunity__c FROM Contract WHERE
                                        Opportunity__c IN : oppIds AND Contract_Active__c = TRUE];
        if(oppContracts.size() == 0)    {
            return;
        }

        for(Contract c : oppContracts)  {
            for(Opportunity_Attachment__c oa : attachments) {
                if(c.Opportunity__c == oa.Opportunity__c && DOCUMENT_TYPES.contains(oa.Document_Type__c) && oa.Final__c == FALSE)   {
                    oa.addError('Final Version of ' + oa.Name + ' must be attached.');
                }
            }
        }

    }

    @TestVisible private List<Opportunity_Attachment__c>  updateFinalFlag(List<Opportunity_Attachment__c> existingAttachments, List<Opportunity_Attachment__c> attachments)  {
        List<Opportunity_Attachment__c> updatedList = new List<Opportunity_Attachment__c>();
        Map<String, Integer> versionsMap = new Map<String, Integer>();
        for(Opportunity_Attachment__c newAttachment : attachments)	{
            for(Opportunity_Attachment__c ex : existingAttachments){
                if(newAttachment.Opportunity__c == ex.Opportunity__c && newAttachment.Final__c == true
                        && newAttachment.Document_Type__c == ex.Document_Type__c){
                    ex.Final__c = false;
                    if(versionsMap.get(ex.Document_Type__c) != null)	{
                        versionsMap.put(ex.Document_Type__c, getHigherVersion(versionsMap.get(ex.Document_Type__c), ex.Version__c));
                    } else	{
                        Integer version = Integer.valueOf(ex.Version__c.substringAfter('V'));
                        versionsMap.put(ex.Document_Type__c, version);
                    }
                    updatedList.add(ex);
                }
            }
            setVersion(newAttachment, versionsMap);
            System.debug('after setVersion: ' + newAttachment.Version__c);
            versionsMap.clear();
        }
        System.debug('updatedList: ' + updatedList);
        return updatedList;
    }

    @TestVisible private void setVersion(Opportunity_Attachment__c opportunityAttachment, Map<String, Integer> versionsMap)	{
        System.debug('setVersion: ' + versionsMap);
		if(versionsMap.size() == 0 || versionsMap.get(opportunityAttachment.Document_Type__c) == null)	{
			opportunityAttachment.Version__c = 'V01';
            return;
		}

		Integer exVersion = versionsMap.get(opportunityAttachment.Document_Type__c);
        System.debug('exVersion: ' + exVersion);
		if(exVersion != null)	{
            ++exVersion;
			opportunityAttachment.Version__c =  (exVersion > 9 ? ('V0' + exVersion) : ('V0' + exVersion));
            System.debug('exVersion after: ' + opportunityAttachment.Version__c);
		}

	}

    @TestVisible private Integer getHigherVersion(Integer oldVersionNumber, String newVersion)	{
		Integer newVersionNumber = Integer.valueOf(newVersion.substringAfter('V'));
        System.debug('getHigherVersion: ' + newVersionNumber);
		return newVersionNumber > oldVersionNumber ? newVersionNumber : oldVersionNumber;
	}
}