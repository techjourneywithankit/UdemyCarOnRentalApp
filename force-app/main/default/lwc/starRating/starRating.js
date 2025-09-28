import { LightningElement, api } from "lwc";
import fivestar from "@salesforce/resourceUrl/fivestar";
import { loadStyle, loadScript } from "lightning/platformResourceLoader";

export default class StarRating extends LightningElement {
  @api value = 0;
  @api maxValue = 5;
  @api readOnly = false;
  isRendered = false;
  ratingObj;

  renderedCallback() {
    if (this.isRendered) {
      return;
    }
    this.loadScriptAndStyle();
    this.isRendered = true;
  }

  loadScriptAndStyle() {
    Promise.all([
      loadScript(this, fivestar + "/rating.js"),
      loadStyle(this, fivestar + "/rating.css")
    ])
      .then(() => {
        this.afterScriptsLoaded();
      })
      .catch((error) => {
        console.error(error);
      });
  }

  get starClass() {
    return this.readOnly ? "readonly c-rating" : "c-rating";
  }

  afterScriptsLoaded() {
    const domEl = this.template.querySelector("ul");
    const callback = (rating) => {
      this.value = rating;
      this.dispatchEvent(
        new CustomEvent("ratingchange", {
          detail: { rating }
        })
      );
    };

    this.ratingObj = window.rating(
      domEl,
      this.value,
      this.maxValue,
      callback,
      this.readOnly
    );
  }
}