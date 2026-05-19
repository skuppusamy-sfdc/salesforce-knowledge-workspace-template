/**
 * @description Consolidated test class for IdParsingUtil, RateChangeNotificationUtil,
 * RateChangeContractUtil. Validation tests use RateChangeInvocableInput.validateAccountAndContract.
 */
@isTest
private class RateChangeHelpersTest {

    @TestSetup
    static void setupTestData() {
        TestDataFactory tdf = new TestDataFactory();
        Account acc = tdf.createServiceAccount('Test Account', null, 'Service_Account', true);
        Contract c = TestDataFactory.createContract(acc, Date.today());
        c.Status = 'Executed';
        update c;
    }

    // ---- IdParsingUtil (parseCommaSeparatedIds) ----
    @isTest static void testIdParsingUtilParseCommaSeparatedIdsNull() {
        Test.startTest();
        List<Id> result = IdParsingUtil.parseCommaSeparatedIds(null);
        Test.stopTest();
        System.assertNotEquals(null, result);
        System.assertEquals(0, result.size());
    }
    @isTest static void testIdParsingUtilParseCommaSeparatedIdsBlank() {
        Test.startTest();
        List<Id> result = IdParsingUtil.parseCommaSeparatedIds('');
        Test.stopTest();
        System.assertNotEquals(null, result);
        System.assertEquals(0, result.size());
    }
    @isTest static void testIdParsingUtilParseCommaSeparatedIdsWhitespaceOnly() {
        Test.startTest();
        List<Id> result = IdParsingUtil.parseCommaSeparatedIds('   ');
        Test.stopTest();
        System.assertNotEquals(null, result);
        System.assertEquals(0, result.size());
    }
    @isTest static void testIdParsingUtilParseCommaSeparatedIdsSingleId() {
        Account acc = new Account(Name = 'Test');
        insert acc;
        Test.startTest();
        List<Id> result = IdParsingUtil.parseCommaSeparatedIds(acc.Id);
        Test.stopTest();
        System.assertEquals(1, result.size());
        System.assertEquals(acc.Id, result[0]);
    }
    @isTest static void testIdParsingUtilParseCommaSeparatedIdsMultipleIds() {
        Account acc1 = new Account(Name = 'Test1');
        Account acc2 = new Account(Name = 'Test2');
        insert new List<Account>{ acc1, acc2 };
        String idsStr = acc1.Id + ',' + acc2.Id;
        Test.startTest();
        List<Id> result = IdParsingUtil.parseCommaSeparatedIds(idsStr);
        Test.stopTest();
        System.assertEquals(2, result.size());
        System.assertEquals(acc1.Id, result[0]);
        System.assertEquals(acc2.Id, result[1]);
    }
    @isTest static void testIdParsingUtilParseCommaSeparatedIdsWithSpaces() {
        Account acc = new Account(Name = 'Test');
        insert acc;
        String idsStr = '  ' + acc.Id + '  ';
        Test.startTest();
        List<Id> result = IdParsingUtil.parseCommaSeparatedIds(idsStr);
        Test.stopTest();
        System.assertEquals(1, result.size());
        System.assertEquals(acc.Id, result[0]);
    }
    @isTest static void testIdParsingUtilParseCommaSeparatedIdsWithBlankSegments() {
        Account acc = new Account(Name = 'Test');
        insert acc;
        String idsStr = ',' + acc.Id + ',,';
        Test.startTest();
        List<Id> result = IdParsingUtil.parseCommaSeparatedIds(idsStr);
        Test.stopTest();
        System.assertEquals(1, result.size());
        System.assertEquals(acc.Id, result[0]);
    }

    // ---- IdParsingUtil (extractSelectedClinicianIds) ----
    @isTest static void testIdParsingUtilExtractSelectedClinicianIdsComplexFormat() {
        String id1 = '003000000000001AAA';
        String id2 = '003000000000002AAA';
        String jsonStr = '{"selectedClinicianIds":[{"selectId":"' + id1 + '","isProcessed":false},{"selectId":"' + id2 + '"}]}';
        Object jsonResult = JSON.deserializeUntyped(jsonStr);
        Test.startTest();
        List<String> result = IdParsingUtil.extractSelectedClinicianIds(jsonResult);
        Test.stopTest();
        System.assertEquals(2, result.size());
        System.assert(result.contains(id1));
        System.assert(result.contains(id2));
    }
    @isTest static void testIdParsingUtilExtractSelectedClinicianIdsSimpleArray() {
        String id1 = '003000000000001AAA';
        String id2 = '003000000000002AAA';
        String jsonStr = '{"selectedClinicianIds":["' + id1 + '","' + id2 + '"]}';
        Object jsonResult = JSON.deserializeUntyped(jsonStr);
        Test.startTest();
        List<String> result = IdParsingUtil.extractSelectedClinicianIds(jsonResult);
        Test.stopTest();
        System.assertEquals(2, result.size());
        System.assert(result.contains(id1));
        System.assert(result.contains(id2));
    }
    @isTest static void testIdParsingUtilExtractSelectedClinicianIdsSingleString() {
        String id1 = '003000000000001AAA';
        String jsonStr = '{"selectedClinicianIds":"' + id1 + '"}';
        Object jsonResult = JSON.deserializeUntyped(jsonStr);
        Test.startTest();
        List<String> result = IdParsingUtil.extractSelectedClinicianIds(jsonResult);
        Test.stopTest();
        System.assertEquals(1, result.size());
        System.assertEquals(id1, result[0]);
    }
    @isTest static void testIdParsingUtilExtractSelectedClinicianIdsNoSelectedClinicianIds() {
        String jsonStr = '{"otherKey":"value"}';
        Object jsonResult = JSON.deserializeUntyped(jsonStr);
        Test.startTest();
        List<String> result = IdParsingUtil.extractSelectedClinicianIds(jsonResult);
        Test.stopTest();
        System.assertEquals(0, result.size());
    }
    @isTest static void testIdParsingUtilExtractSelectedClinicianIdsNullSelectedClinicianIds() {
        String jsonStr = '{"selectedClinicianIds":null}';
        Object jsonResult = JSON.deserializeUntyped(jsonStr);
        Test.startTest();
        List<String> result = IdParsingUtil.extractSelectedClinicianIds(jsonResult);
        Test.stopTest();
        System.assertEquals(0, result.size());
    }
    @isTest static void testIdParsingUtilExtractSelectedClinicianIdsNotMap() {
        Object jsonResult = 'plain string';
        Test.startTest();
        List<String> result = IdParsingUtil.extractSelectedClinicianIds(jsonResult);
        Test.stopTest();
        System.assertEquals(0, result.size());
    }
    @isTest static void testIdParsingUtilExtractSelectedClinicianIdsSkipsBlankIds() {
        String id1 = '003000000000001AAA';
        String jsonStr = '{"selectedClinicianIds":[{"selectId":"' + id1 + '"},{"selectId":""},{"selectId":"   "}]}';
        Object jsonResult = JSON.deserializeUntyped(jsonStr);
        Test.startTest();
        List<String> result = IdParsingUtil.extractSelectedClinicianIds(jsonResult);
        Test.stopTest();
        System.assertEquals(1, result.size());
        System.assertEquals(id1, result[0]);
    }

    // ---- RateChangeNotificationUtil (sendNotification) ----
    @isTest static void testRateChangeNotificationUtilSendNotificationDoesNotThrow() {
        Test.startTest();
        RateChangeNotificationUtil.sendNotification(true, 'Test Title', 'Test body', null, UserInfo.getUserId());
        Test.stopTest();
        System.assert(true, 'sendNotification should not throw');
    }

    // ---- RateChangeNotificationUtil (logError) ----
    @isTest static void testRateChangeNotificationUtilLogErrorNullInput() {
        Test.startTest();
        RateChangeNotificationUtil.logError('TestContext', null, null);
        Test.stopTest();
        List<Error_Log__c> logs = [SELECT Id FROM Error_Log__c];
        System.assertEquals(0, logs.size(), 'No log should be created for null input');
    }
    @isTest static void testRateChangeNotificationUtilLogErrorException() {
        String context = 'RateChangeNotificationUtilTest';
        String recordId = '001000000000000AAA';
        Test.startTest();
        try {
            Integer x = 10 / 0;
        } catch (Exception e) {
            RateChangeNotificationUtil.logError(context, recordId, e);
        }
        Test.stopTest();
        List<Error_Log__c> logs = [SELECT Source_Component__c, Record_Id__c, Error_Message__c, Stack_Trace__c FROM Error_Log__c];
        System.assertEquals(1, logs.size(), 'One log should be created');
        System.assertEquals(context, logs[0].Source_Component__c);
        System.assertEquals(recordId, logs[0].Record_Id__c);
        System.assert(logs[0].Error_Message__c.contains('Divide by 0'), 'Message should contain exception detail');
        System.assert(String.isNotBlank(logs[0].Stack_Trace__c), 'Stack trace should be populated');
    }
    @isTest static void testRateChangeNotificationUtilLogErrorDatabaseErrorArray() {
        String context = 'TestContext';
        String recordId = '003000000000000AAA';
        Account acc = new Account(Name = 'Test');
        insert acc;
        acc.Name = null;
        Database.SaveResult[] results = Database.update(new List<Account>{ acc }, false);
        List<Database.Error> errors = new List<Database.Error>();
        for (Database.SaveResult sr : results) {
            if (!sr.isSuccess()) {
                errors.addAll(sr.getErrors());
            }
        }
        System.assert(!errors.isEmpty(), 'Test setup should produce at least one Database.Error');
        Test.startTest();
        RateChangeNotificationUtil.logError(context, recordId, errors);
        Test.stopTest();
        List<Error_Log__c> logs = [SELECT Source_Component__c, Record_Id__c, Error_Message__c, Stack_Trace__c FROM Error_Log__c];
        System.assertEquals(1, logs.size(), 'One log should be created for Database.Error[]');
        System.assertEquals(context, logs[0].Source_Component__c);
        System.assertEquals(recordId, logs[0].Record_Id__c);
        System.assert(String.isNotBlank(logs[0].Error_Message__c), 'Error message should be populated');
    }
    @isTest static void testRateChangeNotificationUtilLogErrorGenericObject() {
        String context = 'GenericTest';
        String errMsg = 'Custom error message';
        Test.startTest();
        RateChangeNotificationUtil.logError(context, null, errMsg);
        Test.stopTest();
        List<Error_Log__c> logs = [SELECT Source_Component__c, Record_Id__c, Error_Message__c, Stack_Trace__c FROM Error_Log__c];
        System.assertEquals(1, logs.size(), 'One log should be created for generic object');
        System.assertEquals(context, logs[0].Source_Component__c);
        System.assertEquals(errMsg, logs[0].Error_Message__c);
        System.assertEquals('No stack trace available', logs[0].Stack_Trace__c);
    }
    @isTest static void testRateChangeNotificationUtilLogErrorNullRecordId() {
        Test.startTest();
        RateChangeNotificationUtil.logError('Context', null, new DmlException('Test'));
        Test.stopTest();
        List<Error_Log__c> logs = [SELECT Record_Id__c FROM Error_Log__c];
        System.assertEquals(1, logs.size());
        System.assertEquals(null, logs[0].Record_Id__c);
    }

    // ---- RateChangeInvocableInput.validateAccountAndContract ----
    @isTest static void testRateChangeActionValidateAccountAndContractNullInputs() {
        Test.startTest();
        RateChangeInvocableInput.ValidationResult result = RateChangeInvocableInput.validateAccountAndContract(null);
        Test.stopTest();
        System.assertEquals(false, result.isValid);
        System.assertEquals(RateChangeInvocableInput.ERROR_SELECT_ACCOUNT_AND_CONTRACT, result.errorMessage);
        System.assertEquals(null, result.input);
    }
    @isTest static void testRateChangeActionValidateAccountAndContractEmptyInputs() {
        Test.startTest();
        RateChangeInvocableInput.ValidationResult result = RateChangeInvocableInput.validateAccountAndContract(new List<RateChangeInvocableInput>());
        Test.stopTest();
        System.assertEquals(false, result.isValid);
        System.assertEquals(RateChangeInvocableInput.ERROR_SELECT_ACCOUNT_AND_CONTRACT, result.errorMessage);
        System.assertEquals(null, result.input);
    }
    @isTest static void testRateChangeActionValidateAccountAndContractBlankAccountId() {
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = '';
        input.contractId = '003000000000000AAA';
        Test.startTest();
        RateChangeInvocableInput.ValidationResult result = RateChangeInvocableInput.validateAccountAndContract(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        System.assertEquals(false, result.isValid);
        System.assertEquals(RateChangeInvocableInput.ERROR_SELECT_ACCOUNT_AND_CONTRACT, result.errorMessage);
        System.assertEquals(null, result.input);
    }
    @isTest static void testRateChangeActionValidateAccountAndContractBlankContractId() {
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = '001000000000000AAA';
        input.contractId = '';
        Test.startTest();
        RateChangeInvocableInput.ValidationResult result = RateChangeInvocableInput.validateAccountAndContract(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        System.assertEquals(false, result.isValid);
        System.assertEquals(RateChangeInvocableInput.ERROR_SELECT_ACCOUNT_AND_CONTRACT, result.errorMessage);
        System.assertEquals(null, result.input);
    }
    @isTest static void testRateChangeActionValidateAccountAndContractValidInput() {
        RateChangeInvocableInput input = new RateChangeInvocableInput();
        input.accountId = '001000000000000AAA';
        input.contractId = '800000000000000AAA';
        Test.startTest();
        RateChangeInvocableInput.ValidationResult result = RateChangeInvocableInput.validateAccountAndContract(new List<RateChangeInvocableInput>{ input });
        Test.stopTest();
        System.assertEquals(true, result.isValid);
        System.assertEquals(null, result.errorMessage);
        System.assertEquals(input, result.input);
        System.assertEquals(input.accountId, result.input.accountId);
        System.assertEquals(input.contractId, result.input.contractId);
    }
    @isTest static void testRateChangeActionValidateAccountAndContractUsesFirstElement() {
        RateChangeInvocableInput input1 = new RateChangeInvocableInput();
        input1.accountId = '001AAA';
        input1.contractId = '800AAA';
        RateChangeInvocableInput input2 = new RateChangeInvocableInput();
        input2.accountId = '001BBB';
        input2.contractId = '800BBB';
        Test.startTest();
        RateChangeInvocableInput.ValidationResult result = RateChangeInvocableInput.validateAccountAndContract(new List<RateChangeInvocableInput>{ input1, input2 });
        Test.stopTest();
        System.assertEquals(true, result.isValid);
        System.assertEquals(input1, result.input);
    }

    // ---- RateChangeContractUtil ----
    @isTest static void testRateChangeContractUtilGetContractsWithCompensationNoticeLetterNullInput() {
        Test.startTest();
        Set<Id> result = RateChangeContractUtil.getContractsWithCompensationNoticeLetter(null);
        Test.stopTest();
        System.assertNotEquals(null, result);
        System.assertEquals(0, result.size());
    }
    @isTest static void testRateChangeContractUtilGetContractsWithCompensationNoticeLetterEmptyInput() {
        Test.startTest();
        Set<Id> result = RateChangeContractUtil.getContractsWithCompensationNoticeLetter(new List<Contract>());
        Test.stopTest();
        System.assertNotEquals(null, result);
        System.assertEquals(0, result.size());
    }
    @isTest static void testRateChangeContractUtilGetContractsWithCompensationNoticeLetterNoMatchingContent() {
        List<Contract> contracts = [SELECT Id FROM Contract LIMIT 1];
        Test.startTest();
        Set<Id> result = RateChangeContractUtil.getContractsWithCompensationNoticeLetter(contracts);
        Test.stopTest();
        System.assertEquals(0, result.size(), 'No contracts have notice letter when no content exists');
    }
    @isTest static void testRateChangeContractUtilGetContractsWithCompensationNoticeLetterWithMatchingContent() {
        Contract testContract = [SELECT Id FROM Contract LIMIT 1];
        ContentVersion cv = new ContentVersion(Title = 'Compensation Change Notice Letter', PathOnClient = 'notice.pdf', VersionData = Blob.valueOf('Test content'));
        insert cv;
        cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id LIMIT 1];
        ContentDocumentLink cdl = new ContentDocumentLink(ContentDocumentId = cv.ContentDocumentId, LinkedEntityId = testContract.Id, ShareType = 'V', Visibility = 'AllUsers');
        insert cdl;
        List<Contract> contracts = new List<Contract>{ testContract };
        Test.startTest();
        Set<Id> result = RateChangeContractUtil.getContractsWithCompensationNoticeLetter(contracts);
        Test.stopTest();
        System.assertEquals(1, result.size());
        System.assert(result.contains(testContract.Id));
    }
    @isTest static void testRateChangeContractUtilGetContractsWithCompensationNoticeLetterNonMatchingTitle() {
        Contract testContract = [SELECT Id FROM Contract LIMIT 1];
        ContentVersion cv = new ContentVersion(Title = 'Other Document', PathOnClient = 'other.pdf', VersionData = Blob.valueOf('Test'));
        insert cv;
        cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id LIMIT 1];
        ContentDocumentLink cdl = new ContentDocumentLink(ContentDocumentId = cv.ContentDocumentId, LinkedEntityId = testContract.Id, ShareType = 'V', Visibility = 'AllUsers');
        insert cdl;
        List<Contract> contracts = new List<Contract>{ testContract };
        Test.startTest();
        Set<Id> result = RateChangeContractUtil.getContractsWithCompensationNoticeLetter(contracts);
        Test.stopTest();
        System.assertEquals(0, result.size(), 'Should not match documents with different title');
    }
}