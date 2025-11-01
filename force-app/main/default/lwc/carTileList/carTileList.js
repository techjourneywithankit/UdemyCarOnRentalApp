import { LightningElement,wire } from 'lwc';
// Import message service features required for subscribing and the message channel
import {
    publish,
    subscribe,
    unsubscribe,
    APPLICATION_SCOPE,
    MessageContext,
} from 'lightning/messageService';
import recordSelected from '@salesforce/messageChannel/carFilter__c';
import getCars from "@salesforce/apex/carTileListController.getCars"
import carSelection from "@salesforce/messageChannel/carSelection__c";
import BookCarModal from "c/bookCarModal";
import EstimateCarBooking from "c/estimateCarBooking";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { NavigationMixin } from "lightning/navigation";
import BOOKING_OBJECT from "@salesforce/schema/Booking__c";

export default class CarTileList extends LightningElement {
    subscription = null;
    filters;
    showInitialMessage = true;

    @wire(MessageContext)
    messageContext;

    @wire(getCars,{
        filters: '$filters'
    }) cars;

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

    unsubscribeToMessageChannel() {
        unsubscribe(this.subscription);
        this.subscription = null;
    }

    handleMessage(message){
        console.log('message ', message);
        this.filters = {...message.selCarFilter.filters}
        this.showInitialMessage = false;
    }

    get isRecordsFound(){
        console.log('this.cars.data ', this.cars.data);
        return this.cars.data && this.cars.data.length > 0;
    }

    handleCarSelected(event) {
    console.log("handleCarSelected");
    const payload = { carId: event.detail };
    publish(this.messageContext, carSelection, payload);
   }

  handleEstimateBooking(event) {
    console.log("handleEstimateBooking");
    EstimateCarBooking.open({
      carId: event.detail,
      size: "medium"
    });
  }

  handleBookNow(event) {
    console.log("handleBookNow");

    BookCarModal.open({
      carId: event.detail,
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