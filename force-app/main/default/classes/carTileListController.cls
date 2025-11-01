public with sharing class carTileListController {
    
    public class Filters{
        @AuraEnabled
        public String searhKey{get;set;}
        @AuraEnabled
        public Integer maxSeats{get;set;}
        @AuraEnabled
        public Date startDate{get;set;}
        @AuraEnabled
        public Date endDate{get;set;}
        @AuraEnabled
        public Decimal maxRentalRate{get;set;}
        @AuraEnabled
        public Decimal minRating{get;set;}
        @AuraEnabled
        public String pickupLocation{get;set;}
        @AuraEnabled
        public List<String> transmissionType{get;set;}
        @AuraEnabled
        public List<String> fuelType{get;set;}
    }

    @AuraEnabled(cacheable=true)
    public static List<Car__c> getCars(Filters filters){
        List<String> criteria = new List<String>();
        String key,pickupLocation;
        Decimal maxSeat, maxRentalRate, minRating;
        List<String> transmissionType,fuelType;
        //default filter criteria
       String availableCars = Constants.AVAILABLE_CARS;
       criteria.add('Availability_Status__c = :availableCars');

       //Optional Parameters
        if(String.isNotBlank(filters.searhKey)){
            key = '%' + filters.searhKey + '%';
            criteria.add('Name like :key');
        }
        if(filters.maxSeats != null){
            maxSeat = filters.maxSeats;
            criteria.add('Number_of_Seats__c <= :maxSeat');
        }
        if(filters.maxRentalRate != null){
            maxRentalRate = filters.maxRentalRate;
            criteria.add('Rental_Rate_Per_Day__c <= :maxRentalRate');
        }

        if(filters.minRating != null){
            minRating = filters.minRating;
            if(minRating == 0){
                criteria.add('(Average_Rating__c = null OR Average_Rating__c >= 0)');  
            }
            else{
                criteria.add('Average_Rating__c >= :minRating');
            }
        }
        if(String.isNotBlank(filters.pickupLocation)){
            pickupLocation = filters.pickupLocation ;
            criteria.add('PickupLocation__c = :pickupLocation');
        }
        
         //check for transmission type
        if(filters.transmissionType != null && !filters.transmissionType.isEmpty()){
            transmissionType = filters.transmissionType;
            criteria.add('Transmission_Type__c IN :transmissionType');
        }

           //check for fuel type
        if(filters.fuelType != null && !filters.fuelType.isEmpty()){
            fuelType = filters.fuelType;
            criteria.add('Fuel_Type__c IN :fuelType');
        }

        //start date and end date --> so that we can avaoid to fetch the cars which already have booking in those dates. 
        Datetime startDateTime = Datetime.newInstance(filters.startDate, Time.newInstance(0, 0, 0, 0));
        Datetime endDateTime = Datetime.newInstance(filters.endDate, Time.newInstance(23, 59, 59, 0));

        //get booking between the start date and end date and we are excluding the cars which are having the booking
        Set<id> bookedCarId  = new Set<id>();
        for(Booking__c booking : [select id,car__c from Booking__c where start_date_time__c >= :startDateTime and end_date_time__c <= :endDateTime ]){
            bookedCarId.add(booking.car__c);
        }
        if(!bookedCarId.isEmpty()){
            criteria.add('id not in :bookedCarId');
        }

        //prepare your dynamic query 
                String queryToGetCars = 'SELECT Id,Average_Rating__c,Availability_Status__c,Car_Description__c,Car_Family__c,Fuel_Type__c,Make__c,Mileage_Limit_Per_Day__c,Model__c,Name,Number_of_Seats__c,PickupLocation__c,Primary_Image_Url__c,Rental_Rate_Per_Day__c,Transmission_Type__c  FROM Car__c';
                String whereClause =  ' where ' + String.Join(criteria, ' AND ');
                queryToGetCars = queryToGetCars + whereClause;
                queryToGetCars += ' order by Name ';
                System.debug('queryToGetCars ' + queryToGetCars);
                return Database.query(queryToGetCars);
    }

}