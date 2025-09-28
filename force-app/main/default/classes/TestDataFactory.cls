@isTest
public with sharing class TestDataFactory {
    
    //create contacts
    public static List<Contact> createContacts(Integer numberOfRecords) {

        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < numberOfRecords; i++) {
            Contact contact = new Contact(
                FirstName = 'Test',
                LastName = 'Contact ' + i,
                Email = 'testcontact' + i + '@nomail.com'
            );
            contacts.add(contact);
        }
        insert contacts;
        return contacts;
    }
       

    //create cars
    public static List<Car__c> createCars(Integer numberOfRecords) {

        List<Car__c> cars = new List<Car__c>();
        for (Integer i = 0;i < numberOfRecords; i++){
            Car__c car = new Car__c(
                Name = 'Test Car ' + i,
                Make__c = 'TATA',
                Model__c = 'Nexon',
                Fuel_Type__c = 'Petrol',
                Transmission_Type__c = 'Automatic',
                Year__c = 2020,
                Availability_Status__c = 'Available',
                Rental_Rate_Per_Day__c = 100.00,
                Mileage_Limit_Per_Day__c =  200,
                Number_of_Seats__c = 5,
                PickupLocation__c = 'Pune'
            );
             cars.add(car);
        }
         insert cars;
         return cars;
    }

    //create booking
    public static List<Booking__c> createBookings(Integer numberOfRecords,List<Contact> contacts,List<Car__c> cars) {

        List<Booking__c> bookings = new List<Booking__c>();
        for (Integer i = 0;i < numberOfRecords; i++){
            Contact con = contacts[Math.mod(i, contacts.size())];
            Car__c car = cars[Math.mod(i, cars.size())];
            Booking__c booking = new Booking__c(
                Customer__c = con.Id,
                Car__c = car.Id,
                 Start_Date_Time__c = Datetime.now().addDays(1),
                 End_Date_Time__c = Datetime.now().addDays(3),
                 Status__c = CONSTANTS.BOOKING_PENDING_STATUS,
                 payment_status__c = Constants.BOOKING_PAYMENT_PENDING,
                 Final_Booking_Price__c = 200.00 //rental rate of car * duration of booking
            );
               bookings.add(booking);
        }
         insert bookings;
         return bookings;
     }
    
     public static List<Review__c> createReviews(Integer numberOfRecords,List<Contact> contacts,List<Booking__c> bookings,Integer rating) {
         List<Review__c> reviews = new List<Review__c>();
         for (Integer i = 0;i < numberOfRecords;i++){
             Contact con = contacts[Math.mod(i, contacts.size())];
             Booking__c booking = bookings[Math.mod(i, bookings.size())];
             Review__c review = new Review__c(
                    Booking__c = booking.Id,
                    Customer__c = con.Id,
                    Rating__c = rating,
                    Comments__c = 'Test Comments ' + i
             );
             reviews.add(review);
         }
          insert reviews;
          return reviews;
     }
}