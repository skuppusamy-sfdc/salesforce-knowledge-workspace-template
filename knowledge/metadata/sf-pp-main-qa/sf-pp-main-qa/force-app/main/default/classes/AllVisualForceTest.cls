@isTest
private class AllVisualForceTest
{

    @isTest
    static void systemRelationshipHierarchy() {

    	Test.startTest();

		Map<String, RecordType> rtLead = new Map<String, RecordType>();
		
		for (RecordType rt: [Select Name, DeveloperName From RecordType Where SObjectType = 'Lead']) {
			rtLead.put(rt.DeveloperName, rt);
		}

		RecordType rtOpp = [Select Name, DeveloperName From RecordType Where SObjectType = 'Opportunity' And DeveloperName = 'Sales_Opportunity'];

		Account systemAcc = new Account (
			Name = 'System',
			Account_Type__c = 'System'
		);
		insert systemAcc;

		Account subSystemAcc = new Account (
			Name = 'Sub-system',
			Account_Type__c = 'Sub-system',
			ParentId = systemAcc.Id
		);
		insert subSystemAcc;

		Account subsubSystemAcc = new Account (
			Name = 'Sub-sub-system',
			Account_Type__c = 'Sub-sub-system',
			ParentId = subSystemAcc.Id
		);
		insert subsubSystemAcc;

		Account facility = new Account (
			Name = 'Facility',
			Account_Type__c = 'Facility',
			ParentId = subSystemAcc.Id
		);
		insert facility;

		Account noType = new Account (
			Name = 'Facility 1',
			Account_Type__c = 'Facility'
		);
		insert noType;


		Opportunity opp = new Opportunity (
  			Name = 'Opp-Test',
  			AccountId = systemAcc.Id,
  			CloseDate = Date.today(),
  			StageName = 'Marketing Qualified Lead'	
		);
		insert opp;

		Lead salesLead = new Lead(
			FirstName = 'test-lead',
			LastName = 'test-lead',
			Company = 'comapany',
			Status = 'New',
			Account__c = systemAcc.Id,
			RecordTypeId = rtLead.get('Sales_Lead').Id,
			LeadSource = 'Advertisement',
			Service_s__c = 'HM'
		);
		insert salesLead;

		/*Lead leadDiscovery = new Lead (
			FirstName = 'test-lead',
			LastName = 'test-lead',
			Company = 'Sub-system',
			Lead_LD__c = salesLead.Id,
			Account_LD__c = subSystemAcc.Id,
			RecordTypeId = rtLead.get('Lead_Discovery').Id
		);
		insert leadDiscovery;*/

		PageReference pageRef = new PageReference('/apex/SystemTree');
		Test.setCurrentPage(pageRef);

		ApexPages.StandardController stdCtrl = new ApexPages.StandardController(salesLead);
		SystemTreeExtension extension = new SystemTreeExtension(stdCtrl);

		// Create Lead Discovery Record using UI Create Button.
		SystemTreeExtension.createLeadDiscoveryRecord(salesLead.Id, systemAcc.Id);

		/*Lead leadDiscovery = [Select FirstName, LastName, Lead_LD__c, Account_LD__c, Company, LeadSource 
							From Lead Where RecordTypeId =: rtLead.get('Lead_Discovery').Id 
							And Account_LD__c =: systemAcc.Id];

		System.assertNotEquals(null, leadDiscovery);
		System.assertEquals(salesLead.FirstName, leadDiscovery.FirstName);
		System.assertEquals(salesLead.Id, leadDiscovery.Lead_LD__c);
		System.assertEquals(systemAcc.Id, leadDiscovery.Account_LD__c);
		System.assertEquals(systemAcc.Name, leadDiscovery.Company);
		System.assertEquals(salesLead.LeadSource, leadDiscovery.LeadSource);*/
		

		Lead updatedLead = [Select Status From Lead Where Id=: salesLead.Id];
		System.assertEquals('Active', updatedLead.Status);

		salesLead.Account__c = subSystemAcc.Id;
		update salesLead;

		stdCtrl = new ApexPages.StandardController(salesLead);
		extension = new SystemTreeExtension(stdCtrl);

		salesLead.Account__c = subsubSystemAcc.Id;
		update salesLead;

		stdCtrl = new ApexPages.StandardController(salesLead);
		extension = new SystemTreeExtension(stdCtrl);


		salesLead.Account__c = facility.Id;
		update salesLead;

		stdCtrl = new ApexPages.StandardController(salesLead);
		extension = new SystemTreeExtension(stdCtrl);


		salesLead.Account__c = noType.Id;
		update salesLead;

		stdCtrl = new ApexPages.StandardController(salesLead);
		extension = new SystemTreeExtension(stdCtrl);


		facility.ParentId = subsubSystemAcc.Id;
		update facility; 

		salesLead.Account__c = facility.Id;
		update facility;

		stdCtrl = new ApexPages.StandardController(salesLead);
		extension = new SystemTreeExtension(stdCtrl);

		stdCtrl = new ApexPages.StandardController(subsubSystemAcc);
		extension = new SystemTreeExtension(stdCtrl);
		
		/*clsLeadScoreCard cls = new clsLeadScoreCard();
		CreateCompetitorExtension CCE = new CreateCompetitorExtension(stdctrl);
		CompetitorsExtension CE = new CompetitorsExtension(stdctrl);*/
    	Test.stopTest();

    }

    /*@isTest 
    static void targetScoreCard() 
    {

    	Test.startTest();

		Map<String, RecordType> rtLead = new Map<String, RecordType>();
		
		for (RecordType rt: [Select Name, DeveloperName From RecordType Where SObjectType = 'Lead']) {
			rtLead.put(rt.DeveloperName, rt);
		}

		Account facility = new Account (
			Name = 'Facility',
			Account_Type__c = 'Facility'
		);
		insert facility;

		Lead salesLead = new Lead(
			FirstName = 'test-lead',
			LastName = 'test-lead',
			Company = 'comapany',
			Status = 'New',
			Account__c = facility.Id,
			RecordTypeId = rtLead.get('Sales_Lead').Id,
			LeadSource = 'Advertisement'
		);
		insert salesLead;

		Lead leadDiscovery = new Lead (
			FirstName = 'test-lead',
			LastName = 'test-lead',
			Company = 'Sub-system',
			Lead_LD__c = salesLead.Id,
			Account_LD__c = facility.Id,
			RecordTypeId = rtLead.get('Lead_Discovery').Id
		);
		insert leadDiscovery;


		ScoreCardMatrix__c criteria1 = new ScoreCardMatrix__c (
			Criteria_Fields__c='ED Volume',
			Order__c=1, 
			WEIGHTED_CONSTANTS_C__c=3.0

		);
		insert criteria1;

		ScoreCardMatrix__c criteria2 = new ScoreCardMatrix__c (
			Criteria_Fields__c='Staffed Beds',
			Order__c=2, 
			WEIGHTED_CONSTANTS_C__c=0.5

		);
		insert criteria2;

		LeadScoreCardbyAccount__c leadSCValue1 = new LeadScoreCardbyAccount__c(
			 AccountLeadScoreCard__c=facility.Id,
			 Score__c = 2.0, 
			 ScoreCardMatrix__c = criteria1.Id
		);
		insert leadSCValue1;


		LeadScoreCardbyAccount__c leadSCValue2 = new LeadScoreCardbyAccount__c(
			 AccountLeadScoreCard__c=facility.Id,
			 Score__c = 3.0, 
			 ScoreCardMatrix__c = criteria2.Id
		);
		insert leadSCValue2;

		//PageReference pageRef = new PageReference('/apex/LeadScorecard');
		//Test.setCurrentPage(pageRef);

		//ApexPages.StandardController stdCtrl = new ApexPages.StandardController(leadDiscovery);
		//clsLeadScoreCard extension = new clsLeadScoreCard(stdCtrl);


		//List<ScoreCardMatrix__c> matrix = extension.getlstSCbyAcc();
		//Double weightScore = extension.getWeightedScore();
		//Double totalScore = extension.getTotalScore();
		//extension.save();

		//System.assertEquals('ED Volume', matrix[0].Criteria_Fields__c);
		//System.assertEquals(leadSCValue1.Score__c, matrix[0].LeadScoreCardbyAccounts__r[0].Score__c);
		//System.assertEquals(7.5, weightScore);
		//System.assertEquals(5.0, totalScore);


		//pageRef = new PageReference('/apex/vfp_SG_LeadScoreCard');
		//Test.setCurrentPage(pageRef);

		//stdCtrl = new ApexPages.StandardController(facility);
		//extension = new clsLeadScoreCard(stdCtrl);


		//matrix = extension.getlstSCbyAcc();
		//weightScore = extension.getWeightedScore();
		//totalScore = extension.getTotalScore();
		//extension.save();

		//System.assertEquals('ED Volume', matrix[0].Criteria_Fields__c);
		//System.assertEquals(leadSCValue1.Score__c, matrix[0].LeadScoreCardbyAccounts__r[0].Score__c);
		//System.assertEquals(7.5, weightScore);
		//System.assertEquals(5.0, totalScore);


		
		Test.stopTest();

    }

    @isTest
    static void competitorsLink() 
    {
    	Test.startTest();

    		//PageReference pageRef = new PageReference('/apex/CompetitorsLink');
    		//Test.setCurrentPage(pageRef);

			Map<String, RecordType> rtLead = new Map<String, RecordType>();
		
			for (RecordType rt: [Select Name, DeveloperName From RecordType Where SObjectType = 'Lead']) {
				rtLead.put(rt.DeveloperName, rt);
			}

			Lead leadDiscovery = new Lead (
				FirstName = 'test-lead',
				LastName = 'test-lead',
				Company = 'Sub-system',
				RecordTypeId = rtLead.get('Lead_Discovery').Id
			);
			insert leadDiscovery;

    		//ApexPages.StandardController stdCtrl = new ApexPages.StandardController(leadDiscovery);
    		//CompetitorsExtension link = new CompetitorsExtension(stdCtrl);
    		//String url = link.getUrl();

    		//Boolean contains = url.contains('/apex/CreateCompetitor');
    		//System.assertEquals(true, contains);

    	Test.stopTest();
    }

    @isTest
    static void createCompetitor() 
    {

    	Test.startTest();

    		Account accComp = new Account(
    			Name = 'Account-Competitor-FromVFP'
    		);


    		PageReference pageRef = new PageReference('/apex/CreateCompetitor');
    		//Test.setCurrentPage(pageRef);

    		//ApexPages.StandardController stdCtrl = new ApexPages.StandardController(accComp);
    		//CreateCompetitorExtension competitor = new CreateCompetitorExtension(stdCtrl);

    		//CreateCompetitorExtension.acc = accComp;

    		//competitor.customSave();

    		accComp = [Select Name, RecordType.Name From Account Where Name =: accComp.Name];

    		System.assertEquals('Account-Competitor-FromVFP',accComp.Name);
    		System.assertEquals('Competitors', accComp.RecordType.Name);

    		//Account account = competitor.getAcc();

    	Test.stopTest();
    }*/



}