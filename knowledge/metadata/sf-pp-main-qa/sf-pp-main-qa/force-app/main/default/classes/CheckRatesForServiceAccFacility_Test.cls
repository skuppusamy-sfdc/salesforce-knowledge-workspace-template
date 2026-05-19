@Istest(SeeAllData=false)
public class CheckRatesForServiceAccFacility_Test {
    @testSetup
	static void setupTestData() {
 TestDataFactoryCore TDF = new TestDataFactoryCore();

        // Accounts and Contacts
        Account acc = TDF.createServiceAccount('Test Service Account', null, 'Service_Account', true);
        Contact con = TDF.createContact('Test Contact', acc, true);

        // Contract setup
        Contract contract = new Contract(
            AccountId = acc.Id,
            StartDate = Date.today(),
            EndDate = Date.today().addMonths(12),
            Status = 'Draft'
        );
        insert contract;

        // Facility Title
        CodeSet facilityCode = new CodeSet(
            Name = 'Facility Title',
            Code = 'FAC1',
            CodeSetType = 'Facility Title',
            IsActive = true
        );
        insert facilityCode;

        // Shift
        CodeSet shiftCode = new CodeSet(Name='Day Shift', Code='DAY', CodeSetType='Shift');
        insert shiftCode;

        Shift__c shiftRec = new Shift__c(
            Shift_Name__c = shiftCode.Id,
            Contract__c = contract.Id,
            Shift_Start_Time__c = Time.newInstance(1,0,0,0),
            Shift_End_Time__c = Time.newInstance(9,0,0,0),
            Type__c = 'NP/PA',
            Shift_Iteration__c = '1',
            Shift_Day_of_the_Week__c = 'Monday'
        );
        insert shiftRec;

        
        // ContractPaymentAgreement — inserted FIRST
        ContractPaymentAgreement cpa = new ContractPaymentAgreement(
            Type__c = 'Shift',
            ContractId = contract.Id,
            Name = 'Test CPA',
            AgreementType = 'Preventive Care Agreement'
        );
        insert cpa;

        // PreventiveCareAgreement referencing CPA and Shift
        PreventiveCareAgreement pca = new PreventiveCareAgreement(
            FacilityTitle__c = facilityCode.Id,
            Rate__c = 100,
            ContractPaymentAgreementId = cpa.Id,
            Shift__c = shiftRec.Id,
            BonusMeasureType = 'NA',
            TargetMeasurePercent = 0,
            BonusPayout = 0
        );
        insert pca;
        
        PreventiveCareAgreement pca1 = new PreventiveCareAgreement(
            FacilityTitle__c = facilityCode.Id,
            Rate__c = 101,
            ContractPaymentAgreementId = cpa.Id,
            Shift__c = shiftRec.Id,
            BonusMeasureType = 'NA',
            TargetMeasurePercent = 0,
            BonusPayout = 0
        );
        insert pca1;
    }
    
    @IsTest
    static void testHappyPath_validRate() {
        // Arrange
        Contract testContract = [SELECT Id FROM Contract LIMIT 1];
        CodeSet facility = [SELECT Id FROM CodeSet WHERE CodeSetType='Facility Title' LIMIT 1];
        CodeSet shift = [SELECT Code FROM CodeSet WHERE CodeSetType='Shift' LIMIT 1];

        Map<String, Object> input = new Map<String, Object>{
            'ContextId' => testContract.Id,
            'Rate' => 100,
            'UnitOfMeasure' => 'Per Hour',
            'ListOfFacilityTitleIds' => new List<Object>{
                new Map<String,Object>{'value' => facility.Id}
            },
            'shifts' => new List<Object>{
                new Map<String,Object>{'ShiftCode' => shift.Code}
            }
        };
        Map<String, Object> output = new Map<String, Object>();
        Map<String, Object> args = new Map<String, Object>{
            'input' => input, 'output' => output, 'options' => new Map<String, Object>()
        };

        // Act
        CheckRatesForServiceAccFacility handler = new CheckRatesForServiceAccFacility();
        handler.call('ValidateRate', args);

        // Assert
        System.assertEquals(true, output.containsKey('rateValidated'));
    }
}