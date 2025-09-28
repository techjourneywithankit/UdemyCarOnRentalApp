trigger PaymentTransactionTrigger on Payment_Transaction__c (after insert,after delete) {
    new MetadataTriggerHandler().run();
}