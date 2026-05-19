/**
 * @description Utility for parsing ID strings and JSON from rate change flows.
 * Consolidates IdListUtil (comma-separated IDs) and SelectedClinicianIdUtil (user_selected_IDs__c JSON).
 * Used by GetContractsToSend, GenerateAndAttachLetterAction, PostProcessRateChangeAction, CloneContractAction, etc.
 */
public with sharing class IdParsingUtil {
    /**
     * @description Parses a comma-separated string of IDs into a List&lt;Id&gt;.
     * Skips blank segments and trims whitespace. Returns empty list for null or blank input.
     * @param ids Comma-separated ID string (e.g. from PreviewClonedContractIds__c or Non_Processed_Clinical_Ids__c)
     * @return List of Id values; empty list if ids is null or blank
     */
    public static List<Id> parseCommaSeparatedIds(String ids) {
        List<Id> result = new List<Id>();
        if (String.isBlank(ids)) {
            return result;
        }
        for (String idStr : ids.split(',')) {
            if (String.isNotBlank(idStr)) {
                result.add((Id) idStr.trim());
            }
        }
        return result;
    }

    /**
     * @description Extracts selected clinician IDs from user_selected_IDs__c JSON.
     * Supports: (1) complex structure with selectId objects, (2) simple array of strings, (3) single string.
     * @param jsonResult Deserialized JSON object (Map or from JSON.deserializeUntyped)
     * @return List of clinician ID strings
     */
    public static List<String> extractSelectedClinicianIds(Object jsonResult) {
        List<String> allSelectedIds = new List<String>();

        if (jsonResult instanceof Map<String, Object>) {
            Map<String, Object> userData = (Map<String, Object>) jsonResult;

            if (userData.containsKey('selectedClinicianIds') && userData.get('selectedClinicianIds') != null) {
                Object selectedIdsObj = userData.get('selectedClinicianIds');

                if (selectedIdsObj instanceof List<Object>) {
                    List<Object> selectedIdsObjects = (List<Object>) selectedIdsObj;
                    for (Object idObj : selectedIdsObjects) {
                        if (idObj != null) {
                            if (idObj instanceof Map<String, Object>) {
                                Map<String, Object> clinicianRecord = (Map<String, Object>) idObj;
                                if (clinicianRecord.containsKey('selectId') && clinicianRecord.get('selectId') != null) {
                                    String selectId = String.valueOf(clinicianRecord.get('selectId'));
                                    if (String.isNotBlank(selectId)) {
                                        allSelectedIds.add(selectId);
                                    }
                                }
                            } else if (idObj instanceof String) {
                                String singleId = (String) idObj;
                                if (String.isNotBlank(singleId)) {
                                    allSelectedIds.add(singleId);
                                }
                            }
                        }
                    }
                } else if (selectedIdsObj instanceof String) {
                    String singleId = (String) selectedIdsObj;
                    if (String.isNotBlank(singleId)) {
                        allSelectedIds.add(singleId);
                    }
                }
            }
        }

        return allSelectedIds;
    }
}