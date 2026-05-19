/**
 * @description Utility for error logging and async job notifications in rate change flows.
 * Consolidates ErrorLogRateChange (Error_Log__c) and AsyncJobNotificationUtil (CustomNotification).
 * Used by CloneContractAction, PendingRateChangeChecker, PostProcessRateChangeAction,
 * RateChangeQueueable, etc.
 */
public with sharing class RateChangeNotificationUtil {

    private static final String NOTIFICATION_TYPE_DEV_NAME = 'Contract_Management_Job_Complete';

    /**
     * @description Logs errors to Error_Log__c custom object.
     * Handles Database.Error[], Exception, or generic Object. Silently catches insert failures to avoid recursion.
     * @param context Source component name for the log
     * @param recordId Optional record Id associated with the error
     * @param err Database.Error[], Exception, or error details (String, etc.)
     */
    public static void logError(String context, String recordId, Object err) {
        if (err == null) {
            return;
        }

        List<Error_Log__c> logs = new List<Error_Log__c>();

        if (err instanceof Database.Error[]) {
            for (Database.Error dbErr : (Database.Error[]) err) {
                logs.add(new Error_Log__c(
                    Source_Component__c = context,
                    Record_Id__c = recordId,
                    Error_Message__c = dbErr.getMessage(),
                    Stack_Trace__c = dbErr.getStatusCode() != null ? dbErr.getStatusCode().name() : 'No Status Code'
                ));
            }
        } else if (err instanceof Exception) {
            Exception ex = (Exception) err;
            logs.add(new Error_Log__c(
                Source_Component__c = context,
                Record_Id__c = recordId,
                Error_Message__c = ex.getMessage(),
                Stack_Trace__c = ex.getStackTraceString()
            ));
        } else {
            logs.add(new Error_Log__c(
                Source_Component__c = context,
                Record_Id__c = recordId,
                Error_Message__c = String.valueOf(err),
                Stack_Trace__c = 'No stack trace available'
            ));
        }

        if (!logs.isEmpty()) {
            try {
                insert logs;
            } catch (Exception e) {
                // Cannot log to Error_Log__c when insert fails - would recurse
            }
        }
    }

    /**
     * @description Sends a custom notification to the user when an async job completes.
     * @param success Whether the job completed successfully
     * @param title Notification title (e.g. 'Clone Contract Complete')
     * @param body Notification body message
     * @param targetId Optional record Id to link the notification to (e.g. Clinical_Rate_Change__c or Contract)
     * @param userIdToNotify User Id to receive the notification; if null, uses current user
     */
    public static void sendNotification(Boolean success, String title, String body, Id targetId, Id userIdToNotify) {
        try {
            Id recipient = userIdToNotify != null ? userIdToNotify : UserInfo.getUserId();
            if (recipient == null) {
                return;
            }

            List<CustomNotificationType> cntList = [
                SELECT Id FROM CustomNotificationType
                WHERE DeveloperName = :NOTIFICATION_TYPE_DEV_NAME
                LIMIT 1
            ];
            if (cntList.isEmpty()) {
                return;
            }

            Messaging.CustomNotification notification = new Messaging.CustomNotification();
            notification.setNotificationTypeId(cntList[0].Id);
            if (targetId != null) {
                notification.setTargetId(targetId);
            }
            notification.setSenderId(UserInfo.getUserId());
            notification.setTitle(title);
            notification.setBody(body);
            notification.send(new Set<String>{ String.valueOf(recipient) });
        } catch (Exception e) {
            // Silently fail - notification is non-critical
        }
    }
}