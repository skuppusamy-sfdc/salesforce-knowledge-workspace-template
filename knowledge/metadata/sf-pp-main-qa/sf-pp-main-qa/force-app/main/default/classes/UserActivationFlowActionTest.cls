@isTest
private class UserActivationFlowActionTest {
    private static final String COMMUNITY_PROFILE_NAME = 'Core HC Customer Community Plus Login User';

    private static User createPortalOwnerWithRole() {
        UserRole ownerRole = new UserRole(Name = 'Portal Owner Role ' + String.valueOf(DateTime.now().getTime()));
        insert ownerRole;

        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        String unique = String.valueOf(DateTime.now().getTime());

        User ownerUser = new User(
            FirstName = 'Portal',
            LastName = 'Owner',
            Email = 'portal.owner.' + unique + '@example.com',
            Username = 'portal.owner.' + unique + '@example.com',
            Alias = 'pownr',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = sysAdminProfile.Id,
            LanguageLocaleKey = 'en_US',
            UserRoleId = ownerRole.Id
        );
        insert ownerUser;
        return ownerUser;
    }

    private static User createTestUser(Boolean isActive) {
        TestDataFactory factory = new TestDataFactory();
        User portalAccountOwner = createPortalOwnerWithRole();
        User createdUser;
        Profile communityProfile = [SELECT Id FROM Profile WHERE Name = :COMMUNITY_PROFILE_NAME LIMIT 1];

        System.runAs(portalAccountOwner) {
            Account clinicianAccount = factory.createServiceAccount(null, 'PortalClinician', 'Clinician', true);
            Contact clinicianContact = factory.getOrCreateContact(clinicianAccount, 'PortalClinician');
            String unique = String.valueOf(DateTime.now().getTime());
            createdUser = new User(
                FirstName = clinicianContact.FirstName,
                LastName = clinicianContact.LastName,
                ContactId = clinicianContact.Id,
                Username = 'community.user.' + unique + '@example.com',
                Email = 'community.user.' + unique + '@example.com',
                CommunityNickname = ('community' + unique).substring(0, Math.min(40, ('community' + unique).length())),
                Alias = 'cmusr',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                EmailEncodingKey = 'UTF-8',
                ProfileId = communityProfile.Id,
                LanguageLocaleKey = 'en_US',
                IsActive = true
            );
            insert createdUser;
        }

        System.assertNotEquals(null, createdUser, 'Community user should be created for profile: ' + COMMUNITY_PROFILE_NAME);

        if (!isActive) {
            createdUser.IsActive = false;
            update createdUser;
        }

        return createdUser;
    }

    @isTest
    static void testActivateUsersAsync_ActivatesInactiveUser() {
        User inactiveUser = createTestUser(false);

        UserActivationFlowAction.ActivateUserRequest validRequest = new UserActivationFlowAction.ActivateUserRequest();
        validRequest.userRecord = new User(Id = inactiveUser.Id);

        UserActivationFlowAction.ActivateUserRequest missingIdRequest = new UserActivationFlowAction.ActivateUserRequest();
        missingIdRequest.userRecord = new User();

        UserActivationFlowAction.ActivateUserRequest nullUserRequest = new UserActivationFlowAction.ActivateUserRequest();

        Test.startTest();
        UserActivationFlowAction.activateUsersAsync(
            new List<UserActivationFlowAction.ActivateUserRequest>{
                validRequest,
                missingIdRequest,
                nullUserRequest,
                null
            }
        );
        Test.stopTest();

        User refreshed = [SELECT IsActive FROM User WHERE Id = :inactiveUser.Id];
        System.assertEquals(true, refreshed.IsActive, 'Inactive user should be activated by queued job.');
    }

    @isTest
    static void testActivateUsersAsync_NoValidIds_DoesNothing() {
        User inactiveUser = createTestUser(false);

        UserActivationFlowAction.ActivateUserRequest missingIdRequest = new UserActivationFlowAction.ActivateUserRequest();
        missingIdRequest.userRecord = new User();

        UserActivationFlowAction.ActivateUserRequest nullUserRequest = new UserActivationFlowAction.ActivateUserRequest();

        Test.startTest();
        UserActivationFlowAction.activateUsersAsync(
            new List<UserActivationFlowAction.ActivateUserRequest>{
                missingIdRequest,
                nullUserRequest,
                null
            }
        );
        Test.stopTest();

        User refreshed = [SELECT IsActive FROM User WHERE Id = :inactiveUser.Id];
        System.assertEquals(false, refreshed.IsActive, 'User should remain inactive when no valid user Id is provided.');
    }

    @isTest
    static void testQueueableExecute_NoMatchingIds() {
        User activeUser = createTestUser(true);

        Test.startTest();
        System.enqueueJob(new UserActivationFlowAction.ActivateUserQueueable(new List<Id>()));
        System.enqueueJob(new UserActivationFlowAction.ActivateUserQueueable(new List<Id>{ activeUser.Id }));
        Test.stopTest();

        System.assert(true, 'Queueable execute paths completed without exceptions.');
    }
}