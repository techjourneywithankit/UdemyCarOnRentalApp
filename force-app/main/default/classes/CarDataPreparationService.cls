/**
 * @description Service class responsible for data preparation and Car__c record creation
 * Contains hardcoded car data from CSV file
 * @author Salesforce Developer
 * @date 2024
 */
public with sharing class CarDataPreparationService {
    
    /**
     * @description Creates all Car__c records from hardcoded data
     * @return List of Car__c records created
     */
    public static List<Car__c> createAllCarRecords() {
        List<Car__c> carsToInsert = getHardcodedCarData();
        
        if (!carsToInsert.isEmpty()) {
            try {
                insert carsToInsert;
                System.debug('Successfully created ' + carsToInsert.size() + ' Car__c records');
            } catch (DmlException e) {
                System.debug('Error inserting Car__c records: ' + e.getMessage());
                throw new CarDataPreparationException('Failed to insert Car__c records: ' + e.getMessage());
            }
        }
        
        return carsToInsert;
    }
    
    /**
     * @description Returns hardcoded car data from CSV file
     * @return List of Car__c records with all data populated
     */
    private static List<Car__c> getHardcodedCarData() {
        List<Car__c> cars = new List<Car__c>();
        
        // Car 1: Maruti Suzuki Swift
        cars.add(new Car__c(
            Name = 'Maruti Suzuki Swift',
            Availability_Status__c = 'Available',
            Car_Description__c = 'A compact and fuel-efficient hatchback, perfect for city drives.',
            Car_Family__c = 'Hatchback',
            Current_Average__c = 15000,
            Fuel_Level__c = 'Full',
            Fuel_Type__c = 'Petrol',
            Last_Service_Date__c = Date.newInstance(2024, 3, 10),
            Make__c = 'Maruti Suzuki',
            Mileage_Limit_Per_Day__c = 150,
            Model__c = 'Swift',
            Next_Service_Date__c = Date.newInstance(2025, 3, 10),
            Number_of_Seats__c = 5,
            PickupLocation__c = 'Bengaluru',
            Primary_Image_Url__c = 'https://car-on-rental.s3.us-east-2.amazonaws.com/Maruti+Suzuki+Swift.jpg',
            Rental_Rate_Per_Day__c = 1500,
            Transmission_Type__c = 'Manual',
            Year__c = 2022
        ));
        
        // Car 2: Hyundai Creta
        cars.add(new Car__c(
            Name = 'Hyundai Creta',
            Availability_Status__c = 'Available',
            Car_Description__c = 'A popular mid-size SUV with modern features and comfortable interiors.',
            Car_Family__c = 'SUV',
            Current_Average__c = 8000,
            Fuel_Level__c = 'Full',
            Fuel_Type__c = 'Diesel',
            Last_Service_Date__c = Date.newInstance(2024, 6, 1),
            Make__c = 'Hyundai',
            Mileage_Limit_Per_Day__c = 200,
            Model__c = 'Creta',
            Next_Service_Date__c = Date.newInstance(2025, 6, 1),
            Number_of_Seats__c = 5,
            PickupLocation__c = 'Delhi',
            Primary_Image_Url__c = 'https://car-on-rental.s3.us-east-2.amazonaws.com/Hyundai+CREATA.jpg',
            Rental_Rate_Per_Day__c = 1000,
            Transmission_Type__c = 'Automatic',
            Year__c = 2023
        ));
        
        // Car 3: Tata Nexon
        cars.add(new Car__c(
            Name = 'Tata Nexon',
            Availability_Status__c = 'Available',
            Car_Description__c = 'A stylish and safe compact SUV, known for its robust build quality.',
            Car_Family__c = 'SUV',
            Current_Average__c = 22000,
            Fuel_Level__c = 'Full',
            Fuel_Type__c = 'Petrol',
            Last_Service_Date__c = Date.newInstance(2024, 4, 20),
            Make__c = 'Tata',
            Mileage_Limit_Per_Day__c = 180,
            Model__c = 'Nexon',
            Next_Service_Date__c = Date.newInstance(2025, 4, 20),
            Number_of_Seats__c = 5,
            PickupLocation__c = 'Jaipur',
            Primary_Image_Url__c = 'https://car-on-rental.s3.us-east-2.amazonaws.com/TATA+NEXON.jpg',
            Rental_Rate_Per_Day__c = 1800,
            Transmission_Type__c = 'Manual',
            Year__c = 2022
        ));
        
        // Car 4: Mahindra Thar
        cars.add(new Car__c(
            Name = 'Mahindra Thar',
            Availability_Status__c = 'Available',
            Car_Description__c = 'An iconic off-road SUV, designed for adventurous drives.',
            Car_Family__c = 'SUV',
            Current_Average__c = 3000,
            Fuel_Level__c = 'Full',
            Fuel_Type__c = 'Diesel',
            Last_Service_Date__c = Date.newInstance(2024, 7, 15),
            Make__c = 'Mahindra',
            Mileage_Limit_Per_Day__c = 250,
            Model__c = 'Thar',
            Next_Service_Date__c = Date.newInstance(2025, 7, 15),
            Number_of_Seats__c = 4,
            PickupLocation__c = 'Pune',
            Primary_Image_Url__c = 'https://car-on-rental.s3.us-east-2.amazonaws.com/Mahindra+THAR.jpg',
            Rental_Rate_Per_Day__c = 3000,
            Transmission_Type__c = 'Automatic',
            Year__c = 2024
        ));
        
        // Car 5: Maruti Suzuki Baleno
        cars.add(new Car__c(
            Name = 'Maruti Suzuki Baleno',
            Availability_Status__c = 'Available',
            Car_Description__c = 'A premium hatchback with spacious interiors and refined performance.',
            Car_Family__c = 'Hatchback',
            Current_Average__c = 10000,
            Fuel_Level__c = 'Full',
            Fuel_Type__c = 'Petrol',
            Last_Service_Date__c = Date.newInstance(2024, 5, 5),
            Make__c = 'Maruti Suzuki',
            Mileage_Limit_Per_Day__c = 160,
            Model__c = 'Baleno',
            Next_Service_Date__c = Date.newInstance(2025, 5, 5),
            Number_of_Seats__c = 5,
            PickupLocation__c = 'Hyderabad',
            Primary_Image_Url__c = 'https://car-on-rental.s3.us-east-2.amazonaws.com/Maruti+Suzuki+Baleno.jpg',
            Rental_Rate_Per_Day__c = 1600,
            Transmission_Type__c = 'Automatic',
            Year__c = 2023
        ));
        
        // Car 6: Hyundai Verna
        cars.add(new Car__c(
            Name = 'Hyundai Verna',
            Availability_Status__c = 'Available',
            Car_Description__c = 'A sophisticated sedan known for its sleek design and comfortable ride.',
            Car_Family__c = 'Sedan',
            Current_Average__c = 18000,
            Fuel_Level__c = 'Full',
            Fuel_Type__c = 'Petrol',
            Last_Service_Date__c = Date.newInstance(2024, 2, 18),
            Make__c = 'Hyundai',
            Mileage_Limit_Per_Day__c = 170,
            Model__c = 'Verna',
            Next_Service_Date__c = Date.newInstance(2025, 2, 18),
            Number_of_Seats__c = 5,
            PickupLocation__c = 'Mumbai',
            Primary_Image_Url__c = 'https://car-on-rental.s3.us-east-2.amazonaws.com/Hyundai+verna.jpg',
            Rental_Rate_Per_Day__c = 2000,
            Transmission_Type__c = 'Automatic',
            Year__c = 2022
        ));
        
        // Car 7: Tata Altroz
        cars.add(new Car__c(
            Name = 'Tata Altroz',
            Availability_Status__c = 'Available',
            Car_Description__c = 'A premium hatchback offering a blend of style, safety, and performance.',
            Car_Family__c = 'Hatchback',
            Current_Average__c = 7000,
            Fuel_Level__c = 'Full',
            Fuel_Type__c = 'Hybrid',
            Last_Service_Date__c = Date.newInstance(2024, 8, 1),
            Make__c = 'Tata',
            Mileage_Limit_Per_Day__c = 140,
            Model__c = 'Altroz',
            Next_Service_Date__c = Date.newInstance(2025, 8, 1),
            Number_of_Seats__c = 5,
            PickupLocation__c = 'Jaipur',
            Primary_Image_Url__c = 'https://car-on-rental.s3.us-east-2.amazonaws.com/Altroz.jpg',
            Rental_Rate_Per_Day__c = 1400,
            Transmission_Type__c = 'Manual',
            Year__c = 2023
        ));
        
        // Car 8: Mahindra XUV700
        cars.add(new Car__c(
            Name = 'Mahindra XUV700',
            Availability_Status__c = 'Available',
            Car_Description__c = 'A feature-loaded SUV with powerful performance and spacious cabin.',
            Car_Family__c = 'SUV',
            Current_Average__c = 9000,
            Fuel_Level__c = 'Full',
            Fuel_Type__c = 'Diesel',
            Last_Service_Date__c = Date.newInstance(2024, 5, 12),
            Make__c = 'Mahindra',
            Mileage_Limit_Per_Day__c = 220,
            Model__c = 'XUV700',
            Next_Service_Date__c = Date.newInstance(2025, 5, 12),
            Number_of_Seats__c = 7,
            PickupLocation__c = 'Pune',
            Primary_Image_Url__c = 'https://car-on-rental.s3.us-east-2.amazonaws.com/xuv700.jpg.jpg',
            Rental_Rate_Per_Day__c = 2800,
            Transmission_Type__c = 'Automatic',
            Year__c = 2023
        ));
        
        // Car 9: Maruti Suzuki Ertiga
        cars.add(new Car__c(
            Name = 'Maruti Suzuki Ertiga',
            Availability_Status__c = 'Available',
            Car_Description__c = 'A popular MPV offering comfortable seating for large families.',
            Car_Family__c = 'Minivan',
            Current_Average__c = 25000,
            Fuel_Level__c = 'Full',
            Fuel_Type__c = 'Petrol',
            Last_Service_Date__c = Date.newInstance(2024, 1, 25),
            Make__c = 'Maruti Suzuki',
            Mileage_Limit_Per_Day__c = 190,
            Model__c = 'Ertiga',
            Next_Service_Date__c = Date.newInstance(2025, 1, 25),
            Number_of_Seats__c = 7,
            PickupLocation__c = 'Bengaluru',
            Primary_Image_Url__c = 'https://car-on-rental.s3.us-east-2.amazonaws.com/ertiga.jpg',
            Rental_Rate_Per_Day__c = 2200,
            Transmission_Type__c = 'Manual',
            Year__c = 2022
        ));
        
        // Car 10: Hyundai i20
        cars.add(new Car__c(
            Name = 'Hyundai i20',
            Availability_Status__c = 'Available',
            Car_Description__c = 'A premium hatchback with a stylish design and a host of features.',
            Car_Family__c = 'Hatchback',
            Current_Average__c = 6000,
            Fuel_Level__c = 'Full',
            Fuel_Type__c = 'Petrol',
            Last_Service_Date__c = Date.newInstance(2024, 7, 22),
            Make__c = 'Hyundai',
            Mileage_Limit_Per_Day__c = 155,
            Model__c = 'i20',
            Next_Service_Date__c = Date.newInstance(2025, 7, 22),
            Number_of_Seats__c = 5,
            PickupLocation__c = 'Delhi',
            Primary_Image_Url__c = 'https://car-on-rental.s3.us-east-2.amazonaws.com/i20.jpg',
            Rental_Rate_Per_Day__c = 1550,
            Transmission_Type__c = 'Manual',
            Year__c = 2023
        ));
        
        // Car 11: Tata Punch
        cars.add(new Car__c(
            Name = 'Tata Punch',
            Availability_Status__c = 'Available',
            Car_Description__c = 'A micro-SUV offering a commanding driving position and sturdy build.',
            Car_Family__c = 'Hatchback',
            Current_Average__c = 2000,
            Fuel_Level__c = 'Full',
            Fuel_Type__c = 'Petrol',
            Last_Service_Date__c = Date.newInstance(2024, 9, 1),
            Make__c = 'Tata',
            Mileage_Limit_Per_Day__c = 130,
            Model__c = 'Punch',
            Next_Service_Date__c = Date.newInstance(2025, 9, 1),
            Number_of_Seats__c = 5,
            PickupLocation__c = 'Pune',
            Primary_Image_Url__c = 'https://car-on-rental.s3.us-east-2.amazonaws.com/tataPunch.jpg',
            Rental_Rate_Per_Day__c = 1300,
            Transmission_Type__c = 'Manual',
            Year__c = 2024
        ));
        
        // Car 12: Mahindra Bolero
        cars.add(new Car__c(
            Name = 'Mahindra Bolero',
            Availability_Status__c = 'Available',
            Car_Description__c = 'A rugged and reliable utility vehicle, popular in rural areas.',
            Car_Family__c = 'SUV',
            Current_Average__c = 30000,
            Fuel_Level__c = 'Full',
            Fuel_Type__c = 'Diesel',
            Last_Service_Date__c = Date.newInstance(2024, 3, 1),
            Make__c = 'Mahindra',
            Mileage_Limit_Per_Day__c = 160,
            Model__c = 'Bolero',
            Next_Service_Date__c = Date.newInstance(2025, 3, 1),
            Number_of_Seats__c = 7,
            PickupLocation__c = 'Mumbai',
            Primary_Image_Url__c = 'https://car-on-rental.s3.us-east-2.amazonaws.com/Bolero.png',
            Rental_Rate_Per_Day__c = 1700,
            Transmission_Type__c = 'Manual',
            Year__c = 2022
        ));
        
        // Car 13: Maruti Suzuki Dzire
        cars.add(new Car__c(
            Name = 'Maruti Suzuki Dzire',
            Availability_Status__c = 'Available',
            Car_Description__c = 'A compact sedan known for its spacious cabin and fuel efficiency.',
            Car_Family__c = 'Sedan',
            Current_Average__c = 12000,
            Fuel_Level__c = 'Full',
            Fuel_Type__c = 'Petrol',
            Last_Service_Date__c = Date.newInstance(2024, 6, 15),
            Make__c = 'Maruti Suzuki',
            Mileage_Limit_Per_Day__c = 165,
            Model__c = 'Dzire',
            Next_Service_Date__c = Date.newInstance(2025, 6, 15),
            Number_of_Seats__c = 5,
            PickupLocation__c = 'Hyderabad',
            Primary_Image_Url__c = 'https://car-on-rental.s3.us-east-2.amazonaws.com/dzire.jpg',
            Rental_Rate_Per_Day__c = 1750,
            Transmission_Type__c = 'Automatic',
            Year__c = 2023
        ));
        
        // Car 14: Hyundai Venue
        cars.add(new Car__c(
            Name = 'Hyundai Venue',
            Availability_Status__c = 'Available',
            Car_Description__c = 'A sub-compact SUV with a bold design and smart features.',
            Car_Family__c = 'SUV',
            Current_Average__c = 4000,
            Fuel_Level__c = 'Full',
            Fuel_Type__c = 'Petrol',
            Last_Service_Date__c = Date.newInstance(2024, 8, 10),
            Make__c = 'Hyundai',
            Mileage_Limit_Per_Day__c = 175,
            Model__c = 'Venue',
            Next_Service_Date__c = Date.newInstance(2025, 8, 10),
            Number_of_Seats__c = 5,
            PickupLocation__c = 'Mumbai',
            Primary_Image_Url__c = 'https://car-on-rental.s3.us-east-2.amazonaws.com/venue.jpeg',
            Rental_Rate_Per_Day__c = 1900,
            Transmission_Type__c = 'Automatic',
            Year__c = 2024
        ));
        
        // Car 15: Tata Harrier
        cars.add(new Car__c(
            Name = 'Tata Harrier',
            Availability_Status__c = 'Available',
            Car_Description__c = 'A premium SUV offering striking design and strong performance.',
            Car_Family__c = 'SUV',
            Current_Average__c = 11000,
            Fuel_Level__c = 'Full',
            Fuel_Type__c = 'Diesel',
            Last_Service_Date__c = Date.newInstance(2024, 5, 25),
            Make__c = 'Tata',
            Mileage_Limit_Per_Day__c = 210,
            Model__c = 'Harrier',
            Next_Service_Date__c = Date.newInstance(2025, 5, 25),
            Number_of_Seats__c = 5,
            PickupLocation__c = 'Jaipur',
            Primary_Image_Url__c = 'https://car-on-rental.s3.us-east-2.amazonaws.com/Harrier.jpg',
            Rental_Rate_Per_Day__c = 2600,
            Transmission_Type__c = 'Manual',
            Year__c = 2023
        ));
        
        // Car 16: Mahindra Scorpio-N
        cars.add(new Car__c(
            Name = 'Mahindra Scorpio-N',
            Availability_Status__c = 'Available',
            Car_Description__c = 'The new-generation Scorpio, blending ruggedness with modern comfort.',
            Car_Family__c = 'SUV',
            Current_Average__c = 5000,
            Fuel_Level__c = 'Full',
            Fuel_Type__c = 'Diesel',
            Last_Service_Date__c = Date.newInstance(2024, 7, 1),
            Make__c = 'Mahindra',
            Mileage_Limit_Per_Day__c = 230,
            Model__c = 'Scorpio-N',
            Next_Service_Date__c = Date.newInstance(2025, 7, 1),
            Number_of_Seats__c = 7,
            PickupLocation__c = 'Pune',
            Primary_Image_Url__c = 'https://car-on-rental.s3.us-east-2.amazonaws.com/scorpio.jpg',
            Rental_Rate_Per_Day__c = 2900,
            Transmission_Type__c = 'Automatic',
            Year__c = 2024
        ));
        
        // Car 17: Maruti Suzuki WagonR
        cars.add(new Car__c(
            Name = 'Maruti Suzuki WagonR',
            Availability_Status__c = 'Available',
            Car_Description__c = 'A tall-boy hatchback known for its spacious cabin and practicality.',
            Car_Family__c = 'Hatchback',
            Current_Average__c = 20000,
            Fuel_Level__c = 'Full',
            Fuel_Type__c = 'Petrol',
            Last_Service_Date__c = Date.newInstance(2024, 4, 5),
            Make__c = 'Maruti Suzuki',
            Mileage_Limit_Per_Day__c = 145,
            Model__c = 'WagonR',
            Next_Service_Date__c = Date.newInstance(2025, 4, 5),
            Number_of_Seats__c = 5,
            PickupLocation__c = 'Bengaluru',
            Primary_Image_Url__c = 'https://car-on-rental.s3.us-east-2.amazonaws.com/Wagonr.jpg',
            Rental_Rate_Per_Day__c = 1350,
            Transmission_Type__c = 'Manual',
            Year__c = 2022
        ));
        
        // Car 18: Hyundai Grand i10 Nios
        cars.add(new Car__c(
            Name = 'Hyundai Grand i10 Nios',
            Availability_Status__c = 'Available',
            Car_Description__c = 'A stylish and feature-rich hatchback, ideal for urban commutes.',
            Car_Family__c = 'Hatchback',
            Current_Average__c = 9000,
            Fuel_Level__c = 'Full',
            Fuel_Type__c = 'Hybrid',
            Last_Service_Date__c = Date.newInstance(2024, 6, 20),
            Make__c = 'Hyundai',
            Mileage_Limit_Per_Day__c = 140,
            Model__c = 'Grand i10 Nios',
            Next_Service_Date__c = Date.newInstance(2025, 6, 20),
            Number_of_Seats__c = 5,
            PickupLocation__c = 'Delhi',
            Primary_Image_Url__c = 'https://car-on-rental.s3.us-east-2.amazonaws.com/grandi10.jpg',
            Rental_Rate_Per_Day__c = 1450,
            Transmission_Type__c = 'Manual',
            Year__c = 2023
        ));
        
        // Car 19: Tata Safari
        cars.add(new Car__c(
            Name = 'Tata Safari',
            Availability_Status__c = 'Available',
            Car_Description__c = 'A premium SUV offering a luxurious experience and strong road presence.',
            Car_Family__c = 'SUV',
            Current_Average__c = 6000,
            Fuel_Level__c = 'Full',
            Fuel_Type__c = 'Hybrid',
            Last_Service_Date__c = Date.newInstance(2024, 9, 10),
            Make__c = 'Tata',
            Mileage_Limit_Per_Day__c = 220,
            Model__c = 'Safari',
            Next_Service_Date__c = Date.newInstance(2025, 9, 10),
            Number_of_Seats__c = 7,
            PickupLocation__c = 'Pune',
            Primary_Image_Url__c = 'https://car-on-rental.s3.us-east-2.amazonaws.com/Tata-Safari.jpg',
            Rental_Rate_Per_Day__c = 2700,
            Transmission_Type__c = 'Automatic',
            Year__c = 2024
        ));
        
        // Car 20: Maruti Suzuki Ciaz
        cars.add(new Car__c(
            Name = 'Maruti Suzuki Ciaz',
            Availability_Status__c = 'Available',
            Car_Description__c = 'A mid-size sedan known for its spacious cabin and comfortable ride.',
            Car_Family__c = 'Sedan',
            Current_Average__c = 13000,
            Fuel_Level__c = 'Full',
            Fuel_Type__c = 'Hybrid',
            Last_Service_Date__c = Date.newInstance(2024, 7, 5),
            Make__c = 'Maruti Suzuki',
            Mileage_Limit_Per_Day__c = 170,
            Model__c = 'Ciaz',
            Next_Service_Date__c = Date.newInstance(2025, 7, 5),
            Number_of_Seats__c = 5,
            PickupLocation__c = 'Hyderabad',
            Primary_Image_Url__c = 'https://car-on-rental.s3.us-east-2.amazonaws.com/BS6-Maruti-Ciaz-S.jpg',
            Rental_Rate_Per_Day__c = 1850,
            Transmission_Type__c = 'Automatic',
            Year__c = 2023
        ));
        
        return cars;
    }
    
    /**
     * @description Creates comprehensive test data: cars, contacts, bookings, reviews, and cases
     * @return Map containing all created records
     */
    public static Map<String, List<SObject>> createComprehensiveTestData() {
        Map<String, List<SObject>> result = new Map<String, List<SObject>>();
        
        try {
            // 1. Create all car records
            List<Car__c> cars = createAllCarRecords();
            result.put('cars', cars);
            System.debug('Created ' + cars.size() + ' car records');
            
            // 2. Create contacts (60 contacts for 3 bookings per car)
            List<Contact> contacts = createTestContacts(60);
            result.put('contacts', contacts);
            System.debug('Created ' + contacts.size() + ' contact records');
            
            // 3. Create 3 bookings for each car (60 total bookings)
            List<Booking__c> bookings = createTestBookings(cars, contacts);
            result.put('bookings', bookings);
            System.debug('Created ' + bookings.size() + ' booking records');
            
            // 4. Create 1 review for each booking (60 total reviews)
            List<Review__c> reviews = createTestReviews(bookings, contacts);
            result.put('reviews', reviews);
            System.debug('Created ' + reviews.size() + ' review records');
            
            // 5. Create 5 cases for different cars with different support processes
            List<Case> cases = createTestCases(cars, contacts);
            result.put('cases', cases);
            System.debug('Created ' + cases.size() + ' case records');
            
        } catch (Exception e) {
            System.debug('Error creating comprehensive test data: ' + e.getMessage());
            throw new CarDataPreparationException('Failed to create comprehensive test data: ' + e.getMessage());
        }
        
        return result;
    }
    
    /**
     * @description Creates test contacts
     * @param numberOfContacts Number of contacts to create
     * @return List of created contacts
     */
    private static List<Contact> createTestContacts(Integer numberOfContacts) {
        List<Contact> contacts = new List<Contact>();
        
        for (Integer i = 0; i < numberOfContacts; i++) {
            Contact contact = new Contact(
                FirstName = 'Test',
                LastName = 'Customer ' + i,
                Email = 'testcustomer' + i + '@carrental.com',
                Phone = '+91-98765' + String.valueOf(10000 + i).right(5)
            );
            contacts.add(contact);
        }
        
        insert contacts;
        return contacts;
    }
    
    /**
     * @description Creates 3 bookings for each car
     * @param cars List of cars
     * @param contacts List of contacts
     * @return List of created bookings
     */
    private static List<Booking__c> createTestBookings(List<Car__c> cars, List<Contact> contacts) {
        List<Booking__c> bookings = new List<Booking__c>();
        Integer contactIndex = 0;
        
        for (Car__c car : cars) {
            // Create 3 bookings for each car
            for (Integer i = 0; i < 3; i++) {
                Contact customer = contacts[Math.mod(contactIndex, contacts.size())];
                contactIndex++;
                
                DateTime startDate = DateTime.now().addDays(i * 7 + 1); // Stagger bookings
                DateTime endDate = startDate.addDays(2 + i); // Different durations
                
                Booking__c booking = new Booking__c(
                    Customer__c = customer.Id,
                    Car__c = car.Id,
                    Start_Date_Time__c = startDate,
                    End_Date_Time__c = endDate,
                    Status__c = Constants.BOOKING_CONFIRM_STATUS,
                    Payment_Status__c = Constants.BOOKING_PAID,
                    Final_Booking_Price__c = car.Rental_Rate_Per_Day__c * (2 + i)
                );
                bookings.add(booking);
            }
        }
        
        insert bookings;
        return bookings;
    }
    
    /**
     * @description Creates 1 review for each booking
     * @param bookings List of bookings
     * @param contacts List of contacts
     * @return List of created reviews
     */
    private static List<Review__c> createTestReviews(List<Booking__c> bookings, List<Contact> contacts) {
        List<Review__c> reviews = new List<Review__c>();
        
        String[] reviewComments = new String[]{
            'Excellent service and clean car!',
            'Good experience overall, minor issues with AC.',
            'Perfect car for our trip, highly recommended!',
            'Car was clean and well maintained.',
            'Great value for money, will book again.',
            'Smooth booking process and timely delivery.',
            'Car exceeded expectations, very comfortable.',
            'Professional service, car was in perfect condition.',
            'Good car but could be cleaner.',
            'Excellent customer service and reliable car.'
        };
        
        for (Integer i = 0; i < bookings.size(); i++) {
            Booking__c booking = bookings[i];
            Contact customer = contacts[Math.mod(i, contacts.size())];
            
            // Generate random rating between 3-5 (mostly positive reviews)
            Integer rating = Math.mod(i, 3) + 3; // 3, 4, or 5
            String comment = reviewComments[Math.mod(i, reviewComments.size())];
            
            Review__c review = new Review__c(
                Booking__c = booking.Id,
                Customer__c = customer.Id,
                Rating__c = rating,
                Comments__c = comment
            );
            reviews.add(review);
        }
        
        insert reviews;
        return reviews;
    }
    
    /**
     * @description Creates 5 cases for different cars with different support processes
     * @param cars List of cars
     * @param contacts List of contacts
     * @return List of created cases
     */
    private static List<Case> createTestCases(List<Car__c> cars, List<Contact> contacts) {
        List<Case> cases = new List<Case>();
        
        // Get Case Record Type IDs
        Map<String, Id> recordTypeMap = getCaseRecordTypeMap();
        
        // Create 5 different cases for different cars
        List<Map<String, Object>> caseData = new List<Map<String, Object>>{
            new Map<String, Object>{
                'subject' => 'Booking Inquiry - Car Availability',
                'description' => 'Customer wants to know about availability of this car for next weekend.',
                'origin' => 'Web',
                'priority' => 'Medium',
                'recordType' => 'Booking_Inquiry'
            },
            new Map<String, Object>{
                'subject' => 'Review Issue - Poor Car Condition',
                'description' => 'Customer reported that the car was not clean and had mechanical issues.',
                'origin' => 'Email',
                'priority' => 'High',
                'recordType' => 'Review_Issue'
            },
            new Map<String, Object>{
                'subject' => 'Maintenance Request - Engine Check',
                'description' => 'Car needs engine maintenance and oil change.',
                'origin' => 'Phone',
                'priority' => 'High',
                'recordType' => 'Maintenance_Request'
            },
            new Map<String, Object>{
                'subject' => 'Booking Inquiry - Pricing Information',
                'description' => 'Customer asking about special rates for long-term rental.',
                'origin' => 'Web',
                'priority' => 'Low',
                'recordType' => 'Booking_Inquiry'
            },
            new Map<String, Object>{
                'subject' => 'Review Issue - Customer Service Complaint',
                'description' => 'Customer complaint about poor customer service during booking process.',
                'origin' => 'Email',
                'priority' => 'Medium',
                'recordType' => 'Review_Issue'
            }
        };
        
        for (Integer i = 0; i < 5; i++) {
            Car__c car = cars[i];
            Contact contact = contacts[i * 10]; // Use different contacts
            
            Map<String, Object> caseInfo = caseData[i];
            
            Case caseRecord = new Case(
                Subject = (String)caseInfo.get('subject'),
                Description = (String)caseInfo.get('description'),
                Origin = (String)caseInfo.get('origin'),
                Priority = (String)caseInfo.get('priority'),
                Status = 'New',
                ContactId = contact.Id,
                RecordTypeId = recordTypeMap.get((String)caseInfo.get('recordType'))
            );
            cases.add(caseRecord);
        }
        
        insert cases;
        return cases;
    }
    
    /**
     * @description Gets Case Record Type mapping
     * @return Map of record type name to ID
     */
    private static Map<String, Id> getCaseRecordTypeMap() {
        Map<String, Id> recordTypeMap = new Map<String, Id>();
        
        for (RecordType rt : [SELECT Id, DeveloperName FROM RecordType WHERE SObjectType = 'Case']) {
            recordTypeMap.put(rt.DeveloperName, rt.Id);
        }
        
        return recordTypeMap;
    }
    
    /**
     * @description Clears all existing test data before creating new data
     * Deletes records in reverse dependency order to avoid foreign key constraints
     * @return Map with counts of deleted records
     */
    public static Map<String, Integer> clearExistingTestData() {
        Map<String, Integer> deletionCounts = new Map<String, Integer>();
        
        try {
            System.debug('🧹 Starting to clear existing test data...');
            
            // 1. Delete Cases first (no dependencies)
            List<Case> existingCases = [SELECT Id FROM Case];
            if (!existingCases.isEmpty()) {
                delete existingCases;
                deletionCounts.put('cases', existingCases.size());
                System.debug('✅ Deleted ' + existingCases.size() + ' existing case records');
            }
            
            // 2. Delete Reviews (depends on Bookings)
            List<Review__c> existingReviews = [SELECT Id FROM Review__c];
            if (!existingReviews.isEmpty()) {
                delete existingReviews;
                deletionCounts.put('reviews', existingReviews.size());
                System.debug('✅ Deleted ' + existingReviews.size() + ' existing review records');
            }
            
            // 3. Delete Bookings (depends on Cars and Contacts)
            List<Booking__c> existingBookings = [SELECT Id FROM Booking__c];
            if (!existingBookings.isEmpty()) {
                delete existingBookings;
                deletionCounts.put('bookings', existingBookings.size());
                System.debug('✅ Deleted ' + existingBookings.size() + ' existing booking records');
            }
            
            // 4. Delete Contacts (depends on Accounts, but we'll keep accounts)
            List<Contact> existingContacts = [SELECT Id FROM Contact WHERE AccountId != null];
            if (!existingContacts.isEmpty()) {
                delete existingContacts;
                deletionCounts.put('contacts', existingContacts.size());
                System.debug('✅ Deleted ' + existingContacts.size() + ' existing contact records');
            }
            
            // 5. Delete Cars last (other objects depend on cars)
            List<Car__c> existingCars = [SELECT Id FROM Car__c];
            if (!existingCars.isEmpty()) {
                delete existingCars;
                deletionCounts.put('cars', existingCars.size());
                System.debug('✅ Deleted ' + existingCars.size() + ' existing car records');
            }
            
            System.debug('🎉 Successfully cleared all existing test data!');
            System.debug('📊 Deletion Summary:');
            for (String objectType : deletionCounts.keySet()) {
                System.debug('   - ' + objectType + ': ' + deletionCounts.get(objectType) + ' records deleted');
            }
            
        } catch (Exception e) {
            System.debug('❌ Error clearing existing test data: ' + e.getMessage());
            System.debug('Stack trace: ' + e.getStackTraceString());
            throw new CarDataPreparationException('Failed to clear existing test data: ' + e.getMessage());
        }
        
        return deletionCounts;
    }
    
    /**
     * @description Custom exception class for Car Data Preparation errors
     */
    public class CarDataPreparationException extends Exception {}
}