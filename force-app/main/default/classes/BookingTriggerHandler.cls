public with sharing class BookingTriggerHandler extends TriggerHandler{
    
    override public void beforeInsert(){
        BookingTriggerHandlerService.validateBookingOverlap(Trigger.new);
    }

    override public void beforeUpdate(){
        List<Booking__c> bookings = (List<Booking__c>)Trigger.new;
        Map<Id,Booking__c> oldBookingMap = (Map<Id,Booking__c>)Trigger.oldMap;
        List<Booking__c> bookingsToValidate = new List<Booking__c>();
        For(Booking__c booking : bookings){
            String newCar = booking.Car__c;
            String oldCar = oldBookingMap.get(booking.Id).Car__c;
            Datetime newStartDate = booking.Start_Date_Time__c;
            Datetime oldStartDate = oldBookingMap.get(booking.Id).Start_Date_Time__c;
            Datetime newEndDate = booking.End_Date_Time__c;
            Datetime oldEndDate = oldBookingMap.get(booking.Id).End_Date_Time__c;

            if(newCar != oldCar || newStartDate != oldStartDate || newEndDate != oldEndDate){
                bookingsToValidate.add(booking);
            }
        }

        if(!bookingsToValidate.isEmpty()){
            BookingTriggerHandlerService.validateBookingOverlap(bookingsToValidate);
        }
    }

    override public void afterUpdate() {
       BookingTriggerHandlerService.updateTotalBookingValueForCar((List<Booking__c>)Trigger.new, (Map<Id,Booking__c>)Trigger.oldMap);
    }
}