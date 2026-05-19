/**
 * @description Handler class for DocumentVersionTrigger
 * Updates Primary_Document_Title__c field on Agreement records based on Template name matching criteria
 */
public with sharing class DocumentVersionTriggerHandler {
    
    /**
     * @description Handles after insert trigger logic
     * @param newDocumentVersions List of newly inserted DocumentVersion records
     */
    public static void handleAfterInsert(List<Apttus__DocumentVersion__c> newDocumentVersions) {
        try {
            updateAgreementDocumentTitles(newDocumentVersions);
        } catch (Exception e) {
            System.debug('Error in DocumentVersionTriggerHandler.handleAfterInsert: ' + e.getMessage());
            // Log error but don't fail the transaction
        }
    }
    
    /**
     * @description Updates Primary_Document_Title__c field on Agreement records based on Template name criteria
     * @param documentVersions List of DocumentVersion records to process
     */
    private static void updateAgreementDocumentTitles(List<Apttus__DocumentVersion__c> documentVersions) {
        // Collect Agreement IDs and Template IDs for bulk processing
        Set<Id> agreementIds = new Set<Id>();
        Set<Id> templateIds = new Set<Id>();
        
        for (Apttus__DocumentVersion__c docVersion : documentVersions) {
            if (docVersion.Apttus__AgreementId__c != null) {
                agreementIds.add(docVersion.Apttus__AgreementId__c);
            }
            if (docVersion.Apttus__TemplateId__c != null) {
                templateIds.add(docVersion.Apttus__TemplateId__c);
            }
        }
        
        if (agreementIds.isEmpty() || templateIds.isEmpty()) {
            return;
        }
        
        // Query Templates with their names
        Map<Id, Apttus__APTS_Template__c> templateMap = new Map<Id, Apttus__APTS_Template__c>([
            SELECT Id, Name 
            FROM Apttus__APTS_Template__c 
            WHERE Id IN :templateIds
        ]);
        
        // Query Agreements that need to be updated
        List<Apttus__APTS_Agreement__c> agreementsToUpdate = [
            SELECT Id, Primary_Document_Title__c 
            FROM Apttus__APTS_Agreement__c 
            WHERE Id IN :agreementIds
        ];
        
        // Create a map of DocumentVersion to Agreement for processing
        Map<Id, Id> docVersionToAgreementMap = new Map<Id, Id>();
        for (Apttus__DocumentVersion__c docVersion : documentVersions) {
            if (docVersion.Apttus__AgreementId__c != null) {
                docVersionToAgreementMap.put(docVersion.Id, docVersion.Apttus__AgreementId__c);
            }
        }
        
        // Process each DocumentVersion and determine the appropriate document title
        Map<Id, String> agreementIdToDocumentTitle = new Map<Id, String>();
        
        for (Apttus__DocumentVersion__c docVersion : documentVersions) {
            if (docVersion.Apttus__AgreementId__c != null && docVersion.Apttus__TemplateId__c != null) {
                Apttus__APTS_Template__c template = templateMap.get(docVersion.Apttus__TemplateId__c);
                if (template != null && String.isNotBlank(template.Name)) {
                    String documentTitle = determineDocumentTitle(template.Name);
                    if (String.isNotBlank(documentTitle)) {
                        agreementIdToDocumentTitle.put(docVersion.Apttus__AgreementId__c, documentTitle);
                    }
                }
            }
        }
        
        // Update Agreement records with the determined document titles
        List<Apttus__APTS_Agreement__c> agreementsToUpdateList = new List<Apttus__APTS_Agreement__c>();
        for (Apttus__APTS_Agreement__c agreement : agreementsToUpdate) {
            if (agreementIdToDocumentTitle.containsKey(agreement.Id)) {
                agreement.Primary_Document_Title__c = agreementIdToDocumentTitle.get(agreement.Id);
                agreementsToUpdateList.add(agreement);
            }
        }
        
        if (!agreementsToUpdateList.isEmpty()) {
            update agreementsToUpdateList;
        }
    }
    
    /**
     * @description Determines the document title based on template name matching criteria
     * @param templateName The name of the template
     * @return String The determined document title or null if no match
     */
    private static String determineDocumentTitle(String templateName) {
        if (String.isBlank(templateName)) {
            return null;
        }
        
        String templateNameLower = templateName.toLowerCase();
        
        // 1. Core EE Physician
        if (templateNameLower.contains('core ee physician')) {
            return 'Core EE Physician';
        }
        
        // 2. Core EE NPPA
        if (templateNameLower.contains('core ee nppa')) {
            return 'Core EE NPPA';
        }
        
        // 3. Core IC Physician
        if (templateNameLower.contains('core ic physician')) {
            return 'Core IC Physician';
        }
        
        // 4. Core IC NPPA
        if (templateNameLower.contains('core ic nppa')) {
            return 'Core IC NPPA';
        }
        
        // 5. Addendum A (but not A-2)
        if (templateNameLower.contains('addendum a') && !templateNameLower.contains('a-2')) {
            return 'Addendum A';
        }
        
        // 6. Addendum A-2
        if (templateNameLower.contains('addendum a-2')) {
            return 'Addendum A-2';
        }
        
        // 7. Addendum B
        if (templateNameLower.contains('addendum b')) {
            return 'Addendum B';
        }
        
        // 8. Addendum E
        if (templateNameLower.contains('addendum e')) {
            return 'Addendum E';
        }
        
        // 9. Virtual RN FT
        if (templateNameLower.contains('virtual') && templateNameLower.contains('ft')) {
            return 'Virtual RN FT';
        }
        
        // 10. Virtual RN PT
        if (templateNameLower.contains('virtual') && templateNameLower.contains('pt')) {
            return 'Virtual RN PT';
        }
        
        return null;
    }
}