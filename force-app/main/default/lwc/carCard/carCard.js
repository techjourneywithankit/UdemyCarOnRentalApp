import { LightningElement, wire } from "lwc";
// Import message service features required for subscribing and the message channel
import {
  subscribe,
  unsubscribe,
  APPLICATION_SCOPE,
  MessageContext
} from "lightning/messageService";
import recordSelected from "@salesforce/messageChannel/carSelection__c";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import NAME_FIELD from "@salesforce/schema/Car__c.Name";
import MODEL_FIELD from "@salesforce/schema/Car__c.Model__c";
import CAR_FAMILY_FIELD from "@salesforce/schema/Car__c.Car_Family__c";
import SEATS_FIELD from "@salesforce/schema/Car__c.Number_of_Seats__c";
import TRANSMISSION_FIELD from "@salesforce/schema/Car__c.Transmission_Type__c";
import FUEL_TYPE_FIELD from "@salesforce/schema/Car__c.Fuel_Type__c";
import RENTAL_RATE_FIELD from "@salesforce/schema/Car__c.Rental_Rate_Per_Day__c";
import DESCRIPTION_FIELD from "@salesforce/schema/Car__c.Car_Description__c";
import RATING_FIELD from "@salesforce/schema/Car__c.Average_Rating__c";
import BookCarModal from "c/bookCarModal";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { NavigationMixin } from "lightning/navigation";
import BOOKING_OBJECT from "@salesforce/schema/Booking__c";

const FIELDS = [
  NAME_FIELD,
  MODEL_FIELD,
  CAR_FAMILY_FIELD,
  SEATS_FIELD,
  TRANSMISSION_FIELD,
  FUEL_TYPE_FIELD,
  RENTAL_RATE_FIELD,
  DESCRIPTION_FIELD,
  RATING_FIELD
];

export default class CarCard extends NavigationMixin(LightningElement) {
  subscription = null;
  recordId;
  productName;
  modelField;
  carFamilyField;
  seatingCapacityBadge;
  transmissionBadge;
  fuelTypeBadge;
  rentalRateBadge;
  descriptionField;
  hasData = false;

  @wire(MessageContext)
  messageContext;

  @wire(getRecord, { recordId: "$recordId", fields: FIELDS })
  wiredData({ error, data }) {
    if (data) {
      this.productName = getFieldValue(data, NAME_FIELD);
      this.modelField = getFieldValue(data, MODEL_FIELD);
      this.carFamilyField = getFieldValue(data, CAR_FAMILY_FIELD);

      const seatingCapacity = getFieldValue(data, SEATS_FIELD);
      this.seatingCapacityBadge = seatingCapacity + "Seats";

      const transmission = getFieldValue(data, TRANSMISSION_FIELD);
      this.transmissionBadge = transmission ? transmission : "N/A";

      const fuelType = getFieldValue(data, FUEL_TYPE_FIELD);
      this.fuelTypeBadge = fuelType ? fuelType : "N/A";

      const rentalRate = getFieldValue(data, RENTAL_RATE_FIELD);
      this.rentalRateBadge = rentalRate ? `$${rentalRate}/day` : "N/A";

      this.descriptionField = getFieldValue(data, DESCRIPTION_FIELD);

      this.hasData = true;
    } else if (error) {
      console.log(error);
    }
  }

  // Standard lifecycle hooks used to subscribe and unsubsubscribe to the message channel
  connectedCallback() {
    this.subscribeToMessageChannel();
  }

  disconnectedCallback() {
    this.unsubscribeToMessageChannel();
  }

  // Encapsulate logic for Lightning message service subscribe and unsubsubscribe
  subscribeToMessageChannel() {
    if (!this.subscription) {
      this.subscription = subscribe(
        this.messageContext,
        recordSelected,
        (message) => this.handleMessage(message),
        { scope: APPLICATION_SCOPE }
      );
    }
  }

  handleMessage(message) {
    console.log("message", message.carId);
    this.recordId = message.carId;
    this.hasData = false;
  }
  unsubscribeToMessageChannel() {
    unsubscribe(this.subscription);
    this.subscription = null;
  }

  handleBookNow(event) {
    BookCarModal.open({
      carId: this.recordId,
      size: "medium"
    }).then((result) => {
      if (result && result.output === "success") {
        //show the toast message
        this.showToast("Success", "Booking Created Successfully", "success");
        //navigate the user to the booking record.
        let bookingId = result.bookingId;

        let pageReferenceOfBooking = {
          type: "standard__recordPage",
          attributes: {
            recordId: bookingId,
            objectApiName: BOOKING_OBJECT.objectApiName,
            actionName: "view"
          }
        };
        // Navigate to the Account home page
        this[NavigationMixin.Navigate](pageReferenceOfBooking);
      }
    });
  }

  showToast(title, message, variant) {
    const event = new ShowToastEvent({
      title: title,
      message: message,
      variant: variant
    });
    this.dispatchEvent(event);
  }
}