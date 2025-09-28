public with sharing class ContactTriggerHandlerService {
   
    public static void processContact(List<Contact> contacts){
        Set<Id> contactIds = new Set<Id>();
        for(Contact con : contacts){
            contactIds.add(con.Id);
        }

        System.enqueueJob(new queueableEmailValidation(contactIds));
    }
}