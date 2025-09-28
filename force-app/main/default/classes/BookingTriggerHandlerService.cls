public with sharing class BookingTriggerHandlerService {
    
    public static void updateTotalBookingValueForCar(List<Booking__c> bookings, Map<Id,Booking__c> oldBookingMap){
        Set<Id> carIds = new Set<Id>();
        for(Booking__c booking : bookings){
            //check if booking status is changed to closed. 
            String newBookingStatus = booking.Status__c;
            String oldBookingStatus = oldBookingMap.get(booking.Id).Status__c;
            if(newBookingStatus != oldBookingStatus && newBookingStatus == Constants.BOOKING_CLOSED_STATUS){
                carIds.add(booking.Car__c);
            }
        }

        if(carIds.isEmpty()){
            return;
        }
        //Submit Queuable Job to Process
        System.enqueueJob(new QueuableTotalCarValue(carIds));
    }

    public static void validateBookingOverlap(List<Booking__c> bookings){

        //get all the car id
        Set<Id> carIds = new Set<Id>();
        Set<Id> existingBookingId = new Set<Id>();

        for(Booking__c booking : bookings){
            carIds.add(booking.Car__c);
            //only store existing booking for update (booking.id is not null)
            if(String.isNotBlank(booking.Id)){
                existingBookingId.add(booking.Id);
            }
        }
        //set of active booking
        Set<String> activeBookingStatus = new Set<String>();
        activeBookingStatus.add(Constants.BOOKING_PENDING_STATUS);
        activeBookingStatus.add(Constants.BOOKING_CONFIRM_STATUS);
        activeBookingStatus.add(Constants.BOOKING_STARTED_STATUS);
        activeBookingStatus.add(Constants.BOOKING_COMPLETED_STATUS);

        String query = 'select id, Car__c, Start_Date_Time__c, End_Date_Time__c from Booking__c where Car__c in :carIds and Status__c in :activeBookingStatus';
        //for update we have to exclude the current booking
        if(!existingBookingId.isEmpty()){
            query += ' and id not in :existingBookingId';
        }

        //get all the active booking
        List<Booking__c> existingActiveBookings = Database.query(query);
        Map<Id,List<Booking__c>> carIdToExistingBookingMap = new Map<Id,List<Booking__c>>();

        for(Booking__c existingBooking : existingActiveBookings){
            //create one map : key : carId, value : all active booking against the car. 

            if(!carIdToExistingBookingMap.containsKey(existingBooking.Car__c)){
                //add the new car Id with empty booking list.
                carIdToExistingBookingMap.put(existingBooking.Car__c,new List<Booking__c>());
            }
                List<Booking__c> tempList = carIdToExistingBookingMap.get(existingBooking.Car__c);
                tempList.add(existingBooking);
                carIdToExistingBookingMap.put(existingBooking.Car__c,tempList);
        }
        

        for(Booking__c newBooking : bookings){
            //get the list of existing booking against the same car id.
            List<Booking__c> existingBookingList = carIdToExistingBookingMap.get(newBooking.Car__c);
                 if(existingBookingList != null && existingBookingList.size() > 0) {
                    for(Booking__c existingBooking : existingBookingList){
                        Boolean isOverlap = hasOverlap(newBooking, existingBooking);
                        if(isOverlap){
                            //there is overlap between the new booking and existing booking.
                            newBooking.addError(System.Label.Booking_Overlap_Message);
                             break; 
                        }
                        
                    }  
                 }          
        }
    }

    private static Boolean hasOverlap(Booking__c newBooking, Booking__c existingBooking){
        
        return (newBooking.Start_Date_Time__c <= existingBooking.End_Date_Time__c 
        && newBooking.End_Date_Time__c >= existingBooking.Start_Date_Time__c);
    }
}