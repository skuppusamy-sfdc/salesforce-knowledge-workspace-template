@isTest
public with sharing class SelectContactsControllerTest {

    @TestSetup
    static void setup(){
        List<Contact> contacts = new List<Contact>();
        Account account = new Account(Name='test');
        insert account;
        Opportunity opportunity = new Opportunity(Name='test', StageName='Closed - Won', CloseDate= Date.today(), AccountId=account.Id);

        insert opportunity;
        Contact contact = new Contact(LastName='test', FirstName='test', Email='test@test.com', AccountId=account.Id, Phone = '1234567899');
        contacts.add(contact);
        Contact contact1 = new Contact(LastName='testCont', FirstName='testCont', Email='testCont@test.com', AccountId=account.Id, Phone = '1234567888');
        contacts.add(contact1);
        insert contacts;
        OpportunityContactRole ocr = new OpportunityContactRole(OpportunityId=opportunity.Id, ContactId= contact1.Id );
        insert ocr;


    }
    @isTest
    static void testgetAccountContacs() {
        Opportunity opp = [SELECT Id FROM Opportunity Limit 1];
        List<Contact> c1 = SelectContactsController.getAccountContacs(opp.Id, '');
        List<Contact> c2 = SelectContactsController.getAccountContacs(opp.Id, 'test');
        System.assert(c1.size()>0);
        System.assert(c2.size()>0);

    }
    @isTest
    static void testgetOppotrunityContacts() {
        Opportunity opp = [SELECT Id FROM Opportunity Limit 1];
        List<Contact> c1 = SelectContactsController.getOppotrunityContacts(opp.Id, '');
        List<Contact> c2 = SelectContactsController.getOppotrunityContacts(opp.Id, 'test');
        System.assert(c1.size()>0);
        System.assert(c2.size()>0);

    }
}