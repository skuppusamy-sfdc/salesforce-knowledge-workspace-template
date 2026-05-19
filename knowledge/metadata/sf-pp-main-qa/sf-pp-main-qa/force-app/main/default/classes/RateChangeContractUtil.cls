/**
 * @description Utility for rate change contract operations.
 * Centralizes logic for finding contracts with Compensation Change Notice Letter attached.
 * Used by GetContractsToSend and PendingRateChangeChecker.
 */
public with sharing class RateChangeContractUtil {
    /**
     * @description Returns contract Ids that have a Compensation Change Notice Letter attached.
     * @param draftContracts List of draft contracts to check
     * @return Set of contract Ids with the notice letter
     */
    public static Set<Id> getContractsWithCompensationNoticeLetter(List<Contract> draftContracts) {
        Set<Id> contractsWithLetter = new Set<Id>();
        if (draftContracts == null || draftContracts.isEmpty()) {
            return contractsWithLetter;
        }

        List<Id> contractIds = new List<Id>();
        for (Contract c : draftContracts) {
            contractIds.add(c.Id);
        }

        Map<Id, Id> contentDocToContract = new Map<Id, Id>();
        for (ContentDocumentLink link : [
            SELECT ContentDocumentId, LinkedEntityId
            FROM ContentDocumentLink
            WHERE LinkedEntityId IN :contractIds
        ]) {
            contentDocToContract.put(link.ContentDocumentId, link.LinkedEntityId);
        }
        if (contentDocToContract.isEmpty()) {
            return contractsWithLetter;
        }

        for (ContentVersion cv : [
            SELECT ContentDocumentId
            FROM ContentVersion
            WHERE ContentDocumentId IN :contentDocToContract.keySet()
            AND IsLatest = true
            AND Title LIKE '%Compensation Change Notice Letter%'
        ]) {
            Id contractId = contentDocToContract.get(cv.ContentDocumentId);
            if (contractId != null) {
                contractsWithLetter.add(contractId);
            }
        }
        return contractsWithLetter;
    }
}