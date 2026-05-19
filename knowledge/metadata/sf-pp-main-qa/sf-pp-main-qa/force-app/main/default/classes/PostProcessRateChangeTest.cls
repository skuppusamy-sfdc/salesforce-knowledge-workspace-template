@IsTest
private class PostProcessRateChangeTest {

    @TestSetup
    static void setupTestData() {
        TestDataFactory TDF = new TestDataFactory();
        
        // Only create essential records needed across tests
        Account serviceAcc = TDF.createServiceAccount('Test Service Account', null, 'Service_Account', true);
        Account clinicianAcc = TDF.createServiceAccount(null, 'Test Clinician', 'Clinician', true);
        Contact clinicianCon = TDF.getOrCreateContact(clinicianAcc, 'Test Contact');
        Contract clinicianContract = TDF.createClinicianContract(clinicianAcc, true);

        // Insert Clinical_Rate_Change__c for testing
        Clinical_Rate_Change__c crc = TDF.createClinicalRateChangeNew(serviceAcc.Id, clinicianContract.Id, true);
    }

    @IsTest
    static void testSendEmailInvocable() {

        // 1. Query essential records from TestSetup
        Contract con = [SELECT Id, Name, AccountId FROM Contract LIMIT 1];

        // 2. Insert DocGenerationBatchProcess
        DocGenerationBatchProcess batch = new DocGenerationBatchProcess(
            Description = con.Id // simulate contract Id in description
        );
        insert batch;

        // 3. Insert dummy ContentVersion (valid PDF content)
        ContentVersion cv = new ContentVersion(
            Title = 'Test Template',
            PathOnClient = 'TestTemplate.pdf',
            VersionData = Blob.valueOf('Dummy PDF Content')
        );
        insert cv;

        // 4. Re-query ContentVersion to get LatestPublishedVersionId
        cv = [
            SELECT Id, ContentDocument.LatestPublishedVersionId
            FROM ContentVersion
            WHERE Id = :cv.Id
            LIMIT 1
        ];
        Id publishedVersionId = cv.ContentDocument.LatestPublishedVersionId;
        System.assertNotEquals(null, publishedVersionId, 'PublishedVersionId must not be null');

        // 5. Insert DocumentGenerationProcess with TokenData and RequestText
        DocumentGenerationProcess dgp = new DocumentGenerationProcess(
            ReferenceObject = con.Id,
            DocGenerationBatchProcessId = batch.Id,
            Status = 'InProgress',
            TokenData = '{}',
            RequestText = '{"keepIntermediate":false,"title":"TestDoc","templateContentVersionId":"' 
                           + publishedVersionId + '"}'
        );
        insert dgp;

        // 6. Insert Clinical_Rate_Change__c linked to batch
        Clinical_Rate_Change__c crc = new Clinical_Rate_Change__c(
            DocGenerationBatchProcessId__c = batch.Id,
            Service_Account_ID__c = con.AccountId
        );
        insert crc;

        // 7. Build input wrapper for invocable method
        PostProcessRateChange.RateChangeEmailWrapper wrapper = new PostProcessRateChange.RateChangeEmailWrapper();
        wrapper.docGenerationBatchProcessId = batch.Id;
        wrapper.templateId = publishedVersionId;

        Test.startTest();
        PostProcessRateChange.sendEmailInvocable(
            new List<PostProcessRateChange.RateChangeEmailWrapper>{wrapper}
        );
        Test.stopTest();

        // 8. Verify DGP inserted
        List<DocumentGenerationProcess> dgps = [SELECT Id FROM DocumentGenerationProcess];
        System.assertEquals(1, dgps.size(), 'Should have one DocumentGenerationProcess');
    }
}