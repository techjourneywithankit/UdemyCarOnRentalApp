public with sharing class ReviewTriggerHandler extends triggerHandler{
    
    override public void afterInsert(){
        List<Review__c> reviews = (List<Review__c>)Trigger.new;
        List<Review__c> lowReviews = new List<Review__c>();
        for(Review__c review : reviews){
            if(review.Rating__c < Constants.LOW_RATING_THRESHOLD){
                lowReviews.add(review);
            }
        }
        if(!lowReviews.isEmpty()){
            ReviewTriggerHandlerService.shareLowRatingAndCreateCase(lowReviews);
        }

        ReviewTriggerHandlerService.udpateCarAverageRating(reviews);
    }

    override public void afterUpdate(){
        List<Review__c> reviews = (List<Review__c>)Trigger.new;
        Map<Id,Review__c> oldReview = (Map<Id,Review__c>)Trigger.oldMap;
         List<Review__c> lowReviews = new List<Review__c>();
         List<Review__c> updatedReviews = new List<Review__c>();
        for(Review__c review : reviews){
            Decimal newRating = review.Rating__c;
            Decimal oldRating = oldReview.get(review.Id).Rating__c;
            if(newRating != oldRating && review.Rating__c < Constants.LOW_RATING_THRESHOLD){
                lowReviews.add(review);
            }
            if(newRating != oldRating){
                 updatedReviews.add(review);
            }

        }
         if(!lowReviews.isEmpty()){
            ReviewTriggerHandlerService.shareLowRatingAndCreateCase(lowReviews);
        }

        if(!updatedReviews.isEmpty()){
            ReviewTriggerHandlerService.udpateCarAverageRating(updatedReviews);
        }
    }

    override public void afterDelete(){
        List<Review__c> reviews = (List<Review__c>)Trigger.old;
        ReviewTriggerHandlerService.udpateCarAverageRating(reviews);
    }
}