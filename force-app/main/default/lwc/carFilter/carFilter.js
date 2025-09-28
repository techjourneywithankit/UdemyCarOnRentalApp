import { LightningElement, wire } from "lwc";
import PICKUP_LOCATION from "@salesforce/schema/Car__c.PickupLocation__c";
import TRANSMISSION_TYPE from "@salesforce/schema/Car__c.Transmission_Type__c";
import FUEL_TYPE from "@salesforce/schema/Car__c.Fuel_Type__c";
import { getPicklistValues } from "lightning/uiObjectInfoApi";
// Import message service features required for publishing and the message channel
import { publish, MessageContext } from "lightning/messageService";
import recordSelected from "@salesforce/messageChannel/carFilter__c";
const DELAY = 350;
export default class CarFilter extends LightningElement {
  filters = {
    searhKey: "",
    maxSeats: 8,
    startDate: null,
    endDate: null,
    maxRentalRate: 10000,
    minRating: 0,
    pickupLocation: "Delhi",
    transmissionType: [],
    fuelType: []
  };
  delayTimeout;

  @wire(MessageContext)
  messageContext;

  @wire(getPicklistValues, {
    recordTypeId: "012000000000000AAA",
    fieldApiName: PICKUP_LOCATION
  })
  pickupLocationValues;

  @wire(getPicklistValues, {
    recordTypeId: "012000000000000AAA",
    fieldApiName: TRANSMISSION_TYPE
  })
  transmissionTypeValues;

  @wire(getPicklistValues, {
    recordTypeId: "012000000000000AAA",
    fieldApiName: FUEL_TYPE
  })
  fuelTypeValues;

  handleSearchChange(event) {
    this.filters.searhKey = event.target.value;
    this.publishFilter();
  }
  handlePickupLocationChange(event) {
    this.filters.pickupLocation = event.detail.value;
    this.publishFilter();
  }
  handleStartDateChange(event) {
    this.filters.startDate = event.detail.value;
    this.publishFilter();
  }
  handleEndDateChange(event) {
    this.filters.endDate = event.detail.value;
    this.publishFilter();
  }
  handleMaxSeatsChange(event) {
    this.filters.maxSeats = event.target.value;
    this.publishFilter();
  }
  handleMaxRentalRateChange(event) {
    this.filters.maxRentalRate = event.target.value;
    this.publishFilter();
  }
  handleMinRatingChange(event) {
    this.filters.minRating = event.target.value;
    this.publishFilter();
  }

  handleCheckboxChange(event) {
    const value = event.target.dataset.value;
    const name = event.target.name;

    //1. User have either checked the checkbox or unchecked the checkbox
    //1. If user have checked the checkbox
    //1.1 Add the value to the array
    //1.2 If user have unchecked the checkbox, i am not touching the other values.

    if (name === "transmissionType") {
      if (event.target.checked) {
        if (!this.filters.transmissionType.includes(value)) {
          this.filters.transmissionType.push(value);
        }
      } else {
        //keep all the existing values, except the values unchecked by user
        this.filters.transmissionType = this.filters.transmissionType.filter(
          (item) => item !== value
        );
      }
    }

    if (name === "fuelType") {
      if (event.target.checked) {
        if (!this.filters.fuelType.includes(value)) {
          this.filters.fuelType.push(value);
        }
      } else {
        this.filters.fuelType = this.filters.fuelType.filter(
          (item) => item !== value
        );
      }
    }
    this.publishFilter();
  }

  validateFilters() {
    let isValid = true;
    //Access the start date and end date
    const startDate = this.template.querySelector(".startDateClass");
    const endDate = this.template.querySelector(".endDateClass");

    //set the error message to blank
    startDate.setCustomValidity("");
    endDate.setCustomValidity("");

    //validate the start date and end date is required
    if (!this.filters.startDate) {
      startDate.setCustomValidity("Start date is required");
      isValid = false;
    }

    if (!this.filters.endDate) {
      endDate.setCustomValidity("End date is required");
      isValid = false;
    }

    //validate the start date is less than end date
    if (this.filters.startDate && this.filters.endDate) {
      if (this.filters.startDate > this.filters.endDate) {
        startDate.setCustomValidity("Start date should be less than end date");
        isValid = false;
      }
    }

    //report the message
    startDate.reportValidity();
    endDate.reportValidity();

    return isValid;
  }
  publishFilter() {
    console.log("filters", this.filters);
    if (this.validateFilters()) {
      //publish the event with debounding
      clearTimeout(this.delayTimeout);
      this.delayTimeout = setTimeout(() => {
        //publish the changes to the message channel
        const payload = {
          selCarFilter: {
            filters: this.filters
          }
        };
        publish(this.messageContext, recordSelected, payload);
        console.log("payload", payload);
        console.log("Filter Published Successfully");
      }, DELAY);
    }
  }
}