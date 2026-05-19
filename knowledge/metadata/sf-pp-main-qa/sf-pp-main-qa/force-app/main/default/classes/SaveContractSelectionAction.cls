/**
 * @description Saves selected contract IDs to Clinical_Rate_Change__c.Non_Processed_Clinical_Ids__c
 * for use by Post Process Rate Change action. (ContractsForPostProcessing__c is used to store
 * contract IDs for whom emails were sent during post-process.)
 */
public with sharing class SaveContractSelectionAction {

    /**
     * @description Aura-enabled method for LWC to save selected contract IDs.
     * @param accountId Service Account Id
     * @param contractId Client Contract Id
     * @param selectedContractIds List of selected contract IDs
     * @return Map with success (Boolean) and message (String)
     */
    @AuraEnabled(cacheable=false)
    public static Map<String, Object> saveSelectedContracts(String accountId, String contractId, List<String> selectedContractIds) {
        Map<String, Object> result = new Map<String, Object>();
        try {
            String idsStr = null;
            if (selectedContractIds != null && !selectedContractIds.isEmpty()) {
                idsStr = String.join(selectedContractIds, ',');
            }
            String msg = doSave(accountId, contractId, idsStr);
            result.put('success', true);
            result.put('message', msg);
        } catch (Exception e) {
            result.put('success', false);
            result.put('message', e instanceof AuraHandledException ? e.getMessage() : 'Something went wrong. Please try again.');
        }
        return result;
    }

    /**
     * @description Persists selected contract IDs to Clinical_Rate_Change__c.Non_Processed_Clinical_Ids__c.
     * @param accountId Service Account Id
     * @param contractId Client Contract Id
     * @param selectedContractIds Comma-separated string of selected contract IDs
     * @return Success message with count of saved contracts
     */
    private static String doSave(String accountId, String contractId, String selectedContractIds) {
        Clinical_Rate_Change__c crc = RateChangeQueryService.getOpenRateChange(accountId, contractId);
        if (crc == null) {
            throw new AuraHandledException('No pending rate change found for this account and contract.');
        }

        crc.Non_Processed_Clinical_Ids__c = String.isNotBlank(selectedContractIds) ? selectedContractIds.trim() : null;
        update crc;

        Integer count = IdParsingUtil.parseCommaSeparatedIds(selectedContractIds).size();
        return 'Saved ' + count + ' contract(s) for processing.';
    }
}