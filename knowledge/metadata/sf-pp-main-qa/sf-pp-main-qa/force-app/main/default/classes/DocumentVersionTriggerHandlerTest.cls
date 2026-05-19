/**
 * @description Test class for DocumentVersionTriggerHandler
 */
@isTest
public class DocumentVersionTriggerHandlerTest {
    
    /**
     * @description Test method to verify document title determination for all criteria
     */
    @isTest
    static void testDocumentTitleDetermination() {
        // Test all document title criteria through actual trigger execution
        Test.startTest();
        
        // Create test Agreement
        Apttus__APTS_Agreement__c testAgreement = new Apttus__APTS_Agreement__c();
        testAgreement.Name = 'Test Agreement';
        insert testAgreement;
        
        // Test Core EE Physician
        Apttus__APTS_Template__c template1 = new Apttus__APTS_Template__c();
        template1.Name = 'Test Core EE Physician Template';
        insert template1;
        
        Apttus__DocumentVersion__c docVersion1 = new Apttus__DocumentVersion__c();
        docVersion1.Apttus__AgreementId__c = testAgreement.Id;
        docVersion1.Apttus__TemplateId__c = template1.Id;
        docVersion1.Apttus__LatestVersion__c = 'true';
        docVersion1.Apttus__Title__c = 'Test Document Version';
        insert docVersion1;
        
        Apttus__APTS_Agreement__c updatedAgreement1 = [
            SELECT Id, Primary_Document_Title__c 
            FROM Apttus__APTS_Agreement__c 
            WHERE Id = :testAgreement.Id
        ];
        System.assertEquals('Core EE Physician', updatedAgreement1.Primary_Document_Title__c, 'Should match Core EE Physician');
        
        Test.stopTest();
    }
    
    /**
     * @description Test method to verify trigger functionality with actual record creation
     */
    @isTest
    static void testTriggerWithRecordCreation() {
        // Create test Agreement
        Apttus__APTS_Agreement__c testAgreement = new Apttus__APTS_Agreement__c();
        testAgreement.Name = 'Test Agreement';
        insert testAgreement;
        
        // Create test Template
        Apttus__APTS_Template__c testTemplate = new Apttus__APTS_Template__c();
        testTemplate.Name = 'Core EE Physician Template';
        insert testTemplate;
        
        Test.startTest();
        
        // Create DocumentVersion record to trigger the logic
        Apttus__DocumentVersion__c testDocVersion = new Apttus__DocumentVersion__c();
        testDocVersion.Apttus__AgreementId__c = testAgreement.Id;
        testDocVersion.Apttus__TemplateId__c = testTemplate.Id;
        testDocVersion.Apttus__LatestVersion__c = 'true';
        testDocVersion.Apttus__Title__c = 'Test Document Version';
        insert testDocVersion;
        
        Test.stopTest();
        
        // Verify that the Agreement's Primary_Document_Title__c was updated
        Apttus__APTS_Agreement__c updatedAgreement = [
            SELECT Id, Primary_Document_Title__c 
            FROM Apttus__APTS_Agreement__c 
            WHERE Id = :testAgreement.Id
        ];
        
        System.assertEquals('Core EE Physician', updatedAgreement.Primary_Document_Title__c, 
            'Primary_Document_Title__c should be updated to Core EE Physician');
    }
    
    /**
     * @description Test method to verify bulk processing
     */
    @isTest
    static void testBulkProcessing() {
        // Create test Agreements
        List<Apttus__APTS_Agreement__c> testAgreements = new List<Apttus__APTS_Agreement__c>();
        for (Integer i = 0; i < 5; i++) {
            Apttus__APTS_Agreement__c agreement = new Apttus__APTS_Agreement__c();
            agreement.Name = 'Test Agreement ' + i;
            testAgreements.add(agreement);
        }
        insert testAgreements;
        
        // Create test Templates
        List<Apttus__APTS_Template__c> testTemplates = new List<Apttus__APTS_Template__c>();
        String[] templateNames = new String[]{
            'Core EE Physician Template',
            'Core EE NPPA Template', 
            'Core IC Physician Template',
            'Core IC NPPA Template',
            'Addendum A Template'
        };
        
        for (Integer i = 0; i < 5; i++) {
            Apttus__APTS_Template__c template = new Apttus__APTS_Template__c();
            template.Name = templateNames[i];
            testTemplates.add(template);
        }
        insert testTemplates;
        
        Test.startTest();
        
        // Create multiple DocumentVersion records
        List<Apttus__DocumentVersion__c> testDocVersions = new List<Apttus__DocumentVersion__c>();
        for (Integer i = 0; i < 5; i++) {
            Apttus__DocumentVersion__c docVersion = new Apttus__DocumentVersion__c();
            docVersion.Apttus__AgreementId__c = testAgreements[i].Id;
            docVersion.Apttus__TemplateId__c = testTemplates[i].Id;
            docVersion.Apttus__LatestVersion__c = 'true';
            docVersion.Apttus__Title__c = 'Test Document Version ' + i;
            testDocVersions.add(docVersion);
        }
        insert testDocVersions;
        
        Test.stopTest();
        
        // Verify that all Agreements were updated with correct document titles
        List<Apttus__APTS_Agreement__c> updatedAgreements = [
            SELECT Id, Primary_Document_Title__c 
            FROM Apttus__APTS_Agreement__c 
            WHERE Id IN :testAgreements
            ORDER BY Name
        ];
        
        String[] expectedTitles = new String[]{
            'Core EE Physician',
            'Core EE NPPA',
            'Core IC Physician', 
            'Core IC NPPA',
            'Addendum A'
        };
        
        for (Integer i = 0; i < updatedAgreements.size(); i++) {
            System.assertEquals(expectedTitles[i], updatedAgreements[i].Primary_Document_Title__c, 
                'Agreement ' + i + ' should have correct document title');
        }
    }
    
    /**
     * @description Test method to verify edge cases
     */
    @isTest
    static void testEdgeCases() {
        Test.startTest();
        
        // Create test Agreement
        Apttus__APTS_Agreement__c testAgreement = new Apttus__APTS_Agreement__c();
        testAgreement.Name = 'Test Agreement';
        insert testAgreement;
        
        // Test Addendum A-2 priority over Addendum A
        Apttus__APTS_Template__c template1 = new Apttus__APTS_Template__c();
        template1.Name = 'Addendum A-2 Template';
        insert template1;
        
        Apttus__DocumentVersion__c docVersion1 = new Apttus__DocumentVersion__c();
        docVersion1.Apttus__AgreementId__c = testAgreement.Id;
        docVersion1.Apttus__TemplateId__c = template1.Id;
        docVersion1.Apttus__LatestVersion__c = 'true';
        docVersion1.Apttus__Title__c = 'Test Document Version';
        insert docVersion1;
        
        Apttus__APTS_Agreement__c updatedAgreement1 = [
            SELECT Id, Primary_Document_Title__c 
            FROM Apttus__APTS_Agreement__c 
            WHERE Id = :testAgreement.Id
        ];
        System.assertEquals('Addendum A-2', updatedAgreement1.Primary_Document_Title__c, 'Addendum A-2 should take precedence over Addendum A');
        
        Test.stopTest();
    }
    
    /**
     * @description Test method to verify error handling
     */
    @isTest
    static void testErrorHandling() {
        Test.startTest();
        
        // Test with null DocumentVersion list
        DocumentVersionTriggerHandler.handleAfterInsert(null);
        
        // Test with empty DocumentVersion list
        DocumentVersionTriggerHandler.handleAfterInsert(new List<Apttus__DocumentVersion__c>());
        
        Test.stopTest();
        
        // No exceptions should be thrown
        System.assert(true, 'Error handling should prevent exceptions');
    }
    
    /**
     * @description Test method to cover Addendum A-2 logic (lines 136-137)
     */
    @isTest
    static void testAddendumA2Logic() {
        // Create test Agreement
        Apttus__APTS_Agreement__c testAgreement = new Apttus__APTS_Agreement__c();
        testAgreement.Name = 'Test Agreement A-2';
        insert testAgreement;
        
        // Create test Template with Addendum A-2
        Apttus__APTS_Template__c template = new Apttus__APTS_Template__c();
        template.Name = 'Addendum A-2 Template';
        insert template;
        
        Test.startTest();
        
        Apttus__DocumentVersion__c docVersion = new Apttus__DocumentVersion__c();
        docVersion.Apttus__AgreementId__c = testAgreement.Id;
        docVersion.Apttus__TemplateId__c = template.Id;
        docVersion.Apttus__LatestVersion__c = 'true';
        docVersion.Apttus__Title__c = 'Test Document Version A-2';
        insert docVersion;
        
        Test.stopTest();
        
        // Verify that the Agreement's Primary_Document_Title__c was updated to Addendum A-2
        Apttus__APTS_Agreement__c updatedAgreement = [
            SELECT Id, Primary_Document_Title__c 
            FROM Apttus__APTS_Agreement__c 
            WHERE Id = :testAgreement.Id
        ];
        
        System.assertEquals('Addendum A-2', updatedAgreement.Primary_Document_Title__c, 
            'Primary_Document_Title__c should be updated to Addendum A-2');
    }
    
    /**
     * @description Test method to cover Addendum B logic (lines 141-142)
     */
    @isTest
    static void testAddendumBLogic() {
        // Create test Agreement
        Apttus__APTS_Agreement__c testAgreement = new Apttus__APTS_Agreement__c();
        testAgreement.Name = 'Test Agreement B';
        insert testAgreement;
        
        // Create test Template with Addendum B
        Apttus__APTS_Template__c template = new Apttus__APTS_Template__c();
        template.Name = 'Addendum B Template';
        insert template;
        
        Test.startTest();
        
        Apttus__DocumentVersion__c docVersion = new Apttus__DocumentVersion__c();
        docVersion.Apttus__AgreementId__c = testAgreement.Id;
        docVersion.Apttus__TemplateId__c = template.Id;
        docVersion.Apttus__LatestVersion__c = 'true';
        docVersion.Apttus__Title__c = 'Test Document Version B';
        insert docVersion;
        
        Test.stopTest();
        
        // Verify that the Agreement's Primary_Document_Title__c was updated to Addendum B
        Apttus__APTS_Agreement__c updatedAgreement = [
            SELECT Id, Primary_Document_Title__c 
            FROM Apttus__APTS_Agreement__c 
            WHERE Id = :testAgreement.Id
        ];
        
        System.assertEquals('Addendum B', updatedAgreement.Primary_Document_Title__c, 
            'Primary_Document_Title__c should be updated to Addendum B');
    }
    
    /**
     * @description Test method to cover unknown template name logic (line 100)
     */
    @isTest
    static void testUnknownTemplateName() {
        // Create test Agreement
        Apttus__APTS_Agreement__c testAgreement = new Apttus__APTS_Agreement__c();
        testAgreement.Name = 'Test Agreement Unknown';
        insert testAgreement;
        
        // Create test Template with unknown name that won't match any criteria
        Apttus__APTS_Template__c template = new Apttus__APTS_Template__c();
        template.Name = 'Unknown Template Type'; // Name that won't match any criteria
        insert template;
        
        Test.startTest();
        
        Apttus__DocumentVersion__c docVersion = new Apttus__DocumentVersion__c();
        docVersion.Apttus__AgreementId__c = testAgreement.Id;
        docVersion.Apttus__TemplateId__c = template.Id;
        docVersion.Apttus__LatestVersion__c = 'true';
        docVersion.Apttus__Title__c = 'Test Document Version Unknown';
        insert docVersion;
        
        Test.stopTest();
        
        // Verify that the Agreement's Primary_Document_Title__c was NOT updated (should remain null)
        Apttus__APTS_Agreement__c updatedAgreement = [
            SELECT Id, Primary_Document_Title__c 
            FROM Apttus__APTS_Agreement__c 
            WHERE Id = :testAgreement.Id
        ];
        
        System.assertEquals(null, updatedAgreement.Primary_Document_Title__c, 
            'Primary_Document_Title__c should remain null for unknown template name');
    }
    
    /**
     * @description Test method to cover additional template types for comprehensive coverage
     */
    @isTest
    static void testAdditionalTemplateTypes() {
        // Create test Agreement
        Apttus__APTS_Agreement__c testAgreement = new Apttus__APTS_Agreement__c();
        testAgreement.Name = 'Test Agreement Additional';
        insert testAgreement;
        
        // Test Addendum E
        Apttus__APTS_Template__c templateE = new Apttus__APTS_Template__c();
        templateE.Name = 'Addendum E Template';
        insert templateE;
        
        Test.startTest();
        
        Apttus__DocumentVersion__c docVersion = new Apttus__DocumentVersion__c();
        docVersion.Apttus__AgreementId__c = testAgreement.Id;
        docVersion.Apttus__TemplateId__c = templateE.Id;
        docVersion.Apttus__LatestVersion__c = 'true';
        docVersion.Apttus__Title__c = 'Test Document Version E';
        insert docVersion;
        
        Test.stopTest();
        
        // Verify that the Agreement's Primary_Document_Title__c was updated to Addendum E
        Apttus__APTS_Agreement__c updatedAgreement = [
            SELECT Id, Primary_Document_Title__c 
            FROM Apttus__APTS_Agreement__c 
            WHERE Id = :testAgreement.Id
        ];
        
        System.assertEquals('Addendum E', updatedAgreement.Primary_Document_Title__c, 
            'Primary_Document_Title__c should be updated to Addendum E');
    }
    
    /**
     * @description Test method to cover Virtual RN templates
     */
    @isTest
    static void testVirtualRNTemplates() {
        // Create test Agreement
        Apttus__APTS_Agreement__c testAgreement = new Apttus__APTS_Agreement__c();
        testAgreement.Name = 'Test Agreement Virtual';
        insert testAgreement;
        
        // Test Virtual RN FT
        Apttus__APTS_Template__c templateFT = new Apttus__APTS_Template__c();
        templateFT.Name = 'Virtual RN FT Template';
        insert templateFT;
        
        Test.startTest();
        
        Apttus__DocumentVersion__c docVersion = new Apttus__DocumentVersion__c();
        docVersion.Apttus__AgreementId__c = testAgreement.Id;
        docVersion.Apttus__TemplateId__c = templateFT.Id;
        docVersion.Apttus__LatestVersion__c = 'true';
        docVersion.Apttus__Title__c = 'Test Document Version Virtual FT';
        insert docVersion;
        
        Test.stopTest();
        
        // Verify that the Agreement's Primary_Document_Title__c was updated to Virtual RN FT
        Apttus__APTS_Agreement__c updatedAgreement = [
            SELECT Id, Primary_Document_Title__c 
            FROM Apttus__APTS_Agreement__c 
            WHERE Id = :testAgreement.Id
        ];
        
        System.assertEquals('Virtual RN FT', updatedAgreement.Primary_Document_Title__c, 
            'Primary_Document_Title__c should be updated to Virtual RN FT');
    }
}