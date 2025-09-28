@IsTest
public with sharing class BookingTriggerTest {
   
    //data setup
    @TestSetup
    static void makeData(){
        //create contacts
        TestDataFactory.createContacts(2);
        //create cars
        TestDataFactory.createCars(2);
    }

    @IsTest 
    static void testAfterBookingClosed(){
        Car__c carRec = [select id, Total_Bookings_Value__c from Car__c limit 1];
        Contact contactRec = [select id from Contact limit 1];

        //Create new booking
        Booking__c bookingRec = new Booking__c(Car__c = carRec.Id, Customer__c = contactRec.Id, 
        Start_date_time__c = datetime.now().addDays(1),
        End_date_time__c = datetime.now().addDays(3),
        Status__c = Constants.BOOKING_PENDING_STATUS,
        payment_status__c = Constants.BOOKING_PAYMENT_PENDING,
        Final_Booking_Price__c = 200);

        insert bookingRec;

        //create payment - security deposit : 20% of final booking price
        System_Thresholds__mdt securityDepositThr = System_Thresholds__mdt.getInstance(Constants.SECURITY_DEPOSIT_THRESHOLD);
        Decimal securityDepositPercent = Decimal.valueOf(securityDepositThr.value__c)/100;
        Decimal securityDepositAmount = securityDepositPercent * bookingRec.Final_Booking_Price__c;

        Payment_Transaction__c securityPayment = new Payment_Transaction__c(Booking__c = bookingRec.Id, Amount__c = securityDepositAmount,
                                                                            Status__c = Constants.SUCCESS, Type__c = Constants.TYPE_SECURITY_DEPOSIT,
                                                                            Transaction_Date__c = datetime.now()
                                                                            );

        //create payment - rental payment
        Payment_Transaction__c rentalPayment = new Payment_Transaction__c(Booking__c = bookingRec.Id, Amount__c = bookingRec.Final_Booking_Price__c,
                                                                          Status__c = Constants.SUCCESS, Type__c = Constants.TYPE_INITIAL_PAYMENT,
                                                                          Transaction_Date__c = datetime.now());


        List<Payment_Transaction__c> payments = new List<Payment_Transaction__c>{securityPayment, rentalPayment};
        insert payments;

        //update booking status as closed. 
        Test.startTest();
            bookingRec.Status__c = Constants.BOOKING_CLOSED_STATUS;
            update bookingRec;
        Test.stopTest();

        //assert
        Car__c updatedCar = [select id, Total_Bookings_Value__c from Car__c where Id = :carRec.Id];
        Decimal expectedBookingValue = bookingRec.Final_Booking_Price__c;
        Decimal actualBookingValue = updatedCar.Total_Bookings_Value__c;
        system.Assert.areEqual(expectedBookingValue, actualBookingValue, 'Car Booking value is not updated.');
    }

    @IsTest
    static void testValidateBookingOverlapForInsert(){
        Car__c car = [select id from car__c limit 1];
        Contact con = [select id from Contact limit 1];

        //create first booking

        Booking__c firstBooking = new Booking__c(
                 Customer__c = con.Id,
                 Car__c = car.Id,
                 Start_Date_Time__c = Datetime.now().addDays(1), //Ex : 01 Jan , start date : 02 Jan and End Date : 04 Jan
                 End_Date_Time__c = Datetime.now().addDays(3),
                 Status__c = CONSTANTS.BOOKING_PENDING_STATUS,
                 payment_status__c = Constants.BOOKING_PAYMENT_PENDING,
                 Final_Booking_Price__c = 200.00 //rental rate of car * duration of booking
        );
        insert firstBooking;

        //no overlap

        //create second booking

        Booking__c secondBooking = new Booking__c(
                 Customer__c = con.Id,
                 Car__c = car.Id,
                 Start_Date_Time__c = Datetime.now().addDays(4), //Ex : today - 01 Jan , start date : 05 Jan and End Date : 07 Jan
                 End_Date_Time__c = Datetime.now().addDays(6),
                 Status__c = CONSTANTS.BOOKING_PENDING_STATUS,
                 payment_status__c = Constants.BOOKING_PAYMENT_PENDING,
                 Final_Booking_Price__c = 200.00 //rental rate of car * duration of booking
        );
        insert secondBooking;

        //create overlap booking
         Booking__c overlapBooking = new Booking__c(
                 Customer__c = con.Id,
                 Car__c = car.Id,
                 Start_Date_Time__c = Datetime.now().addDays(2), //Ex : today - 01 Jan , start date : 03 Jan and End Date : 07 Jan
                 End_Date_Time__c = Datetime.now().addDays(6),
                 Status__c = CONSTANTS.BOOKING_PENDING_STATUS,
                 payment_status__c = Constants.BOOKING_PAYMENT_PENDING,
                 Final_Booking_Price__c = 200.00 //rental rate of car * duration of booking
        );
        try{
            insert overlapBooking;
        }catch(DMLException ex){
            String actualErrorMessage = ex.getMessage();
            String expectedErrorMessage = System.Label.Booking_Overlap_Message;
            System.Assert(actualErrorMessage.contains(expectedErrorMessage), 'Booking Dates Overlap is not working');
        }

    }


     @IsTest
    static void testValidateBookingOverlapForUpdate(){
        Car__c car = [select id from car__c limit 1];
        Contact con = [select id from Contact limit 1];

        //create first booking

        Booking__c firstBooking = new Booking__c(
                 Customer__c = con.Id,
                 Car__c = car.Id,
                 Start_Date_Time__c = Datetime.now().addDays(1), //Ex : 01 Jan , start date : 02 Jan and End Date : 04 Jan
                 End_Date_Time__c = Datetime.now().addDays(3),
                 Status__c = CONSTANTS.BOOKING_PENDING_STATUS,
                 payment_status__c = Constants.BOOKING_PAYMENT_PENDING,
                 Final_Booking_Price__c = 200.00 //rental rate of car * duration of booking
        );
        insert firstBooking;

        //no overlap

        //create second booking

        Booking__c secondBooking = new Booking__c(
                 Customer__c = con.Id,
                 Car__c = car.Id,
                 Start_Date_Time__c = Datetime.now().addDays(4), //Ex : today - 01 Jan , start date : 05 Jan and End Date : 07 Jan
                 End_Date_Time__c = Datetime.now().addDays(6),
                 Status__c = CONSTANTS.BOOKING_PENDING_STATUS,
                 payment_status__c = Constants.BOOKING_PAYMENT_PENDING,
                 Final_Booking_Price__c = 200.00 //rental rate of car * duration of booking
        );
        insert secondBooking;


        //update dates of second booking. 
        secondBooking.Start_Date_Time__c = Datetime.now().addDays(2); ////Ex : today - 01 Jan , start date : 03 Jan 

        try{
            update secondBooking;
        }catch(DMLException ex){
            String actualErrorMessage = ex.getMessage();
            String expectedErrorMessage = System.Label.Booking_Overlap_Message;
            System.Assert(actualErrorMessage.contains(expectedErrorMessage), 'Booking Dates Overlap is not working');
        }

    }


}