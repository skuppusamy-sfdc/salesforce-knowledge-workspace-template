@isTest
private class ErrorLogUtilTest {

    /**
     * @description Test the basic logException method with a standard System Exception (Divide by 0)
     */
    @isTest
    static void testLogExceptionBasic() {
        // Arrange
        String sourceComponent = 'ErrorLogUtilTest.testLogExceptionBasic';
        String fakeRecordId = '001000000000000AAA';

        Test.startTest();
        try {
            // Force a MathException
            Integer result = 10 / 0;
        } catch (Exception e) {
            // Act
            ErrorLogUtil.logException(e, sourceComponent, fakeRecordId);
        }
        Test.stopTest();

        // Assert
        List<Error_Log__c> logs = [
            SELECT Id, Source_Component__c, Record_Id__c, Error_Message__c, Stack_Trace__c, Type__c, Severity__c 
            FROM Error_Log__c
        ];
        
        System.assertEquals(1, logs.size(), 'One Error Log should be created.');
        System.assertEquals(sourceComponent, logs[0].Source_Component__c);
        System.assertEquals(fakeRecordId, logs[0].Record_Id__c);
        System.assertEquals('Apex', logs[0].Type__c);
        System.assertEquals('High', logs[0].Severity__c);
        System.assert(logs[0].Error_Message__c.contains('Divide by 0'), 'Message should capture the exception detail.');
        System.assert(String.isNotBlank(logs[0].Stack_Trace__c), 'Stack trace should be populated.');
    }

    /**
     * @description Test the overloaded method for Integration scenarios (JSON context, Process Name)
     */
    @isTest
    static void testLogExceptionIntegration() {
        // Arrange
        String processName = 'SAP_Order_Sync';
        String jsonContext = '{"orderId": "123", "status": "failed"}';
        String sourceComponent = 'IntegrationHandler';

        Test.startTest();
        try {
            // Create a custom exception
            throw new CalloutException('Connection Timed Out');
        } catch (Exception e) {
            // Act
            ErrorLogUtil.logException(e, sourceComponent, null, processName, jsonContext);
        }
        Test.stopTest();

        // Assert
        Error_Log__c log = [
            SELECT Integration_Process__c, Context_JSON__c, Type__c, Error_Type__c 
            FROM Error_Log__c 
            LIMIT 1
        ];

        System.assertEquals(processName, log.Integration_Process__c);
        System.assertEquals(jsonContext, log.Context_JSON__c);
        System.assertEquals('Integration', log.Type__c);
        System.assert(log.Error_Type__c.contains('CalloutException'), 'Error Type should match the exception class name.');
    }

    /**
     * @description Test logging a custom error without an Exception object (e.g. Logic errors)
     */
    @isTest
    static void testLogCustomError() {
        // Arrange
        String errorMsg = 'HTTP 400: Bad Request';
        String severity = 'Medium';
        String direction = 'Outbound'; // Testing the Integraiton_Direction__c field
        
        Test.startTest();
        // Act
        ErrorLogUtil.logCustomError(errorMsg, severity, 'CalloutClass', 'PaymentGateway', direction);
        Test.stopTest();

        // Assert
        Error_Log__c log = [
            SELECT Error_Message__c, Severity__c, Integraiton_Direction__c 
            FROM Error_Log__c 
            LIMIT 1
        ];

        System.assertEquals(errorMsg, log.Error_Message__c);
        System.assertEquals(severity, log.Severity__c);
        // Note: Using the specific field API name with the typo provided in your requirements
        System.assertEquals(direction, log.Integraiton_Direction__c);
    }
    
    
    /**
     * @description Test logging a custom error without an Exception object (e.g. Logic errors)
     */
    @isTest
    static void testlogErrorFromFlow() {
        // Create a list of ErrorLogRequest instances
        List<ErrorLogUtil.ErrorLogRequest> errorLogRequests = new List<ErrorLogUtil.ErrorLogRequest>();
        // Create a sample ErrorLogRequest
        ErrorLogUtil.ErrorLogRequest request = new ErrorLogUtil.ErrorLogRequest();
        request.errorMessage = 'Sample error message';
        request.severity = 'High';
        request.sourceComponent = 'SampleFlow';
        request.integrationProcess = 'SampleAPI';
        request.direction = 'Inbound';
        // Add the request to the list
        errorLogRequests.add(request);
        // Call the logErrorFromFlow method
        Test.startTest();
        ErrorLogUtil.logErrorFromFlow(errorLogRequests);
        Test.stopTest();
        // Verify that the Error_Log__c record was created
        List<Error_Log__c> errorLogs = [SELECT Id, Error_Message__c, Severity__c, Source_Component__c, Integration_Process__c FROM Error_Log__c];
        System.assertEquals(1, errorLogs.size(), 'One Error_Log__c record should be created');
    }

    /**
     * @description Confirms Error_Log__c records are created successfully when run as a community user.
     * Uses System.runAs() with a community user profile to verify without sharing allows inserts
     * regardless of the running user's restricted access.
     */
    @isTest
    static void testErrorLogCreationAsCommunityUser() {
        TestDataFactory tdf = new TestDataFactory();
        User accountOwner = tdf.createTestUserWithRole('Portal', 'Owner', 'test Customer Person Account', true);
        Account testAccount;
        Contact testContact;
        User communityUser;
        System.runAs(accountOwner) {
            testAccount = tdf.createServiceAccount('ErrorLog Community Test Account', null, 'Service_Account', true);
            testContact = TestDataFactory.createContactWithDetails(testAccount, 'Community', 'TestUser', 'communityerrorlog@test.com');
            communityUser = tdf.createCommunityUser(testContact, true);
        }

        System.assertNotEquals(null, communityUser, 'A community profile must exist in the org.');

        Integer logCountBefore = [SELECT COUNT() FROM Error_Log__c];

        Test.startTest();
        System.runAs(communityUser) {
            // Community users typically lack direct access to Error_Log__c; without sharing allows insert
            try {
                throw new CalloutException('Simulated error for community user test');
            } catch (Exception e) {
                ErrorLogUtil.logException(e, 'ErrorLogUtilTest.testErrorLogCreationAsCommunityUser', '001000000000000AAA');
            }
            ErrorLogUtil.logCustomError('Custom error from community', 'Medium', 'CommunityFlow', 'TestAPI', 'Inbound');
        }
        Test.stopTest();

        List<Error_Log__c> logs = [
            SELECT Id, Source_Component__c, Error_Message__c, Severity__c
            FROM Error_Log__c
            ORDER BY CreatedDate DESC
        ];
        System.assertEquals(logCountBefore + 2, logs.size(), 'Two Error_Log__c records should be created when run as community user.');
        System.assert(logs[0].Error_Message__c.contains('Custom error from community') || logs[1].Error_Message__c.contains('Custom error from community'),
            'One log should contain the custom error message.');
    }

    /**
     * @description Validate that text fields are truncated to 255 chars to prevent Insert failures
     */
    @isTest
    static void testTruncationLogic() {
        // Arrange
        // Create a string that is 300 characters long
        String longSource = 'A'.repeat(300); 
        
        Test.startTest();
        // Pass the long string into a field limited to 255 (Source_Component__c)
        ErrorLogUtil.logCustomError('Msg', 'Low', longSource, 'Proc', 'Inbound');
        Test.stopTest();

        // Assert
        Error_Log__c log = [SELECT Source_Component__c FROM Error_Log__c LIMIT 1];
        
        System.assertEquals(255, log.Source_Component__c.length(), 'Source Component should be truncated to 255 characters.');
        System.assertNotEquals(longSource, log.Source_Component__c, 'The value should not match the original 300 char string.');
    }
}