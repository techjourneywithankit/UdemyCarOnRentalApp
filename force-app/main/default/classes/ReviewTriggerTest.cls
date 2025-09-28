@isTest
public with sharing class ReviewTriggerTest {
    
    @testsetup
    static void makeData(){
        List<Contact> conList =  TestDataFactory.createContacts(1);
        List<Car__c> carList = TestDataFactory.createCars(1);
        List<Booking__c> bookingList = TestDataFactory.createBookings(1,conList,carList);
    }

    @IsTest
    public static void testInsertReviewTriggerHandlerForNegativeRating(){
            List<Contact> conList = [select id from contact];
            List<Booking__c> bookingList = [select id from Booking__c];
            
            List<Review__c> reviewList = TestDataFactory.createReviews(1,conList,bookingList,2);
        
            //validate sharing record is created. 
            List<Booking__share> bookingShareRec = [select parentId from Booking__share 
                                                    where parentId = :bookingList[0].Id];
        
            System.assert(bookingShareRec.size() > 0, 'Negative review record is not shared successfully');

            List<Case> caseList = [select id from case where Review_ID__c = :reviewList[0].Id];
            
            System.assert(caseList.size() > 0, 'Negative review case record is not created');

    }

    @isTest
    public static void testUpdateReviewTriggerHandlerForNegativeRating(){
        List<Contact> conList = [select id from contact];
        List<Booking__c> bookingList = [select id from Booking__c];
        List<Review__c> reviewList = TestDataFactory.createReviews(1,conList,bookingList,5);
        Review__c reviewRec = reviewList[0];
        reviewRec.Rating__c = 2;
        update reviewRec;

        //validate sharing record is created. 
        List<Booking__share> bookingShareRec = [select parentId from Booking__share 
                                                    where parentId = :bookingList[0].Id];
        
        System.assert(bookingShareRec.size() > 0, 'Negative review record is not shared successfully');

        List<Case> caseList = [select id from case where Review_ID__c = :reviewRec.Id];
            
        system.assert(caseList.size() > 0, 'Negative review case record is not created');
    }

    @isTest
    public static void testInsertForAverageCarRating(){
        List<Contact> conList = [select id from contact];
        List<Booking__c> bookingList = [select id from Booking__c];
        List<Review__c> firstReviewList = TestDataFactory.createReviews(1,conList,bookingList,5);
        List<Review__c> secondReviewList = TestDataFactory.createReviews(1,conList,bookingList,5);
        List<Car__c> carList = [select id,Average_Rating__c from Car__c];
        Integer expectedAverageRating = 5; //(5 + 5)/2
        Integer actualAverageRating = Integer.valueOf(carList[0].Average_Rating__c);
        System.Assert.areEqual(expectedAverageRating,actualAverageRating,'Car Average Rating is not calculated');
    }

    @isTest
    public static void testUpdateForAverageCarRating(){
        List<Contact> conList = [select id from contact];
        List<Booking__c> bookingList = [select id from Booking__c];
        List<Review__c> firstReviewList = TestDataFactory.createReviews(1,conList,bookingList,5);
        List<Review__c> secondReviewList = TestDataFactory.createReviews(1,conList,bookingList,5);

        //update the first review to trigger the update trigger
        firstReviewList[0].Rating__c = 3;
        update firstReviewList;

        List<Car__c> carList = [select id,Average_Rating__c from Car__c];
        Integer expectedAverageRating = 4; //(5 + 3)/2
        Integer actualAverageRating = Integer.valueOf(carList[0].Average_Rating__c);
        System.Assert.areEqual(expectedAverageRating,actualAverageRating,'Car Average Rating is not calculated');
    }

    @isTest
    public static void testDeleteForAverageCarRating(){
        List<Contact> conList = [select id from contact];
        List<Booking__c> bookingList = [select id from Booking__c];
        List<Review__c> firstReviewList = TestDataFactory.createReviews(1,conList,bookingList,5);
        List<Review__c> secondReviewList = TestDataFactory.createReviews(1,conList,bookingList,5);

        //delete the first review to trigger the delete trigger
        delete firstReviewList;

        List<Car__c> carList = [select id,Average_Rating__c from Car__c];
        Integer expectedAverageRating = 5; //(5)/1
        Integer actualAverageRating = Integer.valueOf(carList[0].Average_Rating__c);
        System.Assert.areEqual(expectedAverageRating,actualAverageRating,'Car Average Rating is not calculated');
    }

   
}