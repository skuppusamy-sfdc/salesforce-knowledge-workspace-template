/*
public class CloneAndDocumentQueueable implements Queueable, Database.AllowsCallouts {
    private List<Id> clinicianIds;
    private String clientContractId;
    //private List<string> previewedContractIds;
    private List<Clinical_Rate_Change__c> previewedContractIds;

    public CloneAndDocumentQueueable(List<Id> clinicianIds, String clientContractId, List<Clinical_Rate_Change__c> previewedContractIds) {
        this.clinicianIds = clinicianIds;
        this.clientContractId = clientContractId;
        this.previewedContractIds = previewedContractIds;
    }

    public void execute(QueueableContext context) {
        RateChangeService service = new RateChangeService();
        if (!clinicianIds.isEmpty()) {
            List<Id> newContractIds  = service.cloneContracts(clinicianIds, clientContractId);
            if (!newContractIds.isEmpty()) {
                service.generateAndAttachLetterNew(newContractIds,previewedContractIds);
            }
        }
    }
}*/

public class CloneAndDocumentQueueable implements Queueable, Database.AllowsCallouts {
    private List<Id> clinicianIds;
    private String clientContractId;
    private List<Clinical_Rate_Change__c> previewedContracts;

    public CloneAndDocumentQueueable(List<Id> clinicianIds, String clientContractId, List<Clinical_Rate_Change__c> previewedContracts) {
        this.clinicianIds = clinicianIds;
        this.clientContractId = clientContractId;
        this.previewedContracts = previewedContracts;
    }

    public void execute(QueueableContext context) {
        RateChangeService service = new RateChangeService();

        if (clinicianIds != null && !clinicianIds.isEmpty()) {
            // Step 1: Clone contracts
            List<Id> newContractIds = service.cloneContracts(clinicianIds, clientContractId);

            // Step 2: Generate & attach documents using the refactored method
            if (newContractIds != null && !newContractIds.isEmpty()) {
                service.generateAndAttachLetter(newContractIds, previewedContracts, true); // true = use batch process
            }
        }
    }
}