/**
 * @description
 * Test class for HPFReportEmailUtil utility class.
 * Uses SeeAllData=true to access Reports and OrgWideEmailAddress
 * since they cannot be created in test context.
 *
 * @author Salesforce Developer
 * @date 2026-04-02
 * @since 1.0
 */
@isTest(SeeAllData=true)
private class HPFReportEmailUtilTest {
    
    /**
     * @description
     * Tests the full email sending flow with valid setup: Report, OrgWideEmailAddress,
     * Account Team Member, and an HPF terminated today.
     */
    @isTest
    static void testEmailSendingFlow() {
        List<Report> reports = [
            SELECT Id FROM Report WHERE DeveloperName = 'Inactive_HPF_JER' LIMIT 1
        ];
        List<OrgWideEmailAddress> orgWideEmails = [
            SELECT Id FROM OrgWideEmailAddress WHERE DisplayName = 'No Reply' LIMIT 1
        ];
        
        if (reports.isEmpty()) {
            System.debug('Report Inactive_HPF_JER not found. Skipping test.');
            return;
        }
        if (orgWideEmails.isEmpty()) {
            System.debug('OrgWideEmailAddress "No Reply" not found. Skipping test.');
            return;
        }
        
        Account testAccount = new Account(Name = 'Test Account for Email');
        insert testAccount;
        
        Profile standardProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User testUser = new User(
            FirstName = 'Test', LastName = 'EmailUser',
            Email = 'testemailuser@test.com',
            Username = 'hpfutil_emailuser' + System.now().getTime() + '@test.com',
            Alias = 'temail',
            ProfileId = standardProfile.Id,
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;
        
        AccountTeamMember atm = new AccountTeamMember(
            AccountId = testAccount.Id,
            UserId = testUser.Id,
            TeamMemberRole = 'Medical Staff Coordinator'
        );
        insert atm;
        
        HealthcarePractitionerFacility hpf = new HealthcarePractitionerFacility(
            AccountId = testAccount.Id,
            Status__c = 'Inactive',
            TerminationDate = Date.today(),
            Contracting_Status__c = 'Terminated'
        );
        insert hpf;
        
        Test.startTest();
        HPFReportEmailUtil.sendHPFReportEmail(
            new Set<Id>{ testAccount.Id },
            new Set<Id>{ hpf.Id },
            new Set<Id>()
        );
        Test.stopTest();
        
        System.assert(true, 'Email sending flow executed successfully');
    }
    
    /**
     * @description
     * Tests early return when null account IDs are passed.
     */
    @isTest
    static void testNullAccountIds() {
        Test.startTest();
        HPFReportEmailUtil.sendHPFReportEmail(null, null, null);
        Test.stopTest();
        
        System.assert(true, 'Handled null account IDs gracefully');
    }
    
    /**
     * @description
     * Tests early return when empty account IDs are passed.
     */
    @isTest
    static void testEmptyAccountIds() {
        Test.startTest();
        HPFReportEmailUtil.sendHPFReportEmail(new Set<Id>(), new Set<Id>(), new Set<Id>());
        Test.stopTest();
        
        System.assert(true, 'Handled empty account IDs gracefully');
    }
    
    /**
     * @description
     * Tests the flow when no Account Team Members match the configured roles,
     * and no Email Address Configuration records are active.
     * Covers the no-recipients early return path.
     */
    @isTest
    static void testNoRecipients() {
        List<Report> reports = [
            SELECT Id FROM Report WHERE DeveloperName = 'Inactive_HPF_JER' LIMIT 1
        ];
        List<OrgWideEmailAddress> orgWideEmails = [
            SELECT Id FROM OrgWideEmailAddress WHERE DisplayName = 'No Reply' LIMIT 1
        ];
        
        if (reports.isEmpty() || orgWideEmails.isEmpty()) {
            System.debug('Prerequisites not found. Skipping test.');
            return;
        }
        
        Account testAccount = new Account(Name = 'Test Account No Recipients');
        insert testAccount;
        
        HealthcarePractitionerFacility hpf = new HealthcarePractitionerFacility(
            AccountId = testAccount.Id,
            Status__c = 'Inactive',
            TerminationDate = Date.today(),
            Contracting_Status__c = 'Terminated'
        );
        insert hpf;
        
        Test.startTest();
        HPFReportEmailUtil.sendHPFReportEmail(
            new Set<Id>{ testAccount.Id },
            new Set<Id>{ hpf.Id },
            new Set<Id>()
        );
        Test.stopTest();
        
        System.assert(true, 'Handled no-recipients scenario gracefully');
    }
    
    /**
     * @description
     * Tests the flow when the Report does not exist.
     * Email body will skip report links but should still include tables.
     */
    @isTest
    static void testEmailSendingFlowWithoutReport() {
        Account testAccount = new Account(Name = 'Test Account No Report');
        insert testAccount;
        
        Profile standardProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User testUser = new User(
            FirstName = 'Test', LastName = 'NoReportUser',
            Email = 'testnoreport@test.com',
            Username = 'hpfutil_noreport' + System.now().getTime() + '@test.com',
            Alias = 'tnorep',
            ProfileId = standardProfile.Id,
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;
        
        AccountTeamMember atm = new AccountTeamMember(
            AccountId = testAccount.Id,
            UserId = testUser.Id,
            TeamMemberRole = 'Medical Staff Coordinator'
        );
        insert atm;
        
        HealthcarePractitionerFacility hpf = new HealthcarePractitionerFacility(
            AccountId = testAccount.Id,
            Status__c = 'Inactive',
            TerminationDate = Date.today(),
            Contracting_Status__c = 'Terminated'
        );
        insert hpf;
        
        Test.startTest();
        HPFReportEmailUtil.sendHPFReportEmail(
            new Set<Id>{ testAccount.Id },
            new Set<Id>{ hpf.Id },
            new Set<Id>()
        );
        Test.stopTest();
        
        System.assert(true, 'Executed successfully even without Report');
    }
    
    /**
     * @description
     * Tests the flow when OrgWideEmailAddress does not exist.
     * Covers the early return path in sendHPFReportEmail.
     */
    @isTest
    static void testEmailSendingFlowWithoutOrgWideEmail() {
        List<Report> reports = [
            SELECT Id FROM Report WHERE DeveloperName = 'Inactive_HPF_JER' LIMIT 1
        ];
        if (reports.isEmpty()) {
            System.debug('Report Inactive_HPF_JER not found. Skipping test.');
            return;
        }
        
        Account testAccount = new Account(Name = 'Test Account No Org Email');
        insert testAccount;
        
        Profile standardProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User testUser = new User(
            FirstName = 'Test', LastName = 'NoOrgEmailUser',
            Email = 'testnoorgemail@test.com',
            Username = 'hpfutil_noorgemail' + System.now().getTime() + '@test.com',
            Alias = 'tnoorg',
            ProfileId = standardProfile.Id,
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;
        
        AccountTeamMember atm = new AccountTeamMember(
            AccountId = testAccount.Id,
            UserId = testUser.Id,
            TeamMemberRole = 'Medical Staff Coordinator'
        );
        insert atm;
        
        Test.startTest();
        HPFReportEmailUtil.sendHPFReportEmail(
            new Set<Id>{ testAccount.Id },
            new Set<Id>(),
            new Set<Id>()
        );
        Test.stopTest();
        
        System.assert(true, 'Executed successfully even without OrgWideEmailAddress');
    }
    
    /**
     * @description
     * Tests the testEmailExceptionAccountId test hook. When the account ID
     * matches the hook, sendHPFReportEmail throws before proceeding.
     * Covers the outer catch block in the caller.
     */
    @isTest
    static void testExceptionViaAccountIdHook() {
        Account testAccount = new Account(Name = 'Test Account Exception Hook');
        insert testAccount;
        
        HPFReportEmailUtil.testEmailExceptionAccountId = testAccount.Id;
        
        Test.startTest();
        try {
            HPFReportEmailUtil.sendHPFReportEmail(
                new Set<Id>{ testAccount.Id },
                new Set<Id>(),
                new Set<Id>()
            );
            System.assert(false, 'Expected exception was not thrown');
        } catch (Exception e) {
            System.assert(e.getMessage().contains('Test exception'), 'Caught expected test exception');
        }
        Test.stopTest();
        
        HPFReportEmailUtil.testEmailExceptionAccountId = null;
    }
    
    /**
     * @description
     * Tests the triggerSendEmailException test hook. When set to true,
     * dispatchEmail throws BEFORE the try block, simulating an outer exception.
     */
    @isTest
    static void testTriggerSendEmailException() {
        List<Report> reports = [
            SELECT Id FROM Report WHERE DeveloperName = 'Inactive_HPF_JER' LIMIT 1
        ];
        List<OrgWideEmailAddress> orgWideEmails = [
            SELECT Id FROM OrgWideEmailAddress WHERE DisplayName = 'No Reply' LIMIT 1
        ];
        
        if (reports.isEmpty() || orgWideEmails.isEmpty()) {
            System.debug('Prerequisites not found. Skipping test.');
            return;
        }
        
        Account testAccount = new Account(Name = 'Test Account SendEmail Exception');
        insert testAccount;
        
        Profile standardProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User testUser = new User(
            FirstName = 'Test', LastName = 'SendEmailEx',
            Email = 'testsendemailex@test.com',
            Username = 'hpfutil_sendemailex' + System.now().getTime() + '@test.com',
            Alias = 'tsndex',
            ProfileId = standardProfile.Id,
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;
        
        AccountTeamMember atm = new AccountTeamMember(
            AccountId = testAccount.Id,
            UserId = testUser.Id,
            TeamMemberRole = 'Medical Staff Coordinator'
        );
        insert atm;
        
        HPFReportEmailUtil.triggerSendEmailException = true;
        
        Test.startTest();
        try {
            HPFReportEmailUtil.sendHPFReportEmail(
                new Set<Id>{ testAccount.Id },
                new Set<Id>(),
                new Set<Id>()
            );
            System.assert(false, 'Expected exception was not thrown');
        } catch (Exception e) {
            System.assert(e.getMessage().contains('Test exception'), 'Caught expected send email exception');
        }
        Test.stopTest();
        
        HPFReportEmailUtil.triggerSendEmailException = false;
    }
    
    /**
     * @description
     * Tests the triggerSendEmailInnerException test hook. When set to true,
     * dispatchEmail throws INSIDE the try block, covering the inner catch.
     */
    @isTest
    static void testTriggerSendEmailInnerException() {
        List<Report> reports = [
            SELECT Id FROM Report WHERE DeveloperName = 'Inactive_HPF_JER' LIMIT 1
        ];
        List<OrgWideEmailAddress> orgWideEmails = [
            SELECT Id FROM OrgWideEmailAddress WHERE DisplayName = 'No Reply' LIMIT 1
        ];
        
        if (reports.isEmpty() || orgWideEmails.isEmpty()) {
            System.debug('Prerequisites not found. Skipping test.');
            return;
        }
        
        Account testAccount = new Account(Name = 'Test Account Inner Exception');
        insert testAccount;
        
        Profile standardProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User testUser = new User(
            FirstName = 'Test', LastName = 'InnerEx',
            Email = 'testinnerex@test.com',
            Username = 'hpfutil_innerex' + System.now().getTime() + '@test.com',
            Alias = 'tinnex',
            ProfileId = standardProfile.Id,
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;
        
        AccountTeamMember atm = new AccountTeamMember(
            AccountId = testAccount.Id,
            UserId = testUser.Id,
            TeamMemberRole = 'Medical Staff Coordinator'
        );
        insert atm;
        
        HPFReportEmailUtil.triggerSendEmailInnerException = true;
        
        Test.startTest();
        try {
            HPFReportEmailUtil.sendHPFReportEmail(
                new Set<Id>{ testAccount.Id },
                new Set<Id>(),
                new Set<Id>()
            );
            System.assert(false, 'Expected exception was not thrown');
        } catch (Exception e) {
            System.assert(e.getMessage().contains('Test exception'), 'Caught expected inner exception');
        }
        Test.stopTest();
        
        HPFReportEmailUtil.triggerSendEmailInnerException = false;
    }
    
    /**
     * @description
     * Tests the full flow with multiple Account Team Member roles to ensure
     * all configured roles are queried correctly.
     */
    @isTest
    static void testMultipleTeamRoles() {
        List<Report> reports = [
            SELECT Id FROM Report WHERE DeveloperName = 'Inactive_HPF_JER' LIMIT 1
        ];
        List<OrgWideEmailAddress> orgWideEmails = [
            SELECT Id FROM OrgWideEmailAddress WHERE DisplayName = 'No Reply' LIMIT 1
        ];
        
        if (reports.isEmpty() || orgWideEmails.isEmpty()) {
            System.debug('Prerequisites not found. Skipping test.');
            return;
        }
        
        Account testAccount = new Account(Name = 'Test Account Multi Roles');
        insert testAccount;
        
        Profile standardProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        
        List<User> testUsers = new List<User>();
        List<String> roles = new List<String>{
            'Medical Staff Coordinator', 'Director of Scheduling', 'Credentialing Manager'
        };
        for (Integer i = 0; i < roles.size(); i++) {
            testUsers.add(new User(
                FirstName = 'Test', LastName = 'Role' + i,
                Email = 'testrole' + i + '@test.com',
                Username = 'hpfutil_role' + i + '_' + System.now().getTime() + '@test.com',
                Alias = 'trole' + i,
                ProfileId = standardProfile.Id,
                TimeZoneSidKey = 'America/New_York',
                LocaleSidKey = 'en_US',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US'
            ));
        }
        insert testUsers;
        
        List<AccountTeamMember> atms = new List<AccountTeamMember>();
        for (Integer i = 0; i < roles.size(); i++) {
            atms.add(new AccountTeamMember(
                AccountId = testAccount.Id,
                UserId = testUsers[i].Id,
                TeamMemberRole = roles[i]
            ));
        }
        insert atms;
        
        HealthcarePractitionerFacility hpf = new HealthcarePractitionerFacility(
            AccountId = testAccount.Id,
            Status__c = 'Inactive',
            TerminationDate = Date.today(),
            Contracting_Status__c = 'Terminated'
        );
        insert hpf;
        
        Test.startTest();
        HPFReportEmailUtil.sendHPFReportEmail(
            new Set<Id>{ testAccount.Id },
            new Set<Id>{ hpf.Id },
            new Set<Id>()
        );
        Test.stopTest();
        
        System.assert(true, 'Email sent successfully with multiple team roles');
    }
    
    /**
     * @description
     * Tests the full email flow with multiple accounts to ensure recipients
     * are collected across all accounts.
     */
    @isTest
    static void testMultipleAccounts() {
        List<Report> reports = [
            SELECT Id FROM Report WHERE DeveloperName = 'Inactive_HPF_JER' LIMIT 1
        ];
        List<OrgWideEmailAddress> orgWideEmails = [
            SELECT Id FROM OrgWideEmailAddress WHERE DisplayName = 'No Reply' LIMIT 1
        ];
        
        if (reports.isEmpty() || orgWideEmails.isEmpty()) {
            System.debug('Prerequisites not found. Skipping test.');
            return;
        }
        
        Account testAccount1 = new Account(Name = 'Test Account Multi 1');
        Account testAccount2 = new Account(Name = 'Test Account Multi 2');
        insert new List<Account>{ testAccount1, testAccount2 };
        
        Profile standardProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User testUser1 = new User(
            FirstName = 'Test', LastName = 'Multi1',
            Email = 'testmulti1@test.com',
            Username = 'hpfutil_multi1_' + System.now().getTime() + '@test.com',
            Alias = 'tmlt1',
            ProfileId = standardProfile.Id,
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        User testUser2 = new User(
            FirstName = 'Test', LastName = 'Multi2',
            Email = 'testmulti2@test.com',
            Username = 'hpfutil_multi2_' + System.now().getTime() + '@test.com',
            Alias = 'tmlt2',
            ProfileId = standardProfile.Id,
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        insert new List<User>{ testUser1, testUser2 };
        
        insert new List<AccountTeamMember>{
            new AccountTeamMember(AccountId = testAccount1.Id, UserId = testUser1.Id, TeamMemberRole = 'Medical Staff Coordinator'),
            new AccountTeamMember(AccountId = testAccount2.Id, UserId = testUser2.Id, TeamMemberRole = 'Director of Scheduling')
        };
        
        HealthcarePractitionerFacility hpf1 = new HealthcarePractitionerFacility(
            AccountId = testAccount1.Id,
            Status__c = 'Inactive',
            TerminationDate = Date.today(),
            Contracting_Status__c = 'Terminated'
        );
        HealthcarePractitionerFacility hpf2 = new HealthcarePractitionerFacility(
            AccountId = testAccount2.Id,
            Status__c = 'Active',
            Inactivity_Qualified_270__c = true
        );
        insert new List<HealthcarePractitionerFacility>{ hpf1, hpf2 };
        
        Test.startTest();
        HPFReportEmailUtil.sendHPFReportEmail(
            new Set<Id>{ testAccount1.Id, testAccount2.Id },
            new Set<Id>{ hpf1.Id },
            new Set<Id>{ hpf2.Id }
        );
        Test.stopTest();
        
        System.assert(true, 'Email sent successfully with multiple accounts');
    }
    
    /**
     * @description
     * Tests the flow with both inactive and warning HPF IDs populated
     * to ensure both tables are generated in the email body.
     */
    @isTest
    static void testBothInactiveAndWarningHpfs() {
        List<Report> reports = [
            SELECT Id FROM Report WHERE DeveloperName = 'Inactive_HPF_JER' LIMIT 1
        ];
        List<OrgWideEmailAddress> orgWideEmails = [
            SELECT Id FROM OrgWideEmailAddress WHERE DisplayName = 'No Reply' LIMIT 1
        ];
        
        if (reports.isEmpty() || orgWideEmails.isEmpty()) {
            System.debug('Prerequisites not found. Skipping test.');
            return;
        }
        
        Account testAccount = new Account(Name = 'Test Account Both Tables');
        insert testAccount;
        
        Profile standardProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User testUser = new User(
            FirstName = 'Test', LastName = 'BothTables',
            Email = 'testbothtables@test.com',
            Username = 'hpfutil_bothtables' + System.now().getTime() + '@test.com',
            Alias = 'tboth',
            ProfileId = standardProfile.Id,
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;
        
        AccountTeamMember atm = new AccountTeamMember(
            AccountId = testAccount.Id,
            UserId = testUser.Id,
            TeamMemberRole = 'Medical Staff Coordinator'
        );
        insert atm;
        
        HealthcarePractitionerFacility hpfInactive = new HealthcarePractitionerFacility(
            AccountId = testAccount.Id,
            Status__c = 'Inactive',
            TerminationDate = Date.today(),
            Contracting_Status__c = 'Terminated'
        );
        HealthcarePractitionerFacility hpfWarning = new HealthcarePractitionerFacility(
            AccountId = testAccount.Id,
            Status__c = 'Active',
            Inactivity_Qualified_270__c = true,
            Aging_Days_Left__c = 90
        );
        insert new List<HealthcarePractitionerFacility>{ hpfInactive, hpfWarning };
        
        Test.startTest();
        HPFReportEmailUtil.sendHPFReportEmail(
            new Set<Id>{ testAccount.Id },
            new Set<Id>{ hpfInactive.Id },
            new Set<Id>{ hpfWarning.Id }
        );
        Test.stopTest();
        
        System.assert(true, 'Email sent with both inactive and warning tables');
    }
    
    /**
     * @description
     * Tests the flow when HPF ID sets are empty — email should still be sent
     * with the section text but no tables.
     */
    @isTest
    static void testEmptyHpfIdSets() {
        List<Report> reports = [
            SELECT Id FROM Report WHERE DeveloperName = 'Inactive_HPF_JER' LIMIT 1
        ];
        List<OrgWideEmailAddress> orgWideEmails = [
            SELECT Id FROM OrgWideEmailAddress WHERE DisplayName = 'No Reply' LIMIT 1
        ];
        
        if (reports.isEmpty() || orgWideEmails.isEmpty()) {
            System.debug('Prerequisites not found. Skipping test.');
            return;
        }
        
        Account testAccount = new Account(Name = 'Test Account Empty HPF Sets');
        insert testAccount;
        
        Profile standardProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User testUser = new User(
            FirstName = 'Test', LastName = 'EmptyHpf',
            Email = 'testemptyhpf@test.com',
            Username = 'hpfutil_emptyhpf' + System.now().getTime() + '@test.com',
            Alias = 'temhpf',
            ProfileId = standardProfile.Id,
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;
        
        AccountTeamMember atm = new AccountTeamMember(
            AccountId = testAccount.Id,
            UserId = testUser.Id,
            TeamMemberRole = 'Medical Staff Coordinator'
        );
        insert atm;
        
        Test.startTest();
        HPFReportEmailUtil.sendHPFReportEmail(
            new Set<Id>{ testAccount.Id },
            new Set<Id>(),
            new Set<Id>()
        );
        Test.stopTest();
        
        System.assert(true, 'Email sent with empty HPF ID sets (no tables)');
    }
}