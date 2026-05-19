/**
 * Created by srinivasseri on 2/8/16.
 */

public with sharing class OpportunityTestDataHelper {

    public static Opportunity getOpportunity()   {
        Account acc1 = new Account(Name='Opportunity Account');
        insert acc1;

        Opportunity opportunity = new Opportunity (
                Name = 'Opp-Test',
                CloseDate = Date.today(),
                StageName = 'Marketing Qualified Lead',
                Created_from_Lead__c = true,
                //Service_s__c  = 'HM;WW',
                AccountId = acc1.Id,
                RecordTypeId = getRecordTypeId()
        );
        insert opportunity;
        System.debug('Opportunity: ' + opportunity);
        return opportunity;
    }

    public static Id getRecordTypeId()    {
        RecordType rtOpp = [Select Name, DeveloperName From RecordType
        Where SObjectType = 'Opportunity' and Name = 'HM Sales Opportunity'];
        return rtOpp.Id;
    }


}