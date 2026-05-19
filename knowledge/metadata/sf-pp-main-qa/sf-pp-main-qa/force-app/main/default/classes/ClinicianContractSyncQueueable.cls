/***************************************************************************************************************************
* Class Name    : ClinicianContractSyncQueueable
* Description   : Queueable class that synchronizes Clinician Contracts based on Practice Operations contract updates.
*                 Delegates to ClinicianContractSyncService for the actual sync logic. Use this for async execution.
*                 For synchronous or batch execution, call ClinicianContractSyncService directly.
* Author        : Abhinav Mishra
* Created Date  : 2026-01-27
* Last Modified : 2026-03-02
***************************************************************************************************************************/
public with sharing class ClinicianContractSyncQueueable implements Queueable {

    private List<Id> contractIds;

    /**
     * Constructor for ClinicianContractSyncQueueable
     * @param contractIds List of Practice Operations Contract IDs to process
     */
    public ClinicianContractSyncQueueable(List<Id> contractIds) {
        this.contractIds = contractIds != null ? contractIds : new List<Id>();
    }

    /**
     * Executes the queueable job to synchronize Clinician Contracts.
     * Delegates to ClinicianContractSyncService for the actual sync logic.
     *
     * @param ctx The QueueableContext provided by the platform
     */
    public void execute(QueueableContext ctx) {
        if (contractIds.isEmpty()) {
            return;
        }
        ClinicianContractSyncService service = new ClinicianContractSyncService();
        service.syncClinicianContracts(contractIds);
    }
}