/***************************************************************************************************************************
* Class Name    : PracticeOperationChangeUtil
* Description   : Utility class for Practice Operation Change processing that handles process type precedence logic.
*                 Provides helper methods for managing process type assignments with proper precedence rules.
* Author        : Srishty Sharma
* Created Date  : 22-Oct-2025
* Last Modified : 
***************************************************************************************************************************/
public with sharing class PracticeOperationChangeUtil {
    
    // Process type constants
    private static final String MANUAL_PROCESS_TYPE = 'Manual';
    private static final String AGENT_PROCESS_TYPE = 'Agent';
    private static final String AUTOMATION_PROCESS_TYPE = 'Automation';
    private static final String EMPTY_STRING = '';
    
    /**
     * Adds facility to processTypeToFacilities map with precedence:
     * Manual > Agent > Automation
     * 
     * This method implements a hierarchical precedence system where:
     * - Manual process type takes highest precedence and overrides Agent and Automation
     * - Agent process type takes precedence over Automation but not Manual
     * - Automation process type has lowest precedence
     * 
     * The method ensures that once a higher precedence process type is assigned,
     * it cannot be overridden by a lower precedence type.
     *
     * @param facilityWithProcessType Map<String, String> keyed by facility title, values are process types
     * @param facilityKey String representing FacilityTitle__c identifier
     * @param newType String representing the new process type to potentially assign
     * 
     * @example
     * Map<String, String> facilityMap = new Map<String, String>();
     * addProcessType(facilityMap, 'Facility1', 'Automation'); // Sets to Automation
     * addProcessType(facilityMap, 'Facility1', 'Agent'); // Overrides to Agent
     * addProcessType(facilityMap, 'Facility1', 'Manual'); // Overrides to Manual
     * addProcessType(facilityMap, 'Facility1', 'Automation'); // No change (Manual has precedence)
     */
    public static void addProcessType(Map<String, String> facilityWithProcessType, String facilityKey, String newType) {
        // Validate input parameters
        if (facilityKey == null || newType == null) return;

        // Ensure the facility key exists in the map with empty string as default
        if (!facilityWithProcessType.containsKey(facilityKey)){
            facilityWithProcessType.put(facilityKey, EMPTY_STRING);
        }

        // Manual process type has highest precedence - always overrides
        if (newType == MANUAL_PROCESS_TYPE) {
            facilityWithProcessType.put(facilityKey, newType);
            return;
        }

        // Agent process type has medium precedence - overrides Automation but not Manual
        if (newType == AGENT_PROCESS_TYPE) {
            if(facilityWithProcessType.get(facilityKey) == MANUAL_PROCESS_TYPE) return;
            facilityWithProcessType.put(facilityKey, newType);
            return;
        }

        // Automation process type has lowest precedence - only applies if no other type is set
        if (newType == AUTOMATION_PROCESS_TYPE) {
            if(facilityWithProcessType.get(facilityKey) == MANUAL_PROCESS_TYPE) return;
            if(facilityWithProcessType.get(facilityKey) == AGENT_PROCESS_TYPE) return;
            facilityWithProcessType.put(facilityKey, newType);
            return;
        }
    }
    
    /**
    * Utility to insert error log whenever there is an exception in updating CCM records
    */
    public static void logDmlException(DmlException e, String className, String sourceMethod) {
        Error_Log__c log = new Error_Log__c();

        log.Error_Message__c = e.getMessage();
        log.Error_Type__c = 'Apex'; 
        log.Source_Component__c = className + '.' + sourceMethod;
        log.Error_Timestamp__c = System.now();
        log.Stack_Trace__c = e.getStackTraceString();

        if (e.getNumDml() > 0 && e.getDmlId(0) != null) {
             log.Record_Id__c = e.getDmlId(0);
        }

        // Insert the error log
        try {
            insert log;
        } catch (DmlException logEx) {
            System.debug('Failed to insert Error_Log__c: ' + logEx.getMessage());
        }
    }
}