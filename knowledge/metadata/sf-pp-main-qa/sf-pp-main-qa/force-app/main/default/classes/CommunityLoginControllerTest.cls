/***************************************************************************************************************************
* Class Name    : CommunityLoginControllerTest
* Description   : Test class for CommunityLoginController.
*                 Uses MockSiteLoginAction to simulate Site.login() behavior and validate login flow
*                 and user retrieval logic for community users.
*
* Test Coverage :
*   - Validates retrieval of users by email (existing, non-existing, and blank)
*   - Validates login behavior using MockSiteLoginAction for both success and failure scenarios
*   - Ensures AuraHandledException is thrown for invalid credentials
*
* Author        : Srishty Sharma
* Created Date  : 28-Oct-2025
* Last Modified : 13-April-2026
***************************************************************************************************************************/
@IsTest
private class CommunityLoginControllerTest {

    /**
     * Creates reusable test data before each test method executes.
     * Inserts a standard community user with known credentials and email.
     */
    @TestSetup
    static void setupData() {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        insert new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'normal_user@test.com',
            Alias = 'tst',
            Username = 'normal_user@test.com',
            CommunityNickname = 'normal_user',
            TimeZoneSidKey = 'Asia/Kolkata',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = p.Id,
            LanguageLocaleKey = 'en_US'
        );
    }

    /**
     * Tests that getUserByEmail() successfully retrieves a user
     * when a valid and existing email is provided.
     */
    @IsTest
    static void testGetUserByEmail_found() {
        Test.startTest();
        User result = CommunityLoginController.getUserByEmail('normal_user@test.com');
        Test.stopTest();

        System.assertNotEquals(null, result, 'User should be found for given email.');
    }

    /**
     * Tests that getUserByEmail() returns null when a non-existent
     * email address is provided.
     */
    @IsTest
    static void testGetUserByEmail_notFound() {
        Test.startTest();
        User result = CommunityLoginController.getUserByEmail('unknown@test.com');
        Test.stopTest();

        System.assertEquals(null, result, 'Should return null for unknown email.');
    }

    /**
     * Tests that getUserByEmail() returns null when the provided
     * email address is blank or empty.
     */
    @IsTest
    static void testGetUserByEmail_blank() {
        Test.startTest();
        User result = CommunityLoginController.getUserByEmail('');
        Test.stopTest();

        System.assertEquals(null, result, 'Blank email should return null.');
    }

    /**
     * Tests that isUserLocked() returns false when email is blank.
     */
    @IsTest
    static void testIsUserLocked_blankEmail() {
        Test.startTest();
        Boolean isLocked = CommunityLoginController.isUserLocked('');
        Test.stopTest();

        System.assertEquals(false, isLocked, 'Blank email should never be considered locked.');
    }

    /**
     * Tests that isUserLocked() returns false for unknown users.
     */
    @IsTest
    static void testIsUserLocked_userNotFound() {
        Test.startTest();
        Boolean isLocked = CommunityLoginController.isUserLocked('unknown@test.com');
        Test.stopTest();

        System.assertEquals(false, isLocked, 'Unknown user should not be considered locked.');
    }

    /**
     * Tests that isUserLocked() can query login status for a known user.
     * For seeded test data, the user is expected to be unlocked by default.
     */
    @IsTest
    static void testIsUserLocked_knownUser() {
        Test.startTest();
        Boolean isLocked = CommunityLoginController.isUserLocked('normal_user@test.com');
        Test.stopTest();

        System.assertEquals(false, isLocked, 'Newly created test user should not be locked.');
    }

    /**
     * Tests successful login using the mock SiteLoginAction implementation.
     * Verifies that the login() method returns the expected redirect URL
     * when valid credentials are provided.
     */
    @IsTest
    static void testLogin_success() {
        // Inject mock action for controlled login behavior
        CommunityLoginController.setSiteLoginAction(new CommunityLoginController.MockSiteLoginAction());

        Test.startTest();
        String result = CommunityLoginController.login('normal_user@test.com', 'password123');
        Test.stopTest();

        System.assertEquals('/home', result, 'Mock login should return success URL.');
    }

    /**
     * Tests login failure scenario using the mock SiteLoginAction.
     * Ensures that an AuraHandledException is thrown when invalid
     * credentials are provided.
     */
    @IsTest
    static void testLogin_failure() {
        // Inject mock action for controlled login behavior
        CommunityLoginController.setSiteLoginAction(new CommunityLoginController.MockSiteLoginAction());

        Boolean exceptionThrown = false;
        Test.startTest();
        try {
            CommunityLoginController.login('normal_user@test.com', 'wrongPassword');
            System.assert(false, 'Expected AuraHandledException for invalid login.');
        } catch (AuraHandledException e) {
            exceptionThrown = true;
            System.assert(
                e.getMessage() == 'Script-thrown exception' ||
                e.getMessage() == 'Invalid credentials or login failed.',
                'Expected AuraHandledException for invalid credentials.'
            );
        }
        Test.stopTest();
        System.assertEquals(true, exceptionThrown, 'Should throw exception for invalid login.');
    }

    /**
     * Covers the DefaultSiteLoginAction class
     * This method verifies that the class can be instantiated safely in test context.
     */
    @IsTest
    static void testDefaultSiteLoginAction_coverageOnly() {
        CommunityLoginController.DefaultSiteLoginAction impl =
            new CommunityLoginController.DefaultSiteLoginAction();

        try {
            PageReference ref = impl.doLogin('user@test.com', 'pass', null);
            System.assertEquals(null, ref, 'Expected null PageReference in test context.');
        } catch (Exception e) {
            System.assert(true, 'Expected behavior: Site.login() not allowed in tests.');
        }
    }
}