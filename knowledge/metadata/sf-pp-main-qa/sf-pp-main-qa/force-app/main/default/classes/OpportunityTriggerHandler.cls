/******************************************************************************
 * Name: OpportunityAttachmentTrigger
 * Description: Execution logic for the Attachment Trigger
 *
 *
 * Change Log
 * Item #   Date        Author          Description
 *    1     1/20/2016   srinivasseri    Created
 *    2     12/14/2016  Ben Logan       Refactored code for more efficient execution
 *                                      Added additional document logic
 ******************************************************************************/
 
Global with sharing class OpportunityTriggerHandler {
    public class OpportunityException extends Exception {}


     /**
     * validate the opportunity attachments if the attachment opportunity Contract.Contract_Active__c is TRUE
     * validate if the attached document is marked as final if the document type is either MOU, Pro Forma or Proposal
     */
    public void validateDocumentTypes(List<Opportunity> newOpportunities, list<Opportunity_Attachment__c> Attachments) {
        List<Id> newOpportunityIds = new List<Id>();
        Map<Id, Opportunity> newIdToOpportunityMap = new Map<Id, Opportunity>();
        //Boolean errorsFound = false;
       
        
        
        //Pumps Opportunities and associated attachments into a map to be used for easier access
        //to the dataset
        Map<ID,Opportunity> newOpportunitiesMap = OpportunityMap(newOpportunities);
        Map<Opportunity,List<Opportunity_Attachment__c>> OWA = OpportunitiesWithAttachments(newOpportunities,Attachments);
        Map<String, list<OpportunityHelper.RequiredDocumentAttributes>> StagingRule = OpportunityHelper.StagingRulesMap();
        
        


        for(Opportunity OPP:OWA.keyset()){
    
            //collection for different steps of the document process
            set<String> MissingDocuments = new set<String>();
            set<String> CurrentDocuments = new set<String>();
            set<String> RequiredDocuments = new set<String>();
            set<String> RequiredFinal = new set<String>();
            String errorBuilder = '';
            
            list<OpportunityHelper.RequiredDocumentAttributes> ROAs = StagingRule.get(OPP.StageName);

            
            if(ROAs!=null){
                for(OpportunityHelper.RequiredDocumentAttributes ROA:ROAs){
                    Requireddocuments.add(ROA.DocumentType);
                    if(ROA.Finalized==true){
                        RequiredFinal.add(ROA.DocumentType);
                    }
                }
                //itterates through attachments assoicated with opportunity
                for(Opportunity_Attachment__c ATT:OWA.get(OPP)){
                        if (RequiredFinal.contains(ATT.Document_Type__c) && ATT.Final__c == True) {
                            RequiredFinal.remove(ATT.Document_Type__c);
                        }

                        If(RequiredDocuments.contains(ATT.Document_Type__c)){
                            CurrentDocuments.add(ATT.Document_Type__c);  
                        }
                        
                  }
                 
                //checks to see if any final documents are left unfinalized  
                 if(!RequiredFinal.isEmpty()){
                     for(string RequiredFinal_Left:RequiredFinal){
                        errorBuilder = errorBuilder+'\n Final Version of ' + RequiredFinal_Left + ' must be attached.';    
                     }
                 }
                 
                //error builder producing error if not empty
                 if(errorBuilder!=''){
                     OPP.adderror(errorBuilder);
                 } 
                 
                 for(string doc:RequiredDocuments){
                     If(!CurrentDocuments.contains(doc)){
                        MissingDocuments.add(doc);
                     }
                 } 

                 
                 if(!MissingDocuments.isEmpty())
                 {
                    String stringbuilder = '';
                    for(String MissingDocument:MissingDocuments){
                        stringbuilder=stringbuilder+','+MissingDocument;
                    }
                    
                     OPP.adderror('The following documents are missing '+stringbuilder.substring(1)+'.');
                 }

            }else{
                
            }

        }
        
    }

    @TestVisible private void attachOpportunityAttachmentsToAccount(Opportunity opportunity) {
        List<Opportunity_Attachment__c> opportunity_attachments = [ SELECT Attachment__c
        FROM
            Opportunity_Attachment__c
        WHERE
            Opportunity__c =: opportunity.Id];

        List<Id> attachmentList = new List<Id>();
        for (Opportunity_Attachment__c op : opportunity_attachments)    {
            attachmentList.add(op.Attachment__c);
        }

        System.debug('attachmentList: ' + attachmentList);
        Id oppAccount = opportunity.AccountId;
        System.debug('oppAccount: ' + oppAccount);

        List<Attachment> actualAttachments = new List<Attachment>();
        actualAttachments = [SELECT Id, Body, Name FROM Attachment WHERE Id IN : attachmentList];

        List<Attachment> accountAttachments = new List<Attachment>();
        for(Attachment a : actualAttachments) {
            Attachment attachment = new Attachment();
            attachment.parentId = oppAccount;
            attachment.body = a.Body;
            attachment.name = a.Name;
            accountAttachments.add(attachment);
            System.debug('attachment: ' + attachment);
        }

        System.debug('attachments size: ' + accountAttachments.size());
        insert (accountAttachments);
    }
    
    //***************************************************************
    //Returns a Map of Opportunities and list of Attachments
    //Included logic to enforce the stage rules logic
    //***************************************************************
    Private static Map<Opportunity,List<Opportunity_Attachment__c>>OpportunitiesWithAttachments(List<Opportunity> Opportunities, List<Opportunity_Attachment__c> Attachments)
    {
        Map<Opportunity,List<Opportunity_Attachment__c>> OWA = new Map<Opportunity,List<Opportunity_Attachment__c>>();
        Map<String, list<OpportunityHelper.RequiredDocumentAttributes>> StagingRule = OpportunityHelper.StagingRulesMap();

        for(Opportunity OP:Opportunities){
            if(!Attachments.isempty()){
                for(Opportunity_Attachment__c AT:Attachments){
                        List<Opportunity_Attachment__c> TempList = new List<Opportunity_Attachment__c>();
                        
                        if(OWA.containsKey(OP)){
                            TempList = OWA.get(OP);
                            TempList.add(AT);
                        }else{
                            OWA.put(OP,new List<Opportunity_Attachment__c>{AT});
                        }
                }
            }else{
                if(StagingRule.get(OP.StageName)!=null){
                    list<OpportunityHelper.RequiredDocumentAttributes> ROAs = StagingRule.get(OP.StageName);
                    for(OpportunityHelper.RequiredDocumentAttributes ROA:ROAs){
                        if(ROA.DocumentType!=''){
                            OP.adderror('The following documents are missing '+ROA.DocumentType+'.');
                        }
                    }
                }

            }
        }
        
        return OWA;
    }
    
    Private static Map<ID,Opportunity>OpportunityMap(List<Opportunity> Opportunities)
    {
        Map<ID,Opportunity> Opp = new Map<ID,Opportunity>();

        for(Opportunity OP:Opportunities){
            
            Opportunity tempO = new Opportunity();
            
            if(Opp.containsKey(OP.ID)){
                tempO = Opp.get(OP.ID);
            }else{
                Opp.put(OP.ID,OP);
            }
        }
        
        return Opp;
    }
}