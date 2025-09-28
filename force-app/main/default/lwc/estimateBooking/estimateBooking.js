import { api } from "lwc";
import LightningModal from "lightning/modal";

export default class EstimateBooking extends LightningModal {
  @api recordId;

  get inputVariables() {
    return [
      {
        name: "recordId",
        type: "String",
        value: this.recordId
      }
    ];
  }

  handleStatusChange(event) {
    if (event.detail.status === "FINISHED") {
      this.close();
    }
  }
}