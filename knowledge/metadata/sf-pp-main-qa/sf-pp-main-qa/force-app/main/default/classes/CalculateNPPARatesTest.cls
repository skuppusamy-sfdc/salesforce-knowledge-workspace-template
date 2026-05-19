@IsTest
public class CalculateNPPARatesTest {
 @IsTest
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
        pca1.ContractPaymentAgreementId = cpa.Id;
        Insert pca1;
        
        PreventiveCareAgreement pca2 = TDF.createPCA(cpa.Id, false);
        pca2.Rate__c= 20;
        pca2.ContractPaymentAgreementId = cpa.Id;
        Insert pca2;
        
        
        List <PreventiveCareAgreement> testPCAList = new List <PreventiveCareAgreement>();
         testPCAList.add(pca1);
         testPCAList.add(pca2);
         
        CalculateNPPARates.InvocableInput objInvocableInput = new CalculateNPPARates.InvocableInput();
        objInvocableInput.PCAListToProcess = testPCAList;
        objInvocableInput.NPPATier = '100';
        
        CalculateNPPARates.InvocableInput objInvocableInput1 = new CalculateNPPARates.InvocableInput();
        objInvocableInput1.PCAListToProcess = testPCAList;
        objInvocableInput1.TimeType = 'Part Time';
        
        CalculateNPPARates.InvocableInput objInvocableInput2 = new CalculateNPPARates.InvocableInput();
        objInvocableInput2.PCAListToProcess = testPCAList;
        objInvocableInput2.NPPATier = '100';
        objInvocableInput2.TimeType = 'Part Time';
        
        // Call the main method
        Test.startTest();
        List<CalculateNPPARates.InvocableOutput> resultList = CalculateNPPARates.getCalculatedRates(new List<CalculateNPPARates.InvocableInput>{objInvocableInput});
        List<CalculateNPPARates.InvocableOutput> resultList1 = CalculateNPPARates.getCalculatedRates(new List<CalculateNPPARates.InvocableInput>{objInvocableInput1});
        List<CalculateNPPARates.InvocableOutput> resultList2 = CalculateNPPARates.getCalculatedRates(new List<CalculateNPPARates.InvocableInput>{objInvocableInput2});
        Test.stopTest();
        
       	//System.debug('Result from CalculateNPPARates: ' + resultList);
        //System.debug('Result from CalculateNPPARates1: ' + resultList1);
        //System.debug('Result from CalculateNPPARates2: ' + resultList2);
        
        // ========== ASSERTIONS ==========
        System.assertNotEquals(0, resultList.size(), 'Output list should not be empty');
        System.assertNotEquals(0, resultList1.size(), 'Output list should not be empty');
        System.assertNotEquals(0, resultList1.size(), 'Output list should not be empty');
        
    }
    
    
    
}