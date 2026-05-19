/**
 * This Utility contains the custom functions
 * which can not be done by OOB through Omnistudio to log error for Apex Exception
 * 
 * @author Salesforce Services
 * @version 1.0
 * @since 12/24/2025
 * 
 * Modification Logs
 * =================================================================================
 * StoryNumber		DeveloperName		ModifiedDate		Description
 * =================================================================================
 * PR1050558-4791	Abhinav Mishra	    12/24/2025			Created this utility	
 * 
 * 
 * =================================================================================
 */
public without sharing class ErrorLogUtil {

    // Constants for Field Limits
    private static final Integer MAX_TEXT_LENGTH = 32768;
    private static final Integer MAX_SHORT_TEXT_LENGTH = 255;

    /**
     * @description Main method to log an Exception.
     * @param e The Exception object caught.
     * @param sourceComponent The Class/Method where the error occurred.
     * @param recordId (Optional) The ID of the record being processed.
     */
    public static void logException(Exception e, String sourceComponent, String recordId) {
        logException(e, sourceComponent, recordId, null, null);
    }

    /**
     * @description Overloaded method for Integration specific errors.
     * @param e The Exception object.
     * @param sourceComponent Class/Method name.
     * @param recordId Related Record ID.
     * @param integrationProcess Name of the API or Process.
     * @param contextJson JSON payload or extra debugging info.
     */
    public static void logException(Exception e, String sourceComponent, String recordId, String integrationProcess, String contextJson) {
        
        Error_Log__c newLog = new Error_Log__c();

        // Standard Fields
        newLog.Error_Timestamp__c = System.now();
        newLog.Source_Component__c = truncate(sourceComponent, MAX_SHORT_TEXT_LENGTH);
        newLog.Record_Id__c = truncate(recordId, MAX_SHORT_TEXT_LENGTH);
        newLog.Is_Handled__c = false; 
        
        // Exception Specifics
        if (e != null) {
            newLog.Error_Message__c = truncate(e.getMessage(), MAX_TEXT_LENGTH);
            newLog.Stack_Trace__c = truncate(e.getStackTraceString(), MAX_TEXT_LENGTH);
            newLog.Error_Type__c = e.getTypeName(); // e.g., 'System.DmlException'
            newLog.Type__c = 'Apex'; // Defaulting to Apex, change logic if needed
            newLog.Severity__c = 'High'; // Default severity
        }

        // Integration Specifics
        if (String.isNotBlank(integrationProcess)) {
            newLog.Integration_Process__c = truncate(integrationProcess, MAX_SHORT_TEXT_LENGTH);
            newLog.Type__c = 'Integration';
        }

        // Context Data
        if (String.isNotBlank(contextJson)) {
            newLog.Context_JSON__c = truncate(contextJson, MAX_TEXT_LENGTH);
        }

        // Commit the log
        insertLog(newLog);
    }

    /**
     * @description Method to log a custom error message without an Exception object
     * (e.g., Validation failures or HTTP Error responses).
     */
    public static void logCustomError(String errorMessage, String severity, String sourceComponent, String integrationProcess, String direction) {
        Error_Log__c newLog = new Error_Log__c();
        
        newLog.Error_Timestamp__c = System.now();
        newLog.Error_Message__c = truncate(errorMessage, MAX_TEXT_LENGTH);
        newLog.Severity__c = severity;
        newLog.Source_Component__c = truncate(sourceComponent, MAX_SHORT_TEXT_LENGTH);
        newLog.Integration_Process__c = truncate(integrationProcess, MAX_SHORT_TEXT_LENGTH);
        
        // Handling the schema typo explicitly
        newLog.Integraiton_Direction__c = direction; 
        
        insertLog(newLog);
    }

    /**
     * @description Private helper to insert the log safely.
     */
    private static void insertLog(Error_Log__c log) {
        try {
            // allowPartialSuccess = false, usually we just want to attempt the insert
            // and fail silently if the log object itself has issues.
            Database.insert(log, false);
        } catch (Exception ex) {
            System.debug('Failed to write Error Log: ' + ex.getMessage());
        }
    }

    /**
     * @description Helper utility to truncate strings to avoid Field Too Large errors.
     */
    private static String truncate(String input, Integer length) {
        if (String.isBlank(input)) {
            return input;
        }
        if (input.length() > length) {
            return input.substring(0, length);
        }
        return input;
    }
    
    @InvocableMethod(label='Create Error Log' description='Creates an Error_Log__c record from a Flow' category='Error Logging')
    public static void logErrorFromFlow(List<ErrorLogRequest> requests) {
        for (ErrorLogRequest req : requests) {
            ErrorLogUtil.logCustomError(
                req.errorMessage,
                req.severity,
                req.sourceComponent,
                req.integrationProcess,
                req.direction
            );
        }
    }

    public class ErrorLogRequest {
        @InvocableVariable(label='Error Message' required=true)
        public String errorMessage;

        @InvocableVariable(label='Severity' description='e.g. High, Medium, Low')
        public String severity;

        @InvocableVariable(label='Source Component' description='Flow or process name where the error occurred')
        public String sourceComponent;

        @InvocableVariable(label='Integration Process' description='Name of the API or integration process')
        public String integrationProcess;

        @InvocableVariable(label='Direction' description='Inbound or Outbound')
        public String direction;
    }
}