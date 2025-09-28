public with sharing class ReviewTriggerHandlerService {
    
    public static void shareLowRatingAndCreateCase(List<Review__c> reviews){
        
        //get the customer support group
        Group customerSupportGroup = [select id from group where DeveloperName = :Constants.CUSTOMER_SUPPORT_PUBLIC_GROUP];
        Set<Id> bookingIdSet = new Set<Id>();

        //get the booking from review
        for(Review__c reviewRec : reviews){
            if(String.isNotBlank(reviewRec.Booking__c)){
                bookingIdSet.add(reviewRec.Booking__c);
            }
        }

        //checking if booking is already share with customer support public group
        List<Booking__share> existingShare = [select parentId from Booking__share 
        where parentId in :bookingIdSet and userOrGroupId = :customerSupportGroup.Id 
        and RowCause = :Schema.Booking__share.RowCause.Manual];

        Set<Id> alreadySharedBookingId = new Set<Id>();
        
        for(Booking__share shareRecord : existingShare){
            alreadySharedBookingId.add(shareRecord.parentId);
        }
        List<Booking__share> bookingShareList = new List<Booking__share>();
        for(Id bookingId : bookingIdSet){
            if(!alreadySharedBookingId.contains(bookingId)){
                Booking__share shareWithCustomerSupport = new Booking__share();
                shareWithCustomerSupport.ParentId = bookingId;
                shareWithCustomerSupport.UserOrGroupId = customerSupportGroup.Id;
                shareWithCustomerSupport.AccessLevel = 'Read';
                shareWithCustomerSupport.RowCause = Schema.Booking__share.RowCause.Manual;
                bookingShareList.add(shareWithCustomerSupport);
            }
        }

        if(!bookingShareList.isEmpty()){
            try {
                insert bookingShareList;
            } catch (Exception ex) {
                //log error to the apex logs
                system.debug(ex.getMessage());
                Log logger = Log.get();
                logger.publish(ex.getMessage());
            }
        }

        createCaseForLowRating(reviews);
    }

    private static void createCaseForLowRating (List<Review__c> reviews){
        
        //Get the record type id for negative review record type
        Id reviewIssueRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName()
        .get(Constants.NEGATIVE_REVIEW_RECORD_TYPE).getRecordTypeId();
        
        System.debug('reviewIssueRecordTypeId ' + reviewIssueRecordTypeId);

        //get all the review id
        Set<Id> reviewIdSet = new Set<Id>();
        for(Review__c reviewRec : reviews){
            reviewIdSet.add(reviewRec.Id);
        }

        //get the review records
        List<Review__c> reviewList = [select id,Rating__c,Comments__c, Booking__c, Customer__c, Booking__r.Car__c from Review__c where Id in :reviewIdSet];
        System.debug('reviewList' + reviewList);
        //Avoid duplicate case creation. 
        List<Case> existingCaseList = [
            select id,Review_ID__c from Case where 
            recordTypeId = :reviewIssueRecordTypeId 
            and Type = :Constants.NEGATIVE_REVIEW_CASE_TYPE
            and Review_ID__c in :reviewIdSet
        ];

        Set<Id> existingReviewId = new Set<Id>();
        for(Case caseRecord : existingCaseList){
            existingReviewId.add(caseRecord.Review_ID__c);
        }

        List<Case> caseList = new List<Case>();

        for(Review__c reviewRec : reviewList){

            if(!existingReviewId.contains(reviewRec.Id)){
                Case caseRecord = new Case();
                caseRecord.recordTypeId = reviewIssueRecordTypeId;
                caseRecord.Type = Constants.NEGATIVE_REVIEW_CASE_TYPE;
                caseRecord.Priority = Constants.CASE_PRIORITY_MEDIUM;
                caseRecord.Review_ID__c = reviewRec.Id;
                caseRecord.Related_Booking__c = reviewRec.Booking__c;
                caseRecord.ContactId = reviewRec.Customer__c;
                caseRecord.Related_Car__c = reviewRec.Booking__r.Car__c;
                caseRecord.Subject = 'Low Rating Review : ' + reviewRec.Rating__c + ' Stars';
                caseRecord.Description = 'Review Comments ' + reviewRec.Comments__c;
                caseList.add(caseRecord);
            }
        }
        if(!caseList.isEmpty()){
            try {
                insert caseList;
            } catch (Exception ex) {
                //log error to the apex logs
                system.debug(ex.getMessage());
                Log logger = Log.get();
                logger.publish(ex.getMessage());
            }
        }
    }

    public static void udpateCarAverageRating(List<Review__c> listOfReviews){

        //Variable Declaration
        Set<Id> bookingIdSet = new Set<Id>();
        Set<Id> carIdSet = new Set<Id>();
        Map<Id,Id> carIdReviewIdMap = new Map<Id,Id>();
        Map<Id,Decimal> carAverageRatingMap = new Map<Id,Decimal>();
        List<Car__c> carList = new List<Car__c>();

        //get all booking from review
        for(Review__c reviewRec : listOfReviews){
            bookingIdSet.add(reviewRec.Booking__c);
        }

        //get all the booking records. 
        Map<Id,Booking__c> bookings = new Map<Id,Booking__c>([select id, Car__c from Booking__c where id in :bookingIdSet]);

        //map review to cars through the booking
        for(Review__c review : listOfReviews){
            if(bookings.containsKey(review.Booking__c)){
                Id carId = bookings.get(review.Booking__c).Car__c;
                carIdSet.add(carId);
                carIdReviewIdMap.put(review.Id,carId);
            }
        }

        // Get current average ratings for cars that have reviews
        for(AggregateResult agr : [select Booking__r.Car__c carId, avg(Rating__c) avgRating from review__c 
                               where Booking__r.Car__c in :carIdSet group by Booking__r.Car__c]){
                                
                                Id carId = (Id) agr.get('carId');
                                Decimal averageRating = (Decimal) agr.get('avgRating');
                                carAverageRatingMap.put(carId,averageRating.round(System.RoundingMode.HALF_UP));
        }
        
        // Update cars - either with new average rating or set to null if no reviews
        for(Id carId : carIdSet){
            Car__c car = new Car__c(Id = carId);
            if(carAverageRatingMap.containsKey(carId)){
                // Car has reviews, set to calculated average
                car.Average_Rating__c = carAverageRatingMap.get(carId);
            } else {
                // Car has no reviews (all were deleted), set to null
                car.Average_Rating__c = null;
            }
            carList.add(car);
        }

        if(!carList.isEmpty()){
            try {
                update carList;
            } catch (Exception ex) {
                //log error to the apex logs
                system.debug(ex.getMessage());
                Log logger = Log.get();
                logger.publish(ex.getMessage());
            }
        }
    }
}