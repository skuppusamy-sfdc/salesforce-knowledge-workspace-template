/**
 * @description Test class for PasswordResetController.
 * Covers the InvocableMethod resetUserPassword which triggers password reset
 * and sends email notification for specified user(s).
 */
@IsTest
private class PasswordResetControllerTest {

    /**
     * @description Verifies password reset executes successfully for a single user.
     */
    @IsTest
    static void testResetPasswordSingleUser() {
        TestDataFactory tdf = new TestDataFactory();
        User testUser = tdf.createTestUser('Reset', 'Single', true);
        System.assertNotEquals(null, testUser.Id, 'Test user should be created');

        Integer errorLogCountBefore = [SELECT COUNT() FROM Error_Log__c WHERE Source_Component__c = 'PasswordResetController.resetUserPassword'];

        Test.startTest();
        List<PasswordResetController.ResetResult> results = PasswordResetController.resetUserPassword(new List<Id>{ testUser.Id });
        Test.stopTest();

        System.assertEquals(1, results.size(), 'Should return one result');
        System.assertEquals(true, results[0].isSuccess, 'Reset should succeed');
        System.assertEquals('', results[0].errorMessage, 'Error message should be empty on success');

        Integer errorLogCountAfter = [SELECT COUNT() FROM Error_Log__c WHERE Source_Component__c = 'PasswordResetController.resetUserPassword'];
        System.assertEquals(errorLogCountBefore, errorLogCountAfter, 'No error log should be created on successful password reset');
    }

    /**
     * @description Verifies password reset executes successfully for multiple users (bulk scenario).
     */
    @IsTest
    static void testResetPasswordBulkUsers() {
        TestDataFactory tdf = new TestDataFactory();
        User user1 = tdf.createTestUser('Bulk', 'User1', true);
        User user2 = tdf.createTestUser('Bulk', 'User2', true);
        System.assertEquals(2, [SELECT COUNT() FROM User WHERE Id IN (:user1.Id, :user2.Id)], 'Both test users should exist');

        Integer errorLogCountBefore = [SELECT COUNT() FROM Error_Log__c WHERE Source_Component__c = 'PasswordResetController.resetUserPassword'];

        Test.startTest();
        List<PasswordResetController.ResetResult> results = PasswordResetController.resetUserPassword(new List<Id>{ user1.Id, user2.Id });
        Test.stopTest();

        System.assertEquals(2, results.size(), 'Should return two results');
        System.assertEquals(true, results[0].isSuccess, 'First reset should succeed');
        System.assertEquals(true, results[1].isSuccess, 'Second reset should succeed');

        Integer errorLogCountAfter = [SELECT COUNT() FROM Error_Log__c WHERE Source_Component__c = 'PasswordResetController.resetUserPassword'];
        System.assertEquals(errorLogCountBefore, errorLogCountAfter, 'No error log should be created on successful bulk password reset');
    }

    /**
     * @description Verifies empty list is handled without exception.
     */
    @IsTest
    static void testResetPasswordEmptyList() {
        List<Id> emptyList = new List<Id>();
        System.assertEquals(0, emptyList.size(), 'Test should use empty list');

        Integer errorLogCountBefore = [SELECT COUNT() FROM Error_Log__c WHERE Source_Component__c = 'PasswordResetController.resetUserPassword'];

        Test.startTest();
        List<PasswordResetController.ResetResult> results = PasswordResetController.resetUserPassword(emptyList);
        Test.stopTest();

        System.assertEquals(0, results.size(), 'Should return empty results for empty input');
        Integer errorLogCountAfter = [SELECT COUNT() FROM Error_Log__c WHERE Source_Component__c = 'PasswordResetController.resetUserPassword'];
        System.assertEquals(errorLogCountBefore, errorLogCountAfter, 'Empty list should be handled without creating error logs');
    }

    /**
     * @description Verifies exception path (covers catch block).
     * Uses test seam: passing null in test context triggers a controlled exception.
     */
    @IsTest
    static void testResetPasswordExceptionPath() {
        Integer errorLogCountBefore = [SELECT COUNT() FROM Error_Log__c WHERE Source_Component__c = 'PasswordResetController.resetUserPassword'];

        Test.startTest();
        List<PasswordResetController.ResetResult> results = PasswordResetController.resetUserPassword(new List<Id>{ null });
        Test.stopTest();

        System.assertEquals(1, results.size(), 'Should return one result');
        System.assertEquals(false, results[0].isSuccess, 'Reset should fail');
        System.assertNotEquals(null, results[0].errorMessage, 'Error message should be populated');
        System.assert(results[0].errorMessage.contains('Test exception'), 'Error message should contain test exception text');

        Integer errorLogCountAfter = [SELECT COUNT() FROM Error_Log__c WHERE Source_Component__c = 'PasswordResetController.resetUserPassword'];
        System.assertEquals(errorLogCountBefore + 1, errorLogCountAfter, 'Error log should be created when exception occurs');
    }
}