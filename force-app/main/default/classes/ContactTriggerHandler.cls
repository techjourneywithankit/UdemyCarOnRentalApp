public with sharing class ContactTriggerHandler extends TriggerHandler{
    override public void afterInsert(){
        List<Contact> contacts = (List<Contact>)Trigger.new;
        ContactTriggerHandlerService.processContact(contacts);
    }

    override public void afterUpdate(){
        List<Contact> contacts = (List<Contact>)Trigger.new;
        Map<Id,Contact> oldContactMap = (Map<Id,Contact>)Trigger.oldMap;
        
        List<Contact> contactsToProcess = new List<Contact>();
        for(Contact con : contacts){
            //change in email
            String newEmail = con.Email;
            Contact oldContact = oldContactMap.get(con.Id);
            String oldEmail = oldContact.Email;
            if(newEmail != oldEmail){
                contactsToProcess.add(con);
            }
        }
        if(contactsToProcess.size() > 0){
            ContactTriggerHandlerService.processContact(contactsToProcess);
        }
    }
}