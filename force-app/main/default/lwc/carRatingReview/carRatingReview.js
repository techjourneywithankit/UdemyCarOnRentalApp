import { LightningElement, wire, api } from "lwc";
import getCarReviews from "@salesforce/apex/CarReviewController.getCarReview";

export default class CarRatingReview extends LightningElement {
  @api recordId;
  reviews = [];
  averageRating = 0;
  ratingDistribution = {};
  totalReviews = 0;
  hasData = false;

  @wire(getCarReviews, {
    carId: "$recordId"
  })
  wiredReviews({ data, error }) {
    if (data) {
      this.reviews = data.reviews;
      this.averageRating = data.averageRating;
      this.ratingDistribution = data.ratingDistribution;
      this.totalReviews = data.totalReviews;
      this.processReviews();
      this.hasData = true;
    } else if (error) {
      this.error = error;
      this.allReviews = undefined;
    }
  }

  processReviews() {
    if (this.reviews) {
      this.reviews = this.reviews.map((review) => {
        return {
          ...review,
          CreatedDateFormatted: this.formatDate(review.CreatedDate)
        };
      });
    }
  }

  formatDate(dateString) {
    const date = new Date(dateString);
    return date.toLocaleDateString("en-US", {
      year: "numeric",
      month: "long",
      day: "numeric"
    });
  }

  get ratingDistributionList() {
    const distribution = [];
    for (let i = 5; i >= 1; i--) {
      //let 3 customer have provided 5 rating
      //let 2 customer have provided 8 rating

      //3 customers / 5 customers = 60%
      //2 customers / 5 customers = 40%
      const count = this.ratingDistribution[i];
      const totalReview = this.totalReviews;
      let fixedPercentage;
      if (totalReview > 0) {
        const percentage = (count / totalReview) * 100;
        fixedPercentage = percentage.toFixed(2);
      } else {
        fixedPercentage = 0;
      }

      let ratingDistributionObj = {
        rating: i,
        count: count,
        percentage: fixedPercentage
      };
      distribution.push(ratingDistributionObj);
    }
    return distribution;
  }
}