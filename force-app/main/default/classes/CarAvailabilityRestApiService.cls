@Restresource(urlMapping='/v1/cars/available/*')
global with sharing class CarAvailabilityRestApiService {
    
    @HttpGet
    global static responseWrapper getAvailableCars() {
        //get the query parameters 
        RestRequest req = RestContext.request;
        //start date
        Date startDate = Date.valueOf(req.params.get('startDate'));
        //end date
        Date endDate = Date.valueOf(req.params.get('endDate'));
        //Fuel type
        String fuelType = req.params.get('fuelType');
        //transmissin type
        String transmissionType = req.params.get('transmissionType');
        //Location
        String location = req.params.get('location');

        //validations
        if(startDate == null || endDate == null){
            return new responseWrapper(false, 'Start date and end date are required', null);
        }
        if (String.isBlank(location)) {
            return new responseWrapper(false, 'Location is required', null);
        }
        //start date must be less than end date
        if(startDate > endDate){
            return new responseWrapper(false, 'Start date must be less than end date', null);
        }

        Set<id> bookedCarId  = new Set<id>();
        Datetime startDateTime = Datetime.newInstance(startDate, Time.newInstance(0, 0, 0, 0));
        Datetime endDateTime = Datetime.newInstance(endDate, Time.newInstance(23, 59, 59, 0));
        //get booking records for the same date range
        for(Booking__c booking :[select id,car__c from Booking__c where start_date_time__c >= :startDateTime and end_date_time__c <= :endDateTime]){
            bookedCarId.add(booking.car__c);
        }

        //build the query for available cars -- dynamic
        String available = CONSTANTS.AVAILABLE_CARS;
        String query = 'select id, name, rental_rate_per_day__c, primary_image_url__c, fuel_type__c, Car_Family__c, transmission_type__c,car_description__c,PickupLocation__c from car__c';
        query = query + ' where id not in :bookedCarId and PickupLocation__c = :location and Availability_Status__c = :available';

        //Optional Parameters
        if(String.isNotBlank(fuelType)){
            query = query + ' and fuel_type__c = :fuelType';
        }
        if(String.isNotBlank(transmissionType)){
            query = query + ' and transmission_type__c = :transmissionType';
        }
       
        //execute query
        List<Car__c> cars = Database.query(query);

        if(cars.isEmpty()){
            return new responseWrapper(false, 'No cars available for the given date range', null);
        }
        
        //prepare response
        List<carResponseWrapper> carResponseWrappers = new List<carResponseWrapper>();
        for(Car__c car : cars){
           carResponseWrapper carResponse = new carResponseWrapper(car);
           carResponseWrappers.add(carResponse);
        }
        return new responseWrapper(true, 'Available cars', carResponseWrappers);

    }

    global class responseWrapper {
        public Boolean success;
        public String message;
        public List<carResponseWrapper> cars;

        public responseWrapper(Boolean success, String message, List<carResponseWrapper> cars){
            this.success = success;
            this.message = message;
            this.cars = cars;
        }
    }

    global class carResponseWrapper {
        public string id;
        public string name;
        public Decimal rentalRate;
        public string imageUrl;
        public string fuelType;
        public string family;
        public string transmissionType;
        public string location;
        public string description;

        public carResponseWrapper(Car__c car){
            this.id = car.Id;
            this.name = car.Name;
            this.rentalRate = car.Rental_Rate_Per_Day__c;
            this.imageUrl = car.Primary_Image_Url__c;
            this.fuelType = car.Fuel_Type__c;
            this.family = car.Car_Family__c;
            this.transmissionType = car.Transmission_Type__c;
            this.location = car.PickupLocation__c;
            this.description = car.Car_Description__c;
        }

    }
}