public class OpportunityAttachmentController {

    public String version {get;set;}
    public String selectedType {get;set;}
    public List<SelectOption> documentTypeList;
    public Boolean finalVersion {get;set;}
    public String description {get;set;}
    private Opportunity opportunity {get;set;}
    public String fileName {get;set;}
    public Transient Blob fileBody {get;set;}
    public boolean displayPopup {get; set;} 
    public List<Opportunity> Opps {get; set;}
    public Decimal sub {get; set;}

    public  OpportunityAttachmentController(ApexPages.StandardController controller) {
        this.opportunity = (Opportunity)controller.getRecord();
    }

    public void closePopup() {        
        displayPopup = false;    
    }     
    public PageReference showPopup() { 
        try{

            // List<opportunity> Opps = new List<opportunity>();
            // if(opportunity != null){
            //     system.debug('b');
            //     Opps = [SELECT Id, stageName, Subsidy__c, Revenue__c, Volume__c, Margin__c FROM opportunity WHERE Id = :opportunity.id limit 1];
            //   system.debug('c');
            // }
            //  if(fileBody != null && (selectedType == 'Proposal' || selectedType == 'MOU' || selectedType == 'Contract' || selectedType == 'Proforma at Contract Signature')){
            //      system.debug('d');
            //      displayPopup = true;
            //      system.debug('after popup');
            //      return null;
            // } else {
            // }
                if(fileBody == null){
                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                        'Could not save attachment. No File attached'));
                    return null;
                } else{
                    processUpload();
                    return new PageReference('/'+opportunity.Id);
                }
                
                   
             
        }
        catch(Exception e) {
            ApexPages.AddMessages(e);
            return null;
        }  
    }

    // creates a new Opportunity_Attachment__c record
    private Database.SaveResult saveCustomAttachment() {
        Opportunity_Attachment__c obj = new Opportunity_Attachment__c();
        obj.opportunity__c = opportunity.Id;
        obj.description__c = description;
        obj.version__c = 'V01';
        obj.final__c = finalVersion;
        obj.document_Type__c = selectedType;
        // fill out custom obj fields
        return Database.insert(obj);
    }

    // create an actual Attachment record with the Opportunity_Attachment__c as parent
    private Database.SaveResult saveStandardAttachment(Id parentId) {
        Database.SaveResult result;

        Attachment attachment = new Attachment();
        attachment.body = this.fileBody;
        attachment.name = this.fileName;
        attachment.parentId = parentId;
        // insert the attahcment
        result = Database.insert(attachment);
        // reset the file for the view state
        fileBody = Blob.valueOf(' ');
        return result;
    }

    /**
    * Upload process is:
    *  1. Insert new Opportunity_Attachment__c record
    *  2. Insert new Attachment with the new Opportunity_Attachment__c record as parent
    *  3. Update the Opportunity_Attachment__c record with the ID of the new Attachment
    **/
    public PageReference processUpload() {
        
        try {
            
            Database.SaveResult customAttachmentResult = saveCustomAttachment();
            System.debug('processUpload: ' + opportunity.Id);

            if (customAttachmentResult == null || !customAttachmentResult.isSuccess()) {
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                        'Could not save attachment.'));
                return null;
            }

            Database.SaveResult attachmentResult = saveStandardAttachment(customAttachmentResult.getId());

            if (attachmentResult == null || !attachmentResult.isSuccess()) {
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                        'Could not save attachment.'));
                return null;
            } else {
                // update the custom attachment record with some attachment info
                Opportunity_Attachment__c customAttachment = [select id from Opportunity_Attachment__c where id = :customAttachmentResult.getId()];
                customAttachment.name = this.fileName;
                customAttachment.Attachment__c = attachmentResult.getId();
                update customAttachment;
            }

        } catch (Exception e) {
            ApexPages.AddMessages(e);
            return null;
        }

        return new PageReference('/'+opportunity.Id);
    }

    public PageReference back() {
        return new PageReference('/'+opportunity.Id);
    }

    public List<SelectOption> getDocumentTypeList() {
        documentTypeList = new List<SelectOption>();
        Schema.DescribeFieldResult metadata = Opportunity_Attachment__c.Document_Type__c.getDescribe();
        List<Schema.PickListEntry> metadataPickList = metadata.getPickListValues();
        documentTypeList.add(new SelectOption('','None'));
        for(Schema.PickListEntry obj: metadataPickList){
            documentTypeList.add(new SelectOption(obj.getLabel(),obj.getValue()));
        }
        return documentTypeList;
    }

}