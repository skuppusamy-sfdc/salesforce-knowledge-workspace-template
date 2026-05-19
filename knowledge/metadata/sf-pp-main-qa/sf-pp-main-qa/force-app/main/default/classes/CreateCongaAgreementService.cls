public with sharing class CreateCongaAgreementService {
    @TestVisible private static Set<Id> testCorporateEntityIds;

    @TestVisible
    static void setTestCorporateEntityIds(Set<Id> ceIds) {
        testCorporateEntityIds = ceIds;
    }
    
    /**
     * @description: This method is the entry point for creating Conga Agreements and Contract Agreements.
     * It is called from the LWC button on the Contract record page.
     * @param contractId The Id of the Contract record from which the button was clicked.
     * @return Id The Id of the first created Agreement record.
     */
    @AuraEnabled
    public static Id createAgreements(String contractId) {
        if (String.isBlank(contractId)) {
            throwException('Contract Id cannot be blank.');
        }

        // Query the main Contract record. This query no longer includes the subquery.
        Contract c = [
            SELECT Id, PreviousContractId, AccountId, StartDate, EndDate, Account.Name,
                   Agreement_Record_Needed__c, Name,
                   Contracting_Corporate_Entity__c,
                   Contracting_Corporate_Entity__r.Id, //PCA StartEnd
                   Employment_Type__c,
                   NPPA_Tier__c
            FROM Contract
            WHERE Id = :contractId
        ];
        
        // Separately query for all related Provider Network Contracts.
        List<ProviderNetworkContract> providerNetworkContracts = [
            SELECT Id, Healthcare_Practitioner_Facility__c,
                   Healthcare_Practitioner_Facility__r.Contracting_Corporate_Entity__c,
                   Time_Type_Formula__c
            FROM ProviderNetworkContract
            WHERE ContractId = :c.Id AND Healthcare_Practitioner_Facility__r.Exclude_On_Agreement__c = false
        ];
        
        String acctName = (c.Account == null || String.isBlank(c.Account.Name)) ? '' : c.Account.Name; 
        String startDateStr = (c.StartDate == null) ? '' : String.valueOf(c.StartDate);
        String agrName = (acctName + ' ' + startDateStr).trim();

        // Get Record Type Ids for Apttus Agreement object
        Map<String, Id> recordTypeIds = getAgreementRecordTypeIds();

        // --- Scenario 1: Previous Contract is BLANK ---
        if (String.isBlank(c.PreviousContractId)) {
            return handleBlankPreviousContract(c, providerNetworkContracts, recordTypeIds, agrName);
        }
        // --- Scenario 2: Previous Contract is NOT BLANK ---
        else {
            return handlePopulatedPreviousContract(c, providerNetworkContracts, recordTypeIds, agrName);
        }
    }

    /**
     * @description: Helper method to get the RecordType Ids for the Apttus Agreement object.
     * @return Map of RecordType DeveloperName to Id.
     */
    private static Map<String, Id> getAgreementRecordTypeIds() {
        Map<String, Id> recordTypeIds = new Map<String, Id>();
        for (RecordType rt : [
            SELECT Id, DeveloperName
            FROM RecordType
            WHERE SobjectType = 'Apttus__APTS_Agreement__c'
            AND DeveloperName IN ('Core_Agreement', 'Addendum')
        ]) {
            recordTypeIds.put(rt.DeveloperName, rt.Id);
        }
        return recordTypeIds;
    }

    /**
     * @description: Handles the logic when PreviousContractId is blank.
     * It creates Agreements and Contract Agreements for each unique corporate entity.
     * @param c The Contract record.
     * @param providerNetworkContracts The related ProviderNetworkContract records.
     * @param recordTypeIds The map of record type developer names to Ids.
     * @return Id The Id of the first created Agreement record.
     */
    private static Id handleBlankPreviousContract(Contract c, List<ProviderNetworkContract> providerNetworkContracts, Map<String, Id> recordTypeIds, String AgreementName) {
        // Find unique corporate entities
        Set<Id> corporateEntityIds = new Set<Id>();
        // no test-time CE injection
        for (ProviderNetworkContract pnc : providerNetworkContracts) {
            if (pnc.Healthcare_Practitioner_Facility__r.Contracting_Corporate_Entity__c != null) {
                corporateEntityIds.add(pnc.Healthcare_Practitioner_Facility__r.Contracting_Corporate_Entity__c);
            }
        }

        // Test seam: allow deterministic CE coverage in tests without SeeAllData
        if (Test.isRunningTest() && testCorporateEntityIds != null && !testCorporateEntityIds.isEmpty()) {
            corporateEntityIds.addAll(testCorporateEntityIds);
        }

        if (corporateEntityIds.isEmpty()) {
            throwException('No Provider Network Contracts found with a valid Contracting Corporate Entity. Please ensure the Contract has associated Provider Network Contracts with Corporate Entities before creating an agreement.');
        }

        // Create Agreements for each unique corporate entity
        List<Apttus__APTS_Agreement__c> agreements = new List<Apttus__APTS_Agreement__c>();
        //PCA Start Added IF for if Contract.CCE is filled
        if(c.Contracting_Corporate_Entity__c == null){
            for (Id ceId : corporateEntityIds) {
                Apttus__APTS_Agreement__c agreement = CreateAgreementWithoutContractCCE(c, ceId, AgreementName);
                if (recordTypeIds.containsKey('Core_Agreement')) {
                    agreement.RecordTypeId = recordTypeIds.get('Core_Agreement');
                }
                agreements.add(agreement);
            }
        }else{
            Apttus__APTS_Agreement__c agreement = CreateAgreementWithContractCCE(c, AgreementName);
                if (recordTypeIds.containsKey('Core_Agreement')) {
                    agreement.RecordTypeId = recordTypeIds.get('Core_Agreement');
                }
                agreements.add(agreement);
        }//PCA End

        
        insert agreements;
        

        // Populate new flags on created agreements and update
        populateAgreementFlags(c, providerNetworkContracts, agreements);
        agreements = CongaAgreementServiceHelper.congaServiceHelpCombined(agreements);
        update agreements;

        // Create Contract_Agreement__c links
        List<Contract_Agreement__c> contractAgreements = new List<Contract_Agreement__c>();
        for (Apttus__APTS_Agreement__c agreement : agreements) {
            Contract_Agreement__c ca = new Contract_Agreement__c();
            ca.Contract__c = c.Id;
            ca.Agreement__c = agreement.Id;
            contractAgreements.add(ca);
        }
        insert contractAgreements;

        // Update Agreement_Record_Needed__c if blank
        if (String.isBlank(c.Agreement_Record_Needed__c)) {
            c.Agreement_Record_Needed__c = 'New Core Contract';
            update c;
        }
        
        

        return agreements[0].Id;
    }

    /**
     * @description: Handles the logic when PreviousContractId is populated.
     * It branches based on the value of Agreement_Record_Needed__c.
     * @param c The Contract record.
     * @param providerNetworkContracts The related ProviderNetworkContract records.
     * @param recordTypeIds The map of record type developer names to Ids.
     * @return Id The Id of the first created Agreement record.
     */
    private static Id handlePopulatedPreviousContract(Contract c, List<ProviderNetworkContract> providerNetworkContracts, Map<String, Id> recordTypeIds, String AgreementName){
        // Auto-populate Agreement_Record_Needed__c if blank
        if (String.isBlank(c.Agreement_Record_Needed__c)) {
            updateAgreementRecordNeeded(c, null);
        }
        
        if (c.Agreement_Record_Needed__c == 'New Core Contract') {
            return handleNewCoreContract(c, providerNetworkContracts, recordTypeIds, AgreementName);
        } else if (c.Agreement_Record_Needed__c == 'Update Addendum') {
            return handleUpdateAddendum(c, providerNetworkContracts, recordTypeIds, AgreementName);
        } else if (c.Agreement_Record_Needed__c == 'New Addendum') {
            return handleNewAddendum(c, providerNetworkContracts, recordTypeIds, AgreementName);
        }
        throwException('Invalid Agreement Record Needed value: ' + c.Agreement_Record_Needed__c + '. Expected values are: New Core Contract, Update Addendum, or New Addendum.');
        return null; // Satisfy compiler; execution never reaches here due to exception
    }

    /**
     * @description: Handles the logic for New Core Contract scenario.
     * Creates new Core Agreements, deactivates old Contract Agreements, and cancels old Agreements.
     * @param c The Contract record.
     * @param providerNetworkContracts The related ProviderNetworkContract records.
     * @param recordTypeIds The map of record type developer names to Ids.
     * @return Id The Id of the first created Agreement record.
     */
    private static Id handleNewCoreContract(Contract c, List<ProviderNetworkContract> providerNetworkContracts, Map<String, Id> recordTypeIds, String AgreementName) {
        // Find unique corporate entities
        Set<Id> corporateEntityIds = new Set<Id>();
        // no test-time CE injection
        for (ProviderNetworkContract pnc : providerNetworkContracts) {
            if (pnc.Healthcare_Practitioner_Facility__r.Contracting_Corporate_Entity__c != null) {
                corporateEntityIds.add(pnc.Healthcare_Practitioner_Facility__r.Contracting_Corporate_Entity__c);
            }
        }

        // Test seam: allow deterministic CE coverage in tests without SeeAllData
        if (Test.isRunningTest() && testCorporateEntityIds != null && !testCorporateEntityIds.isEmpty()) {
            corporateEntityIds.addAll(testCorporateEntityIds);
        }

        if (corporateEntityIds.isEmpty()) {
            throwException('No Provider Network Contracts found with a valid Contracting Corporate Entity. Please ensure the Contract has associated Provider Network Contracts with Corporate Entities before creating an agreement.');
        }

        // Create new Agreements for each unique corporate entity
        List<Apttus__APTS_Agreement__c> newAgreements = new List<Apttus__APTS_Agreement__c>();
        //PCA Start Added IF for if Contract.CCE is filled
        if(c.Contracting_Corporate_Entity__c == null){
            for (Id ceId : corporateEntityIds) {
                Apttus__APTS_Agreement__c agreement = CreateAgreementWithoutContractCCE(c, ceId, AgreementName);
                if (recordTypeIds.containsKey('Core_Agreement')) {
                    agreement.RecordTypeId = recordTypeIds.get('Core_Agreement');
                }
                newAgreements.add(agreement);
            }
        }else{
            Apttus__APTS_Agreement__c agreement = CreateAgreementWithContractCCE(c, AgreementName);
            if (recordTypeIds.containsKey('Core_Agreement')) {
                agreement.RecordTypeId = recordTypeIds.get('Core_Agreement');
            }
            newAgreements.add(agreement);
        }//PCA End

        insert newAgreements;

        // Populate new flags on created agreements and update
        populateAgreementFlags(c, providerNetworkContracts, newAgreements);
        newAgreements = CongaAgreementServiceHelper.congaServiceHelpCombined(newAgreements);
        update newAgreements;

        // Create new Contract_Agreement__c links
        List<Contract_Agreement__c> newContractAgreements = new List<Contract_Agreement__c>();
        for (Apttus__APTS_Agreement__c agreement : newAgreements) {
            Contract_Agreement__c ca = new Contract_Agreement__c();
            ca.Contract__c = c.Id;
            ca.Agreement__c = agreement.Id;
            newContractAgreements.add(ca);
            }
            insert newContractAgreements;

        // Deactivate old Contract_Agreement__c links
        List<Contract_Agreement__c> oldLinks = [
            SELECT Id, Status__c 
            FROM Contract_Agreement__c
            WHERE Contract__c = :c.PreviousContractId
        ];
        for (Contract_Agreement__c oldLink : oldLinks) {
            oldLink.Status__c = 'Inactive';
        }
        update oldLinks;

        return newAgreements[0].Id;
    }

    /**
     * @description: Handles the logic for Update Addendum scenario.
     * It creates a new addendum and conditionally creates Contract_Agreement__c links.
     * @param c The Contract record.
     * @param providerNetworkContracts The related ProviderNetworkContract records.
     * @param recordTypeIds The map of record type developer names to Ids.
     * @return Id The Id of the created addendum.
     */
    private static Id handleUpdateAddendum(Contract c, List<ProviderNetworkContract> providerNetworkContracts, Map<String, Id> recordTypeIds, String AgreementName) {
        //CCE Start
        // Find unique corporate entities
        Set<Id> corporateEntityIds = new Set<Id>();
        for (ProviderNetworkContract pnc : providerNetworkContracts) {
            if (pnc.Healthcare_Practitioner_Facility__r.Contracting_Corporate_Entity__c != null) {
                corporateEntityIds.add(pnc.Healthcare_Practitioner_Facility__r.Contracting_Corporate_Entity__c);
            }
        }

        // Test seam: allow deterministic CE coverage in tests without SeeAllData
        if (Test.isRunningTest() && testCorporateEntityIds != null && !testCorporateEntityIds.isEmpty()) {
            corporateEntityIds.addAll(testCorporateEntityIds);
        }

        if (corporateEntityIds.isEmpty()) {
            throwException('No Provider Network Contracts found with a valid Contracting Corporate Entity. Please ensure the Contract has associated Provider Network Contracts with Corporate Entities before creating an agreement.');
        }

        // Create Agreements for each unique corporate entity
        List<Apttus__APTS_Agreement__c> newAddendumsToInsert = new List<Apttus__APTS_Agreement__c>();
        //PCA Start Added IF for if Contract.CCE is filled
        if(c.Contracting_Corporate_Entity__c == null){
            for (Id ceId : corporateEntityIds) {
                Apttus__APTS_Agreement__c agreement = CreateAgreementWithoutContractCCE(c, ceId, AgreementName);
                if (recordTypeIds.containsKey('Addendum')) {
                    agreement.RecordTypeId = recordTypeIds.get('Addendum');
                }
                newAddendumsToInsert.add(agreement);
            }
        }else{
                // Create new addendum
                Apttus__APTS_Agreement__c newAddendum = CreateAgreementWithContractCCE(c, AgreementName);
                if (recordTypeIds.containsKey('Addendum')) {
                    newAddendum.RecordTypeId = recordTypeIds.get('Addendum');
                }
                newAddendumsToInsert.add(newAddendum);
        }//PCA End
        
        
        
        
        insert newAddendumsToInsert;

        Apttus__APTS_Agreement__c newAddendum = new Apttus__APTS_Agreement__c();

        // Populate new flags on created agreement and update
        populateAgreementFlags(c, [SELECT Id, Time_Type_Formula__c, Healthcare_Practitioner_Facility__c FROM ProviderNetworkContract WHERE ContractId = :c.Id], newAddendumsToInsert);
        List<Apttus__APTS_Agreement__c> newAddendums = CongaAgreementServiceHelper.congaServiceHelpCombined(newAddendumsToInsert);
        if (newAddendums != null && !newAddendums.isEmpty()){
        	newAddendum =  newAddendums[0];
        }
        update newAddendums;

        // Query previous contract's agreements to compare document titles
        List<Apttus__APTS_Agreement__c> prevAgreements = [
            SELECT Id, Primary_Document_Title__c, Corporate_Entity__c
            FROM Apttus__APTS_Agreement__c
            WHERE Contract__c = :c.PreviousContractId
        ];

        //Put newAgreement into Map
        Map<Id, Apttus__APTS_Agreement__c> newAgreementByCE = new Map<Id, Apttus__APTS_Agreement__c>();
        for (Apttus__APTS_Agreement__c a : newAddendums) {
            if (a.Corporate_Entity__c == null) continue;
            if (!newAgreementByCE.containsKey(a.Corporate_Entity__c)) {
                newAgreementByCE.put(a.Corporate_Entity__c, a);
            }
        }

        // Create Contract_Agreement__c links only if document titles don't match
        List<Contract_Agreement__c> contractAgreements = new List<Contract_Agreement__c>();
        for (Apttus__APTS_Agreement__c prevAg : prevAgreements) {
            if(newAgreementByCE.get(prevAg.Corporate_Entity__c) != null){
                if (prevAg.Primary_Document_Title__c != newAgreementByCE.get(prevAg.Corporate_Entity__c).Primary_Document_Title__c) {
                    Contract_Agreement__c ca = new Contract_Agreement__c();
                    ca.Contract__c = c.Id;
                    ca.Agreement__c = newAgreementByCE.get(prevAg.Corporate_Entity__c).Id;
                    contractAgreements.add(ca);
            	}
            }            
        }
        
        if (!contractAgreements.isEmpty()) {
            insert contractAgreements;
        }

        // Deactivate old Contract_Agreement__c links
        List<Contract_Agreement__c> oldLinks = [
            SELECT Id, Status__c 
            FROM Contract_Agreement__c 
            WHERE Contract__c = :c.PreviousContractId
        ];
        for (Contract_Agreement__c oldLink : oldLinks) {
            oldLink.Status__c = 'Inactive';
        }
        update oldLinks;

        return newAddendum.Id;
    }

    /**
     * @description: Handles the logic for New Addendum scenario.
     * It creates a new addendum and links it to old agreements.
     * @param c The Contract record.
     * @param providerNetworkContracts The related ProviderNetworkContract records.
     * @param recordTypeIds The map of record type developer names to Ids.
     * @return Id The Id of the created addendum.
     */
    private static Id handleNewAddendum(Contract c, List<ProviderNetworkContract> providerNetworkContracts, Map<String, Id> recordTypeIds, String AgreementName) {
        //CCE Start
        // Find unique corporate entities
        Set<Id> corporateEntityIds = new Set<Id>();
        for (ProviderNetworkContract pnc : providerNetworkContracts) {
            if (pnc.Healthcare_Practitioner_Facility__r.Contracting_Corporate_Entity__c != null) {
                corporateEntityIds.add(pnc.Healthcare_Practitioner_Facility__r.Contracting_Corporate_Entity__c);
            }
        }

        // Test seam: allow deterministic CE coverage in tests without SeeAllData
        if (Test.isRunningTest() && testCorporateEntityIds != null && !testCorporateEntityIds.isEmpty()) {
            corporateEntityIds.addAll(testCorporateEntityIds);
        }

        if (corporateEntityIds.isEmpty()) {
            throwException('No Provider Network Contracts found with a valid Contracting Corporate Entity. Please ensure the Contract has associated Provider Network Contracts with Corporate Entities before creating an agreement.');
        }

        // Create Agreements for each unique corporate entity
        List<Apttus__APTS_Agreement__c> newAddendumsToInsert = new List<Apttus__APTS_Agreement__c>();
        //PCA Start Added IF for if Contract.CCE is filled
        if(c.Contracting_Corporate_Entity__c == null){
            for (Id ceId : corporateEntityIds) {
                Apttus__APTS_Agreement__c agreement = CreateAgreementWithoutContractCCE(c, ceId, AgreementName);
                if (recordTypeIds.containsKey('Addendum')) {
                    agreement.RecordTypeId = recordTypeIds.get('Addendum');
                }
                newAddendumsToInsert.add(agreement);
            }
        }else{
                // Create new addendum
                Apttus__APTS_Agreement__c newAddendum = CreateAgreementWithContractCCE(c, AgreementName);
                if (recordTypeIds.containsKey('Addendum')) {
                    newAddendum.RecordTypeId = recordTypeIds.get('Addendum');
                }
                newAddendumsToInsert.add(newAddendum);
        }//PCA End
        
        
        
        
        insert newAddendumsToInsert;
        Apttus__APTS_Agreement__c newAddendum = new Apttus__APTS_Agreement__c();
        // Populate new flags on created agreement and update
        populateAgreementFlags(c, [SELECT Id, Time_Type_Formula__c, Healthcare_Practitioner_Facility__c FROM ProviderNetworkContract WHERE ContractId = :c.Id], newAddendumsToInsert);
        List<Apttus__APTS_Agreement__c> newAddendums = CongaAgreementServiceHelper.congaServiceHelpCombined(newAddendumsToInsert);
        if (newAddendums != null && !newAddendums.isEmpty()){
        	newAddendum =  newAddendums[0];
        }
        update newAddendums;

        // Get old agreements from previous contract
        List<Apttus__APTS_Agreement__c> oldAgreements = [
            SELECT Id
            FROM Apttus__APTS_Agreement__c
            WHERE Contract__c = :c.PreviousContractId
        ];

        // Create Contract_Agreement__c links for old agreements
        List<Contract_Agreement__c> contractAgreements = new List<Contract_Agreement__c>();
        for (Apttus__APTS_Agreement__c oldAg : oldAgreements) {
            Contract_Agreement__c ca = new Contract_Agreement__c();
            ca.Contract__c = c.Id;
            ca.Agreement__c = oldAg.Id;
            contractAgreements.add(ca);
        }
        // Create Contract_Agreement__c links for new agreements
        for (Apttus__APTS_Agreement__c Ag : newAddendums) {
            Contract_Agreement__c ca = new Contract_Agreement__c();
            ca.Contract__c = c.Id;
            ca.Agreement__c = Ag.Id;
            contractAgreements.add(ca);
        }

        
        insert contractAgreements;

        // Deactivate old Contract_Agreement__c links
        List<Contract_Agreement__c> oldLinks = [
            SELECT Id, Status__c 
            FROM Contract_Agreement__c
            WHERE Contract__c = :c.PreviousContractId
        ];
        for (Contract_Agreement__c oldLink : oldLinks) {
            oldLink.Status__c = 'Inactive';
        }
        update oldLinks;

        return newAddendum.Id;
    }

    
    // Populate newly requested flags/fields on created agreements, based on current vs previous contract state
    private static void populateAgreementFlags(
        Contract currentContract,
        List<ProviderNetworkContract> currentPncs,
        List<Apttus__APTS_Agreement__c> agreementsJustCreated
    ) {
        if (agreementsJustCreated == null || agreementsJustCreated.isEmpty()) {
            return;
        }

        Contract prev;
        List<ProviderNetworkContract> prevPncs = new List<ProviderNetworkContract>();
        if (!String.isBlank(currentContract.PreviousContractId)) {
            prev = [
                SELECT Id,
                       Contracting_Corporate_Entity__c,
                       Employment_Type__c,
                       NPPA_Tier__c
                FROM Contract
                WHERE Id = :currentContract.PreviousContractId
            ];
            prevPncs = [
                SELECT Id, Time_Type_Formula__c, Healthcare_Practitioner_Facility__c
                FROM ProviderNetworkContract
                WHERE ContractId = :prev.Id
            ];
        }

        // Also ensure we have current contract fields needed for leadership checks
        Contract curDetails = [
            SELECT Id, AccountId
            FROM Contract WHERE Id = :currentContract.Id
        ];

        // Previous contract agreement types for Adding_Bonus__c
        // Build previous contract bonus presence from its Contract Payment Agreements' PCAs
        Boolean prevHasBonusByPca = false;
        if (prev != null) {
            // Get all ContractPaymentAgreement IDs for previous contract
            List<ContractPaymentAgreement> prevCPAs = [
                SELECT Id
                FROM ContractPaymentAgreement
                WHERE ContractId = :prev.Id
            ];
            
            if (!prevCPAs.isEmpty()) {
                Set<Id> prevCPAIds = new Set<Id>();
                for (ContractPaymentAgreement cpa : prevCPAs) {
                    prevCPAIds.add(cpa.Id);
                }
                
                // Query PreventiveCareAgreements related to these CPAs
                List<PreventiveCareAgreement> prevPCAs = [
                    SELECT Id, Type__r.CodeSetType
                    FROM PreventiveCareAgreement
                    WHERE ContractPaymentAgreementId IN :prevCPAIds
                ];
                
                for (PreventiveCareAgreement pca : prevPCAs) {
                    if (pca.Type__r != null && pca.Type__r.CodeSetType == 'Bonus') {
                        prevHasBonusByPca = true;
                        break;
                    }
                }
            }
        }

        // 1) Facilities_Added__c
        Boolean facilitiesAdded = false;
        if (prev != null && currentContract.Contracting_Corporate_Entity__c != null &&
            currentContract.Contracting_Corporate_Entity__c == prev.Contracting_Corporate_Entity__c) {
            Set<Id> curHpf = new Set<Id>();
            for (ProviderNetworkContract p : currentPncs) {
                if (p.Healthcare_Practitioner_Facility__c != null) curHpf.add(p.Healthcare_Practitioner_Facility__c);
            }
            Set<Id> prevHpf = new Set<Id>();
            for (ProviderNetworkContract p : prevPncs) {
                if (p.Healthcare_Practitioner_Facility__c != null) prevHpf.add(p.Healthcare_Practitioner_Facility__c);
            }
            for (Id idVal : curHpf) {
                if (!prevHpf.contains(idVal)) { facilitiesAdded = true; break; }
            }
        } else {
            facilitiesAdded = false;
        }

        // 2) 3) Clinician_s_EE_Status__c based on Time_Type_Formula__c changes
        String clinicianEeStatus = null; // expect 'PT' or 'FT'
        Boolean anyCurFT = false, anyCurPT = false, anyPrevFT = false, anyPrevPT = false;
        for (ProviderNetworkContract p : currentPncs) {
            if (p.Time_Type_Formula__c == 'Full Time') anyCurFT = true;
            if (p.Time_Type_Formula__c == 'Part Time') anyCurPT = true;
        }
        for (ProviderNetworkContract p : prevPncs) {
            if (p.Time_Type_Formula__c == 'Full Time') anyPrevFT = true;
            if (p.Time_Type_Formula__c == 'Part Time') anyPrevPT = true;
        }
        // Corrected logic: Current = Full Time AND Previous = Part Time → 'PT'
        if (anyCurFT && anyPrevPT) clinicianEeStatus = 'PT';
        // Current = Part Time AND Previous = Full Time → 'FT'
        else if (anyCurPT && anyPrevFT) clinicianEeStatus = 'FT';

        // 4) Entity_Change__c via Case
        Boolean entityChange = false;
        Boolean clinicianNameChange = false;
        try {
            // Always use AccountId linkage as specified; filter out Closed
            entityChange = [SELECT Id FROM Case WHERE AccountId = :curDetails.AccountId AND Type = 'Business Entity Change' AND Status != 'Closed' LIMIT 1].size() == 1;
            clinicianNameChange = [SELECT Id FROM Case WHERE AccountId = :curDetails.AccountId AND Type = 'Name Change' AND Status != 'Closed' LIMIT 1].size() == 1;
        } catch (Exception e) {
            entityChange = false;
            clinicianNameChange = false;
        }

        // 5) 6) Clinician switching flags from contract employment type
        Boolean switchEeToIc = false;
        Boolean switchIcToEe = false;
        if (prev != null) {
            if (currentContract.Employment_Type__c == 'Independent Contractor' && prev.Employment_Type__c == 'Employee') {
                switchEeToIc = true;
            }
            if (currentContract.Employment_Type__c == 'Employee' && prev.Employment_Type__c == 'Independent Contractor') {
                switchIcToEe = true;
            }
        }

        // 7) EE_NPPA_Hour_Tier_Change__c
        Boolean nppaTierChange = false;
        if (prev != null) {
            // If Present Contract's NPPA_Tier__c value and Previous contract's NPPA_Tier__c value match then false, else true
            String currentNPPATier = currentContract.NPPA_Tier__c;
            String prevNPPATier = prev.NPPA_Tier__c;
            if (currentNPPATier == prevNPPATier) {
                nppaTierChange = false;
            } else {
                nppaTierChange = true;
            }
        }

        // 8) Leadership_Position_Change__c - multi-condition
        Boolean leadershipChange = false;
        if (prev != null) {
            // Get all ContractPaymentAgreement IDs for current contract
            List<ContractPaymentAgreement> currentCPAs = [
                SELECT Id
                FROM ContractPaymentAgreement
                WHERE ContractId = :currentContract.Id
            ];
            
            // Get all ContractPaymentAgreement IDs for previous contract
            List<ContractPaymentAgreement> prevCPAs = [
                SELECT Id
                FROM ContractPaymentAgreement
                WHERE ContractId = :prev.Id
            ];
            
            // Get PreventiveCareAgreements for current contract
            List<PreventiveCareAgreement> currentPCAs = new List<PreventiveCareAgreement>();
            if (!currentCPAs.isEmpty()) {
                Set<Id> currentCPAIds = new Set<Id>();
                for (ContractPaymentAgreement cpa : currentCPAs) {
                    currentCPAIds.add(cpa.Id);
                }
                currentPCAs = [
                    SELECT Id, Type__c, Type__r.CodeSetType, Type__r.Name, Admin_Hours__c
                    FROM PreventiveCareAgreement
                    WHERE ContractPaymentAgreementId IN :currentCPAIds
                ];
            }
            
            // Get PreventiveCareAgreements for previous contract
            List<PreventiveCareAgreement> prevPCAs = new List<PreventiveCareAgreement>();
            if (!prevCPAs.isEmpty()) {
                Set<Id> prevCPAIds = new Set<Id>();
                for (ContractPaymentAgreement cpa : prevCPAs) {
                    prevCPAIds.add(cpa.Id);
                }
                prevPCAs = [
                    SELECT Id, Type__c, Type__r.CodeSetType, Type__r.Name, Admin_Hours__c
                    FROM PreventiveCareAgreement
                    WHERE ContractPaymentAgreementId IN :prevCPAIds
                ];
            }
            
            // First Condition: Compare CodeSetType - if current = 'Stipend' and previous != 'Stipend'
            Boolean firstCondition = false;
            for (PreventiveCareAgreement currPCA : currentPCAs) {
                if (currPCA.Type__r != null && currPCA.Type__r.CodeSetType == 'Stipend') {
                    // Check if any previous PCA has non-Stipend CodeSetType
                    for (PreventiveCareAgreement prevPCA : prevPCAs) {
                        if (prevPCA.Type__r != null && prevPCA.Type__r.CodeSetType != 'Stipend') {
                            firstCondition = true;
                            break;
                        }
                    }
                    if (firstCondition) break;
                }
            }
            
            // Second Condition: Compare CodeSet Names
            Boolean secondCondition = false;
            if (!firstCondition) {
                for (PreventiveCareAgreement currPCA : currentPCAs) {
                    if (currPCA.Type__r != null) {
                        String currName = currPCA.Type__r.Name;
                        // Compare with all previous PCAs
                        for (PreventiveCareAgreement prevPCA : prevPCAs) {
                            if (prevPCA.Type__r != null) {
                                String prevName = prevPCA.Type__r.Name;
                                if (currName != prevName) {
                                    secondCondition = true;
                                    break;
                                }
                            }
                        }
                        if (secondCondition) break;
                    }
                }
            }
            
            // Third Condition: Compare Admin_Hours__c
            Boolean thirdCondition = false;
            if (!firstCondition && !secondCondition) {
                for (PreventiveCareAgreement currPCA : currentPCAs) {
                    Decimal currHours = currPCA.Admin_Hours__c;
                    // Compare with all previous PCAs
                    for (PreventiveCareAgreement prevPCA : prevPCAs) {
                        Decimal prevHours = prevPCA.Admin_Hours__c;
                        if (currHours != prevHours) {
                            thirdCondition = true;
                            break;
                        }
                    }
                    if (thirdCondition) break;
                }
            }
            
            leadershipChange = firstCondition || secondCondition || thirdCondition;
        }

        // 9) New_Clinician__c - true if Contract's previous contract is blank
        Boolean newClinician = String.isBlank(currentContract.PreviousContractId);

        // Apply to all created agreements
        for (Apttus__APTS_Agreement__c ag : agreementsJustCreated) {
            ag.Facilities_Added__c = facilitiesAdded;
            if (clinicianEeStatus != null) {
                ag.Clinician_s_EE_Status__c = clinicianEeStatus;
            }
            ag.Entity_Change__c = entityChange;
            ag.Clinician_Name__c = clinicianNameChange;
            ag.Clinician_Switching_from_EE_to_IC__c = switchEeToIc;
            ag.Clinician_switching_from_IC_to_EE__c = switchIcToEe;
            ag.EE_NPPA_Hour_Tier_Change__c = nppaTierChange;
            ag.Leadership_Position_Change__c = leadershipChange;
            ag.New_Clinician__c = newClinician;
            
            // Adding_Bonus__c: Compare CodeSetType between current and previous contract payment agreements
            Boolean addingBonus = false;
            if (prev != null) {
                // Check if current contract has any Bonus CodeSetType
                Boolean currentHasBonus = false;
                List<ContractPaymentAgreement> currentCPAs = [
                    SELECT Id
                    FROM ContractPaymentAgreement
                    WHERE ContractId = :currentContract.Id
                ];
                
                if (!currentCPAs.isEmpty()) {
                    Set<Id> currentCPAIds = new Set<Id>();
                    for (ContractPaymentAgreement cpa : currentCPAs) {
                        currentCPAIds.add(cpa.Id);
                    }
                    
                    List<PreventiveCareAgreement> currentPCAs = [
                        SELECT Id, Type__r.CodeSetType
                        FROM PreventiveCareAgreement
                        WHERE ContractPaymentAgreementId IN :currentCPAIds
                    ];
                    
                    for (PreventiveCareAgreement pca : currentPCAs) {
                        if (pca.Type__r != null && pca.Type__r.CodeSetType == 'Bonus') {
                            currentHasBonus = true;
                            break;
                        }
                    }
                }
                
                // If current = 'Bonus' and previous != 'Bonus', then addingBonus = true
                if (currentHasBonus && !prevHasBonusByPca) {
                    addingBonus = true;
                }
            }
            ag.Adding_Bonus__c = addingBonus;
        }
    }


    /**
     * @description: Temporary logic for SCPHEAL-139
     * Updates Agreement_Record_Needed__c field based on agreement document titles.
     * @param contRec The Contract record to update.
     * @param insertedAgreementId The Id of the newly inserted agreement.
     */
    private static void updateAgreementRecordNeeded(Contract contRec, Id insertedAgreementId) {
        // Only auto-populate if Agreement_Record_Needed__c is blank
        if (String.isNotBlank(contRec.Agreement_Record_Needed__c)) {
            return;
        }
        
        // 1. New Core Contract Scenarios
        if (contRec.PreviousContractId == null) {
            contRec.Agreement_Record_Needed__c = 'New Core Contract';
            update contRec;
            return;
        }
        
        // If PreviousContractId is not null, check the conditions for New Core Contract
        if (contRec.PreviousContractId != null) {
            // Get previous contract details
            Contract prevContract = [
                SELECT Id, Employment_Type__c, AccountId
                FROM Contract 
                WHERE Id = :contRec.PreviousContractId
            ];
            
            // Check for New Core Contract conditions
            Boolean shouldBeNewCore = false;
            
            // Check for EE Status changes (FT to PT or PT to FT)
            List<ProviderNetworkContract> currentPncs = [
                SELECT Time_Type_Formula__c 
                FROM ProviderNetworkContract 
                WHERE ContractId = :contRec.Id
            ];
            List<ProviderNetworkContract> prevPncs = [
                SELECT Time_Type_Formula__c 
                FROM ProviderNetworkContract 
                WHERE ContractId = :prevContract.Id
            ];
            
            Boolean anyCurFT = false, anyCurPT = false, anyPrevFT = false, anyPrevPT = false;
            for (ProviderNetworkContract p : currentPncs) {
                if (p.Time_Type_Formula__c == 'Full Time') anyCurFT = true;
                if (p.Time_Type_Formula__c == 'Part Time') anyCurPT = true;
            }
            for (ProviderNetworkContract p : prevPncs) {
                if (p.Time_Type_Formula__c == 'Full Time') anyPrevFT = true;
                if (p.Time_Type_Formula__c == 'Part Time') anyPrevPT = true;
            }
            
            // Condition 1: Adjusting Clinician's EE Status (FT to PT)
            if (anyCurPT && anyPrevFT) shouldBeNewCore = true;
            // Condition 2: Adjusting Clinician's EE Status (PT to FT)
            if (anyCurFT && anyPrevPT) shouldBeNewCore = true;
            
            // Condition 3: Entity Change (Entity to Ind or Vice Versa)
            if (contRec.Employment_Type__c != prevContract.Employment_Type__c) {
                shouldBeNewCore = true;
            }
            
            // Condition 4: Clinician Name Change (Change in legal name)
            List<Case> nameChangeCases = [
                SELECT Id 
                FROM Case 
                WHERE AccountId = :contRec.AccountId 
                AND Type = 'Name Change' 
                AND Status != 'Closed'
                LIMIT 1
            ];
            if (!nameChangeCases.isEmpty()) {
                shouldBeNewCore = true;
            }
            
            // Condition 5: Clinician switching from EE to IC
            if (contRec.Employment_Type__c == 'Independent Contractor' && prevContract.Employment_Type__c == 'Employee') {
                shouldBeNewCore = true;
            }
            
            // Condition 6: Clinician switching from IC to EE
            if (contRec.Employment_Type__c == 'Employee' && prevContract.Employment_Type__c == 'Independent Contractor') {
                shouldBeNewCore = true;
            }
            
            if (shouldBeNewCore) {
                contRec.Agreement_Record_Needed__c = 'New Core Contract';
                update contRec;
                return;
            }
        }
        
        // 2. New Addendum Scenario
        // Get current contract's agreement document title
        List<Apttus__APTS_Agreement__c> currentAgreements = [
            SELECT Primary_Document_Title__c 
            FROM Apttus__APTS_Agreement__c 
            WHERE Contract__c = :contRec.Id
            LIMIT 1
        ];
        
        // Get previous contract's agreement document title
        List<Apttus__APTS_Agreement__c> prevAgreements = [
            SELECT Primary_Document_Title__c 
            FROM Apttus__APTS_Agreement__c 
            WHERE Contract__c = :contRec.PreviousContractId
            LIMIT 1
        ];
        
        if (!currentAgreements.isEmpty() && !prevAgreements.isEmpty()) {
            String currentDocTitle = currentAgreements[0].Primary_Document_Title__c;
            String prevDocTitle = prevAgreements[0].Primary_Document_Title__c;
            
            // 2. New Addendum: If document titles are NOT the same
            if (currentDocTitle != prevDocTitle) {
                contRec.Agreement_Record_Needed__c = 'New Addendum';
                update contRec;
                return;
            }
            
            // 3. Update Addendum: If document titles are the same
            if (currentDocTitle == prevDocTitle) {
                contRec.Agreement_Record_Needed__c = 'Update Addendum';
                update contRec;
                return;
            }
        }
        
        //if Agreement Record Needed field is still null
        if (String.isBlank(contRec.Agreement_Record_Needed__c)){
            contRec.Agreement_Record_Needed__c = 'New Core Contract';
            update contRec;
            return;
        }
    }
    
    /**
     * @description: Helper method to throw exceptions
     * Uses IllegalArgumentException which works in both UI and backend contexts
     * @param message The error message to throw
     */
    private static void throwException(String message) {
        // Use IllegalArgumentException which works in all contexts (UI, triggers, batch, etc.)
        throw new IllegalArgumentException(message);
    }
    /**
     * @description: Helper method create agreements with Contract.CCE != null
     */
    private static Apttus__APTS_Agreement__c CreateAgreementWithoutContractCCE(Contract c, Id ceId, String AgreementName){
        Apttus__APTS_Agreement__c agreement = new Apttus__APTS_Agreement__c();
                agreement.Name = AgreementName;
                agreement.Contract__c = c.Id;
                agreement.Apttus__Account__c = c.AccountId;
                //PCA Start
                agreement.Corporate_Entity__c = ceId;
			return agreement;
    }
    /**
     * @description: Helper method create agreements with Contract.CCE != null
     */
    private static Apttus__APTS_Agreement__c CreateAgreementWithContractCCE(Contract c, String AgreementName){
        Apttus__APTS_Agreement__c agreement = new Apttus__APTS_Agreement__c();
                agreement.Name = AgreementName;
                agreement.Contract__c = c.Id;
                agreement.Apttus__Account__c = c.AccountId;
                agreement.Corporate_Entity__c = c.Contracting_Corporate_Entity__r.Id;
			return agreement;
    }
}