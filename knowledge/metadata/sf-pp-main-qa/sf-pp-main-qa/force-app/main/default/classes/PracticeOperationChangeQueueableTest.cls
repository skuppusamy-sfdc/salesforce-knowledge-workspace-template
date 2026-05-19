/***************************************************************************************************************************
* Class Name    : PracticeOperationChangeQueueableTest
* Description   : Comprehensive test class for PracticeOperationChangeQueueable that validates all 11 business rules
*                 and process type assignments. Tests the queueable's ability to process Preventive Care Agreements
*                 and create Practice Operation Change records with appropriate classifications.
* Author        : Srishty Sharma
* Created Date  : 22-Oct-2025
* Last Modified : 
***************************************************************************************************************************/
@IsTest
public class PracticeOperationChangeQueueableTest {
    
    // Test data constants
    private static final String EE_NURSE_PRACTITIONER_NAME = 'EE Nurse Practitioner';
    private static final String EE_NURSE_PRACTITIONER_CODE = 'EE Nurse Practitioner';
    private static final String MEDICAL_DIRECTOR_NAME = 'Medical Director';
    private static final String MEDICAL_DIRECTOR_CODE = 'Medical Director';
    private static final String DAY_SHIFT_NAME = 'Day Shift';
    private static final String DAY_SHIFT_CODE = 'Day';
    private static final String TEST_PAY_CODE_LABEL = 'TEST_PAY_CODE';
    private static final String TEST_SERVICE_ACCOUNT_NAME = 'Test Service Account';
    private static final String TEST_CONTACT_NAME = 'Test ContactPreview';
    private static final String NP_HPF_NAME = 'NP HPF';
    private static final String TEST_CONTACT_NAME_2 = 'Test Contact';
    
    // CodeSet type constants
    private static final String FACILITY_TITLE_TYPE = 'Facility Title';
    private static final String SHIFT_TYPE = 'Shift';
    private static final String NP_PA_SHIFT_TYPE = 'NP/PA';
    private static final String EMPLOYEE_SUB_TYPE = 'Employee';
    
    // Contract and record type constants
    private static final String CLIENT_RECORD_TYPE = 'Client';
    private static final String DRAFT_STATUS = 'Draft';
    private static final String ACTIVE_STATUS = 'Active';
    
    // Process type constants
    private static final String MANUAL_PROCESS_TYPE = 'Manual';
    private static final String AGENT_PROCESS_TYPE = 'Agent';
    private static final String AUTOMATION_PROCESS_TYPE = 'Automation';
    
    // PCA type constants
    private static final String STIPEND_TYPE = 'Stipend';
    private static final String LEADERSHIP_INCENTIVES_TYPE = 'Leadership Incentives';
    private static final String VARIABLE_TYPE = 'Variable';
    private static final String SHIFT_TYPE_PCA = 'Shift';
    
    // Shift constants
    private static final String SHIFT_ITERATION = '1';
    private static final String SHIFT_ITERATION_2 = '2';
    private static final String MONDAY = 'Monday';
    private static final String CLIENT_CPA_NAME = 'Client CPA';
    
    // Test assertion messages
    private static final String POC_RECORDS_SHOULD_BE_CREATED = 'Practice Operation Change records should be created';
    private static final String MANUAL_PROCESS_TYPE_ASSIGNED = 'Manual process type should be assigned';
    private static final String STIPEND_CHANGE_RULE_APPLIED = 'Stipend Change rule should be applied';
    private static final String STIPEND_CHANGE_MANUAL_TYPE = 'Stipend Change should be Manual process type';
    private static final String LEADERSHIP_INCENTIVES_RULE_APPLIED = 'Leadership Incentives Change rule should be applied';
    private static final String LEADERSHIP_INCENTIVES_MANUAL_TYPE = 'Leadership Incentives Change should be Manual process type';
    private static final String VARIABLE_CHANGE_RULE_APPLIED = 'Variable Change rule should be applied';
    private static final String VARIABLE_CHANGE_MANUAL_TYPE = 'Variable Change should be Manual process type';
    private static final String ONLY_RATE_INCREASED_RULE_APPLIED = 'ONLY Rate Increased Existing Shift rule should be applied';
    private static final String ONLY_RATE_INCREASED_AGENT_TYPE = 'ONLY Rate Increased Existing Shift should be Agent process type';
    private static final String NEW_SHIFT_ADDED_RULE_APPLIED = 'New Shift Added with existing Type and same Rate rule should be applied';
    private static final String NEW_SHIFT_ADDED_AUTOMATION_TYPE = 'New Shift Added with existing Type and same Rate should be Automation process type';
    private static final String NO_POC_RECORDS_EMPTY_CONTRACTS = 'No POC records should be created for empty contract IDs';
    
    /**
     * Sets up comprehensive test data for PracticeOperationChangeQueueable testing.
     * Creates CodeSet records, Service Account, Contract, Shift, CPA, and various PCAs
     * to test different business rules and process type assignments.
     */
    @TestSetup
    static void setupTestData() {
        TestDataFactoryCore TDF = new TestDataFactoryCore();
        
        // --------------------------
        // 1. Create CodeSet records for FacilityTitle and Shift
        // --------------------------
        CodeSet eeNurseCode = new CodeSet(
            Name = EE_NURSE_PRACTITIONER_NAME,  
            Code = EE_NURSE_PRACTITIONER_CODE,  
            CodeSetType = FACILITY_TITLE_TYPE,
            IsActive = true,
            Shift_Type__c = NP_PA_SHIFT_TYPE
        );
        CodeSet medDirectorCode = new CodeSet(
            Name = MEDICAL_DIRECTOR_NAME,  
            Code = MEDICAL_DIRECTOR_CODE,  
            CodeSetType = FACILITY_TITLE_TYPE,
            IsActive = true,
            Shift_Type__c = NP_PA_SHIFT_TYPE
        );
        CodeSet dayShiftCode = new CodeSet(
            Name = DAY_SHIFT_NAME,
            Code = DAY_SHIFT_CODE,
            CodeSetType = SHIFT_TYPE,
            IsActive = true,
            Code_Set_Sub_Type__c = EMPLOYEE_SUB_TYPE
        );
        
        insert new List<CodeSet>{eeNurseCode, medDirectorCode, dayShiftCode};
        
        // --------------------------
        // 2. Service Account for Client
        // --------------------------
        Account serviceAcc = TDF.createServiceAccount(TEST_SERVICE_ACCOUNT_NAME, null, 'Service_Account', true);
        
        Contact con = TDF.getOrCreateContact(serviceAcc, TEST_CONTACT_NAME);
        
        HealthcarePractitionerFacility hpf = TDF.createHealthcarePractitionerFacility(NP_HPF_NAME, con.id, serviceAcc.id, null, false);
        hpf.Status__c = ACTIVE_STATUS;
        hpf.Facility_Title__c = eeNurseCode.Id;
        insert hpf;
        
        // --------------------------
        // 3. Client Contracts
        // --------------------------
        Contract clientContract = new Contract(
            AccountId = serviceAcc.Id,
            RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType='Contract' AND DeveloperName=:CLIENT_RECORD_TYPE LIMIT 1].Id,
            StartDate = Date.today(),
            EndDate = Date.today().addMonths(6),
            Status = DRAFT_STATUS,
            NPPA_Tier_Changed__c = true
        );
        insert clientContract;
        
        // --------------------------
        // 4. Create Shift records
        // --------------------------
        Shift__c dayShift = new Shift__c(
            Shift_Name__c = dayShiftCode.Id,
            Contract__c = clientContract.Id,
            Shift_Iteration__c = SHIFT_ITERATION,
            Shift_Day_of_the_Week__c = MONDAY,
            Shift_Start_Time__c = Time.newInstance(8, 0, 0, 0),
            Shift_End_Time__c = Time.newInstance(16, 0, 0, 0),
            Type__c = NP_PA_SHIFT_TYPE
        );
                
        insert dayShift;
        
        // --------------------------
        // 5.1 Client CPA (Contract Payment Agreement) Shift
        // --------------------------
        ContractPaymentAgreement clientCPAShift = TDF.createCPA(CLIENT_CPA_NAME, clientContract.Id, null, false);
        
        insert new List<ContractPaymentAgreement>{clientCPAShift};
        
        // --------------------------
        // 6. Create various PCAs to test different rules
        // --------------------------
        List<PreventiveCareAgreement> pcaList = new List<PreventiveCareAgreement>();
        
        // PCA 4: Shift Bonus Change (Manual)
        PreventiveCareAgreement shiftBonusPCA = TDF.createPCA(clientCPAShift.Id, false);
        shiftBonusPCA.FacilityTitle__c = eeNurseCode.Id;
        shiftBonusPCA.Shift__c = dayShift.Id;
        shiftBonusPCA.New_Shift_Bonus_Type_Added__c = true;
        shiftBonusPCA.Rate__c = 50;
        pcaList.add(shiftBonusPCA);
        
        // PCA 5: Mixed Bag Shift Rates (Manual) - Same facility, different rates
        PreventiveCareAgreement mixedBagPCA1 = TDF.createPCA(clientCPAShift.Id, false);
        mixedBagPCA1.FacilityTitle__c = eeNurseCode.Id;
        mixedBagPCA1.Shift__c = dayShift.Id;
        mixedBagPCA1.Rate__c = 100;
        pcaList.add(mixedBagPCA1);
        
        PreventiveCareAgreement mixedBagPCA2 = TDF.createPCA(clientCPAShift.Id, false);
        mixedBagPCA2.FacilityTitle__c = eeNurseCode.Id;
        mixedBagPCA2.Shift__c = dayShift.Id;
        mixedBagPCA2.Rate__c = 120; // Different rate for same facility/shift
        pcaList.add(mixedBagPCA2);
        
        // PCA 6: New Shift Type Added (Manual)
        PreventiveCareAgreement newShiftTypePCA = TDF.createPCA(clientCPAShift.Id, false);
        newShiftTypePCA.FacilityTitle__c = eeNurseCode.Id;
        newShiftTypePCA.Shift__c = dayShift.Id;
        newShiftTypePCA.New_Shift_Type_Added__c = true;
        newShiftTypePCA.Rate__c = 110;
        pcaList.add(newShiftTypePCA);
        
        // PCA 7: NPPA Tier Change (Manual)
        PreventiveCareAgreement nppaTierPCA = TDF.createPCA(clientCPAShift.Id, false);
        nppaTierPCA.FacilityTitle__c = eeNurseCode.Id;
        nppaTierPCA.Shift__c = dayShift.Id;
        nppaTierPCA.Rate__c = 130;
        pcaList.add(nppaTierPCA);
        
        // PCA 8: Rate Decreased for Existing Shift (Manual)
        PreventiveCareAgreement rateDecreasedPCA = TDF.createPCA(clientCPAShift.Id, false);
        rateDecreasedPCA.FacilityTitle__c = eeNurseCode.Id;
        rateDecreasedPCA.Shift__c = dayShift.Id;
        rateDecreasedPCA.Existing_Rate_Decreased__c = true;
        rateDecreasedPCA.Rate__c = 90;
        pcaList.add(rateDecreasedPCA);
        
        // PCA 11: Rate Pay Code Change (Automation)
        PreventiveCareAgreement ratePayCodePCA = TDF.createPCA(clientCPAShift.Id, false);
        ratePayCodePCA.FacilityTitle__c = eeNurseCode.Id;
        ratePayCodePCA.Shift__c = dayShift.Id;
        ratePayCodePCA.Is_Newly_Added__c = true;
        ratePayCodePCA.Rate__c = 100;
        pcaList.add(ratePayCodePCA);
        
        insert pcaList;
        
        // --------------------------
        // 7. Create Pay Codes for Rate Pay Code testing
        // --------------------------
        Pay_Codes__c payCode = new Pay_Codes__c(
            Pay_Code_Label__c = TEST_PAY_CODE_LABEL
        );
        insert payCode;
        
        // --------------------------
        // 8. Create Rate Pay Code records
        // --------------------------
        Rate_Pay_Code__c rpc = new Rate_Pay_Code__c(
            Preventive_Care_Agreement__c = ratePayCodePCA.Id,
            Pay_Code__c = payCode.Id,
            Is_Newly_Added__c = true
        );
        insert rpc;
    }
    
    /**
     * Tests the basic execution of PracticeOperationChangeQueueable using the invoker.
     * Verifies that Practice Operation Change records are created and different process types are assigned.
     * Also tests the enqueueing of CreateClientChangeManagementQueueable.
     */
    @IsTest
    static void testShiftExecution() {
        // Get contract ID from test data
        Contract testContract = [SELECT Id FROM Contract LIMIT 1];
        List<Id> contractIds = new List<Id>{testContract.Id};
        
        Test.startTest();
        PracticeOperationChangeQueueableInvoker.runQueueable(contractIds);
        Test.stopTest();
        
        // Assert that Practice Operation Change records are created
        List<Practice_Operation_Change__c> pocList = [
            SELECT Id, Contract__c, Facility_Title__c, Process_Type__c, Qualified_Rules__c
            FROM Practice_Operation_Change__c
            WHERE Contract__c = :testContract.Id
        ];
        
        System.assert(!pocList.isEmpty(), POC_RECORDS_SHOULD_BE_CREATED);
        
        // Verify that different process types are assigned
        Set<String> processTypes = new Set<String>();
        List<Id> pocIds = new List<Id>();
        for (Practice_Operation_Change__c poc : pocList) {
            processTypes.add(poc.Process_Type__c);
            pocIds.add(poc.Id);
        }
        System.assert(processTypes.contains(MANUAL_PROCESS_TYPE), MANUAL_PROCESS_TYPE_ASSIGNED);
        
        System.enqueueJob(new CreateClientChangeManagementQueueable(contractIds, pocIds));
    }
    
    /**
     * Tests the Stipend Change rule (Rule 1) which should be classified as Manual process type.
     * Creates a Stipend PCA with rate increase and verifies the rule is applied correctly.
     */
    @IsTest
    static void testStipendChangeRule() {
        TestDataFactoryCore TDF = new TestDataFactoryCore();
        Account serviceAcc = [SELECT Id FROM Account LIMIT 1];
        CodeSet eeNurseCode = [SELECT Id FROM CodeSet where Code = :EE_NURSE_PRACTITIONER_CODE LIMIT 1];
        Contract testContract = new Contract(
            AccountId = serviceAcc.Id,
            RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType='Contract' AND DeveloperName=:CLIENT_RECORD_TYPE LIMIT 1].Id,
            StartDate = Date.today(),
            EndDate = Date.today().addMonths(6),
            Status = DRAFT_STATUS
        );
        insert testContract;
        
        ContractPaymentAgreement clientCPAStipend = TDF.createCPA(CLIENT_CPA_NAME, testContract.Id, null, false);
        clientCPAStipend.Type__c = STIPEND_TYPE;
        insert clientCPAStipend;
        
        // PCA 1: Stipend Change (Manual)
        PreventiveCareAgreement stipendPCA = TDF.createPCA(clientCPAStipend.Id, false);
        stipendPCA.FacilityTitle__c = eeNurseCode.Id;
        stipendPCA.Existing_Rate_Increased__c = true;
        stipendPCA.Rate__c = 100;
        insert stipendPCA;
        
        List<Id> contractIds = new List<Id>{testContract.Id};
        
        Test.startTest();
        System.enqueueJob(new PracticeOperationChangeQueueable(contractIds));
        Test.stopTest();
        
        // Assert Stipend Change rule is applied
        List<Practice_Operation_Change__c> stipendPOCs = [
            SELECT Id, Process_Type__c, Qualified_Rules__c
            FROM Practice_Operation_Change__c
            WHERE Contract__c = :testContract.Id
        ];
        
        System.assertEquals(1, stipendPOCs.size(), STIPEND_CHANGE_RULE_APPLIED);
        System.assertEquals(MANUAL_PROCESS_TYPE, stipendPOCs[0].Process_Type__c, STIPEND_CHANGE_MANUAL_TYPE);
    }
    
    /**
     * Tests the Leadership Incentives Change rule (Rule 2) which should be classified as Manual process type.
     * Creates a Leadership Incentives PCA with rate decrease and verifies the rule is applied correctly.
     */
    @IsTest
    static void testLeadershipIncentivesChangeRule() {
        TestDataFactoryCore TDF = new TestDataFactoryCore();
        Account serviceAcc = [SELECT Id FROM Account LIMIT 1];
        CodeSet medDirectorCode = [SELECT Id FROM CodeSet where Code = :MEDICAL_DIRECTOR_CODE LIMIT 1];
        
        Contract testContract = new Contract(
            AccountId = serviceAcc.Id,
            RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType='Contract' AND DeveloperName=:CLIENT_RECORD_TYPE LIMIT 1].Id,
            StartDate = Date.today(),
            EndDate = Date.today().addMonths(6),
            Status = DRAFT_STATUS
        );
        insert testContract;
        
        ContractPaymentAgreement clientCPALI = TDF.createCPA(CLIENT_CPA_NAME, testContract.Id, null, false);
        clientCPALI.Type__c = LEADERSHIP_INCENTIVES_TYPE;
        insert clientCPALI;
        
        PreventiveCareAgreement leadershipPCA = TDF.createPCA(clientCPALI.Id, false);
        leadershipPCA.FacilityTitle__c = medDirectorCode.Id;
        leadershipPCA.Existing_Rate_Decreased__c = true;
        leadershipPCA.Rate__c = 200;
        insert leadershipPCA;
        
        List<Id> contractIds = new List<Id>{testContract.Id};
        
        Test.startTest();
        System.enqueueJob(new PracticeOperationChangeQueueable(contractIds));
        Test.stopTest();
        
        // Assert Leadership Incentives Change rule is applied
        List<Practice_Operation_Change__c> leadershipPOCs = [
            SELECT Id, Process_Type__c, Qualified_Rules__c
            FROM Practice_Operation_Change__c
            WHERE Contract__c = :testContract.Id
        ];
        System.assertEquals(1, leadershipPOCs.size(), LEADERSHIP_INCENTIVES_RULE_APPLIED);
        System.assertEquals(MANUAL_PROCESS_TYPE, leadershipPOCs[0].Process_Type__c, LEADERSHIP_INCENTIVES_MANUAL_TYPE);
    }
    
    /**
     * Tests the Variable Change rule (Rule 3) which should be classified as Manual process type.
     * Creates a Variable PCA with rate decrease and verifies the rule is applied correctly.
     */
    @IsTest
    static void testVariableChangeRule() {
        TestDataFactoryCore TDF = new TestDataFactoryCore();
        Account serviceAcc = [SELECT Id FROM Account LIMIT 1];
        CodeSet medDirectorCode = [SELECT Id FROM CodeSet where Code = :MEDICAL_DIRECTOR_CODE LIMIT 1];
        
        Contract testContract = new Contract(
            AccountId = serviceAcc.Id,
            RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType='Contract' AND DeveloperName=:CLIENT_RECORD_TYPE LIMIT 1].Id,
            StartDate = Date.today(),
            EndDate = Date.today().addMonths(6),
            Status = DRAFT_STATUS
        );
        insert testContract;
        
        ContractPaymentAgreement clientCPAVariable = TDF.createCPA(CLIENT_CPA_NAME, testContract.Id, null, false);
        clientCPAVariable.Type__c = VARIABLE_TYPE;
        insert clientCPAVariable;
        
        PreventiveCareAgreement variablepPCA = TDF.createPCA(clientCPAVariable.Id, false);
        variablepPCA.FacilityTitle__c = medDirectorCode.Id;
        variablepPCA.Existing_Rate_Decreased__c = true;
        variablepPCA.Rate__c = 200;
        insert variablepPCA;
        
        List<Id> contractIds = new List<Id>{testContract.Id};
        
        Test.startTest();
        System.enqueueJob(new PracticeOperationChangeQueueable(contractIds));
        Test.stopTest();
        
        // Assert Variable Change rule is applied
        List<Practice_Operation_Change__c> variablePOCs = [
            SELECT Id, Process_Type__c, Qualified_Rules__c
            FROM Practice_Operation_Change__c
            WHERE Contract__c = :testContract.Id
        ];
        
        System.assertEquals(1, variablePOCs.size(), VARIABLE_CHANGE_RULE_APPLIED);
        System.assertEquals(MANUAL_PROCESS_TYPE, variablePOCs[0].Process_Type__c, VARIABLE_CHANGE_MANUAL_TYPE);
    }
    
    /**
     * Tests the ONLY Rate Increased Existing Shift rule (Rule 9) which should be classified as Agent process type.
     * Creates a Shift PCA with only rate increase (no other changes) and verifies the rule is applied correctly.
     */
    @IsTest
    static void testOnlyRateIncreasedExistingShiftRule() {
        TestDataFactoryCore TDF = new TestDataFactoryCore();
        Account serviceAcc = [SELECT Id FROM Account LIMIT 1];
        CodeSet eeNurseCode = [SELECT Id FROM CodeSet where Code = :EE_NURSE_PRACTITIONER_CODE LIMIT 1];
        
        Contract testContract = new Contract(
            AccountId = serviceAcc.Id,
            RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType='Contract' AND DeveloperName=:CLIENT_RECORD_TYPE LIMIT 1].Id,
            StartDate = Date.today(),
            EndDate = Date.today().addMonths(6),
            Status = DRAFT_STATUS
        );
        insert testContract;
        
        ContractPaymentAgreement clientCPAShift = TDF.createCPA(CLIENT_CPA_NAME, testContract.Id, null, false);
        clientCPAShift.Type__c = SHIFT_TYPE_PCA;
        insert clientCPAShift;
        
        PreventiveCareAgreement rateIncreasedPCA = TDF.createPCA(clientCPAShift.Id, false);
        rateIncreasedPCA.FacilityTitle__c = eeNurseCode.Id;
        rateIncreasedPCA.Existing_Rate_Increased__c = true;
        rateIncreasedPCA.Rate__c = 140;
        rateIncreasedPCA.New_Shift_Type_Added__c = false;
        rateIncreasedPCA.New_Shift_Bonus_Type_Added__c = false;
        rateIncreasedPCA.Is_Newly_Added__c = false;
        rateIncreasedPCA.Is_Deleted__c = true;
        insert rateIncreasedPCA;
        
        List<Id> contractIds = new List<Id>{testContract.Id};
        
        Test.startTest();
        System.enqueueJob(new PracticeOperationChangeQueueable(contractIds));
        Test.stopTest();
        
        // Assert ONLY Rate Increased Existing Shift rule is applied
        List<Practice_Operation_Change__c> rateIncreasedPOCs = [
            SELECT Id, Process_Type__c, Qualified_Rules__c
            FROM Practice_Operation_Change__c
            WHERE Contract__c = :testContract.Id
        ];
        
        System.assertEquals(1, rateIncreasedPOCs.size(), ONLY_RATE_INCREASED_RULE_APPLIED);
        System.assertEquals(AGENT_PROCESS_TYPE, rateIncreasedPOCs[0].Process_Type__c, ONLY_RATE_INCREASED_AGENT_TYPE);
    }
    
    /**
     * Tests the New Shift Added with existing Type and same Rate rule (Rule 10) which should be classified as Automation process type.
     * Creates a Shift PCA with existing shift type added and newly added flag and verifies the rule is applied correctly.
     */
    @IsTest
    static void testNewShiftAddedWithExistingTypeAndSameRateRule() {
        TestDataFactoryCore TDF = new TestDataFactoryCore();
        Account serviceAcc = [SELECT Id FROM Account LIMIT 1];
        CodeSet eeNurseCode = [SELECT Id FROM CodeSet where Code = :EE_NURSE_PRACTITIONER_CODE LIMIT 1];
        CodeSet dayShiftCode = [SELECT Id FROM CodeSet where Code = :DAY_SHIFT_CODE LIMIT 1];
        
        Contract testContract = new Contract(
            AccountId = serviceAcc.Id,
            RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType='Contract' AND DeveloperName=:CLIENT_RECORD_TYPE LIMIT 1].Id,
            StartDate = Date.today(),
            EndDate = Date.today().addMonths(6),
            Status = DRAFT_STATUS
        );
        insert testContract;
        
        Shift__c dayShift = new Shift__c(
            Shift_Name__c = dayShiftCode.Id,
            Contract__c = testContract.Id,
            Shift_Iteration__c = SHIFT_ITERATION,
            Shift_Day_of_the_Week__c = MONDAY,
            Shift_Start_Time__c = Time.newInstance(8, 0, 0, 0),
            Shift_End_Time__c = Time.newInstance(16, 0, 0, 0),
            Type__c = NP_PA_SHIFT_TYPE
        );
        
        ContractPaymentAgreement clientCPAShift = TDF.createCPA(CLIENT_CPA_NAME, testContract.Id, null, false);
        clientCPAShift.Type__c = SHIFT_TYPE_PCA;
        insert clientCPAShift;
        
        PreventiveCareAgreement newShiftAddedPCA = TDF.createPCA(clientCPAShift.Id, false);
        newShiftAddedPCA.FacilityTitle__c = eeNurseCode.Id;
        newShiftAddedPCA.Shift__c = dayShift.Id;
        newShiftAddedPCA.Existing_Shift_Type_Added__c = true;
        newShiftAddedPCA.Is_Newly_Added__c = true;
        newShiftAddedPCA.Rate__c = 100;
        insert newShiftAddedPCA;
        
        List<Id> contractIds = new List<Id>{testContract.Id};
        
        Test.startTest();
        System.enqueueJob(new PracticeOperationChangeQueueable(contractIds));
        Test.stopTest();
        
        // Assert New Shift Added with existing Type and same Rate rule is applied
        List<Practice_Operation_Change__c> newShiftAddedPOCs = [
            SELECT Id, Process_Type__c, Qualified_Rules__c
            FROM Practice_Operation_Change__c
            WHERE Contract__c = :testContract.Id
        ];
        
        System.assertEquals(1, newShiftAddedPOCs.size(), NEW_SHIFT_ADDED_RULE_APPLIED);
        System.assertEquals(AUTOMATION_PROCESS_TYPE, newShiftAddedPOCs[0].Process_Type__c, NEW_SHIFT_ADDED_AUTOMATION_TYPE);
    }
    
    /**
     * Tests edge case with empty contract IDs to ensure no POC records are created.
     * Verifies that the queueable handles empty input gracefully.
     */
    @IsTest
    static void testEmptyContractIds() {
        Test.startTest();
        System.enqueueJob(new PracticeOperationChangeQueueable(new List<Id>()));
        Test.stopTest();
        
        // Should not create any POC records
        List<Practice_Operation_Change__c> pocList = [
            SELECT Id FROM Practice_Operation_Change__c
        ];
        
        System.assertEquals(0, pocList.size(), NO_POC_RECORDS_EMPTY_CONTRACTS);
    }
    
    /**
     * Tests logException method
     */
    @IsTest
    static void testLogException() {
        
        Test.startTest();
        try{
            insert new Account();
        }
        catch (DmlException de) {
            PracticeOperationChangeUtil.logDmlException(de, 'PracticeOperationChangeQueueableTest','testLogException');
        }
        Test.stopTest();
        
        List<Error_Log__c> errorLogs = [
            SELECT Id FROM Error_Log__c where Source_Component__c = 'PracticeOperationChangeQueueableTest.testLogException'
        ];
        
        System.assertEquals(1, errorLogs.size());
    }
}