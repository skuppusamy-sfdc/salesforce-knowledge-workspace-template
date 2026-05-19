/**
 * @description Unified queueable for rate change operations: Clone Contract and Sync Contracts.
 * Sends notification via RateChangeNotificationUtil when job completes.
 */
public class RateChangeQueueable implements Queueable, Database.AllowsCallouts {

    public static final String JOB_TYPE_CLONE = 'CLONE';
    public static final String JOB_TYPE_SYNC = 'SYNC';
    private static final Integer SYNC_BATCH_SIZE = 5;

    private String jobType;

    // CLONE params
    private List<Id> clinicianIds;
    private String clientContractId;
    private List<Clinical_Rate_Change__c> previewedContracts;

    // SYNC params
    private List<Id> contractIds;
    private Integer processedCount;
    private Id crcId;

    /**
     * @description Constructs the queueable for CLONE job.
     * @param clinicianIds List of clinician (Contact) IDs to clone contracts for
     * @param clientContractId Client contract Id (Contract_ID__c)
     * @param previewedContracts Clinical_Rate_Change__c records to update with cloned contract IDs
     */
    public RateChangeQueueable(List<Id> clinicianIds, String clientContractId, List<Clinical_Rate_Change__c> previewedContracts) {
        this.jobType = JOB_TYPE_CLONE;
        this.clinicianIds = clinicianIds;
        this.clientContractId = clientContractId;
        this.previewedContracts = previewedContracts;
    }

    /**
     * @description Constructs the queueable for SYNC job (initial).
     * @param contractIds List of clinician contract Ids to process
     * @param crcId Clinical_Rate_Change__c Id for notification target and recipient lookup
     */
    public RateChangeQueueable(List<Id> contractIds, Id crcId) {
        this.jobType = JOB_TYPE_SYNC;
        this.contractIds = contractIds != null ? contractIds : new List<Id>();
        this.processedCount = 0;
        this.crcId = crcId;
    }

    /**
     * @description Constructs the queueable for SYNC job (chained).
     * @param contractIds Remaining contract Ids to process
     * @param processedCount Number of contracts already processed in previous chain
     * @param crcId Clinical_Rate_Change__c Id for notification (passed through from initial job)
     */
    public RateChangeQueueable(List<Id> contractIds, Integer processedCount, Id crcId) {
        this.jobType = JOB_TYPE_SYNC;
        this.contractIds = contractIds != null ? contractIds : new List<Id>();
        this.processedCount = processedCount != null ? processedCount : 0;
        this.crcId = crcId;
    }

    /**
     * @description Executes the queueable job (CLONE or SYNC). Invoked by the platform.
     * @param context QueueableContext provided by the platform.
     */
    public void execute(QueueableContext context) {
        if (jobType == JOB_TYPE_CLONE) {
            executeClone();
        } else {
            executeSync();
        }
    }

    private void executeClone() {
        Boolean success = false;
        String errorMessage = null;
        Integer contractCount = 0;

        try {
            if (clinicianIds != null && !clinicianIds.isEmpty()) {
                List<Id> newContractIds = ClinicianContractCloneService.cloneContracts(clinicianIds, clientContractId);

                if (newContractIds != null && !newContractIds.isEmpty() && previewedContracts != null && !previewedContracts.isEmpty()) {
                    List<String> idStrings = new List<String>();
                    for (Id idVal : newContractIds) {
                        idStrings.add(String.valueOf(idVal));
                    }
                    String contractIdsStr = String.join(idStrings, ',');
                    Set<Id> crcIds = new Set<Id>();
                    for (Clinical_Rate_Change__c crc : previewedContracts) {
                        crcIds.add(crc.Id);
                    }
                    List<Clinical_Rate_Change__c> toUpdate = [
                        SELECT Id
                        FROM Clinical_Rate_Change__c
                        WHERE Id IN :crcIds
                    ];
                    for (Clinical_Rate_Change__c rec : toUpdate) {
                        rec.PreviewClonedContractIds__c = contractIdsStr;
                    }
                    if (!toUpdate.isEmpty()) {
                        update toUpdate;
                    }
                    contractCount = newContractIds.size();
                }
                success = true;
            } else {
                errorMessage = 'No clinicians selected to process.';
            }
        } catch (Exception e) {
            success = false;
            errorMessage = e.getMessage();
        }

        Id targetId = String.isNotBlank(clientContractId) ? (Id) clientContractId : (previewedContracts != null && !previewedContracts.isEmpty() ? previewedContracts[0].Id : null);
        Id userIdToNotify = UserInfo.getUserId();
        if (previewedContracts != null && !previewedContracts.isEmpty()) {
            try {
                Id createdById = previewedContracts[0].CreatedById;
                if (createdById != null) {
                    userIdToNotify = createdById;
                }
            } catch (SObjectException ex) {
                // CreatedById not queried on passed-in records - use current user
            }
        }
        String title = success ? 'Clone Contract Complete' : 'Clone Contract Failed';
        String body = success
            ? 'Successfully cloned ' + contractCount + ' contract(s). Next, run Generate And Attach Letter to create notice letters.'
            : (errorMessage != null ? errorMessage : 'Contract cloning did not complete successfully. Please try again.');
        RateChangeNotificationUtil.sendNotification(success, title, body, targetId, userIdToNotify);
    }

    private void executeSync() {
        Boolean success = false;
        String errorMessage = null;

        if (contractIds == null || contractIds.isEmpty()) {
            sendSyncNotification(true, processedCount, null);
            return;
        }

        try {
            ContractSyncRemoteAction action = new ContractSyncRemoteAction();
            Integer toProcess = Math.min(SYNC_BATCH_SIZE, contractIds.size());

            for (Integer i = 0; i < toProcess; i++) {
                Id contractId = contractIds[i];
                Map<String, Object> inputMap = new Map<String, Object>{ 'ContractId' => String.valueOf(contractId), 'UpdateRates' => false };
                Map<String, Object> outputMap = new Map<String, Object>();
                action.invokeMethod('processContract', inputMap, outputMap, new Map<String, Object>());
                processedCount++;
            }

            List<Id> remaining = new List<Id>();
            for (Integer i = toProcess; i < contractIds.size(); i++) {
                remaining.add(contractIds[i]);
            }

            if (!remaining.isEmpty()) {
                System.enqueueJob(new RateChangeQueueable(remaining, processedCount, crcId));
            } else {
                success = true;
                sendSyncNotification(success, processedCount, null);
            }
        } catch (Exception e) {
            errorMessage = e.getMessage();
            sendSyncNotification(false, processedCount, errorMessage);
        }
    }

    private void sendSyncNotification(Boolean success, Integer count, String errorMessage) {
        Id targetId = crcId;
        Id userIdToNotify = null;
        if (crcId != null) {
            List<Clinical_Rate_Change__c> crcs = [SELECT Id, CreatedById FROM Clinical_Rate_Change__c WHERE Id = :crcId LIMIT 1];
            if (!crcs.isEmpty()) {
                userIdToNotify = crcs[0].CreatedById;
            }
        }
        String title = success ? 'Contract Sync Complete' : 'Contract Sync Failed';
        String body = success
            ? 'Successfully synced ' + count + ' contract(s).'
            : (errorMessage != null ? errorMessage : 'Contract sync did not complete successfully. Please try again.');
        RateChangeNotificationUtil.sendNotification(success, title, body, targetId, userIdToNotify);
    }
}