@isTest
public class PCATriggerHandlerTest {
    @isTest
    static void setupTestData() {
        TestDataFactoryCore tdf = new TestDataFactoryCore();
        
        // Create Service Account (Business Account)
        Account serviceAcc = TDF.createServiceAccount('Test Service Account', null, 'Service_Account', true);
        
        // Create Clinician Person Account
        Account clinicianAcc = TDF.createServiceAccount(null, 'Test Clinician', 'Clinician', true);
        
        // Create Corporate Account
        Account corporateEntity = TDF.createServiceAccount('Test Corporate Entity', null, 'Corporate_Entity', true);
        
        // Create Contact for Clinician 
        Contact clinicianCon = TDF.getOrCreateContact(clinicianAcc, 'Test Contact');
        
        // Create Contract under Clinician Account 
        Contract clinicianContract = TDF.createClinicianContract(clinicianAcc, true);
        
        // Create Healthcare Payer Network linked to Service Account
        HealthcarePayerNetwork hpn = TDF.createHealthcarePayerNetwork('Test Payer Network', serviceAcc.Id, true);
        
        // Create Healthcare Provider linked to Clinician Contact
        HealthcareProvider hp = TDF.createHealthcareProvider('Physician Provider', clinicianCon.Id, true);
        
        // Create Healthcare Practitioner Facility
        HealthcarePractitionerFacility hpf = TDF.createHealthcarePractitionerFacility(
            'Test HPF', clinicianCon.Id, serviceAcc.Id, serviceAcc.Id, true
        );
        
        // Create Provider Network Contract
        ProviderNetworkContract pnc = TDF.createPNC(clinicianContract.Id, hp.Id, hpn.Id, hpf.Id, true);
        
        // Create Contract Payment Agreement
        ContractPaymentAgreement cpa = TDF.createCPA('Test CPA', clinicianContract.Id, pnc.Id, true);
        
        // Create Preventive Care Agreement
        PreventiveCareAgreement pca1 = TDF.createPCA(cpa.Id, false);
        pca1.Rate__c= 10;
        pca1.Unit_of_Measure__c = 'per hour';
        pca1.ContractPaymentAgreementId = cpa.Id;
        Insert pca1;
        
        Test.startTest();
        delete pca1;
        Test.stopTest();
    }

}