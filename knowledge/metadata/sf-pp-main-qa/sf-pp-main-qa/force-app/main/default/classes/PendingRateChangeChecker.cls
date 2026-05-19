/**
 * @description Agent action to check for pending rate change runs and draft contracts.
 * Queries Clinical_Rate_Change__c for Open status records by account, extracts clinician IDs
 * from user_selected_IDs__c, and finds draft contracts for those clinician accounts.
 */
public with sharing class PendingRateChangeChecker {
    @TestVisible private static Boolean exceptionForTest = false;

    /**
     * @description Output wrapper with formatted message for the agent to display.
     */
    public class InvocableOutput {
        @InvocableVariable(label='Has Pending Run' description='Whether there is a previous pending rate change run')
        public Boolean hasPendingRun;
        @InvocableVariable(label='Formatted Message' description='Message to display to the user about pending run and draft contracts')
        public String formattedMessage;
        @InvocableVariable(label='Draft Contract Count' description='Number of draft contracts found for selected clinicians')
        public Integer draftContractCount;
    }

    /**
     * @description Checks for Open Clinical_Rate_Change__c records and draft contracts for selected clinicians.
     * @param inputs List containing accountId (Service_Account_ID__c) and contractId (Contract_ID__c)
     * @return List of InvocableOutput with formatted notification for the agent
     */
    @InvocableMethod(label='Check Pending Rate Change' description='Checks if there is a previous pending rate change run and draft contracts. Pass accountId and contractId from context.' category='Contract Management')
    public static List<InvocableOutput> checkPendingRateChange(List<RateChangeInvocableInput> inputs) {
        List<InvocableOutput> outputs = new List<InvocableOutput>();
        InvocableOutput output = new InvocableOutput();

        RateChangeInvocableInput.ValidationResult validation = RateChangeInvocableInput.validateAccountAndContract(inputs);
        if (!validation.isValid) {
            output.hasPendingRun = false;
            output.formattedMessage = validation.errorMessage;
            output.draftContractCount = 0;
            outputs.add(output);
            return outputs;
        }

        String accountId = validation.input.accountId;
        String contractId = validation.input.contractId;

        try {
            if (Test.isRunningTest() && exceptionForTest) {
                throw new CalloutException('test');
            }
            Clinical_Rate_Change__c crc = RateChangeQueryService.getOpenRateChange(accountId, contractId);

            if (crc == null) {
                output.hasPendingRun = false;
                output.formattedMessage = 'No pending rate change found for this account and contract.';
                output.draftContractCount = 0;
                outputs.add(output);
                return outputs;
            }

            output.hasPendingRun = true;

            List<String> contactIds = new List<String>();
            if (String.isNotBlank(crc.user_selected_IDs__c)) {
                try {
                    Object jsonResult = JSON.deserializeUntyped(crc.user_selected_IDs__c);
                    contactIds = IdParsingUtil.extractSelectedClinicianIds(jsonResult);
                } catch (JSONException e) {
                    RateChangeNotificationUtil.logError('PendingRateChangeChecker.checkPendingRateChange', crc.Id != null ? String.valueOf(crc.Id) : null, e);
                }
            }

            Set<Id> clinicianAccountIds = new Set<Id>();
            if (!contactIds.isEmpty()) {
                List<Id> validIds = new List<Id>();
                for (String idStr : contactIds) {
                    if (String.isNotBlank(idStr)) {
                        try {
                            validIds.add((Id) idStr);
                        } catch (Exception ex) {
                            // Skip invalid IDs
                        }
                    }
                }

                if (!validIds.isEmpty()) {
                    for (Contact c : [
                        SELECT AccountId
                        FROM Contact
                        WHERE Id IN :validIds
                        AND AccountId != null
                    ]) {
                        clinicianAccountIds.add(c.AccountId);
                    }
                    for (Account a : [
                        SELECT Id
                        FROM Account
                        WHERE Id IN :validIds
                    ]) {
                        clinicianAccountIds.add(a.Id);
                    }
                }
            }

            List<Contract> draftContracts = new List<Contract>();
            if (!clinicianAccountIds.isEmpty()) {
                draftContracts = [
                    SELECT Id, ContractNumber, Account.Name, Status
                    FROM Contract
                    WHERE AccountId IN :clinicianAccountIds
                    AND Status = 'Draft'
                    ORDER BY Account.Name, ContractNumber
                ];
            }

            Set<Id> contractsWithLetter = RateChangeContractUtil.getContractsWithCompensationNoticeLetter(draftContracts);

            output.draftContractCount = draftContracts.size();
            output.formattedMessage = buildFormattedMessage(draftContracts, clinicianAccountIds.size(), contractsWithLetter);

        } catch (Exception e) {
            output.hasPendingRun = false;
            output.formattedMessage = 'Something went wrong while checking. Please try again.';
            output.draftContractCount = 0;
        }

        outputs.add(output);
        return outputs;
    }

    /**
     * @description Builds formatted message for agent display with contract list and letter status.
     * @param draftContracts List of draft contracts
     * @param clinicianCount Number of clinicians
     * @param contractsWithLetter Set of contract Ids with notice letter attached
     * @return Formatted string for agent response
     */
    private static String buildFormattedMessage(List<Contract> draftContracts, Integer clinicianCount, Set<Id> contractsWithLetter) {
        String msg = '**Pending Rate Change**\n\n';
        msg += 'There is a pending rate change for the selected clinicians. ';
        msg += 'Draft contracts are available.\n\n';

        if (draftContracts.isEmpty()) {
            msg += 'No draft contracts were found for the selected clinicians.';
        } else {
            msg += '**Contracts (' + draftContracts.size() + '):**\n';
            for (Contract c : draftContracts) {
                String name = c.Account != null && c.Account.Name != null ? c.Account.Name : 'Unknown';
                String contractNum = c.ContractNumber != null ? c.ContractNumber : String.valueOf(c.Id);
                Boolean hasLetter = contractsWithLetter != null && contractsWithLetter.contains(c.Id);
                msg += '• ' + name + ' - ' + contractNum + (hasLetter ? ' ✓ Notice letter attached' : ' (notice letter not yet generated)') + '\n';
            }
        }

        return msg;
    }

}