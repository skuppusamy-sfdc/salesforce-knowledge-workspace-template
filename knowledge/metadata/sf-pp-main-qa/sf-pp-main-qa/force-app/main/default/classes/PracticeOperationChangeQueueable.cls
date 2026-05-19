/***************************************************************************************************************************
* Class Name    : PracticeOperationChangeQueueable
* Description   : Queueable class that processes Preventive Care Agreements (PCAs) and creates Practice Operation Change
*                 records based on business rules. Analyzes PCA changes to determine process types (Manual, Agent, Automation)
*                 and applies 11 different business rules to categorize changes appropriately.
* Author        : Srishty Sharma
* Created Date  : 16-Oct-2025
* Last Modified : 
***************************************************************************************************************************/
public with sharing class PracticeOperationChangeQueueable implements Queueable {
    
    // Constants for hardcoded strings
    private static final String SHIFT_BONUS_CODE = 'Shift Bonus';
    private static final String STIPEND_TYPE = 'Stipend';
    private static final String LEADERSHIP_INCENTIVES_TYPE = 'Leadership Incentives';
    private static final String VARIABLE_TYPE = 'Variable';
    private static final String SHIFT_TYPE = 'Shift';
    private static final String EMPLOYEE_SUB_TYPE = 'Employee';
    private static final String NP_PA_SHIFT_TYPE = 'NP/PA';
    private static final String MANUAL_PROCESS_TYPE = 'Manual';
    private static final String AGENT_PROCESS_TYPE = 'Agent';
    private static final String AUTOMATION_PROCESS_TYPE = 'Automation';
    private static final String COMMA_SEPARATOR = ',';
    private static final String DEFAULT_PROCESS_TYPE = 'Manual';
    
    // Rule names
    private static final String STIPEND_CHANGE_RULE = 'Stipend Change';
    private static final String LEADERSHIP_INCENTIVES_CHANGE_RULE = 'Leadership Incentives Change';
    private static final String VARIABLE_CHANGE_RULE = 'Variable Change';
    private static final String SHIFT_BONUS_CHANGE_RULE = 'Shift Bonus Change';
    private static final String MIXED_BAG_SHIFT_RATES_RULE = 'Shift Mixed Bag Shift Rates';
    private static final String NEW_SHIFT_TYPE_ADDED_RULE = 'New Shift Type Added';
    private static final String NPPA_TIER_CHANGE_RULE = 'NPPA Tier Change';
    private static final String RATE_DECREASED_EXISTING_SHIFT_RULE = 'Rate Decreased for Existing Shift';
    private static final String ONLY_RATE_INCREASED_EXISTING_SHIFT_RULE = 'ONLY Rate Increased Existing Shift';
    private static final String NEW_SHIFT_ADDED_EXISTING_TYPE_RULE = 'New Shift Added with existing Type and same Rate';
    private static final String RATE_PAY_CODE_CHANGE_RULE = 'Rate Pay Code Change';
    
    // Error messages
    private static final String FAILED_INSERT_ERROR = 'Failed insert Practice Operation Changes: ';
    
    private List<Id> contractIds;

    /**
     * Constructor for PracticeOperationChangeQueueable
     * @param contractIds List of Contract IDs to process for Practice Operation Changes
     */
    public PracticeOperationChangeQueueable(List<Id> contractIds) {
        this.contractIds = contractIds;
    }

    /**
     * Executes the queueable job to process Preventive Care Agreements and create Practice Operation Change records.
     * 
     * This method performs the following operations:
     * 1. Identifies facilities with mixed bag shift rates (different rates for same facility/shift combination)
     * 2. Processes all PCAs and applies 11 business rules to determine process types and qualified rules
     * 3. Creates Practice Operation Change records with appropriate process types and rule classifications
     * 4. Enqueues CreateClientChangeManagementQueueable for further processing
     *    (which will chain ClinicianContractSyncQueueable to avoid governor limits)
     * 
     * Business Rules Applied:
     * - Manual Process: Stipend Change, Leadership Incentives Change, Variable Change, Shift Bonus Change,
     *   Mixed Bag Shift Rates, New Shift Type Added, NPPA Tier Change, Rate Decreased for Existing Shift
     * - Agent Process: ONLY Rate Increased Existing Shift
     * - Automation Process: New Shift Added with existing Type and same Rate, Rate Pay Code Change
     * 
     * @param ctx The QueueableContext provided by the platform
     */
    public void execute(QueueableContext ctx) {
        // Step 1: Identify facilities with mixed bag shift rates
        Map<Id,Set<String>> contractWithMixedBagFacilityTitles = identifyMixedBagFacilities();
        
        // Step 2: Process PCAs and apply business rules
        Map<Id,Map<String, Set<String>>> contractIdWithFacilityToRules = new Map<Id,Map<String, Set<String>>>();
        Map<Id,Map<String,String>> contractIdWithFacilityToProcessType = new Map<Id,Map<String,String>>();
        
        processPreventiveCareAgreements(contractWithMixedBagFacilityTitles, contractIdWithFacilityToRules, contractIdWithFacilityToProcessType);
        
        // Step 3: Create Practice Operation Change records
        List<Practice_Operation_Change__c> pocToInsert = createPracticeOperationChangeRecords(contractIdWithFacilityToRules, contractIdWithFacilityToProcessType);
        
        // Step 4: Insert records and handle errors
        insertPracticeOperationChanges(pocToInsert);
        
        // Step 5: Enqueue next job for Client Change Management creation
        // Note: ClinicianContractSyncQueueable will be chained from CreateClientChangeManagementQueueable
        // to avoid "Too many queueable jobs" governor limit
        enqueueClientChangeManagementJob(pocToInsert);
    }
    
    /**
     * Identifies facilities with mixed bag shift rates by querying PCAs and finding
     * facilities where the same shift has different rates (max != min).
     * 
     * @return Map of Contract ID to Set of Facility Titles with mixed bag rates
     */
    private Map<Id,Set<String>> identifyMixedBagFacilities() {
        Map<Id,Set<String>> contractWithMixedBagFacilityTitles = new Map<Id,Set<String>>();
        
        for (AggregateResult ar : [SELECT ContractPaymentAgreement.ContractId contractId,
                                   FacilityTitle__c fac,Shift__r.Shift_Name__c shiftName,
                                   MAX(Rate__c) maxRate,MIN(Rate__c) minRate
                                   FROM PreventiveCareAgreement
                                   WHERE ContractPaymentAgreement.ContractId IN :contractIds
                                   AND Shift__r.Shift_Name__r.Code != :SHIFT_BONUS_CODE
                                   AND ContractPaymentAgreement.Type__c = :SHIFT_TYPE
                                   GROUP BY ContractPaymentAgreement.ContractId,FacilityTitle__c, Shift__r.Shift_Name__c
                                  ]) {
                                      Decimal maxR = (Decimal) ar.get('maxRate');
                                      Decimal minR = (Decimal) ar.get('minRate');
                                      String fac = (String) ar.get('fac');
                                      Id contractId = (Id) ar.get('contractId');
                                      if (maxR != minR && fac != null) {
                                          if(!contractWithMixedBagFacilityTitles.containsKey(contractId)){
                                              contractWithMixedBagFacilityTitles.put(contractId, new Set<String>());
                                          }
                                          contractWithMixedBagFacilityTitles.get(contractId).add(fac);
                                      }
                                  }
        return contractWithMixedBagFacilityTitles;
    }

    /**
     * Processes Preventive Care Agreements and applies business rules to determine
     * process types and qualified rules for each facility.
     * 
     * @param contractWithMixedBagFacilityTitles Map of contracts to facilities with mixed bag rates
     * @param contractIdWithFacilityToRules Output map of contracts to facilities to applicable rules
     * @param contractIdWithFacilityToProcessType Output map of contracts to facilities to process types
     */
    private void processPreventiveCareAgreements(
        Map<Id,Set<String>> contractWithMixedBagFacilityTitles,
        Map<Id,Map<String, Set<String>>> contractIdWithFacilityToRules,
        Map<Id,Map<String,String>> contractIdWithFacilityToProcessType) {
        
        for (PreventiveCareAgreement pca : [SELECT Id,FacilityTitle__c,
                                            Shift__r.Shift_Name__c,Shift__r.Shift_Name__r.Code,
                                            Existing_Rate_Increased__c,Existing_Rate_Decreased__c,
                                            New_Shift_Type_Added__c,New_Shift_Bonus_Type_Added__c,
                                            Existing_Shift_Type_Added__c,Is_Newly_Added__c,
                                            Rate_Pay_Code_Added__c,Rate_Pay_Code_Remove__c,
                                            Over_Rate__c,Is_Deleted__c,ContractPaymentAgreement.Contract.NPPA_Tier_Changed__c,
                                            Rate__c,ContractPaymentAgreement.Type__c,FacilityTitle__r.Code_Set_Sub_Type__c,
                                            ContractPaymentAgreement.ContractId,Shift__r.Shift_Name__r.Code_Set_Sub_Type__c,
                                            FacilityTitle__r.Shift_Type__c
                                            FROM PreventiveCareAgreement
                                            WHERE ContractPaymentAgreement.ContractId IN :contractIds
                                            ORDER BY FacilityTitle__c]) {
            String facTitle = pca.FacilityTitle__c;
            Id contractId = pca.ContractPaymentAgreement.ContractId;
            if (facTitle == null) continue;
            
            // Initialize maps for this contract if not already done
            if(!contractIdWithFacilityToRules.containsKey(contractId)){
                contractIdWithFacilityToRules.put(contractId, new Map<String, Set<String>>());
            }
            if(!contractIdWithFacilityToProcessType.containsKey(contractId)){
                contractIdWithFacilityToProcessType.put(contractId, new Map<String,String>());
            }            
            
            Map<String, Set<String>> facilityToRules = contractIdWithFacilityToRules.get(contractId);
            Map<String,String> facilityWithProcessType = contractIdWithFacilityToProcessType.get(contractId);
            
            // Ensure rule set exists for this facility
            if (!facilityToRules.containsKey(facTitle)) {
                facilityToRules.put(facTitle, new Set<String>());
            }

            String pcaType = pca.ContractPaymentAgreementId != null ? pca.ContractPaymentAgreement.Type__c : null;
            
            // Apply all 11 business rules
            applyBusinessRules(pca, pcaType, facTitle, contractId, contractWithMixedBagFacilityTitles, 
                             facilityToRules, facilityWithProcessType);
        }
    }
    
    /**
     * Applies all 11 business rules to determine process types and qualified rules for a PCA.
     * 
     * @param pca The Preventive Care Agreement to process
     * @param pcaType The type of the PCA (Stipend, Leadership Incentives, Variable, Shift)
     * @param facTitle The facility title for this PCA
     * @param contractId The contract ID
     * @param contractWithMixedBagFacilityTitles Map of contracts to facilities with mixed bag rates
     * @param facilityToRules Map to store applicable rules for this facility
     * @param facilityWithProcessType Map to store process type for this facility
     */
    private void applyBusinessRules(
        PreventiveCareAgreement pca, 
        String pcaType, 
        String facTitle, 
        Id contractId,
        Map<Id,Set<String>> contractWithMixedBagFacilityTitles,
        Map<String, Set<String>> facilityToRules,
        Map<String,String> facilityWithProcessType) {
        
        // RULE 1: Stipend Change (Manual)
        if (pcaType == STIPEND_TYPE && (pca.Existing_Rate_Increased__c || pca.Existing_Rate_Decreased__c || pca.Is_Newly_Added__c)) {
            facilityToRules.get(facTitle).add(STIPEND_CHANGE_RULE);
            PracticeOperationChangeUtil.addProcessType(facilityWithProcessType, facTitle, MANUAL_PROCESS_TYPE);
        }

        // RULE 2: Leadership Incentives Change (Manual)
        if (pcaType == LEADERSHIP_INCENTIVES_TYPE && (pca.Existing_Rate_Increased__c || pca.Existing_Rate_Decreased__c || pca.Is_Newly_Added__c)) {
            facilityToRules.get(facTitle).add(LEADERSHIP_INCENTIVES_CHANGE_RULE);
            PracticeOperationChangeUtil.addProcessType(facilityWithProcessType, facTitle, MANUAL_PROCESS_TYPE);
        }

        // RULE 3: Variable Change (Manual)
        if (pcaType == VARIABLE_TYPE && (pca.Existing_Rate_Increased__c == true || pca.Existing_Rate_Decreased__c == true || pca.Is_Newly_Added__c == true)) {
            facilityToRules.get(facTitle).add(VARIABLE_CHANGE_RULE);
            PracticeOperationChangeUtil.addProcessType(facilityWithProcessType, facTitle, MANUAL_PROCESS_TYPE);
        }

        // RULE 4: Shift Bonus Change (Manual)
        Boolean isShiftType = (pcaType == SHIFT_TYPE);
        Boolean shiftBonusCode = (pca.Shift__r != null && pca.Shift__r.Shift_Name__r != null && SHIFT_BONUS_CODE.equals(pca.Shift__r.Shift_Name__r.Code)); 
        
        if (isShiftType && (pca.New_Shift_Bonus_Type_Added__c || (shiftBonusCode && (pca.Existing_Rate_Increased__c || pca.Existing_Rate_Decreased__c)))) {
            facilityToRules.get(facTitle).add(SHIFT_BONUS_CHANGE_RULE);
            PracticeOperationChangeUtil.addProcessType(facilityWithProcessType, facTitle, MANUAL_PROCESS_TYPE);
        }

        // RULE 5: Mixed Bag Shift Rates (Manual)
        if (isShiftType && contractWithMixedBagFacilityTitles.containsKey(contractId) && contractWithMixedBagFacilityTitles.get(contractId).contains(facTitle)) {
            facilityToRules.get(facTitle).add(MIXED_BAG_SHIFT_RATES_RULE);
            PracticeOperationChangeUtil.addProcessType(facilityWithProcessType, facTitle, MANUAL_PROCESS_TYPE);
        }

        // RULE 6: New Shift Type Added (Manual)
        if (isShiftType && pca.New_Shift_Type_Added__c) {
            facilityToRules.get(facTitle).add(NEW_SHIFT_TYPE_ADDED_RULE);
            PracticeOperationChangeUtil.addProcessType(facilityWithProcessType, facTitle, MANUAL_PROCESS_TYPE);
        }

        // RULE 7: NPPA Tier Change (Manual)
        Boolean nppaTierChanged = (pca.ContractPaymentAgreementId != null 
                                   && pca.ContractPaymentAgreement.ContractId != null
                                   && pca.ContractPaymentAgreement.Contract.NPPA_Tier_Changed__c);
        Boolean shiftIsEmployee = (pca.Shift__r != null && pca.FacilityTitle__r.Code_Set_Sub_Type__c != null && EMPLOYEE_SUB_TYPE.equals(pca.FacilityTitle__r.Code_Set_Sub_Type__c));
        Boolean facilityShiftTypeNPPA = (pca.FacilityTitle__r != null && NP_PA_SHIFT_TYPE.equals(pca.FacilityTitle__r.Shift_Type__c));
        if (nppaTierChanged && isShiftType && shiftIsEmployee && facilityShiftTypeNPPA) {
            facilityToRules.get(facTitle).add(NPPA_TIER_CHANGE_RULE);
            PracticeOperationChangeUtil.addProcessType(facilityWithProcessType, facTitle, MANUAL_PROCESS_TYPE);
        }

        // RULE 8: Rate Decreased for Existing Shift (Manual)
        if (isShiftType && !shiftBonusCode && pca.Existing_Rate_Decreased__c && !pca.Is_Newly_Added__c) {
            facilityToRules.get(facTitle).add(RATE_DECREASED_EXISTING_SHIFT_RULE);
            PracticeOperationChangeUtil.addProcessType(facilityWithProcessType, facTitle, MANUAL_PROCESS_TYPE);
        }

        // RULE 9: ONLY Rate Increased Existing Shift (Agent)
        if (isShiftType 
            && pca.Existing_Rate_Increased__c
            && !pca.New_Shift_Type_Added__c
            && !pca.New_Shift_Bonus_Type_Added__c
            && !pca.Is_Newly_Added__c
           	&& !shiftBonusCode) {

            facilityToRules.get(facTitle).add(ONLY_RATE_INCREASED_EXISTING_SHIFT_RULE);
            PracticeOperationChangeUtil.addProcessType(facilityWithProcessType, facTitle, AGENT_PROCESS_TYPE);
        }

        // RULE 10: New Shift Added with existing Type and same Rate (Automation)
        if (isShiftType 
            && !pca.New_Shift_Type_Added__c
            && pca.Existing_Shift_Type_Added__c
            && pca.Is_Newly_Added__c) {

            facilityToRules.get(facTitle).add(NEW_SHIFT_ADDED_EXISTING_TYPE_RULE);
            PracticeOperationChangeUtil.addProcessType(facilityWithProcessType, facTitle, AUTOMATION_PROCESS_TYPE);
        }

        // RULE 11: Rate Pay Code Change (Automation)
        Boolean hasRemove = (pca.Rate_Pay_Code_Remove__c != null && pca.Rate_Pay_Code_Remove__c > 0);
        Boolean hasAdd = (pca.Rate_Pay_Code_Added__c != null && pca.Rate_Pay_Code_Added__c > 0);
        if (isShiftType && (hasRemove || hasAdd)) {
            facilityToRules.get(facTitle).add(RATE_PAY_CODE_CHANGE_RULE);
            PracticeOperationChangeUtil.addProcessType(facilityWithProcessType, facTitle, AUTOMATION_PROCESS_TYPE);
        }
    }
    
    /**
     * Creates Practice Operation Change records based on the processed rules and process types.
     * 
     * @param contractIdWithFacilityToRules Map of contracts to facilities to applicable rules
     * @param contractIdWithFacilityToProcessType Map of contracts to facilities to process types
     * @return List of Practice Operation Change records to insert
     */
    private List<Practice_Operation_Change__c> createPracticeOperationChangeRecords(
        Map<Id,Map<String, Set<String>>> contractIdWithFacilityToRules,
        Map<Id,Map<String,String>> contractIdWithFacilityToProcessType) {
        
        List<Practice_Operation_Change__c> pocToInsert = new List<Practice_Operation_Change__c>();

        for(Id contractId : contractIdWithFacilityToRules.keySet()){
            Map<String, Set<String>> facilityToRules = contractIdWithFacilityToRules.get(contractId);
            Map<String, String> facilityToFinalProcessType = contractIdWithFacilityToProcessType.get(contractId);
            for (String fac : facilityToRules.keySet()) {
                Set<String> rules = facilityToRules.get(fac);
                if (rules.isEmpty()) {
                    System.debug('Skipping facility with no matching rules: ' + fac);
                    continue; // don’t create record
                }
                System.debug('rules'+rules);
                String finalProc = facilityToFinalProcessType.containsKey(fac) ? facilityToFinalProcessType.get(fac) : DEFAULT_PROCESS_TYPE;
                String qualRules = String.join(new List<String>(rules), COMMA_SEPARATOR);
                Practice_Operation_Change__c poc = new Practice_Operation_Change__c();
                poc.Contract__c = contractId;
                poc.Facility_Title__c = fac;
                poc.Process_Type__c = finalProc;
                poc.Qualified_Rules__c = qualRules;
                System.debug('@@@@@poc'+poc);
                pocToInsert.add(poc);
            }
        }
        System.debug('@@@POCsize'+pocToInsert.size());
        return pocToInsert;
    }
    
    /**
     * Inserts Practice Operation Change records with error handling.
     * 
     * @param pocToInsert List of Practice Operation Change records to insert
     */
    private void insertPracticeOperationChanges(List<Practice_Operation_Change__c> pocToInsert) {
        if (!pocToInsert.isEmpty()) {
            try {
                insert pocToInsert;
            } catch (DmlException de) {
                System.debug(FAILED_INSERT_ERROR + de);
                PracticeOperationChangeUtil.logDmlException(de, 'PracticeOperationChangeQueueable','insertPracticeOperationChanges');
            }
        }
    }
    
    /**
     * Enqueues the CreateClientChangeManagementQueueable job with the created POC IDs.
     * 
     * @param pocToInsert List of Practice Operation Change records that were inserted
     */
    private void enqueueClientChangeManagementJob(List<Practice_Operation_Change__c> pocToInsert) {
        List<Id> createdPocIds = new List<Id>();
        for (Practice_Operation_Change__c created : pocToInsert) {
            if (created.Id != null) createdPocIds.add(created.Id);
        }

        if (!createdPocIds.isEmpty() && !Test.isRunningTest()) {
            System.enqueueJob(new CreateClientChangeManagementQueueable(contractIds, createdPocIds));
        }
    }
    
}