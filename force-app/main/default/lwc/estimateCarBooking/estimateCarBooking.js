import { api } from "lwc";
import LightningModal from "lightning/modal";
export default class EstimateCarBooking extends LightningModal {
  @api carId;
  get inputVariables() {
    return [
      {
        name: "recordId",
        type: "String",
        value: this.carId
      }
    ];
  }

  handleStatusChange(event) {
    if (event.detail.status === "FINISHED") {
      // set behavior after a finished flow interview
      this.close("Success");
    }
  }
}