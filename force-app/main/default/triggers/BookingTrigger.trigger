trigger BookingTrigger on Booking__c (before insert, before update, after update) {
    new MetadataTriggerHandler().run();
}