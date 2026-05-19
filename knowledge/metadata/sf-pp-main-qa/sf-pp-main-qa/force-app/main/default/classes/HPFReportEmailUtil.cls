/**
 * @description
 * Utility class to send HPF inactivation report emails. Contains all email
 * composition logic: recipient collection, HTML body/table construction,
 * and email dispatch.
 *
 * HPF record IDs are passed directly from the calling batch class
 * (DeactivateHPFsForClinician) — the batch already identifies which HPFs
 * are 12-month inactives and which are 9-month warnings during its execute()
 * processing, so there is no need to re-query or hit the Reports API.
 *
 * Called from DeactivateHPFsForClinician.finish() after HPF records have
 * been updated.
 *
 * Configuration: Update the constants at the top of this class to modify
 * recipient roles, email addresses, report names, or support contacts.
 *
 * @author Srishty Sharma
 * @date 2026-04-02
 * @since 1.0
 */
public class HPFReportEmailUtil {

    // ═══════════════════════════════════════════════════════════════════
    // RECIPIENT CONFIGURATION – update these lists to add/remove recipients
    // ═══════════════════════════════════════════════════════════════════

    @TestVisible
    private static final List<String> RECIPIENT_TEAM_ROLES = new List<String>{
        'Medical Staff Coordinator',
        'Clinician Experience Specialist',
        'Provider Coverage Coordinator',
        'Medical Staff Liaison - CPA',
        'Director of Scheduling',
        'Credentialing Manager'
    };

    @TestVisible
    private static final List<String> RECIPIENT_EMAIL_CONFIG_LABELS = new List<String>{
        'SalesforceDataQuality',
        'inactivations',
        'eeinactivations'
    };

    // ═══════════════════════════════════════════════════════════════════
    // REPORT CONFIGURATION – developer names of the reports to link in email
    // ═══════════════════════════════════════════════════════════════════

    private static final String INACTIVE_HPF_REPORT_NAME = 'Inactive_HPF_JER';
    private static final String WARNING_HPF_REPORT_NAME  = 'X3_Month_HPF_Inactivation';

    // ═══════════════════════════════════════════════════════════════════
    // EMAIL CONFIGURATION
    // ═══════════════════════════════════════════════════════════════════

    private static final String ORG_WIDE_EMAIL_NAME = 'No Reply';
    private static final String SUPPORT_EMAIL       = 'DL.SALESFORCEDQ@SCP-HEALTH.COM';

    // ═══════════════════════════════════════════════════════════════════
    // TABLE STYLING – inline CSS applied to the HTML email tables
    // ═══════════════════════════════════════════════════════════════════

    private static final String TABLE_STYLE   = 'border-collapse:collapse;width:100%;font-family:Arial,sans-serif;font-size:12px;';
    private static final String HEADER_STYLE  = 'background-color:#4472C4;color:#ffffff;padding:8px;border:1px solid #ddd;text-align:left;';
    private static final String CELL_STYLE    = 'padding:8px;border:1px solid #ddd;';
    private static final String ALT_ROW_STYLE = 'background-color:#f2f2f2;';

    // ═══════════════════════════════════════════════════════════════════
    // TEST HOOKS
    // ═══════════════════════════════════════════════════════════════════

    @TestVisible private static Id testEmailExceptionAccountId = null;
    @TestVisible private static Boolean triggerSendEmailException = false;
    @TestVisible private static Boolean triggerSendEmailInnerException = false;

    // ═══════════════════════════════════════════════════════════════════
    // PUBLIC ENTRY POINT
    // ═══════════════════════════════════════════════════════════════════

    /**
     * @description Sends the HPF inactivation report email. Call this from
     *              the finish() method of DeactivateHPFsForClinician.
     * @param accountIds    Account IDs whose team members should receive the email
     * @param inactiveHpfIds HPF IDs that were deactivated (12-month inactives)
     * @param warningHpfIds  HPF IDs flagged as 9-month warnings (270-day)
     */
    public static void sendHPFReportEmail(Set<Id> accountIds, Set<Id> inactiveHpfIds, Set<Id> warningHpfIds) {
        if (Test.isRunningTest() && testEmailExceptionAccountId != null &&
            accountIds != null && accountIds.contains(testEmailExceptionAccountId)) {
            throw new CalloutException('Test exception for catch coverage');
        }

        Set<Id> safeAccountIds = (accountIds != null) ? accountIds : new Set<Id>();
        Set<String> recipientEmails = collectRecipientEmails(safeAccountIds);
        if (recipientEmails.isEmpty()) {
            return;
        }

        Id orgWideEmailId = getOrgWideEmailId();
        String baseUrl = getBaseUrl();
        Map<String, Id> reportIdMap = getReportIds();

        String subject = 'PFA 12 month Inactivation: ' + Date.today().format();
        String emailBody = buildEmailBody(baseUrl, reportIdMap, inactiveHpfIds, warningHpfIds);

        dispatchEmail(new List<String>(recipientEmails), orgWideEmailId, subject, emailBody);
    }

    // ═══════════════════════════════════════════════════════════════════
    // RECIPIENT COLLECTION
    // ═══════════════════════════════════════════════════════════════════

    @TestVisible
    private static Set<String> collectRecipientEmails(Set<Id> accountIds) {
        Set<String> emails = new Set<String>();
        addAccountTeamEmails(emails, accountIds);
        addConfiguredEmails(emails);
        return emails;
    }

    private static void addAccountTeamEmails(Set<String> emails, Set<Id> accountIds) {
        for (AccountTeamMember atm : [
            SELECT User.Email
            FROM AccountTeamMember
            WHERE AccountId IN :accountIds
              AND TeamMemberRole IN :RECIPIENT_TEAM_ROLES
              AND User.Email != null
        ]) {
            emails.add(atm.User.Email);
        }
    }

    private static void addConfiguredEmails(Set<String> emails) {
        for (Email_Address_Configuration__mdt config : [
            SELECT Email__c
            FROM Email_Address_Configuration__mdt
            WHERE Label IN :RECIPIENT_EMAIL_CONFIG_LABELS
              AND IsActive__c = true
        ]) {
            if (config.Email__c != null) {
                emails.add(config.Email__c);
            }
        }
    }

    // ═══════════════════════════════════════════════════════════════════
    // EMAIL BODY CONSTRUCTION
    // ═══════════════════════════════════════════════════════════════════

    @TestVisible
    private static String buildEmailBody(String baseUrl, Map<String, Id> reportIdMap,
                                          Set<Id> inactiveHpfIds, Set<Id> warningHpfIds) {
        String body = buildDisclaimerSection();

        Id inactiveReportId = reportIdMap.get(INACTIVE_HPF_REPORT_NAME);
        body += buildInactiveHpfSection(baseUrl, inactiveReportId, inactiveHpfIds);

        Id warningReportId = reportIdMap.get(WARNING_HPF_REPORT_NAME);
        body += buildWarningHpfSection(baseUrl, warningReportId, warningHpfIds);

        return body;
    }

    private static String buildDisclaimerSection() {
        return '<p style="font-weight:bold;color:#FF0000;">' +
               'IF YOU HAVE QUESTIONS OR CONCERNS ABOUT DATA REPRESENTED BELOW, ' +
               'PLEASE DO NOT REPLY TO THIS EMAIL, BUT DIRECT THEM TO ' +
               '<a href="mailto:' + SUPPORT_EMAIL + '">' + SUPPORT_EMAIL + '</a>' +
               '</p>';
    }

    private static String buildInactiveHpfSection(String baseUrl, Id reportId, Set<Id> hpfIds) {
        String section = '<hr/>';
        section += '<p>The following providers were identified as not having worked for the past year ' +
                   'and the HPF status has been changed to Inactive.</p>';

        if (reportId != null) {
            String reportLink = baseUrl + '/' + reportId;
            section += '<p>Please navigate to the following report for additional details ' +
                       '<a href="' + reportLink + '" target="_blank">here</a></p>';
        }

        List<HealthcarePractitionerFacility> hpfs = (hpfIds != null && !hpfIds.isEmpty())
            ? queryHpfsByIds(hpfIds)
            : new List<HealthcarePractitionerFacility>();
        section += buildInactiveHpfTable(baseUrl, hpfs);

        return section;
    }

    private static String buildWarningHpfSection(String baseUrl, Id reportId, Set<Id> hpfIds) {
        String section = '<hr/>';
        section += '<p>The following providers were identified as not having worked for the past 9 months ' +
                   'and the HPF status will be changed to &quot;Inactive&quot; when the aging counter reaches 0 ' +
                   '(not having worked for the past year).</p>';

        if (reportId != null) {
            String reportLink = baseUrl + '/' + reportId;
            section += '<p>Please navigate to the following report for additional details ' +
                       '<a href="' + reportLink + '" target="_blank">here</a></p>';
        }

        List<HealthcarePractitionerFacility> hpfs = (hpfIds != null && !hpfIds.isEmpty())
            ? queryHpfsByIds(hpfIds)
            : new List<HealthcarePractitionerFacility>();
        section += buildWarningHpfTable(baseUrl, hpfs);

        return section;
    }

    // ═══════════════════════════════════════════════════════════════════
    // HPF DATA QUERY – fetches full SObject data for the IDs from batch
    // ═══════════════════════════════════════════════════════════════════

    @TestVisible
    private static List<HealthcarePractitionerFacility> queryHpfsByIds(Set<Id> hpfIds) {
        if (hpfIds == null || hpfIds.isEmpty()) {
            return new List<HealthcarePractitionerFacility>();
        }
        return [
            SELECT Id, Name,
                   Account.Id, Account.Name,
                   Account.Staffing_Team__c,
                   Practitioner.Id, Practitioner.Name,
                   Practitioner.Professional_Title__c,
                   Facility_Title__c,
                   Facility_Title__r.Name,
                   Last_Date_Worked__c,
                   Aging_Days_Left__c
            FROM HealthcarePractitionerFacility
            WHERE Id IN :hpfIds
        ];
    }

    // ═══════════════════════════════════════════════════════════════════
    // HTML TABLE BUILDERS
    // ═══════════════════════════════════════════════════════════════════

    private static String buildInactiveHpfTable(String baseUrl, List<HealthcarePractitionerFacility> hpfs) {
        List<String> headers = new List<String>{
            'HPF', 'Facility', 'Staffing Team', 'Clinician',
            'Title', 'Facility Title', 'Last Date Worked'
        };

        List<List<String>> rows = new List<List<String>>();
        for (HealthcarePractitionerFacility hpf : hpfs) {
            rows.add(new List<String>{
                buildRecordLink(baseUrl, hpf.Id, hpf.Name),
                buildRecordLink(baseUrl, hpf.Account?.Id, hpf.Account?.Name),
                safeString(hpf.Account?.Staffing_Team__c),
                buildRecordLink(baseUrl, hpf.Practitioner?.Id, hpf.Practitioner?.Name),
                safeString(hpf.Practitioner?.Professional_Title__c),
                safeString(hpf.Facility_Title__r?.Name),
                safeDate(hpf.Last_Date_Worked__c)
            });
        }

        return buildHtmlTable(headers, rows);
    }

    private static String buildWarningHpfTable(String baseUrl, List<HealthcarePractitionerFacility> hpfs) {
        List<String> headers = new List<String>{
            'HPF', 'Facility', 'Staffing Team', 'Clinician',
            'Title', 'Facility Title', 'Last Date Worked', 'Aging'
        };

        List<List<String>> rows = new List<List<String>>();
        for (HealthcarePractitionerFacility hpf : hpfs) {
            rows.add(new List<String>{
                buildRecordLink(baseUrl, hpf.Id, hpf.Name),
                buildRecordLink(baseUrl, hpf.Account?.Id, hpf.Account?.Name),
                safeString(hpf.Account?.Staffing_Team__c),
                buildRecordLink(baseUrl, hpf.Practitioner?.Id, hpf.Practitioner?.Name),
                safeString(hpf.Practitioner?.Professional_Title__c),
                safeString(hpf.Facility_Title__r?.Name),
                safeDate(hpf.Last_Date_Worked__c),
                safeDecimal(hpf.Aging_Days_Left__c)
            });
        }

        return buildHtmlTable(headers, rows);
    }

    private static String buildHtmlTable(List<String> headers, List<List<String>> rows) {
        String tbl = '<table style="' + TABLE_STYLE + '">';

        tbl += '<tr>';
        for (String header : headers) {
            tbl += '<th style="' + HEADER_STYLE + '">' + header + '</th>';
        }
        tbl += '</tr>';

        if (rows.isEmpty()) {
            tbl += '<tr>';
            for (Integer i = 0; i < headers.size(); i++) {
                tbl += '<td style="' + CELL_STYLE + '">&nbsp;</td>';
            }
            tbl += '</tr>';
        } else {
            Integer rowIndex = 0;
            for (List<String> row : rows) {
                String rowStyle = Math.mod(rowIndex, 2) == 1 ? ALT_ROW_STYLE : '';
                tbl += '<tr style="' + rowStyle + '">';
                for (String cell : row) {
                    tbl += '<td style="' + CELL_STYLE + '">' + cell + '</td>';
                }
                tbl += '</tr>';
                rowIndex++;
            }
        }

        tbl += '</table>';
        return tbl;
    }

    // ═══════════════════════════════════════════════════════════════════
    // UTILITY METHODS
    // ═══════════════════════════════════════════════════════════════════

    private static String buildRecordLink(String baseUrl, Id recordId, String label) {
        if (recordId == null) {
            return '';
        }
        String displayLabel = String.isNotBlank(label) ? label : String.valueOf(recordId);
        return '<a href="' + baseUrl + '/' + recordId + '" target="_blank">' + displayLabel + '</a>';
    }

    private static String safeString(String val) {
        return String.isNotBlank(val) ? val : '';
    }

    private static String safeDate(Date val) {
        return val != null ? val.format() : '';
    }

    private static String safeDecimal(Decimal val) {
        return val != null ? String.valueOf(val.intValue()) : '';
    }

    private static String getBaseUrl() {
        String baseUrl = URL.getOrgDomainUrl().toExternalForm();
        if (baseUrl.endsWith('/')) {
            baseUrl = baseUrl.substring(0, baseUrl.length() - 1);
        }
        return baseUrl;
    }

    private static Id getOrgWideEmailId() {
        List<OrgWideEmailAddress> owea = [
            SELECT Id
            FROM OrgWideEmailAddress
            WHERE DisplayName = :ORG_WIDE_EMAIL_NAME
            LIMIT 1
        ];
        if (owea.isEmpty()) {
            return null;
        }
        return owea[0].Id;
    }

    private static Map<String, Id> getReportIds() {
        List<String> reportNames = new List<String>{ INACTIVE_HPF_REPORT_NAME, WARNING_HPF_REPORT_NAME };
        Map<String, Id> reportMap = new Map<String, Id>();
        for (Report r : [
            SELECT Id, DeveloperName
            FROM Report
            WHERE DeveloperName IN :reportNames
        ]) {
            reportMap.put(r.DeveloperName, r.Id);
        }
        return reportMap;
    }

    private static void dispatchEmail(List<String> recipients, Id orgWideEmailId, String subject, String body) {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(recipients);
        if (orgWideEmailId != null) {
            email.setOrgWideEmailAddressId(orgWideEmailId);
        }
        email.setSubject(subject);
        email.setHtmlBody(body);
        email.setSaveAsActivity(false);

        if (Test.isRunningTest() && triggerSendEmailException) {
            throw new CalloutException('Test exception for send email coverage');
        }

        try {
            if (Test.isRunningTest() && triggerSendEmailInnerException) {
                throw new CalloutException('Test exception for inner catch coverage');
            }
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ email });
        } catch (Exception e) {
            ErrorLogUtil.logException(e, 'HPFReportEmailUtil::dispatchEmail', null);
            throw e;
        }
    }
}