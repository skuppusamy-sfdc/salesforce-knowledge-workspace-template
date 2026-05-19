global without sharing class SystemTreeExtension {

ApexPages.StandardController stdCtrl {get; set;}
    public static Id lookup {get; set;}
    
    public static Map<Id, Account> systems {get; set;}
    public static Map<Id, Map<Id,Account>> subsystem {get; set;}
    public static Map<Id, Map<Id, Account>> subsubsystem {get; set;}
    public static Map<Id, Map<Id, Account>> facility {get; set;} 
    public static Map<Id, String> link {get; set;}
    public static String msg {get; set;} 
    public static Map<Id, Account> noType {get; set;}
    public final Map<String, String> types = new Map<String, String>{'System'=>'system','Sub-system'=>'subsystem','Sub-sub-system'=>'subsubsystem','Facility'=>'facility'};

    public SystemTreeExtension(ApexPages.StandardController controller) {
        
        stdCtrl = controller;
        lookUp();
        msg = 'Already in Lead Discovery List';
        
    }
    
    
    public void lookUp() 
    {
    
        
        systems = new Map<Id,Account>();
        subsystem = new Map<Id, Map<Id,Account>>();
        subsubsystem = new Map<Id, Map<Id,Account>>();
        facility = new Map<Id, Map<Id,Account>>();
        Set<Id> subSystemId = new Set<Id>();
        Set<Id> subsubSystemId = new Set<Id>();
        Set<Id> facilityId = new Set<Id>();
        Set<Id> freeEDId = new Set<Id>();
        String flag;
        noType = new Map<Id, Account>();
        
        link = new Map<Id, String>();
        Id accId;
        List<Lead> leadDiscovery = new List<Lead>();
        
        List<Account> accountId;
        List<Lead> accountIdOnLead;
        List<Opportunity> accountIdOnOpp;
           
        accountIdOnLead = [Select Account__c From Lead Where Id =: stdCtrl.getId()];
        accountId = [Select ParentId From Account Where Id =: stdCtrl.getId()];
        accountIdOnOpp = [Select AccountId From Opportunity Where Id =: stdCtrl.getId()];
        
        // if the extension is being called from Lead
        if (!accountIdOnLead.isEmpty()) {
            accId = accountIdOnLead[0].Account__c;
            leadDiscovery = [Select Account_LD__c, Lead_LD__c From Lead Where Lead_LD__c =: stdCtrl.getId() And RecordType.Name = 'Sales Lead' and isConverted = false];
        }
        
        // if the extension is being called from Account
        if (!accountId.isEmpty()) {
            accId = accountId[0].Id;
        }
        
        // if the extension is being called from Opportunity
        if (!accountIdOnOpp.isEmpty()) {
            accId = accountIdOnOpp[0].AccountId;
        }
        
        // check if the lead has a related account
        if (accId == null) return;
                
        Account record = [Select Account_Type__c, ParentId, Name From Account Where Id =: accId];
        
        // If the account record does not have Account Type and ParentId, still show the record on the table.        
        if (record.Account_Type__c != 'System' && (record.Account_Type__c == null  || record.ParentId == null)) {
           link.put(record.Id, record.Id);
           noType.put(record.Id, record);
        }

        if (record.Account_Type__c == 'System') {
            
            flag = record.Account_Type__c;
            lookUp = record.Id;
            for (List<Account> a : [Select Id From Account Where ParentId =: lookUp And Account_Type__c = 'Sub-system']) {
                
                for (integer i=0; i<a.size(); i++) {
                  subSystemId.add(a[i].Id);
                }
                      
            }
            
            for (List<Account> a : [Select Id From Account Where ParentId In: subSystemId And Account_Type__c = 'Sub-sub-system']) {
                
                for (integer i=0; i<a.size(); i++) {
                    subsubSystemId.add(a[i].Id);
                }
            
            }
    
            for (List<Account> a : [Select Id From Account Where (ParentId In: subSystemId Or ParentId In: subsubsystemId Or ParentId =: lookup) And ( Account_Type__c = 'Facility' Or  Account_Type__c Not In ('System','Sub-system','Sub-sub-system','Facility') )]) {
                
                for (integer i=0; i<a.size(); i++) {
                    facilityId.add(a[i].Id);
                }
            }
            
            
        } 
        
        if (record.Account_Type__c == 'Sub-system' && record.ParentId != null) {
            flag = record.Account_Type__c;
            lookUp = record.ParentId;
            subSystemId.add(record.Id);
            
            for (List<Account> a : [Select Id From Account Where ParentId In: subSystemId And Account_Type__c = 'Sub-sub-system']) {
                
                for (integer i=0; i<a.size(); i++) {
                    subsubSystemId.add(a[i].Id);
                }
            
            }
            
            for (List<Account> a : [Select Id From Account Where (ParentId In: subSystemId Or ParentId In: subsubsystemId) And ( Account_Type__c = 'Facility' Or Account_Type__c Not In ('System','Sub-System','Sub-sub-system','Facility'))]) {
                
                for (integer i=0; i<a.size(); i++) {
                    facilityId.add(a[i].Id);
                }
            }
            
        }
        
        if (record.Account_Type__c == 'Sub-sub-system' && record.ParentId != null) {
            flag = record.Account_Type__c;
            lookUp = [Select ParentId From Account Where Id =: record.ParentId].ParentId;
            subSystemId.add(record.ParentId);
            subsubSystemId.add(record.Id);
            
            for (List<Account> a : [Select Id From Account Where  ParentId In: subsubsystemId And (Account_Type__c = 'Facility' Or Account_Type__c Not In ('System','Sub-System','Sub-sub-system','Facility'))]) {
                
                for (integer i=0; i<a.size(); i++) {    
                    facilityId.add(a[i].Id);
                }
            }
            
        }
        
        Boolean contains = types.containsKey(record.Account_Type__c);

        
        if ((record.Account_Type__c == 'Facility' || contains == false) && record.ParentId != null) {
            flag = 'Facility';
            Account accType = [Select Account_Type__c, ParentId, Parent.ParentId From Account Where Id =: record.ParentId]; 
            
            if (accType.Account_Type__c == 'System'){
                lookUp = accType.Id;
            }else if (accType.Account_Type__c == 'Sub-system') {
                lookUp = accType.ParentId;
                subSystemId.add(accType.Id);
            } else if (accType.Account_Type__c == 'Sub-sub-system') {
                lookUp = accType.Parent.ParentId;
                subSystemId.add(accType.ParentId);
                subsubSystemId.add(accType.Id);
            }
            facilityId.add(record.Id);
            
        }
        
        
        for (Account a : [Select Id, Name ,Account_Type__c From 
                          Account Where Id =: lookUp]) {
                 systems.put(a.Id,a);   
                 // Fill in the links to create a Lead Discovery. 
                 // Logic dependes of what the user has looked for.
                 if (flag == 'System') {
                   link.put(a.Id, a.Id); 
                 } else if (flag == 'Sub-system' || flag == 'Sub-sub-system' || flag == 'Facility' ) {
                   link.put(a.Id, 'hide');
                 }    
                 
                 subsystem.put(a.Id, new Map<Id, Account>{});
                 facility.put(a.Id, new Map<Id, Account>{});     
        }
        
        Map<Id, Account> subMap = new Map<Id, Account>();
        for (Account a : [Select Id, Name ,Account_Type__c, ParentId From 
                            Account Where ParentId In: systems.keySet()]) {
               
                if (a.ParentId == systems.get(a.ParentId).Id && subSystemId.contains(a.Id)) 
                {
                    if (subsystem.containsKey(a.ParentId)) {
                        subsystem.get(a.ParentId).put(a.Id, a);
                    } else {
                        subsystem.put(a.ParentId, new Map<Id, Account>{a.Id=>a});
                    }  
                }
                                
                subMap.put(a.Id, a);  
                subsubsystem.put(a.Id, new Map<Id, Account>{});  
                facility.put(a.Id, new Map<Id, Account>{});
                
                // Fill in the links to create a Lead Discovery. 
                // Logic dependes of what the user has looked for.
                if (flag == 'System' || flag == 'Sub-system' ) {
                  link.put(a.Id, a.Id);
                } else if (flag == 'Sub-sub-system' || flag == 'Facility') {
                  link.put(a.Id, 'hide');
                }
        }
        
        Map<Id, Account> subsubMap = new Map<Id, Account>();
        for (Account a : [Select Id, Name ,Account_Type__c, ParentId From 
                            Account Where ParentId In: subMap.keySet()]) {
               
                if (a.ParentId == subMap.get(a.ParentId).Id && subsubSystemId.contains(a.Id)) 
                {
                    if (subsubsystem.containsKey(a.ParentId)) {
                        subsubsystem.get(a.ParentId).put(a.Id, a);
                    } else {
                        subsubsystem.put(a.ParentId, new Map<Id, Account>{a.Id=>a});
                    }  
                }
                                
                subsubMap.put(a.Id, a);    
                facility.put(a.Id, new Map<Id, Account>{});

                // Fill in the links to create a Lead Discovery. 
                // Logic dependes of what the user has looked for.
                if (flag == 'System' || flag == 'Sub-system' || flag == 'Sub-sub-system') { 
                  link.put(a.Id, a.Id);
                } else if (flag == 'Facility') {
                  link.put(a.Id, 'hide');
                }
        }

        for (Account a : [Select Id, Name, Account_Type__c, ParentId, Parent.ParentId, Parent.Parent.ParentId From
                         Account Where (ParentId In: subMap.keySet() Or ParentId In: subsubMap.keySet() Or ParentId In: systems.keySet()) And (Account_Type__c = 'Facility' Or (Account_Type__c Not In ('System','Sub-system','Sub-sub-system','Facility') And Account_Type__c != null) )]) {
               
               Account sys = systems.get(a.ParentId); 
               Account sub = subMap.get(a.ParentId);
               Account subsub = subsubMap.get(a.ParentId);
                if ( ((sub != null && a.ParentId == subMap.get(a.ParentId).Id) ||
                      (subsub != null && a.ParentId == subsubMap.get(a.ParentId).Id) ||
                      (sys != null && a.ParentId == systems.get(a.ParentId).Id) 
                      ) 
                    && facilityId.contains(a.Id)) 
                {
                     if (facility.containsKey(a.ParentId)) {
                         facility.get(a.ParentId).put(a.Id, a);
                     } else {
                         facility.put(a.ParentId, new Map<Id, Account>{a.Id=>a});
                     } 
                     
                }
                
                     // Fill in the links to create a Lead Discovery. 
                    // Logic dependes of what the user has looked for.
                    if (flag == 'System' || flag == 'Sub-system' || flag == 'Sub-sub-system' || flag == 'Facility' ) { 
                        link.put(a.Id, a.Id); 
                    }     
        }
        
        
        
        /*for (Integer i=0; i<leadDiscovery.size(); i++) {
            
            Id leadDId = leadDiscovery[i].Account_LD__c;
            // Remove records from the list that are currently in Lead Discovery
            
            if (link.containsKey(leadDId)) link.put(leadDId,'inLD');    
        
        } */        
            
    }
    
    
    // Create a Lead Discovery Record
    webService static String createLeadDiscoveryRecord(Id leadId, Id accId) {
            
            
            String result;
            
            try {
                // Get Lead Discovery RecordType
                Id rtLD = [Select Id From RecordType Where SObjectType = 'Lead' And Name = 'Sales Lead'].Id;
                // Get Account name
                String accName = [Select Name From Account Where Id =: accId].Name;
                Lead leadName = [Select FirstName, City, Street, PostalCode, Country, State, Email, Title, MiddleName, Phone, LastName, LeadSource, Who_at_SG_was_contacted_directly__c, Other_Lead_Source_Contact__c, Lead_Source_Detail__c, Status, NumberOfEmployees From Lead Where Id =: leadId];
                
            
                Lead record = new Lead(
                        Lead_LD__c = leadId,
                        Account_LD__c = accId,
                        Company = accName,
                        RecordTypeId = rtLD,
                        FirstName = leadName.FirstName,
                        MiddleName = leadName.MiddleName,
                        LastName = leadName.LastName,
                        LeadSource=leadName.LeadSource,
                        Who_at_SG_was_contacted_directly__c = leadName.Who_at_SG_was_contacted_directly__c,
                        Other_Lead_Source_Contact__c = leadName.Other_Lead_Source_Contact__c,
                        Lead_Source_Detail__c = leadName.Lead_Source_Detail__c,
                        NumberOfEmployees = leadName.NumberOfEmployees, 
                        City = leadName.City,
                        PostalCode = leadName.PostalCode,
                        Country = leadName.Country,
                        State = leadName.State,
                        Title = leadName.Title,
                        Email = leadName.Email,
                        Phone = leadName.Phone,
                        Street = leadName.Street   
                );
       
                insert record;
                if (leadName.Status != 'Active') {
                    Lead lead = new Lead (Id=leadId, Status='Active');
                    update lead;
                }
                
                result = 'Done';
            } catch (DmlException e) {
              result = e.getMessage();
              return result;
            }
            
            return result;
    }
    

}