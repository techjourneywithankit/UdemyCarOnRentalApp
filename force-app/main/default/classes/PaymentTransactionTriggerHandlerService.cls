public with sharing class PaymentTransactionTriggerHandlerService {
    
    public static void handlePaymentTransactions(List<Payment_Transaction__c> paymentTransactions){

        //get all the affected booking id
        Set<Id> bookingIds = new Set<Id>();
        for(Payment_Transaction__c paymentTransaction : paymentTransactions){
            bookingIds.add(paymentTransaction.Booking__c);
        }

        //Parent --> child relationship query
        //bookingId to list of related Payment_Transaction__c
       Set<String> paymentType = new Set<String>();
       paymentType.add(Constants.TYPE_INITIAL_PAYMENT);
       paymentType.add(Constants.TYPE_SECURITY_DEPOSIT);
        paymentType.add(Constants.TYPE_PARTIAL_PAYMENT);

        List<Booking__c> updateBookingRecords = new List<Booking__c>();

       List<Booking__c> bookingList = [SELECT Id,Status__c,Payment_Status__c,Final_Booking_Price__c,Security_Deposit__c,
       (select id,Amount__c,Type__c,Status__c from Payment_Transactions__r where status__c = :Constants.SUCCESS and type__c in :paymentType) 
       FROM Booking__c where id in :bookingIds];
       System.debug('bookingList'+bookingList);
       
       for(Booking__c booking : bookingList){
         Decimal initialPayment = 0;
         Decimal partialPayment = 0;
         Decimal securityPayment = 0;

         for(Payment_Transaction__c paymentTransaction : booking.Payment_Transactions__r){
             if(paymentTransaction.Type__c == Constants.TYPE_INITIAL_PAYMENT){
                initialPayment = initialPayment + paymentTransaction.Amount__c;
             }
              else if(paymentTransaction.Type__c == Constants.TYPE_PARTIAL_PAYMENT){
                partialPayment = partialPayment + paymentTransaction.Amount__c;
             }
              else if(paymentTransaction.Type__c == Constants.TYPE_SECURITY_DEPOSIT){
                securityPayment = securityPayment + paymentTransaction.Amount__c;
             }
         }

         System.debug('initialPayment'+initialPayment);
         System.debug('partialPayment'+partialPayment);
         System.debug('securityPayment'+securityPayment);

         //payment status : Final Booking Price >= Initial Payment + Partial Payment && security deposit >=  securityPayment--> paid , else partially paid
         //booking status : Exisint booking status = Pending && initialPayment,partialPayment,securityPayment > 0 --> Confirmed. 
         booking.Payment_Status__c = calculatePaymentStatus(initialPayment, partialPayment, securityPayment,booking.Final_Booking_Price__c,booking.Security_Deposit__c);
         booking.Status__c = calculateBookingStatus(initialPayment, partialPayment, securityPayment,booking.Status__c);
         updateBookingRecords.add(booking);
       }

        if(updateBookingRecords.size() > 0){
           try {
            update updateBookingRecords;
           } catch (Exception e) {
               system.debug('Error occured while updating the payment status and booking status '+ e.getMessage());
               Log logger = Log.get();
               logger.publish('Error while updating Payment and Booking Status ' + e.getMessage());
           }
        }
    }

    public static String calculatePaymentStatus(Decimal initialPayment, Decimal partialPayment, Decimal securityPayment,
                                                Decimal finalBookingPrice, Decimal securityDeposit){

        if(initialPayment == 0 && securityDeposit == 0 && finalBookingPrice == 0){
            return constants.BOOKING_PAYMENT_PENDING;
        }                                            
        Decimal totalRentalPayment =    initialPayment + partialPayment;
        Boolean isTotalRentalPaymentCompleted = finalBookingPrice <= totalRentalPayment;
        Boolean isSecurityDepositCompleted = securityDeposit <= securityPayment;

        if(isTotalRentalPaymentCompleted && isSecurityDepositCompleted){
            return constants.BOOKING_PAID;
        }else{
             return constants.BOOKING_PARTIAL_PAID;
        }
    }

    public static String calculateBookingStatus(Decimal initialPayment, Decimal partialPayment, Decimal securityPayment,String currentBookingStatus){
        if(currentBookingStatus == constants.BOOKING_PAYMENT_PENDING && (initialPayment > 0 || partialPayment > 0 || securityPayment > 0)){
            return constants.BOOKING_CONFIRM_STATUS;
        }else{
            return currentBookingStatus;
        }
    }
        
}