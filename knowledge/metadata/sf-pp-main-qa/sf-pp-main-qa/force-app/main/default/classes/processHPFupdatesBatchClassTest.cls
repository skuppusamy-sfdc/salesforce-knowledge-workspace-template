@isTest
private class processHPFupdatesBatchClassTest {
    
    /***************************************************************************************************************************
    * Method Name   : setupTestData
    * Description   : Creates test data including Accounts, Contracts, HPF records, and PNC records
    * Return Type   : void
    ***************************************************************************************************************************/
    @TestSetup
    static void setupTestData() {
        TestDataFactory factory = new TestDataFactory();
        Account clinicianAccount = factory.createServiceAccount(
            null,                    
            'TestClinician',         
            'Clinician',            
            true                     
        );
        Account serviceAccount = factory.createServiceAccount(
            'Test Facility',       
            null,                    
            'Service_Account',      
            true                     
        );
        Account corporateEntity = factory.createServiceAccount(
            'Test Corporate Entity',
            null,                    
            'Corporate_Entity',      
            true                     
        );
        Contact clinicianContact = factory.getOrCreateContact(clinicianAccount, 'TestClinician');
        HealthcareProvider healthcareProvider = factory.createHealthcareProvider(
            'Test Healthcare Provider',
            clinicianContact.Id,
            true
        );
        HealthcarePayerNetwork payerNetwork = factory.createHealthcarePayerNetwork(
            'Test Payer Network',
            corporateEntity.Id,
            true
        );
        Contract executedContract = factory.createClinicianContract(clinicianAccount, false);
        executedContract.Status = 'Draft';
        executedContract.StartDate = Date.today();
        executedContract.EndDate = Date.today().addYears(1);
        executedContract.Process_Previous_HPF_Inactivation__c = false;
        insert executedContract;
        
        executedContract.Status = 'Executed';
        Update executedContract;

        HealthcarePractitionerFacility oldHPF = factory.createHealthcarePractitionerFacility(
            'Old HPF Record',
            clinicianContact.Id,
            serviceAccount.Id,
            corporateEntity.Id,
            false
        );
        oldHPF.Status__c = 'Active';
        oldHPF.Contracting_Status__c = 'Draft';

        insert oldHPF;

        HealthcarePractitionerFacility newHPF = factory.createHealthcarePractitionerFacility(
            'New HPF Record',
            clinicianContact.Id,
            serviceAccount.Id,
            corporateEntity.Id,
            false
        );
        newHPF.Status__c = 'Active';
        newHPF.Contracting_Status__c = 'Draft';
        insert newHPF;

        ProviderNetworkContract pnc = factory.createPNC(
            executedContract.Id,
            healthcareProvider.Id,
            payerNetwork.Id,
            newHPF.Id,
            false
        );
        pnc.Deleted__c = false;
        pnc.StartDate = Date.today();
        pnc.EndDate = Date.today() + 100;
        insert pnc;
    }
    @isTest
    static void testSuccessfulHPFInactivation() {
        Test.startTest();
        Database.executeBatch(new processHPFupdatesBactchClass(), 200);
        Test.stopTest();
        List<HealthcarePractitionerFacility> oldHPFs = [
            SELECT Id, Status__c, Contracting_Status__c, TerminationDate, Name
            FROM HealthcarePractitionerFacility
            WHERE TerminationDate != null
        ];
		System.assertEquals(1, oldHPFs.size(), 'Expected one old HPF record');
    	System.assertEquals('Inactive', oldHPFs[0].Status__c, 'Old HPF should be Inactive');
    	System.assertEquals('Terminated', oldHPFs[0].Contracting_Status__c, 'Old HPF should be Terminated');
    	System.assertNotEquals(null, oldHPFs[0].TerminationDate, 'Termination date must be populated');
        List<HealthcarePractitionerFacility> newHPFs = [
            SELECT Id, Status__c, Contracting_Status__c, Name
            FROM HealthcarePractitionerFacility
            WHERE TerminationDate = null
        ];
        System.assertEquals(1, newHPFs.size(), 'Expected one new HPF record');
    	System.assertNotEquals('Inactive', newHPFs[0].Status__c, 'New HPF should remain active');
    }
    
     @isTest
        static void testFailureHPFInactivation() {
            processHPFupdatesBactchClass.forceHPFUpdateFailure = true;
            Test.startTest();
            Database.executeBatch(new processHPFupdatesBactchClass(), 200);
            Test.stopTest();
            List<HealthcarePractitionerFacility> allHPFs = [ SELECT Id, Status__c, Contracting_Status__c, TerminationDate, Name
            													FROM HealthcarePractitionerFacility
            													WHERE TerminationDate = null];
            System.assertEquals(2, allHPFs.size(), 'Both shall nothave the termination date populated');
    		
            
        }
    
    
}