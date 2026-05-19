@isTest
public class TestDataFactoryCore {
    
    // Creates a Person or Business Account with a given RecordType DeveloperName.
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
            // Person Account requires LastName
            acc = new Account(
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
    
    // Create Contact for Person Account
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

    // Creates a Contract under a given Account.
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
    
    // Creates a test User with System Administrator profile (or any profile)
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
    
    // Creates a Provider Network Contract under a given Contract.   
    public ProviderNetworkContract createPNC(Id contractId, Id HP, Id HPN, Id HPF, Boolean doInsert) {
        ProviderNetworkContract pnc = new ProviderNetworkContract(
            ContractId = contractId,
            StartDate = Date.today(),
            EndDate = Date.today().addMonths(12),
            HealthcarePayerNetworkId = HPN, 
            HealthcareProviderId = HP,
            Healthcare_Practitioner_Facility__c = HPF
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
    public ContractPaymentAgreement createCPA(String baseName, Id contractId, Id pncId, Boolean doInsert) {
        // Query contract and account for building unique name
        Contract c = [SELECT Id, ContractNumber, AccountId FROM Contract WHERE Id = :contractId LIMIT 1];
        Account acc = [SELECT Id, Name, Global_Provider_ID__pc FROM Account WHERE Id = :c.AccountId LIMIT 1];
        
        // Create CPA record
        ContractPaymentAgreement cpa = new ContractPaymentAgreement(
            ContractId = contractId,
            Provider_Network_Contract__c = pncId,
            Type__c = 'Shift',
            Name = buildCPAUniqueName(baseName, c, acc),
            AgreementType = 'Preventive Care Agreement',
            Status = 'Draft',
            StartDateTime = DateTime.now()
        );
        
        if (doInsert) insert cpa;
        return cpa;
    }
    
    // Helper method to build unique CPA Name
    private String buildCPAUniqueName(String baseName, Contract newContract, Account acc) {
        String globalOrAccount = acc != null && acc.Global_Provider_ID__pc != null
            ? String.valueOf(acc.Global_Provider_ID__pc)
            : (acc != null ? acc.Name : 'NA');
                
                return (newContract.ContractNumber != null ? newContract.ContractNumber : 'NA')
                + '-' + globalOrAccount
                + '-' + (baseName != null ? baseName : 'NA')
                + '-' + DateTime.now().getTime(); // ensure uniqueness
    }

    // Creates a Preventive Care Agreement under a given CPA. 
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

    // Creates a Clinical Rate Change record.     
   
    
    // Creates a HealthcarePayerNetwork record
    public HealthcarePayerNetwork createHealthcarePayerNetwork(String Name, Id corporateEntityId, Boolean doInsert){
        HealthcarePayerNetwork healthcarePayerNetwork = new HealthcarePayerNetwork(
            Name = Name,
            PayerId = corporateEntityId
        );
        if(doInsert) {
            insert healthcarePayerNetwork;  
        }
        return healthcarePayerNetwork;
    }
    
    // Creates HealthcareProvider record
    public HealthcareProvider createHealthcareProvider(String Name, Id physicianContactId, Boolean doInsert){
        HealthcareProvider physicianProvider = new HealthcareProvider(
            Name = Name,
            PractitionerId = physicianContactId
        );
        if(doInsert) {
            insert physicianProvider;  
        }
        return physicianProvider;
    }
    
    // Creates HealthcarePractitionerFacility record
    public HealthcarePractitionerFacility createHealthcarePractitionerFacility(String Name, Id npaContactId, Id serviceAccountId, Id corporateEntityId, Boolean doInsert){
        HealthcarePractitionerFacility npaHPF = new HealthcarePractitionerFacility(
            Name = Name,
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
    
    // Creates a Person Account with a given Professional Title.
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
    
    // Creates a Contact under a given Account.
    public static Contact createContact(Account acc) {
        Contact con = new Contact(
            LastName = 'Test Contact',
            AccountId = acc.Id
        );
        insert con;
        return con;
    }
    
    // Creates a Contract under a given Account.
    public static Contract createContract(Account acc, Date startDate) {
        Contract c = new Contract(
            AccountId = acc.Id,
            Status = 'Draft',
            StartDate = startDate
        );
        insert c;
        return c;
    }
    
    // Creates a Contact with additional fields under a given Account.
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
    
    // Creates a Contract with additional fields under a given Account.
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

    // Creates a Contract with ContractNumber and Service_Line__c for ContractDetails testing
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
     * Creates a CodeSet record. Reusable for Shift, Facility Title, etc.
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
     * Creates a Shift__c record. For multiple shifts: build a List with doInsert=false, then insert once.
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
     * Creates a Client contract with RecordType and EndDate.
     * @param previousContractId Optional; when set, links to previous contract.
     */
    public Contract createClientContract(Account serviceAcc, Date startDate, Integer termMonths, Id previousContractId, Boolean doInsert) {
        Id clientRTId = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get('Client').getRecordTypeId();
        Contract c = new Contract(
            AccountId = serviceAcc.Id,
            RecordTypeId = clientRTId,
            StartDate = startDate,
            EndDate = startDate.addMonths(termMonths),
            Status = 'Draft'
        );
        if (previousContractId != null) {
            c.PreviousContractId = previousContractId;
        }
        if (doInsert) {
            insert c;
        }
        return c;
    }

    /**
     * Creates a Rate_Pay_Code__c record.
     * @param preventiveCareAgreementId Required - links to PreventiveCareAgreement
     * @param payCodeId Optional - links to Pay_Codes__c
     * @param isNewlyAdded Optional - defaults to true
     * @param isDeleted Optional - defaults to false
     */
    public Rate_Pay_Code__c createRatePayCode(Id preventiveCareAgreementId, Id payCodeId, Boolean isNewlyAdded, Boolean isDeleted, Boolean doInsert) {
        Rate_Pay_Code__c rpc = new Rate_Pay_Code__c(
            Preventive_Care_Agreement__c = preventiveCareAgreementId
        );
        if (payCodeId != null) {
            rpc.Pay_Code__c = payCodeId;
        }
        if (isNewlyAdded != null) {
            rpc.Is_Newly_Added__c = isNewlyAdded;
        } else {
            rpc.Is_Newly_Added__c = true;
        }
        if (isDeleted != null) {
            rpc.Is_Deleted__c = isDeleted;
        }
        if (doInsert) {
            insert rpc;
        }
        return rpc;
    }

    /**
     * Creates a Practice_Operation_Change__c record.
     */
    public Practice_Operation_Change__c createPracticeOperationChange(Id facilityTitleId, Id contractId, Boolean doInsert) {
        Practice_Operation_Change__c poc = new Practice_Operation_Change__c(
            Facility_Title__c = facilityTitleId,
            Contract__c = contractId
        );
        if (doInsert) {
            insert poc;
        }
        return poc;
    }

    /**
     * Creates a Client_Change_Management__c record.
     * @param practiceOperationChangeId Optional - when null, CCM is created without POC link (e.g. for ClinicianContractSyncQueueable)
     * @param healthcarePractitionerFacilityId Optional - when null, CCM is created without HPF link
     */
    public Client_Change_Management__c createClientChangeManagement(Id contractId, Id practiceOperationChangeId, Id healthcarePractitionerFacilityId, String processType, String status, Boolean doInsert) {
        Client_Change_Management__c ccm = new Client_Change_Management__c(
            Contract__c = contractId,
            Process_Type__c = processType != null ? processType : 'Automation',
            Status__c = status != null ? status : 'New'
        );
        if (practiceOperationChangeId != null) {
            ccm.Practice_Operation_Change__c = practiceOperationChangeId;
        }
        if (healthcarePractitionerFacilityId != null) {
            ccm.Healthcare_Practitioner_Facility__c = healthcarePractitionerFacilityId;
        }
        if (doInsert) {
            insert ccm;
        }
        return ccm;
    }

}