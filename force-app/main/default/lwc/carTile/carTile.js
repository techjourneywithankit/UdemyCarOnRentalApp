import { LightningElement, api } from "lwc";

export default class CarTile extends LightningElement {
  __car;
  pictureUrl;
  name;
  rentalRate;
  transmissionType;
  fuelType;
  numberOfSeats;
  averageRating = 0;
  @api
  get car() {
    return this.__car;
  }

  set car(value) {
    this.__car = value;
    this.pictureUrl = value.Primary_Image_Url__c;
    this.name = value.Name;
    this.rentalRate = value.Rental_Rate_Per_Day__c;
    this.transmissionType = `Transmission: ${value.Transmission_Type__c}`;
    this.fuelType = `Fuel Type: ${value.Fuel_Type__c}`;
    this.numberOfSeats = value.Number_of_Seats__c;
    this.averageRating = value.Average_Rating__c || 0;
  }

  handleClick() {
    const carSelected = new CustomEvent("carselected", {
      detail: this.car.Id
    });
    this.dispatchEvent(carSelected);
  }

  handleEstimateBookingClick() {
    const estimateBooking = new CustomEvent("estimatebooking", {
      detail: this.car.Id
    });
    this.dispatchEvent(estimateBooking);
  }

  handleBookNowClick() {
    const bookNow = new CustomEvent("booknow", {
      detail: this.car.Id
    });
    this.dispatchEvent(bookNow);
  }
}