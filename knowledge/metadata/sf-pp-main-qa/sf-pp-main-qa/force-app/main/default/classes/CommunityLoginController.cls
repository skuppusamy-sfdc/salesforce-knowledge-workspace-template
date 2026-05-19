/***************************************************************************************************************************
* Class Name    : CommunityLoginController
* Description   : This controller handles custom login functionality for the Salesforce Community.
*                 It provides methods to:
*                  1. Retrieve user details based on the provided email address.
*                  2. Identify if the user is configured for SSO login using FederationIdentifier.
*                  3. Perform standard username-password login for non-SSO users through the Site.login() method.
*                 These methods are designed to be invoked from a Lightning Web Component (LWC) or Aura component
*                 as part of a custom community login flow.
*
* Author        : Srishty Sharma
* Created Date  : 28-Oct-2025
* Last Modified : 13-April-2026
***************************************************************************************************************************/
public without sharing class CommunityLoginController {
    private static final String LOCKED_ACCOUNT_MESSAGE = 'Your account has been locked due to too many failed login attempts. Please contact your recruiter for assistance.';
    
    /**
     * Interface that defines the contract for community login actions.
     * This allows for dependency injection and mocking of Site.login() during unit testing.
     */
    public interface SiteLoginAction {
        /**
         * Performs a login action using the provided credentials.
         *
         * @param username The community user's Salesforce username.
         * @param password The community user's password.
         * @param startUrl The URL to redirect to after successful login.
         * @return A PageReference representing the post-login destination.
         */
        PageReference doLogin(String username, String password, String startUrl);
    }
    
    /**
     * Default implementation of SiteLoginAction that invokes the standard
     * Salesforce Site.login() method for authenticating community users.
     */
    public class DefaultSiteLoginAction implements SiteLoginAction {
        /**
         * Invokes the standard Site.login() method to authenticate the user.
         *
         * @param username The community user's Salesforce username.
         * @param password The community user's password.
         * @param startUrl The URL to redirect to after successful login.
         * @return A PageReference returned by Site.login() after successful authentication.
         */
        public PageReference doLogin(String username, String password, String startUrl) {
            return Site.login(username, password, startUrl);
        }
    }
    
    /**
     * Mock implementation of SiteLoginAction, used only in test context.
     * Simulates login behavior for unit testing without invoking the real Site.login().
     */
    @TestVisible
    public class MockSiteLoginAction implements SiteLoginAction {
        /**
         * Simulates a successful or failed login attempt depending on input credentials.
         *
         * @param username The mock username used for test verification.
         * @param password The mock password used for test verification.
         * @param startUrl The URL to redirect to after simulated login.
         * @return A mock PageReference if credentials are valid, otherwise throws an exception.
         * @throws AuraHandledException If the provided credentials are invalid.
         */
        public PageReference doLogin(String username, String password, String startUrl) {
            if (username == 'normal_user@test.com' && password == 'password123') {
                return new PageReference('/home');
            } else {
                throw new AuraHandledException('Invalid credentials or login failed.');
            }
        }
    }
    
    /**
     * Holds the current SiteLoginAction implementation being used.
     * By default, this points to DefaultSiteLoginAction, but can be replaced
     * with a mock version during test execution for isolation.
     */
    @TestVisible private static SiteLoginAction siteLoginAction = new DefaultSiteLoginAction();

    /**
     * Injects a custom or mock implementation of SiteLoginAction.
     * This method allows tests to override the default behavior of Site.login().
     *
     * @param mockAction The mock implementation of SiteLoginAction.
     */
    @TestVisible
    public static void setSiteLoginAction(SiteLoginAction mockAction) {
        siteLoginAction = mockAction;
    }
    
    /**
     * Retrieves user details based on the provided email address.
     * This method is used to determine whether the user exists
     * and if they have a FederationIdentifier (indicating SSO configuration).
     *
     * @param email The email address entered by the user on the login screen.
     * @return The User record matching the provided email, or null if no user is found.
     * @AuraEnabled(cacheable=false)
     */
    @AuraEnabled(cacheable=false)
    public static User getUserByEmail(String email) {
        if (String.isBlank(email)) return null;

        List<User> users = [
            SELECT Id, Username, FederationIdentifier
            FROM User
            WHERE Email = :email AND IsActive = true
            LIMIT 1
        ];

        return users.isEmpty() ? null : users[0];
    }

    /**
     * Checks whether the user account associated with the supplied email is password locked.
     *
     * @param email The email address entered by the user on the login screen.
     * @return true when the matching user's UserLogin indicates password lock; otherwise false.
     */
    @AuraEnabled(cacheable=false)
    public static Boolean isUserLocked(String email) {
        if (String.isBlank(email)) {
            return false;
        }

        List<User> users = [
            SELECT Id
            FROM User
            WHERE Email = :email AND IsActive = true
            LIMIT 1
        ];

        if (users.isEmpty()) {
            return false;
        }

        List<UserLogin> userLogins = [
            SELECT IsPasswordLocked
            FROM UserLogin
            WHERE UserId = :users[0].Id
            LIMIT 1
        ];

        return !userLogins.isEmpty() && userLogins[0].IsPasswordLocked;
    }

    /**
     * Authenticates a community user using the standard username-password login mechanism.
     * Internally calls Site.login(String, String, String) to perform authentication.
     * During test runs, this method automatically switches to MockSiteLoginAction.
     *
     * @param username The Salesforce username associated with the community user.
     * @param password The password entered by the user.
     * @return The redirect URL returned by Site.login(), or null if login fails.
     * @throws AuraHandledException If authentication fails or an exception occurs during login.
     * @AuraEnabled
     */
    @AuraEnabled
    public static String login(String username, String password) {
        try {
            // Use mock implementation automatically during test runs
            if (Test.isRunningTest()) {
                siteLoginAction = new MockSiteLoginAction();
            }
            
            PageReference loginPage = siteLoginAction.doLogin(username, password, null);
            return loginPage != null ? loginPage.getUrl() : null;
        } catch (Exception e) {
            String exceptionMessage = e.getMessage() != null ? e.getMessage().toLowerCase() : '';
            if (exceptionMessage.contains('lock')) {
                throw new AuraHandledException(LOCKED_ACCOUNT_MESSAGE);
            }
            throw new AuraHandledException('Invalid credentials or login failed.');
        }
    }
}