public with sharing class PaymentTransactionTriggerHandler extends TriggerHandler{
    
    override public void afterInsert(){
        PaymentTransactionTriggerHandlerService.handlePaymentTransactions(Trigger.New);
    }

    override public void afterDelete(){
        PaymentTransactionTriggerHandlerService.handlePaymentTransactions(Trigger.Old);
    }
}