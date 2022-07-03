import { LightningElement, api, wire } from "lwc";
import { getRecord } from "lightning/uiRecordApi";

import CONTACT_NAME_FIELD from "@salesforce/schema/Contact.Name";
import CONTACT_MOBILEPHONE_FIELD from "@salesforce/schema/Contact.MobilePhone";

import setup from "@salesforce/apex/ChatController.setup";

export default class MessageBirdConfigurationWindow extends LightningElement {
  @api recordId;
  @api objectApiName;
  mobilePhone;

  @wire(getRecord, {
    recordId: "$recordId",
    fields: [CONTACT_NAME_FIELD, CONTACT_MOBILEPHONE_FIELD]
  })
  contact;

  handleOnSubmit(event) {
    event.preventDefault();
    if (this.validate()) {
      setup({
        recordId: this.recordId,
        mobilePhone: this.mobilePhone
      })
        .then((response) => {
          this.fireOnConfigurationEvent(response);
        })
        .cath((error) => {
          console.error("handleOnSubmit.error", error);
        });
    }
  }

  validate() {
    let mobilePhoneComponent = this.template.querySelector(
      "lightning-input[data-lwc-id=mobilephone]"
    );
    this.mobilePhone = mobilePhoneComponent.value.trim();
    if (!this.mobilePhone) {
      mobilePhoneComponent.setCustomValidity("");
    }
    return mobilePhoneComponent.reportValidity();
  }

  fireOnConfigurationEvent(setupResponse) {
    let onConfigureEvent = new CustomEvent("configure", {
      detail: {
        response: setupResponse,
        mobilePhone: this.mobilePhone
      }
    });
    this.dispatchEvent(onConfigureEvent);
  }
}
