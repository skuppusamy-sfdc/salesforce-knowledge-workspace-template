/**
 * @description Centralized query service for Clinical_Rate_Change__c.
 * Replaces duplicated query logic across CloneContractAction, GenerateAndAttachLetterAction,
 * GetContractsToSend, PostProcessRateChangeAction, PendingRateChangeChecker, SaveContractSelectionAction.
 */
public with sharing class RateChangeQueryService {
    /**
     * @description Returns the first Open Clinical_Rate_Change__c for the given account and contract.
     * @param accountId Service Account Id (Service_Account_ID__c)
     * @param contractId Client Contract Id (Contract_ID__c)
     * @return Clinical_Rate_Change__c or null if none found
     */
    public static Clinical_Rate_Change__c getOpenRateChange(String accountId, String contractId) {
        List<Clinical_Rate_Change__c> records = getOpenRateChanges(accountId, contractId);
        return records.isEmpty() ? null : records[0];
    }

    /**
     * @description Returns all Open Clinical_Rate_Change__c records for the given account and contract.
     * @param accountId Service Account Id (Service_Account_ID__c)
     * @param contractId Client Contract Id (Contract_ID__c)
     * @return List of Clinical_Rate_Change__c (empty if none found)
     */
    public static List<Clinical_Rate_Change__c> getOpenRateChanges(String accountId, String contractId) {
        if (String.isBlank(accountId) || String.isBlank(contractId)) {
            return new List<Clinical_Rate_Change__c>();
        }
        return [
            SELECT Id, user_selected_IDs__c, Service_Account_ID__c, Contract_ID__c,
                   ContractsForPostProcessing__c, CreatedById, DocGenerationBatchProcessId__c,
                   PreviewClonedContractIds__c, Non_Processed_Clinical_Ids__c, Status__c
            FROM Clinical_Rate_Change__c
            WHERE Service_Account_ID__c = :accountId
            AND Contract_ID__c = :contractId
            AND Status__c = 'Open'
        ];
    }

    /**
     * @description Returns the most recent Clinical_Rate_Change__c for the given account and contract (any status).
     * Used by Rate Change Summary action to show summary for open or closed rate changes.
     * @param accountId Service Account Id (Service_Account_ID__c)
     * @param contractId Client Contract Id (Contract_ID__c)
     * @return Clinical_Rate_Change__c or null if none found
     */
    public static Clinical_Rate_Change__c getRateChangeForSummary(String accountId, String contractId) {
        if (String.isBlank(accountId) || String.isBlank(contractId)) {
            return null;
        }
        List<Clinical_Rate_Change__c> records = [
            SELECT Id, user_selected_IDs__c, Service_Account_ID__c, Contract_ID__c,
                   ContractsForPostProcessing__c, CreatedById, DocGenerationBatchProcessId__c,
                   PreviewClonedContractIds__c, Non_Processed_Clinical_Ids__c, Status__c
            FROM Clinical_Rate_Change__c
            WHERE Service_Account_ID__c = :accountId
            AND Contract_ID__c = :contractId
            ORDER BY CreatedDate DESC
            LIMIT 1
        ];
        return records.isEmpty() ? null : records[0];
    }

    /**
     * @description Returns all Open Clinical_Rate_Change__c records for the given service account (no contract filter).
     * Used when closing all open rate changes for an account after post-process.
     * @param serviceAccountId Service Account Id
     * @return List of Clinical_Rate_Change__c (empty if none found)
     */
    public static List<Clinical_Rate_Change__c> getOpenRateChangesByAccount(String serviceAccountId) {
        if (String.isBlank(serviceAccountId)) {
            return new List<Clinical_Rate_Change__c>();
        }
        return [
            SELECT Id, Status__c
            FROM Clinical_Rate_Change__c
            WHERE Service_Account_ID__c = :serviceAccountId
            AND Status__c = 'Open'
        ];
    }
}