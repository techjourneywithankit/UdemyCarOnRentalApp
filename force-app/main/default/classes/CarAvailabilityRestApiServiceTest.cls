@isTest
public with sharing class CarAvailabilityRestApiServiceTest {

    @TestSetup
    static void makeData(){
        List<Contact> conList =  TestDataFactory.createContacts(2);
        List<Car__c> carList = TestDataFactory.createCars(4);
        List<Booking__c> bookingList = TestDataFactory.createBookings(1,conList,carList);
    }

    @isTest
    static void testGetAvailableCars(){

        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        RestContext.request = req;
        RestContext.response = res;

      
        //  Date todaysDate = date.today();
        //  Date startDate = todaysDate.addDays(1);
        //  Date endDate = todaysDate.addDays(3); 
        //  String startDateString = startDate.format('yyyy-MM-dd');
        //  String endDateString = endDate.format('yyyy-MM-dd');
         

        req.params.put('startDate',formatDate(date.today().addDays(10)));
        req.params.put('endDate',formatDate(date.today().addDays(30)));
        req.params.put('location','Pune');
        req.params.put('fuelType','Petrol');
        req.params.put('transmissionType','Automatic');

        CarAvailabilityRestApiService.responseWrapper response = CarAvailabilityRestApiService.getAvailableCars();
        Test.stopTest();

        System.Assert.areEqual(true,response.success);
    }

    private static string formatDate(Date inpDate){
          return inpDate.year() + '-' + inpDate.month() + '-' + inpDate.day();  
    }
}