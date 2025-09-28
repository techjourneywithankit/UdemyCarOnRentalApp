import { api } from "lwc";
import LightningModal from "lightning/modal";
import BOOKING_OBJECT from "@salesforce/schema/Booking__c";
import CONTACT_FIELD from "@salesforce/schema/Booking__c.Customer__c";
import START_DATE_FIELD from "@salesforce/schema/Booking__c.Start_Date_Time__c";
import END_DATE_FIELD from "@salesforce/schema/Booking__c.End_Date_Time__c";
import COUPON_CODE_FIELD from "@salesforce/schema/Booking__c.Coupon_Code__c";
import CAR_FIELD from "@salesforce/schema/Booking__c.Car__c";

export default class BookCarModal extends LightningModal {
  @api carId;

  // Expose the object and fields to the template
  objectApiName = BOOKING_OBJECT.objectApiName;
  contactField = CONTACT_FIELD.fieldApiName;
  startDateField = START_DATE_FIELD.fieldApiName;
  endDateField = END_DATE_FIELD.fieldApiName;
  couponCodeField = COUPON_CODE_FIELD.fieldApiName;
  carField = CAR_FIELD.fieldApiName;

  handleCancel() {
    this.close("Cancel");
  }

  handleSubmit(event) {
    //stop the form from submitting
    event.preventDefault();
    //get the form fields
    const fields = event.detail.fields;
    //set the car field
    fields[CAR_FIELD.fieldApiName] = this.carId; //assignig the car to the booking.
    //submit the form
    this.template.querySelector("lightning-record-edit-form").submit(fields);
  }

  handleError(event) {
    console.log("Error " + event.detail.errorMessage);
  }

  handleSuccess(event) {
    //1. close the modal
    //2. navigate to the booking record
    //Booking Id ?
    console.log(JSON.stringify(event.detail));
    const bookingId = event.detail.id;
    this.close({
      output: "success",
      bookingId: bookingId
    });
  }
}