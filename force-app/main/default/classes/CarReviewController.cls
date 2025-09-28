public with sharing class CarReviewController {
    
    @AuraEnabled(cacheable=true)
    public static ReviewWrapper getCarReview(Id carId){

    // Get car's average rating
      Car__c car = [
        SELECT Id, Average_Rating__c
        FROM Car__c
        WHERE Id = :carId
        LIMIT 1
      ];
    Decimal averageRating = 0;
     if(car.Average_Rating__c == null || car.Average_Rating__c == 0){
        averageRating = 0;
      }else{
        averageRating = car.Average_Rating__c;
      }


       // Get all reviews for distribution calculation
      List<Review__c> allReviews = [
        SELECT Id, Rating__c, Comments__c, CreatedDate, Booking__r.Car__c
        FROM Review__c
        WHERE Booking__r.Car__c = :carId
        ORDER BY CreatedDate DESC
      ];

      Integer tototalReviews = allReviews.size();
    

    //distribution
    Map<Integer,Integer> ratingDistribution = new Map<Integer,Integer>();
    for(Integer i = 1 ; i<=5 ; i++){
        ratingDistribution.put(i,0); //ratingDistribution = {1:0,2:0,3:0,4:0,5:0}
    }

    for(Review__c review : allReviews){
        Integer rating = (Integer)review.Rating__c;
        Integer ratingDistributionValue = ratingDistribution.get(rating);
        ratingDistributionValue = ratingDistributionValue +1;
        ratingDistribution.put(rating,ratingDistributionValue);
    }

    ReviewWrapper reviewWrapper = new ReviewWrapper(allReviews,ratingDistribution,tototalReviews,averageRating);
    return reviewWrapper;
}


    
public class ReviewWrapper {
    @AuraEnabled
    public List<Review__c> reviews;
    @AuraEnabled
    public Map<Integer, Integer> ratingDistribution;
    @AuraEnabled
    public Integer totalReviews;
    @AuraEnabled 
    public Decimal averageRating;
    
    public ReviewWrapper(
      List<Review__c> reviews,
      Map<Integer, Integer> ratingDistribution,
      Integer totalReviews,
      Decimal averageRating
    ) {
      this.reviews = reviews;
      this.ratingDistribution = ratingDistribution;
      this.totalReviews = totalReviews;
      this.averageRating = averageRating;
    }
  }


}

//car --> multiple booking --> one booking can have multiple reviews