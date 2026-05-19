/**
 * @description Test class for RateChangeInvocableInput, RateChangeInvocableOutput, and DraftContractOutput.
 * Ensures coverage for simple data/wrapper classes used by invocable actions.
 */
@isTest
private class RateChangeInvocableClassesTest {

    @TestSetup
    static void setupTestData() {
        TestDataFactory tdf = new TestDataFactory();
        Account acc = tdf.createServiceAccount('Test', null, 'Service_Account', true);
        Contract c = TestDataFactory.createContract(acc, Date.today());
    }

    @isTest
    static void testRateChangeInvocableInput() {
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = '001000000000000AAA';
        input.contractId = '800000000000000AAA';

        System.assertEquals('001000000000000AAA', input.accountId);
        System.assertEquals('800000000000000AAA', input.contractId);
    }

    @isTest
    static void testRateChangeInvocableOutput() {
        RateChangeInvocableOutput output = new RateChangeInvocableOutput();
        output.success = true;
        output.message = 'Test message';

        System.assertEquals(true, output.success);
        System.assertEquals('Test message', output.message);
    }

    @isTest
    static void testDraftContractOutput() {
        DraftContractOutput dco = new DraftContractOutput();
        dco.accountId = '001AAA';
        dco.clientContractId = '800AAA';
        dco.contractId = '800BBB';
        dco.contractNumber = 'C-001';
        dco.startDate = '2025-01-01';
        dco.clinicianName = 'Test Clinician';

        System.assertEquals('001AAA', dco.accountId);
        System.assertEquals('800AAA', dco.clientContractId);
        System.assertEquals('800BBB', dco.contractId);
        System.assertEquals('C-001', dco.contractNumber);
        System.assertEquals('2025-01-01', dco.startDate);
        System.assertEquals('Test Clinician', dco.clinicianName);
    }
}