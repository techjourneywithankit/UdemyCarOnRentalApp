@isTest
public with sharing class ContactTriggerHandlerServiceTest {
    
    @testSetup
    static void makeData(){
        List<Contact> conList =  TestDataFactory.createContacts(2);
    }

    @isTest
    static void testContactForInsertOrUpdate(){
        Test.setMock(HttpCalloutMock.class, new EmailValidatoinHtppMock());
        List<Contact> conList = [select id,Email,Email_Verified__c from contact];
        for(Contact con : conList){
            con.Email = 'test@test.com';
        }
        Test.startTest();
         update conList;
        Test.stopTest();
        List<Contact> updatedContacts = [select id,Email,Email_Verified__c from contact];
        for(Contact con : updatedContacts){
            System.Assert.areEqual(true,con.Email_Verified__c,'Email Verifification is failed');
        }
    }
}