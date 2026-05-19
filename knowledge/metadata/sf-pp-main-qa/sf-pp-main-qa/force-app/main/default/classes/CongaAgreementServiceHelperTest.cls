@isTest
public class CongaAgreementServiceHelperTest {
    
    public static Boolean updateAgreements = false; //needed to update agreement records for this test class

    @TestSetup
    static void setup() {
        
        Service_Line__c hmServiceLine = new Service_Line__c(
            Name = 'HM',
            Type__c = 'Parent Service Line'
        );
        insert hmServiceLine;
        
        Service_Line__c ccServiceLine = new Service_Line__c(
            Name = 'CC',
            Parent__c = hmServiceLine.Id,
            Type__c = 'Service Line'
        );	
        insert ccServiceLine;

        CodeSet csFacilityTitle = new CodeSet(
            Name = 'Test Facility Title',
            Code = 'Test Facility Title',
            CodeSetType = 'Facility Title',
            Code_Set_Sub_Type__c = 'Independent Contractor', 
            Can_Have_Leadership_Incentive__c = true,
            IsActive = true 
        );

        CodeSet csBonusType = new CodeSet(
            Name = 'Sign On Bonus', 
            Code_Set_Sub_Type__c = 'Employee',
            Code = 'Sign On Bonus',
            CodeSetType = 'Bonus', 
            IsActive = true 
        );
        
        CodeSet csShiftBonus = new CodeSet(
            Name = 'Shift Bonus', 
            Code = 'Shift Bonus', 
            CodeSetType = 'Shift',
            IsActive = true 
        );
        
        CodeSet csNightShift = new CodeSet(
            Name = 'Night', 
            Code = 'Night', 
            CodeSetType = 'Shift',
            IsActive = true 
        );
        
        CodeSet csVarType = new CodeSet(
            Name = 'Variable Pooled',
            Code = 'Variable Pooled',
            CodeSetType = 'Variable', 
            IsActive = true 
        );
        
        CodeSet csStipendType = new CodeSet(
            Name = 'Director Base Stipend',
            Code = 'Director Base Stipend',
            CodeSetType = 'Stipend', 
            IsActive = true 
        );
        
        CodeSet csVMSType = new CodeSet(
            Name = 'Variable Monthly Stipend',
            Code = 'Variable Monthly Stipend',
            CodeSetType = 'Stipend', 
            IsActive = true 
        );
        
        insert new List<CodeSet>{csFacilityTitle,csBonusType,csShiftBonus,csNightShift,csVarType,csStipendType,csVMSType};

        Account personAccount = new Account(
            FirstName = 'Test',
            LastName = 'Clinician',
            Professional_Title__pc = 'DO', 
            Service_Line__c = ccServiceLine.Id,
            RecordTypeId = CongaAgreementServiceHelper.clinicianAccRTId
        );
        
        Account personAccount2 = new Account(
            FirstName = 'Test2',
            LastName = 'Clinician2',
            Professional_Title__pc = 'DO', 
            Service_Line__c = ccServiceLine.Id,
            RecordTypeId = CongaAgreementServiceHelper.clinicianAccRTId
        );
        insert new List<Account>{personAccount,personAccount2};

        Contract setupContract = new Contract(
            AccountId = personAccount.Id,
            StartDate = System.today(),
            ContractTerm = 12
            // add agreement id here
        );
        insert setupContract;

        // Account for Locums Company
        Account locumsAccount = new Account(Name = 'Test Locums Co');
        insert locumsAccount;
        
        Shift__c shiftName = new Shift__c(
            Contract__c = setupContract.Id,
            Shift_Name__c = csShiftBonus.Id, 
            Shift_Iteration__c = 'Shift Bonus', 
            Shift_Day_of_the_Week__c = 'Monday',
            Shift_Start_Time__c = Time.newInstance(9, 0, 0, 0),
            Shift_End_Time__c = Time.newInstance(17, 0, 0, 0),
            Type__c = 'NP/PA' 
        );
        insert shiftName; 

        Shift__c nightShift = new Shift__c(
            Contract__c = setupContract.Id,
            Shift_Name__c = csNightShift.Id, 
            Shift_Iteration__c = 'Night', 
            Shift_Day_of_the_Week__c = 'Monday',
            Shift_Start_Time__c = Time.newInstance(19, 0, 0, 0),
            Shift_End_Time__c = Time.newInstance(7, 0, 0, 0),
            Type__c = 'NP/PA' 
        );
        insert nightShift;
    }

    @isTest
    static void testIndependentContractor() {
        updateAgreements = true;
        Account personAccount = [SELECT Id, Name, PersonContactId FROM Account WHERE FirstName = 'Test'];
        Account personAccount2 = [SELECT Id, Name, PersonContactId FROM Account WHERE FirstName = 'Test2'];
        Service_Line__c servLineRec = [SELECT Id, Name, Type__c FROM Service_Line__c WHERE Name = 'HM' LIMIT 1];
        Service_Line__c ccServLineRec = [SELECT Id, Name, Type__c FROM Service_Line__c WHERE Name = 'CC' LIMIT 1];
        Service_Line__c servLineRec2Parent = servLineRec.clone(false,true);
        servLineRec2Parent.Name = 'EM';
        servLineRec2Parent.Type__c = 'Parent Service Line';
        insert servLineRec2Parent;
        
        Service_Line__c servLineRec2 = servLineRec.clone(false,true);
        servLineRec2.Name = 'EM';
        servLineRec2.Type__c = 'Service Line';
        servLineRec2.Parent__c = servLineRec2Parent.Id;
        insert servLineRec2;

        CodeSet csFacilityTitle, csBonusType, csVarType, csStipendType, csVMSType;
        for (CodeSet csRec : [SELECT Id,Name FROM CodeSet WHERE Name IN ('Test Facility Title','Sign On Bonus','Variable Pooled','Director Base Stipend','Variable Monthly Stipend')]){
            if (csRec.Name == 'Test Facility Title'){
                csFacilityTitle = csRec;
            } else if (csRec.Name == 'Sign On Bonus'){
                csBonusType = csRec;
            } else if (csRec.Name == 'Variable Pooled'){
                csVarType = csRec;
            } else if (csRec.Name == 'Director Base Stipend'){
                csStipendType = csRec;
            } else if (csRec.Name == 'Variable Monthly Stipend'){
                csVMSType = csRec;
            }
        }
        //CodeSet csFacilityTitle = [SELECT Id FROM CodeSet WHERE Name = 'Test Facility Title'];
        //CodeSet csPCAType = [SELECT Id, Name FROM CodeSet WHERE Name = 'Sign On Bonus'];
        //CodeSet csVarType = [SELECT Id, Name FROM CodeSet WHERE Name = 'Variable Pooled'];
        
        Shift__c nightShift = [SELECT Id,Contract__c,Shift_Name__c,Shift_Iteration__c,Shift_Day_of_the_Week__c,
                               Shift_Start_Time__c,Shift_End_Time__c FROM Shift__c WHERE Shift_Name__r.Name = 'Night'];
        
        // Independent
        Contract contRec = new Contract(
            AccountId = personAccount.Id,
            Employment_Type__c = 'Independent Contractor',
            Time_Type__c = 'Full Time',
            StartDate = System.today().addDays(4),
            ContractTerm = 12
        );
        insert contRec;

        Contract contRec2 = [SELECT Id,AccountId,StartDate,ContractTerm,Employment_Type__c,Time_Type__c FROM Contract LIMIT 1];
        contRec2.AccountId = personAccount2.Id;
        contRec2.Employment_Type__c = 'Independent Contractor';
        contRec2.Time_Type__c = 'Full Time';
        update contRec2;
        
        Corporation_and_Tax_Information__c corpTax = new Corporation_and_Tax_Information__c(
            Clinician__c = personAccount.PersonContactId,
            Corporation_Name__c = 'Test Corp Inc.',
            Status__c = 'Executed',
            Type__c = 'Business Entity',
            Effective_Date__c = System.today(),
            Expiration_Date__c = System.today().addMonths(12)
        );        
        insert corpTax;
        
        Account serviceAcct = new Account(
        	Name = 'Test Service Account 1',
            RecordTypeId = CongaAgreementServiceHelper.serviceAccRTId,
            BillingStreet = '18160 San Pedro Ave',
            BillingCity = 'San Antonio',
            BillingStateCode = 'TX',
            BillingPostalCode = '78232',
            BillingCountryCode = 'US',
            Phone = '2104957800',
            Service_Line__c = ccServLineRec.Id
        );
        
        Account serviceAcct2 = serviceAcct.clone(false,true);
        serviceAcct2.Name = 'Test Service Account 2';
        serviceAcct2.Client_Owner_Type__c = 'Christus JV';
        serviceAcct2.Service_Line__c = servLineRec2.Id;
        
        Account corpEntityAcct = new Account(
        	Name = 'Test Corporate Entity Account 1',
            RecordTypeId = CongaAgreementServiceHelper.corpEntAccRTId,
            BillingStreet = '2101 Abbott Rd',
            BillingCity = 'Anchorage',
            BillingStateCode = 'AK',
            BillingPostalCode = '99507',
            BillingCountryCode = 'US',
            Phone = '9072728424'
        );
        
        Account corpEntityAcct2 = new Account(
        	Name = 'Test Corporate Entity Account 2',
            RecordTypeId = CongaAgreementServiceHelper.corpEntAccRTId,
            BillingStreet = '1866 Burton Avenue',
            BillingCity = 'Memphis',
            BillingStateCode = 'TN',
            BillingPostalCode = '38128',
            BillingCountryCode = 'US',
            Phone = '9016389830'
        );
        
        Account payerAcc = new Account();
        payerAcc.Name = 'Test Payer Account';        
        
        insert new List<Account>{serviceAcct,serviceAcct2,corpEntityAcct,corpEntityAcct2,payerAcc};
        
        HealthcareProvider hpRec = new HealthcareProvider(
            Name = 'Test HP Record',
            PractitionerId = personAccount.PersonContactId
        );
        insert hpRec;
        
        HealthcarePayerNetwork hpnRec = new HealthcarePayerNetwork(
            Name = 'Test HPN Record',
            PayerId = payerAcc.Id
        );
        insert hpnRec;
        
        // HPF
        HealthcarePractitionerFacility hpfRec = new HealthcarePractitionerFacility(
            AccountId = serviceAcct.Id,
            PractitionerId = personAccount.PersonContactId,
            Facility_Title__c = csFacilityTitle.Id,
            No_of_Hours_Anticipated_to_Work__c = 40,
			Contracting_Corporate_Entity__c = corpEntityAcct.Id,            
            Name = 'Test HPF Record' 
        );
        
        HealthcarePractitionerFacility hpfRec2 = new HealthcarePractitionerFacility(
            AccountId = serviceAcct2.Id,
            PractitionerId = personAccount2.PersonContactId,
            Facility_Title__c = csFacilityTitle.Id,
            No_of_Hours_Anticipated_to_Work__c = 40,
            Contracting_Corporate_Entity__c = corpEntityAcct2.Id,
            Name = 'Test HPF Record 2' 
        );
        insert new List<HealthcarePractitionerFacility>{hpfRec,hpfRec2};
            
        ProviderNetworkContract pncRec = new ProviderNetworkContract(
            ContractId = contRec.Id,
            StartDate = Date.today().addDays(4),
            EndDate = Date.today().addMonths(12),
            HealthcarePayerNetworkId = hpnRec.Id, 
            HealthcareProviderId = hpRec.Id,
            Healthcare_Practitioner_Facility__c = hpfRec.Id
        );
        
        ProviderNetworkContract pncRec2 = new ProviderNetworkContract(
            ContractId = contRec2.Id,
            StartDate = Date.today().addDays(4),
            EndDate = Date.today().addMonths(12),
            HealthcarePayerNetworkId = hpnRec.Id, 
            HealthcareProviderId = hpRec.Id,
            Healthcare_Practitioner_Facility__c = hpfRec2.Id
        );
        insert new List<ProviderNetworkContract>{pncRec,pncRec2};
        
        hpfRec.Contracting_Corporate_Entity__c = corpEntityAcct.Id;
        hpfRec2.Contracting_Corporate_Entity__c = corpEntityAcct2.Id;
        update new List<HealthcarePractitionerFacility>{hpfRec,hpfRec2};
 		
        // CPA
        ContractPaymentAgreement cpaRec = new ContractPaymentAgreement(
            ContractId = contRec.Id,
            Type__c = 'Bonus',
            Name = 'Test CPA Bonus', 
            AgreementType = 'Preventive Care Agreement',
            Provider_Network_Contract__c = pncRec.Id
        );
        
        // CPA2
        ContractPaymentAgreement cpaRec2 = new ContractPaymentAgreement(
            ContractId = contRec2.Id,
            Type__c = 'Bonus',
            Name = 'Test CPA Bonus 2', 
            AgreementType = 'Preventive Care Agreement',
            Provider_Network_Contract__c = pncRec2.Id
        );
        
        // CPA3
        ContractPaymentAgreement cpaRec3 = new ContractPaymentAgreement(
            ContractId = contRec2.Id,
            Type__c = 'Variable',
            Name = 'Test CPA Variable 1', 
            AgreementType = 'Preventive Care Agreement',
            Provider_Network_Contract__c = pncRec2.Id
        );
        
		// CPA4
		ContractPaymentAgreement cpaRec4 = new ContractPaymentAgreement(
            ContractId = contRec2.Id,
            Type__c = 'Stipend',
            Name = 'Test CPA Stipend', 
            AgreementType = 'Preventive Care Agreement',
            Provider_Network_Contract__c = pncRec2.Id
        );
        
        // CPA5
		ContractPaymentAgreement cpaRec5 = new ContractPaymentAgreement(
            ContractId = contRec2.Id,
            Type__c = 'Leadership Incentives',
            Name = 'Test CPA LI 1', 
            AgreementType = 'Preventive Care Agreement',
            Provider_Network_Contract__c = pncRec2.Id
        );
		insert new List<ContractPaymentAgreement>{cpaRec,cpaRec2,cpaRec3,cpaRec4,cpaRec5};

        // PCA
        PreventiveCareAgreement pcaRec = new PreventiveCareAgreement(
            ContractPaymentAgreementId = cpaRec.Id,
            FacilityTitle__c = csFacilityTitle.Id,
            Type__c = csBonusType.Id, 
            Time_Type__c = 'Full Time',
            RVU_Metric_Type__c = 'wRVU',
            Rate__c = 10000,
            Shift__c = nightShift.Id, 
            Repayment_Terms__c = 'Pro Rata',
            Duration_Months__c = 12,
            BonusMeasureType = 'Test Bonus Type', 
            TargetMeasurePercent = 95, 
            BonusPayout = 5000 
        );
        
        // PCA2
        PreventiveCareAgreement pcaRec2 = new PreventiveCareAgreement(
            ContractPaymentAgreementId = cpaRec2.Id,
            FacilityTitle__c = csFacilityTitle.Id,
            Type__c = csFacilityTitle.Id, 
            Time_Type__c = 'Full Time',
            RVU_Metric_Type__c = 'wRVU',
            Rate__c = 10000,
            Shift__c = nightShift.Id, 
            Repayment_Terms__c = 'Pro Rata',
            Duration_Months__c = 12,
            BonusMeasureType = 'Test Shift Type', 
            TargetMeasurePercent = 95, 
            BonusPayout = 5000 
        );
        
        // PCA3
        PreventiveCareAgreement pcaRec3 = new PreventiveCareAgreement(
            ContractPaymentAgreementId = cpaRec3.Id,
            FacilityTitle__c = csFacilityTitle.Id,
            Type__c = csVarType.Id, 
            Time_Type__c = 'Full Time',
            RVU_Metric_Type__c = 'wRVU',
            Rate__c = 10000,
            Shift__c = nightShift.Id, 
            Repayment_Terms__c = 'Pro Rata',
            Duration_Months__c = 12,
            BonusMeasureType = 'Test Bonus Type', 
            TargetMeasurePercent = 95, 
            BonusPayout = 5000 
        ); 

        PreventiveCareAgreement pcaRec4 = new PreventiveCareAgreement(
            ContractPaymentAgreementId = cpaRec4.Id,
            FacilityTitle__c = csFacilityTitle.Id,
            Type__c = csStipendType.Id, 
            Time_Type__c = 'Full Time',
            RVU_Metric_Type__c = 'wRVU',
            Rate__c = 10000,
            Shift__c = nightShift.Id, 
            Repayment_Terms__c = 'Pro Rata',
            Duration_Months__c = 12,
            BonusMeasureType = 'Test Stipend Type', 
            TargetMeasurePercent = 95, 
            BonusPayout = 5000,
            Stipend_Tier__c = 'Tier 4'
        );
        
        PreventiveCareAgreement pcaRec5 = new PreventiveCareAgreement(
            ContractPaymentAgreementId = cpaRec5.Id,
            FacilityTitle__c = csFacilityTitle.Id,
            Type__c = csVMSType.Id, 
            Time_Type__c = 'Full Time',
            RVU_Metric_Type__c = 'wRVU',
            Rate__c = 10000,
            Shift__c = nightShift.Id, 
            Repayment_Terms__c = 'Pro Rata',
            Duration_Months__c = 12,
            BonusMeasureType = 'Test LI Type', 
            TargetMeasurePercent = 95, 
            BonusPayout = 5000,
            Stipend_Tier__c = 'Legacy'
        );
        insert new List<PreventiveCareAgreement>{pcaRec,pcaRec2,pcaRec3,pcaRec4,pcaRec5};
        
        contRec2.Contracting_Corporate_Entity__c = corpEntityAcct.Id;
        update contRec2;
        
        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Prospecting',
        	CloseDate = Date.today().addYears(1),
            AccountId = serviceAcct.Id,
            Christus_JV__c = true,
            RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Growth_Opportunity').getRecordTypeId()
        );
        insert opp;
        
        PartyRoleRelation prrRec = new PartyRoleRelation();
        prrRec.RoleName = 'Locums Company';
        prrRec.RelatedRoleName = 'Service Account';
        prrRec.RelationshipObjectName = 'Account_Account_Relationship';
        prrRec.ShouldCreaInversRoleAuto = false;
        insert prrRec;
        
        AccountAccountRelation aarRec = new AccountAccountRelation();
        aarRec.AccountId = corpEntityAcct.Id;
        aarRec.RelatedAccountId = serviceAcct.Id;
        aarRec.PartyRoleRelationId = prrRec.Id;
        aarRec.HierarchyType = 'Peer';
        insert aarRec;

        // Agreement
        Apttus__APTS_Agreement__c agreeRec = new Apttus__APTS_Agreement__c(
            Contract__c = contRec.Id,
            Shift_Name__c = 'NP/PA',
            Name = 'Test Agreement IC', 
            Apttus__Agreement_Category__c = 'Sales',
            Corporate_Entity__c = corpEntityAcct.Id
        );
        // Agreement 2
        Apttus__APTS_Agreement__c agreeRec2 = new Apttus__APTS_Agreement__c(
            Contract__c = contRec2.Id,
            Shift_Name__c = 'NP/PA',
            Name = 'Test Agreement IC 2', 
            Apttus__Agreement_Category__c = 'Sales',
            Corporate_Entity__c = corpEntityAcct2.Id
        );
        List<Apttus__APTS_Agreement__c> agreeList = new List<Apttus__APTS_Agreement__c>{agreeRec,agreeRec2};
        insert agreeList;  

        Test.startTest();
        
        /*List<Apttus__APTS_Agreement__c> agreeList = [
            SELECT Id, Contract__c, Contract__r.AccountId, Shift_Type__c, Shift_Name__c, Time_Type__c
            FROM Apttus__APTS_Agreement__c 
            WHERE Id = :agreeRec.Id OR Id = :agreeRec2.Id
        ];*/

       	CongaAgreementServiceHelper.congaServiceHelpCombined(agreeList);
        
        Test.stopTest();

        // Results
        Apttus__APTS_Agreement__c updatedAgree = [
            SELECT Id, Service_Line__c, Service_Line_Parent__c, Service_Account_Name__c, Clinician_Facility_Association__c, Facility_Title__c,
                   No_of_Hours_Anticipated_to_Work__c, Clinician_Contracting_With__c, 
                   Provider_Signature_Box__c, NPPA_EE_Flag__c, Night_Shift_Bonus_Count__c,
                   Bonus_Type__c, Rate__c, Half_Bonus_Amount__c, RVU_Metric_Type__c,
                   wRVU__c, Time_Type__c, Display_Addendum_A__c, Display_Addendum_A_2__c,
                   Repayment_Terms__c, Duration_Months__c, Christus_JV__c, Stipend_Tier__c
            FROM Apttus__APTS_Agreement__c 
            WHERE Id = :agreeRec.Id
        ];
		
        System.assertEquals('Test Service Account 1', updatedAgree.Service_Account_Name__c, 'Service Account Name should be populated from Service Account.');
        System.assertEquals('CC', updatedAgree.Service_Line__c, 'Service Line should be populated from Service Account\'s related Service Line.');
        System.assertEquals('HM', updatedAgree.Service_Line_Parent__c, 'Service Line Parent should be populated from Service Account\'s related Service Line.');
            
        // HPF
        System.assertEquals(hpfRec.AccountId, updatedAgree.Clinician_Facility_Association__c, 'Clinician Facility Association should be populated.');
        System.assertEquals('Test Facility Title', updatedAgree.Facility_Title__c, 'Facility Title should be populated from HPF.');
        System.assertEquals('40', updatedAgree.No_of_Hours_Anticipated_to_Work__c, 'Hours should be populated from HPF.');
        System.assertEquals(true, updatedAgree.Christus_JV__c, 'Christus JV should be populated.');

        // Contractor
        System.assertEquals('Test Corp Inc.', updatedAgree.Clinician_Contracting_With__c, 'Clinician Contracting With should come from Corp Tax info.');
        System.assertEquals('Test Corp Inc.', updatedAgree.Provider_Signature_Box__c, 'Provider Signature Box should come from Corp Tax info.');

        // Shift
        // chck ths
        System.assertEquals(false, updatedAgree.NPPA_EE_Flag__c, 'NPPA EE Flag should be false.');
        System.assertEquals(false, updatedAgree.Night_Shift_Bonus_Count__c, 'Night Shift Bonus Count should be true.');

        // PCA
        String placeHolder = null;
        System.assertEquals('Sign On Bonus', updatedAgree.Bonus_Type__c, 'Bonus Type should be set from PCA Type ID.');
        System.assertEquals('10000.00', updatedAgree.Rate__c, 'Rate should be set from PCA.');
        System.assertEquals('5000.00', updatedAgree.Half_Bonus_Amount__c, 'Half Bonus should be calculated.');
        System.assertEquals(placeHolder, updatedAgree.RVU_Metric_Type__c, 'RVU Metric Type should be set.');
        System.assertEquals(false, updatedAgree.wRVU__c, 'wRVU flag should be false.');
        System.assertEquals('Full Time', updatedAgree.Time_Type__c, 'Time Type should be set.');
        System.assertEquals('Pro Rata', updatedAgree.Repayment_Terms__c, 'Repayment Terms should be set.');
        System.assertEquals('12', updatedAgree.Duration_Months__c, 'Duration Months should be set.');
        
        // Addendum
        // chck ths
        System.assertEquals(true, updatedAgree.Display_Addendum_A_2__c, 'Display Addendum A-2 should be true for Sign On Bonus.');
    }

    @isTest
    static void testEmployeeLogic() {
        updateAgreements = true;
        Account personAccount = [SELECT Id, Name, PersonContactId FROM Account WHERE FirstName = 'Test'];
        
        Contract contRec = new Contract(
            AccountId = personAccount.Id,
            Employment_Type__c = 'Employee', 
            StartDate = System.today().addDays(5),
            ContractTerm = 12
        );
        insert contRec;
        
        Apttus__APTS_Agreement__c agreeRec = new Apttus__APTS_Agreement__c(
            Contract__c = contRec.Id,
            Name = 'Test Agreement Employee', 
            Apttus__Agreement_Category__c = 'Sales' 
        );
        insert agreeRec;

        Test.startTest();
        
        List<Apttus__APTS_Agreement__c> agreeList = [
            SELECT Id, Contract__c, Contract__r.AccountId, Shift_Type__c, Shift_Name__c
            FROM Apttus__APTS_Agreement__c 
            WHERE Id = :agreeRec.Id
        ];

        // helper
        CongaAgreementServiceHelper.congaServiceHelpCombined(agreeList);
        
        Test.stopTest();

        Apttus__APTS_Agreement__c updatedAgree = [
            SELECT Clinician_Contracting_With__c, Provider_Signature_Box__c
            FROM Apttus__APTS_Agreement__c 
            WHERE Id = :agreeRec.Id
        ];

        System.assertEquals(personAccount.Name, updatedAgree.Clinician_Contracting_With__c, 'Clinician Contracting With should come from Person Account Name.');
        System.assertEquals('Test Clinician, DO', updatedAgree.Provider_Signature_Box__c, 'Provider Signature Box should be concatenated from Person Account fields.');
    }
}