import { LightningElement, api, wire } from "lwc";
import createFile from "@salesforce/apex/carImageController.createFile";
import getCarImages from "@salesforce/apex/carImageController.getCarImages";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { notifyRecordUpdateAvailable } from "lightning/uiRecordApi";
import { refreshApex } from "@salesforce/apex";

export default class CarImageManager extends LightningElement {
  isPrimaryChecked = true;
  @api recordId;
  @api hideUploadSection = false;

  @wire(getCarImages, {
    productId: "$recordId"
  })
  carImages;

  get hasProductImages() {
    let hasImagesPresent = false;
    if (this.carImages.data && this.carImages.data.length > 0) {
      hasImagesPresent = true;
    }
    return hasImagesPresent;
  }
  handlePrimaryImage(event) {
    this.isPrimaryChecked = event.target.checked;
  }

  async handleUploadFinished(event) {
    const uploadedFiles = event.detail.files;
    const carFile = uploadedFiles[0];

    let documentId = carFile.documentId;

    try {
      await createFile({
        documentId: documentId,
        recordId: this.recordId,
        isPrimaryImage: this.isPrimaryChecked
      });
      this.showToast("Success", "Image Uploaded Successfully", "success");
      //notify the LDS for the update
      await refreshApex(this.carImages);
      await notifyRecordUpdateAvailable([{ recordId: this.recordId }]);
    } catch (error) {
      this.showToast("Error", "Image Upload Failed", "error");
    }
  }

  showToast(title, message, variant) {
    const event = new ShowToastEvent({
      title: title,
      message: message,
      variant: variant
    });
    this.dispatchEvent(event);
  }

  get showUploadSection() {
    return !this.hideUploadSection; //true
  }
}