@isTest
public class ContactSSNActionTest {

    @isTest
    static void testContactSSNAction(){
        Contact con = new Contact(LastName = 'Test1');
        con.SSN_Encrypted__c = '123456789';
        con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Business_Contacts').getRecordTypeId();
        insert con;
        con = [SELECT Id,SSN_Encrypted__c,SSN_Last_4_Digit__c FROM Contact WHERE Id = :con.Id];
        System.assertEquals('6789',con.SSN_Last_4_Digit__c);
        con.SSN_Encrypted__c = '123456790';
        update con;
        con = [SELECT Id,SSN_Encrypted__c,SSN_Last_4_Digit__c FROM Contact WHERE Id = :con.Id];
        System.assertEquals('6790',con.SSN_Last_4_Digit__c);
        con.SSN_Encrypted__c = null;
        update con;
        con = [SELECT Id,SSN_Encrypted__c,SSN_Last_4_Digit__c FROM Contact WHERE Id = :con.Id];
		Assert.isNull(con.SSN_Last_4_Digit__c);
    }
    
    @isTest
    static void testClinicianSSNAction(){
        Account personAcc = new Account(LastName = 'Test2');
        personAcc.SSN_Encrypted__pc = '123456791';
        personAcc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Clinician').getRecordTypeId();
        insert personAcc;
        personAcc = [SELECT Id,PersonContactId,SSN_Encrypted__pc,SSN_Last_4_Digit__pc FROM Account WHERE Id = :personAcc.Id];
        System.assertEquals('6791',personAcc.SSN_Last_4_Digit__pc);
        personAcc.SSN_Encrypted__pc = '123456792';
        update personAcc;
        personAcc = [SELECT Id,PersonContactId,SSN_Encrypted__pc,SSN_Last_4_Digit__pc FROM Account WHERE Id = :personAcc.Id];
        System.assertEquals('6792',personAcc.SSN_Last_4_Digit__pc);
        personAcc.SSN_Encrypted__pc = null;
        update personAcc;
        personAcc = [SELECT Id,PersonContactId,SSN_Encrypted__pc,SSN_Last_4_Digit__pc FROM Account WHERE Id = :personAcc.Id];
		Assert.isNull(personAcc.SSN_Last_4_Digit__pc);
    }    
    
}