/**
 * @description Factory for creating test data (Accounts, Contacts, Contracts, Clinical_Rate_Change__c,
 * HealthcareProvider, HealthcarePractitionerFacility, ProviderNetworkContract, etc.) used by account-management-agent tests.
 */
@isTest
public class TestDataFactory {

    /**
     * @description Creates a Service Account (business or Clinician person account).
     * @param name Account Name for business accounts.
     * @param lastName LastName for person/clinician accounts.
     * @param recordTypeDeveloperName Record type developer name (e.g. 'Service_Account', 'Clinician').
     * @param doInsert Whether to insert the record.
     * @return Created Account.
     */
    public Account createServiceAccount(
        String name,      // For business accounts
        String lastName,  // For person/clinician accounts
        String recordTypeDeveloperName,        
        Boolean doInsert
    ) {
        Id rtId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
            .get(recordTypeDeveloperName)
            .getRecordTypeId();
        
        Account acc;
        if(recordTypeDeveloperName == 'Clinician') {
            // Person Account requires LastName; FirstName needed for buildTokenData
            acc = new Account(
                FirstName = 'Test',
                LastName = lastName,
                RecordTypeId = rtId
            );
        } else {
            // Business Account requires Name
            acc = new Account(
                Name = name,
                RecordTypeId = rtId
            );
        }
        
        if (doInsert) {
            insert acc;
        }
        return acc;
    }
    /**
     * @description Gets or creates a Contact for the given Account. For Person Accounts, returns the existing PersonContactId.
     * @param acc Account (Person or business).
     * @param lastName Last name for new Contact.
     * @return Contact record.
     */
    public Contact getOrCreateContact(Account acc, String lastName) {
        if (acc.Id == null) {
            insert acc;
        }
        
        // Re-query to get IsPersonAccount and PersonContactId
        acc = [SELECT Id, IsPersonAccount, PersonContactId FROM Account WHERE Id = :acc.Id LIMIT 1];
        
        if (acc.IsPersonAccount) {
            // Return the existing Contact for Person Account
            return [SELECT Id, FirstName, LastName, Email FROM Contact WHERE Id = :acc.PersonContactId];
        } else {
            Contact con = new Contact(
                LastName = lastName,
                AccountId = acc.Id,
                FirstName = 'Test',
                Email = 'testcpa' + Datetime.now().getTime() + '@example.com'
            );
            insert con;
            return con;
        }
    }
    
    /**
     * @description Creates a Contact for a business Account. For Person Accounts, returns the existing Contact.
     * @param lastName Last name for the Contact.
     * @param acc Account to link.
     * @param doInsert Whether to insert the record.
     * @return Created or existing Contact.
     */
    public Contact createContact(String lastName, Account acc, Boolean doInsert) {
        if (acc.IsPersonAccount) {
            // Return existing Contact for Person Account
            return [SELECT Id, FirstName, LastName, Email FROM Contact WHERE AccountId = :acc.Id LIMIT 1];
        }
        
        Contact con = new Contact(
            LastName = lastName,
            FirstName = 'Test',
            Email = 'testcpa' + Datetime.now().getTime() + '@example.com',
            AccountId = acc.Id
        );
        if (doInsert) {
            insert con;
        }
        return con;
    }    

    /**
     * @description Creates a Clinician contract.
     * @param acc Clinician Account.
     * @param doInsert Whether to insert the record.
     * @return Created Contract.
     */
    public Contract createClinicianContract(Account acc, Boolean doInsert) {
        Id clinicianContractRTId = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get('Clinician').getRecordTypeId();
        Contract c = new Contract(
            AccountId = acc.Id,
            StartDate = system.today(),
            RecordTypeId = clinicianContractRTId,
            Status = 'Draft',
            Employment_Type__c = 'Employee'
        );
        if(doInsert) {
            insert c;
        }
        return c;
    }
    
    /**
     * @description Creates a test User with System Administrator profile.
     * @param firstName User first name.
     * @param lastName User last name.
     * @param doInsert Whether to insert the record.
     * @return Created User.
     */
    public User createTestUser (String firstName, String lastName, Boolean doInsert) {
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1];
        
        String uniqueSuffix = String.valueOf(DateTime.now().getTime());
        
        User u = new User(
            FirstName = firstName,
            LastName = lastName,
            IsActive = true,
            Email = firstName.toLowerCase() + uniqueSuffix + '@example.com',
            Username = firstName.toLowerCase() + uniqueSuffix + '@example.com',
            Alias = firstName.substring(0, 3).toLowerCase(),
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = sysAdminProfile.id,
            LanguageLocaleKey = 'en_US'
        );
        
        if (doInsert) {
            insert u;
        }
        return u;
    }

    /**
     * @description Creates a ProviderNetworkContract.
     * @param contractId Contract Id.
     * @param hp HealthcareProvider Id.
     * @param hpn HealthcarePayerNetwork Id.
     * @param hpf HealthcarePractitionerFacility Id.
     * @param doInsert Whether to insert the record.
     * @return Created ProviderNetworkContract.
     */
    public ProviderNetworkContract createPNC(Id contractId, Id hp, Id hpn, Id hpf, Boolean doInsert) {
        ProviderNetworkContract pnc = new ProviderNetworkContract(
            ContractId = contractId,
            StartDate = Date.today(),
            EndDate = Date.today().addMonths(12),
            HealthcarePayerNetworkId = hpn,
            HealthcareProviderId = hp,
            Healthcare_Practitioner_Facility__c = hpf
        );
        
        if(doInsert) {
            insert pnc;  
        }
        return pnc;
    }

    // Creates a Contract Payment Agreement under a given Contract/PNC.
   /* public ContractPaymentAgreement createCPA(String Name, Id contractId, Id pncId, Boolean doInsert) {
        ContractPaymentAgreement cpa = new ContractPaymentAgreement(
            ContractId = contractId,
            Provider_Network_Contract__c = pncId,
            Type__c = 'Shift',
            Name = Name,
            AgreementType = 'Preventive Care Agreement',
            Status = 'Draft',
            StartDateTime = DateTime.now()
        );
        if(doInsert) {
            insert cpa;  
        }
        return cpa;
    }*/
    /**
     * @description Creates a ContractPaymentAgreement with default name resolution.
     * @param baseName Base name for the CPA.
     * @param contractId Contract Id.
     * @param pncId ProviderNetworkContract Id.
     * @param doInsert Whether to insert the record.
     * @return Created ContractPaymentAgreement.
     */
    public ContractPaymentAgreement createCPA(String baseName, Id contractId, Id pncId, Boolean doInsert) {
        return createCPA(baseName, contractId, pncId, doInsert, false);
    }

    /**
     * @description Creates a ContractPaymentAgreement with optional simple name.
     * @param baseName Base name for the CPA.
     * @param contractId Contract Id.
     * @param pncId ProviderNetworkContract Id.
     * @param doInsert Whether to insert the record.
     * @param useSimpleName When true, skips Contract/Account queries and uses timestamp-based name (saves 2 SOQL).
     * @return Created ContractPaymentAgreement.
     */
    public ContractPaymentAgreement createCPA(String baseName, Id contractId, Id pncId, Boolean doInsert, Boolean useSimpleName) {
        String cpaName;
        if (useSimpleName) {
            cpaName = baseName + '-' + DateTime.now().getTime();
        } else {
            Contract c = [SELECT Id, ContractNumber, AccountId FROM Contract WHERE Id = :contractId LIMIT 1];
            Account acc = [SELECT Id, Name, Global_Provider_ID__pc FROM Account WHERE Id = :c.AccountId LIMIT 1];
            cpaName = buildCPAUniqueName(baseName, c, acc);
        }
        ContractPaymentAgreement cpa = new ContractPaymentAgreement(
            ContractId = contractId,
            Provider_Network_Contract__c = pncId,
            Type__c = 'Shift',
            Name = cpaName,
            AgreementType = 'Preventive Care Agreement',
            Status = 'Draft',
            StartDateTime = DateTime.now()
        );
        if (doInsert) {
            insert cpa;
        }
        return cpa;
    }
    
    /**
     * @description Builds a unique CPA name from contract and account info.
     * @param baseName Base name.
     * @param newContract Contract for ContractNumber.
     * @param acc Account for Global_Provider_ID__pc or Name.
     * @return Unique name string.
     */
    private String buildCPAUniqueName(String baseName, Contract newContract, Account acc) {
        String globalOrAccount = acc != null && acc.Global_Provider_ID__pc != null
            ? String.valueOf(acc.Global_Provider_ID__pc)
            : (acc != null ? acc.Name : 'NA');
                
                return (newContract.ContractNumber != null ? newContract.ContractNumber : 'NA')
                + '-' + globalOrAccount
                + '-' + (baseName != null ? baseName : 'NA')
                + '-' + DateTime.now().getTime(); // ensure uniqueness
    }

    /**
     * @description Creates a PreventiveCareAgreement.
     * @param cpaId ContractPaymentAgreement Id.
     * @param doInsert Whether to insert the record.
     * @return Created PreventiveCareAgreement.
     */
    public PreventiveCareAgreement createPCA(Id cpaId, Boolean doInsert) {
        PreventiveCareAgreement pca = new PreventiveCareAgreement(
            ContractPaymentAgreementId = cpaId,
            BonusMeasureType = 'Performance',     
            TargetMeasurePercent = 10,          
            BonusPayout = 12     	
        );
        if(doInsert) {
            insert pca;  
        }
        return pca;
    }

    /**
     * @description Creates a Clinical_Rate_Change__c record.
     * @param serviceAccountId Service Account Id.
     * @param previewContractIds PreviewClonedContractIds__c value.
     * @param doInsert Whether to insert the record.
     * @return Created Clinical_Rate_Change__c.
     */
    public Clinical_Rate_Change__c createClinicalRateChange(Id serviceAccountId, String previewContractIds, Boolean doInsert) {
        Clinical_Rate_Change__c crc = new Clinical_Rate_Change__c(
            Service_Account_ID__c = serviceAccountId,
            PreviewClonedContractIds__c = previewContractIds,
            Non_Processed_Clinical_Ids__c = null
        );
        if(doInsert) {
            insert crc;  
        }
        return crc;
    }
    
    /**
     * @description Creates a HealthcarePayerNetwork.
     * @param name Network name.
     * @param corporateEntityId Payer (corporate entity) Id.
     * @param doInsert Whether to insert the record.
     * @return Created HealthcarePayerNetwork.
     */
    public HealthcarePayerNetwork createHealthcarePayerNetwork(String name, Id corporateEntityId, Boolean doInsert){
        HealthcarePayerNetwork healthcarePayerNetwork = new HealthcarePayerNetwork(
            Name = name,
            PayerId = corporateEntityId
        );
        if(doInsert) {
            insert healthcarePayerNetwork;  
        }
        return healthcarePayerNetwork;
    }
    
    /**
     * @description Creates a HealthcareProvider.
     * @param name Provider name.
     * @param physicianContactId Practitioner (Contact) Id.
     * @param doInsert Whether to insert the record.
     * @return Created HealthcareProvider.
     */
    public HealthcareProvider createHealthcareProvider(String name, Id physicianContactId, Boolean doInsert){
        HealthcareProvider physicianProvider = new HealthcareProvider(
            Name = name,
            PractitionerId = physicianContactId
        );
        if(doInsert) {
            insert physicianProvider;  
        }
        return physicianProvider;
    }
    
    /**
     * @description Creates a HealthcarePractitionerFacility.
     * @param name Facility name.
     * @param npaContactId Practitioner (Contact) Id.
     * @param serviceAccountId Service Account Id.
     * @param corporateEntityId Contracting Corporate Entity Id.
     * @param doInsert Whether to insert the record.
     * @return Created HealthcarePractitionerFacility.
     */
    public HealthcarePractitionerFacility createHealthcarePractitionerFacility(String name, Id npaContactId, Id serviceAccountId, Id corporateEntityId, Boolean doInsert){
        HealthcarePractitionerFacility npaHPF = new HealthcarePractitionerFacility(
            Name = name,
            PractitionerId = npaContactId,
            AccountId = serviceAccountId,
            Status__c = 'Prospect',
            Contracting_Corporate_Entity__c = corporateEntityId,
            Time_Type__c = 'Full Time'
        );
        if(doInsert) {
            insert npaHPF;  
        }
        return npaHPF;
    }
    
    /**
     * @description Creates a Person Account for Service_Account record type.
     * @param professionalTitle Unused; kept for compatibility.
     * @return Created Account.
     */
    public static Account createPersonAccount(String professionalTitle) {
        Id recordTypeId;
        
        Map<String, Schema.RecordTypeInfo> recordTypeInfoMap = Schema.SObjectType.Account.getRecordTypeInfosByName();
        System.debug('recordTypeInfoMap@@@@'+recordTypeInfoMap);
        
        // Use consistent record type name - adjust as per your org
        if (recordTypeInfoMap.containsKey('Service_Account')) {
            recordTypeId = recordTypeInfoMap.get('Service_Account').getRecordTypeId();
        }
        
        System.debug('recordTypeId@@@@'+recordTypeId);
        
        Account acc = new Account(
            RecordTypeId = recordTypeId,
            Name = 'Test Service Account'      
        );
        insert acc;
        return acc;
    }
    
    /**
     * @description Creates a Contact for the given Account.
     * @param acc Account to link.
     * @return Created Contact.
     */
    public static Contact createContact(Account acc) {
        Contact con = new Contact(
            LastName = 'Test Contact',
            AccountId = acc.Id
        );
        insert con;
        return con;
    }
    
    /**
     * @description Creates a Contract for the given Account.
     * @param acc Account to link.
     * @param startDate Contract start date.
     * @return Created Contract.
     */
    public static Contract createContract(Account acc, Date startDate) {
        Contract c = new Contract(
            AccountId = acc.Id,
            Status = 'Draft',
            StartDate = startDate
        );
        insert c;
        return c;
    }
    
    /**
     * @description Creates and inserts a Clinical_Rate_Change__c record.
     * @param serviceAccountId Service Account Id.
     * @param previewContractIds PreviewClonedContractIds__c value.
     * @return Created Clinical_Rate_Change__c.
     */
    public static Clinical_Rate_Change__c createClinicalRateChange(Id serviceAccountId, String previewContractIds) {
        Clinical_Rate_Change__c crc = new Clinical_Rate_Change__c(
            Service_Account_ID__c = serviceAccountId,
            PreviewClonedContractIds__c = previewContractIds,
            Non_Processed_Clinical_Ids__c = null
        );
        insert crc;
        return crc;
    }
    /**
     * @description Creates a Clinical_Rate_Change__c with optional user selections.
     * @param serviceAccountId Service Account Id.
     * @param clinicianContractId Contract Id.
     * @param doInsert Whether to insert the record.
     * @return Created Clinical_Rate_Change__c.
     */
    public Clinical_Rate_Change__c createClinicalRateChangeNew(Id serviceAccountId, String clinicianContractId, Boolean doInsert) {
        return createClinicalRateChangeNew(serviceAccountId, clinicianContractId, doInsert, false);
    }

    public Clinical_Rate_Change__c createClinicalRateChangeNew(Id serviceAccountId, String clinicianContractId, Boolean doInsert, Boolean skipRequery) {
        return createClinicalRateChangeNew(serviceAccountId, clinicianContractId, null, doInsert, skipRequery);
    }

    /**
     * @description Creates a Clinical_Rate_Change__c with optional user selections and requery.
     * @param serviceAccountId Service Account Id.
     * @param contractId Contract Id.
     * @param userSelectedIdsJson Optional JSON for user_selected_IDs__c. When set, Status__c='Open' and Contract_ID__c=contractId.
     * @param doInsert Whether to insert the record.
     * @param skipRequery When true, skips post-insert requery.
     * @return Created Clinical_Rate_Change__c.
     */
    public Clinical_Rate_Change__c createClinicalRateChangeNew(Id serviceAccountId, String contractId, String userSelectedIdsJson, Boolean doInsert, Boolean skipRequery) {
        Clinical_Rate_Change__c crc = new Clinical_Rate_Change__c(
            Service_Account_ID__c = serviceAccountId,
            PreviewClonedContractIds__c = contractId,
            Contract_ID__c = contractId,
            Non_Processed_Clinical_Ids__c = null
        );
        if (String.isNotBlank(userSelectedIdsJson)) {
            crc.user_selected_IDs__c = userSelectedIdsJson;
            crc.Status__c = 'Open';
        }
        if (doInsert) {
            insert crc;
        }
        if (doInsert && !skipRequery) {
            crc = [SELECT Id, CreatedById, Service_Account_ID__c, PreviewClonedContractIds__c, Non_Processed_Clinical_Ids__c
                   FROM Clinical_Rate_Change__c
                   WHERE Id = :crc.Id];
        }
        return crc;
    }

    
    /**
     * @description Creates a ContractFileRequest for fileToLinkGenerator.
     * @param accountId Account Id.
     * @param contractId Contract Id.
     * @return ContractFileRequest.
     */
    public static fileToLinkGenerator.ContractFileRequest createContractFileRequest(Id accountId, Id contractId) {
        fileToLinkGenerator.ContractFileRequest request = new fileToLinkGenerator.ContractFileRequest();
        request.accountId = accountId;
        request.contractId = contractId;
        return request;
    }
    
    /**
     * @description Creates a ContractFileResponse for fileToLinkGenerator.
     * @param success Success flag.
     * @param message Message string.
     * @param fileLinks List of file links.
     * @return ContractFileResponse.
     */
    public static fileToLinkGenerator.ContractFileResponse createContractFileResponse(Boolean success, String message, List<String> fileLinks) {
        fileToLinkGenerator.ContractFileResponse response = new fileToLinkGenerator.ContractFileResponse();
        response.success = success;
        response.message = message;
        response.fileLinks = fileLinks;
        return response;
    }
    
    /**
     * @description Creates a Contact with full details.
     * @param acc Account to link.
     * @param firstName First name.
     * @param lastName Last name.
     * @param email Email address.
     * @return Created Contact.
     */
    public static Contact createContactWithDetails(Account acc, String firstName, String lastName, String email) {
        Contact con = new Contact(
            FirstName = firstName,
            LastName = lastName,
            Email = email,
            AccountId = acc.Id
        );
        insert con;
        return con;
    }
    
    /**
     * @description Creates a Contract with status and term.
     * @param acc Account to link.
     * @param startDate Start date.
     * @param status Contract status.
     * @param contractTerm Contract term in months.
     * @return Created Contract.
     */
    public static Contract createContractWithDetails(Account acc, Date startDate, String status, Integer contractTerm) {
        Contract c = new Contract(
            AccountId = acc.Id,
            Status = status,
            StartDate = startDate,
            ContractTerm = contractTerm
        );
        insert c;
        return c;
    }
    
    /**
     * @description Creates a Clinical_Rate_Change__c with full details.
     * @param serviceAccountId Service Account Id.
     * @param contractId Contract Id.
     * @param previewContractIds PreviewClonedContractIds__c value.
     * @param userSelectedIds user_selected_IDs__c value.
     * @param nonProcessedIds Non_Processed_Clinical_Ids__c value.
     * @return Created Clinical_Rate_Change__c.
     */
    public static Clinical_Rate_Change__c createClinicalRateChangeWithDetails(Id serviceAccountId, Id contractId, String previewContractIds, String userSelectedIds, String nonProcessedIds) {
        Clinical_Rate_Change__c crc = new Clinical_Rate_Change__c(
            Service_Account_ID__c = serviceAccountId,
            Contract_ID__c = contractId,
            PreviewClonedContractIds__c = previewContractIds,
            user_selected_IDs__c = userSelectedIds,
            Non_Processed_Clinical_Ids__c = nonProcessedIds
        );
        insert crc;
        return crc;
    }

    /**
     * @description Creates a Contract for ContractDetails tests.
     * @param acc Account to link.
     * @param serviceLine Service Line Id.
     * @param startDate Start date.
     * @return Created Contract.
     */
    public static Contract createContractForDetails(Account acc, String serviceLine, Date startDate) {
        Contract c = new Contract(
            AccountId = acc.Id,
            Service_Line__c = serviceLine,
            StartDate = startDate,
            Status = 'Draft'
        );
        insert c;
        return c;
    }
    
    /**
     * @description Creates a ContractDetails.InvocableOutput for testing.
     * @param contractDetails Formatted contract details string.
     * @param returnedContractId Returned contract Id.
     * @return ContractDetails.InvocableOutput.
     */
    public static ContractDetails.InvocableOutput createContractDetailsOutput(String contractDetails, String returnedContractId) {
        ContractDetails.InvocableOutput output = new ContractDetails.InvocableOutput();
        output.contractDetails = contractDetails;
        output.returnedContractId = returnedContractId;
        return output;
    }

    /**
     * @description Creates a CodeSet record. Reusable for Shift, Facility Title, etc.
     */
    public CodeSet createCodeSet(String name, String code, String codeSetType, Boolean doInsert) {
        CodeSet cs = new CodeSet(
            Name = name,
            Code = code,
            CodeSetType = codeSetType,
            IsActive = true
        );
        if (doInsert) {
            insert cs;
        }
        return cs;
    }

    /**
     * @description Creates a Shift__c record. Reusable for PO and Clinician contracts.
     * For multiple shifts: build a List, add records with doInsert=false, then insert the list once.
     * @param shiftNameCodeSetId CodeSet Id for Shift_Name__c (e.g. Day, Night)
     * @param contractId Contract to link
     * @param iteration Shift_Iteration__c (e.g. '1', '2')
     * @param dayOfWeek Shift_Day_of_the_Week__c (e.g. 'Monday', 'Tuesday')
     * @param startTime Shift_Start_Time__c
     * @param endTime Shift_End_Time__c
     * @param type Type__c (e.g. 'NP/PA')
     * @param doInsert Whether to insert (use false when bulk-inserting)
     */
    public Shift__c createShift(Id shiftNameCodeSetId, Id contractId, String iteration, String dayOfWeek, Time startTime, Time endTime, String type, Boolean doInsert) {
        Shift__c s = new Shift__c(
            Shift_Name__c = shiftNameCodeSetId,
            Contract__c = contractId,
            Shift_Iteration__c = iteration,
            Shift_Day_of_the_Week__c = dayOfWeek,
            Shift_Start_Time__c = startTime,
            Shift_End_Time__c = endTime,
            Type__c = type,
            Existing_Shift_Type_Added__c = true
        );
        if (doInsert) {
            insert s;
        }
        return s;
    }

    /**
     * @description Creates PreventiveCareAgreement with Shift and Rate. Reusable for PO and Clinician PCAs.
     * @param forPOContract When true, sets Existing_* and Cloned_From__c (for PO PCAs). When false, sets FacilityTitle__c=null (for Clinician PCAs).
     */
    public PreventiveCareAgreement createPCAWithShift(Id cpaId, Id shiftId, Decimal rate, Boolean forPOContract, Boolean doInsert) {
        PreventiveCareAgreement pca = new PreventiveCareAgreement(
            ContractPaymentAgreementId = cpaId,
            Shift__c = shiftId,
            Rate__c = rate,
            BonusMeasureType = 'Performance',
            TargetMeasurePercent = 10,
            BonusPayout = 12
        );
        if (forPOContract) {
            pca.Existing_Shift_Type_Added__c = true;
            pca.Existing_Rate_Increased__c = false;
            pca.Existing_Rate_Decreased__c = false;
            pca.Cloned_From__c = null;
        } else {
            pca.FacilityTitle__c = null;
        }
        if (doInsert) {
            insert pca;
        }
        return pca;
    }

    /**
     * @description Creates a Client (PO) contract with RecordType and EndDate. Shifts must be added while in Draft.
     */
    public Contract createClientContract(Account serviceAcc, Date startDate, Integer termMonths, Boolean doInsert) {
        Id clientRTId = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get('Client').getRecordTypeId();
        Contract c = new Contract(
            AccountId = serviceAcc.Id,
            StartDate = startDate,
            Status = 'Draft',
            ContractTerm = termMonths,
            RecordTypeId = clientRTId,
            EndDate = startDate.addMonths(termMonths)
        );
        if (doInsert) {
            insert c;
        }
        return c;
    }

    /**
     * @description Creates AccountTeamMember for a given Account and User.
     */
    public AccountTeamMember createAccountTeamMember(Id accountId, Id userId, String teamMemberRole, Boolean doInsert) {
        AccountTeamMember atm = new AccountTeamMember(
            AccountId = accountId,
            UserId = userId,
            TeamMemberRole = teamMemberRole
        );
        if (doInsert) {
            insert atm;
        }
        return atm;
    }

    /**
     * @description Bulk-insert setup for ClinicianContractCloneServiceTest. Reduces DML and trigger executions.
     * Inserts: 3 Accounts, 2 Contracts, 2 CodeSets, HPN/HP/HPF, 2 PNCs, 2 CPAs, 2 Shifts, 3 PCAs, 1 CRC.
     */
    public void createClinicianContractCloneSetupBulk() {
        Id clientRTId = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get('Client').getRecordTypeId();
        Id clinicianRTId = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get('Clinician').getRecordTypeId();
        Id serviceAccRTId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Service_Account').getRecordTypeId();
        Id corpRTId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Corporate_Entity').getRecordTypeId();
        Id clinicianAccRTId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Clinician').getRecordTypeId();

        List<Account> accounts = new List<Account>{
            new Account(Name = 'Test Service Account', RecordTypeId = serviceAccRTId),
            new Account(FirstName = 'Test', LastName = 'Test Clinician', RecordTypeId = clinicianAccRTId)
        };
        try {
            accounts.add(new Account(Name = 'Test Corporate Entity', RecordTypeId = corpRTId));
        } catch (Exception e) { }
        insert accounts;
        Account serviceAcc = accounts[0];
        Account clinicianAcc = accounts[1];
        Id corpId = accounts.size() > 2 ? accounts[2].Id : serviceAcc.Id;

        clinicianAcc = [SELECT Id, PersonContactId FROM Account WHERE Id = :clinicianAcc.Id LIMIT 1];
        Id contactId = clinicianAcc.PersonContactId;

        Date startDate = Date.today();
        List<Contract> contracts = new List<Contract>{
            new Contract(AccountId = serviceAcc.Id, StartDate = startDate, Status = 'Draft', ContractTerm = 12,
                RecordTypeId = clientRTId, EndDate = startDate.addMonths(12)),
            new Contract(AccountId = clinicianAcc.Id, StartDate = startDate, RecordTypeId = clinicianRTId,
                Status = 'Draft', Employment_Type__c = 'Employee')
        };
        insert contracts;
        Contract clientContract = contracts[0];
        Contract clinicianContract = contracts[1];

        List<CodeSet> codeSets = new List<CodeSet>{
            new CodeSet(Name = 'Day Shift', Code = 'DAY', CodeSetType = 'Shift', IsActive = true),
            new CodeSet(Name = 'Test Facility Title', Code = 'TFT', CodeSetType = 'Facility Title', IsActive = true)
        };
        insert codeSets;
        Id shiftCsId = codeSets[0].Id;
        Id facilityTitleCsId = codeSets[1].Id;

        HealthcarePayerNetwork hpn = createHealthcarePayerNetwork('Test Payer Network', serviceAcc.Id, true);
        HealthcareProvider hp = createHealthcareProvider('Physician Provider', contactId, true);
        HealthcarePractitionerFacility hpf = createHealthcarePractitionerFacility('Test HPF', contactId, serviceAcc.Id, corpId, true);

        List<ProviderNetworkContract> pncs = new List<ProviderNetworkContract>{
            new ProviderNetworkContract(ContractId = clinicianContract.Id, StartDate = Date.today(), EndDate = Date.today().addMonths(12),
                HealthcarePayerNetworkId = hpn.Id, HealthcareProviderId = hp.Id, Healthcare_Practitioner_Facility__c = hpf.Id),
            new ProviderNetworkContract(ContractId = clientContract.Id, StartDate = Date.today(), EndDate = Date.today().addMonths(12),
                HealthcarePayerNetworkId = hpn.Id, HealthcareProviderId = hp.Id, Healthcare_Practitioner_Facility__c = hpf.Id)
        };
        insert pncs;

        String ts = String.valueOf(DateTime.now().getTime());
        List<ContractPaymentAgreement> cpas = new List<ContractPaymentAgreement>{
            new ContractPaymentAgreement(ContractId = clinicianContract.Id, Provider_Network_Contract__c = pncs[0].Id, Type__c = 'Shift',
                Name = 'Test CPA-' + ts, AgreementType = 'Preventive Care Agreement', Status = 'Draft', StartDateTime = DateTime.now()),
            new ContractPaymentAgreement(ContractId = clientContract.Id, Provider_Network_Contract__c = pncs[1].Id, Type__c = 'Shift',
                Name = 'Client CPA-' + ts, AgreementType = 'Preventive Care Agreement', Status = 'Draft', StartDateTime = DateTime.now())
        };
        insert cpas;

        Time t9 = Time.newInstance(9, 0, 0, 0);
        Time t17 = Time.newInstance(17, 0, 0, 0);
        List<Shift__c> shifts = new List<Shift__c>{
            new Shift__c(Shift_Name__c = shiftCsId, Contract__c = clientContract.Id, Shift_Iteration__c = '1', Shift_Day_of_the_Week__c = 'Monday',
                Shift_Start_Time__c = t9, Shift_End_Time__c = t17, Type__c = 'NP/PA', Existing_Shift_Type_Added__c = true),
            new Shift__c(Shift_Name__c = shiftCsId, Contract__c = clinicianContract.Id, Shift_Iteration__c = '1', Shift_Day_of_the_Week__c = 'Monday',
                Shift_Start_Time__c = t9, Shift_End_Time__c = t17, Type__c = 'NP/PA', Existing_Shift_Type_Added__c = true)
        };
        insert shifts;

        clientContract.Status = 'Executed';
        clientContract.End_Date__c = clientContract.EndDate;
        clinicianContract.Status = 'Executed';
        clinicianContract.Contracting_Corporate_Entity__c = corpId;
        clinicianContract.Start_Date__c = clinicianContract.StartDate;
        clinicianContract.NPPA_Tier__c = '120';
        update new List<Contract>{ clientContract, clinicianContract };

        List<PreventiveCareAgreement> pcas = new List<PreventiveCareAgreement>{
            new PreventiveCareAgreement(ContractPaymentAgreementId = cpas[0].Id, BonusMeasureType = 'Performance', TargetMeasurePercent = 10, BonusPayout = 12),
            new PreventiveCareAgreement(ContractPaymentAgreementId = cpas[1].Id, Shift__c = shifts[0].Id, FacilityTitle__c = facilityTitleCsId,
                Time_Type__c = 'Full Time', Rate__c = 95.00, Unit_of_Measure__c = 'per Hour', BonusMeasureType = 'Performance', TargetMeasurePercent = 10, BonusPayout = 12),
            new PreventiveCareAgreement(ContractPaymentAgreementId = cpas[0].Id, Shift__c = shifts[1].Id, Rate__c = 100.00, FacilityTitle__c = facilityTitleCsId,
                Time_Type__c = 'Full Time', Unit_of_Measure__c = 'per Hour', BonusMeasureType = 'Performance', TargetMeasurePercent = 10, BonusPayout = 12)
        };
        insert pcas;

        String userSelectedJson = '{"selectedClinicianIds":[{"selectId":"' + contactId + '","isProcessed":false}]}';
        createClinicalRateChangeNew(serviceAcc.Id, clientContract.Id, userSelectedJson, true, true);
    }
}