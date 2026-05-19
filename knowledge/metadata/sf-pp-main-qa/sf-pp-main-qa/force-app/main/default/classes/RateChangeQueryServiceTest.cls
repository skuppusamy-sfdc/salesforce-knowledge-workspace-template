/**
 * @description Test class for RateChangeQueryService.
 */
@isTest
private class RateChangeQueryServiceTest {

    @TestSetup
    static void setupTestData() {
        TestDataFactory tdf = new TestDataFactory();
        Account testAccount = tdf.createServiceAccount('Test Service Account', null, 'Service_Account', true);
        Contract testContract = TestDataFactory.createContract(testAccount, Date.today());
        Clinical_Rate_Change__c crc = TestDataFactory.createClinicalRateChange(testAccount.Id, '["' + testContract.Id + '"]');
        crc.Contract_ID__c = testContract.Id;
        crc.Service_Account_ID__c = testAccount.Id;
        crc.Status__c = 'Open';
        update crc;
    }

    @isTest
    static void testGetOpenRateChangeBlankAccountId() {
        Contract c = [SELECT Id FROM Contract LIMIT 1];

        Test.startTest();
        Clinical_Rate_Change__c result = RateChangeQueryService.getOpenRateChange('', c.Id);
        Test.stopTest();

        System.assertEquals(null, result);
    }

    @isTest
    static void testGetOpenRateChangeBlankContractId() {
        Account a = [SELECT Id FROM Account LIMIT 1];

        Test.startTest();
        Clinical_Rate_Change__c result = RateChangeQueryService.getOpenRateChange(a.Id, '');
        Test.stopTest();

        System.assertEquals(null, result);
    }

    @isTest
    static void testGetOpenRateChangeFound() {
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Contract c = [SELECT Id FROM Contract LIMIT 1];

        Test.startTest();
        Clinical_Rate_Change__c result = RateChangeQueryService.getOpenRateChange(acc.Id, c.Id);
        Test.stopTest();

        System.assertNotEquals(null, result);
        System.assertEquals(acc.Id, result.Service_Account_ID__c);
        System.assertEquals(c.Id, result.Contract_ID__c);
        System.assertEquals('Open', result.Status__c);
    }

    @isTest
    static void testGetOpenRateChangeNotFound() {
        Account acc = [SELECT Id FROM Account LIMIT 1];

        Test.startTest();
        Clinical_Rate_Change__c result = RateChangeQueryService.getOpenRateChange(acc.Id, acc.Id);
        Test.stopTest();

        System.assertEquals(null, result);
    }

    @isTest
    static void testGetOpenRateChangesReturnsList() {
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Contract c = [SELECT Id FROM Contract LIMIT 1];

        Test.startTest();
        List<Clinical_Rate_Change__c> results = RateChangeQueryService.getOpenRateChanges(acc.Id, c.Id);
        Test.stopTest();

        System.assertEquals(1, results.size());
        System.assertEquals('Open', results[0].Status__c);
    }

    @isTest
    static void testGetOpenRateChangesByAccountBlankId() {
        Test.startTest();
        List<Clinical_Rate_Change__c> results = RateChangeQueryService.getOpenRateChangesByAccount('');
        Test.stopTest();

        System.assertNotEquals(null, results);
        System.assertEquals(0, results.size());
    }

    @isTest
    static void testGetOpenRateChangesByAccountFound() {
        Account acc = [SELECT Id FROM Account LIMIT 1];

        Test.startTest();
        List<Clinical_Rate_Change__c> results = RateChangeQueryService.getOpenRateChangesByAccount(acc.Id);
        Test.stopTest();

        System.assertEquals(1, results.size());
        System.assertEquals('Open', results[0].Status__c);
    }

    @isTest
    static void testGetRateChangeForSummaryBlankIds() {
        Test.startTest();
        System.assertEquals(null, RateChangeQueryService.getRateChangeForSummary('', ''));
        System.assertEquals(null, RateChangeQueryService.getRateChangeForSummary(null, '800000000000000AAA'));
        System.assertEquals(null, RateChangeQueryService.getRateChangeForSummary('001000000000000AAA', null));
        Test.stopTest();
    }

    @isTest
    static void testGetRateChangeForSummaryFound() {
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Contract c = [SELECT Id FROM Contract LIMIT 1];

        Test.startTest();
        Clinical_Rate_Change__c result = RateChangeQueryService.getRateChangeForSummary(acc.Id, c.Id);
        Test.stopTest();

        System.assertNotEquals(null, result);
        System.assertEquals(acc.Id, result.Service_Account_ID__c);
        System.assertEquals(c.Id, result.Contract_ID__c);
    }

    @isTest
    static void testGetRateChangeForSummaryReturnsMostRecent() {
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Contract c = [SELECT Id FROM Contract LIMIT 1];
        Clinical_Rate_Change__c existing = [SELECT Id FROM Clinical_Rate_Change__c LIMIT 1];
        existing.Status__c = 'Closed';
        update existing;

        Clinical_Rate_Change__c newer = TestDataFactory.createClinicalRateChangeWithDetails(
            acc.Id, c.Id, '["' + c.Id + '"]', null, null
        );
        newer.Status__c = 'Open';
        update newer;

        Test.startTest();
        Clinical_Rate_Change__c result = RateChangeQueryService.getRateChangeForSummary(acc.Id, c.Id);
        Test.stopTest();

        System.assertNotEquals(null, result);
        System.assertEquals(newer.Id, result.Id);
    }
}