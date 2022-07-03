import { LightningElement, api } from "lwc";

export default class ChatPublisher extends LightningElement {
  _initials;
  _userName;

  handleKeyChange(event) {
    if (event.keyCode === 13) {
      this.sendingMessage(event.target.value);
      event.target.value = "";
    }
  }
  send() {
    let textMessageComponent = this.template.querySelector(
      "textarea[data-lwc-id=message]"
    );
    this.sendingMessage(textMessageComponent.value);
    textMessageComponent.value = "";
  }

  sendingMessage(message) {
    if (message && message.trim()) {
      let onsendEvent = new CustomEvent("send", {
        detail: message
      });
      this.dispatchEvent(onsendEvent);
    }
  }

  @api
  set userName(value) {
    let fisrtName = value.split(" ")[0];
    let lastName = value.split(" ")[1];
    this._userName = value;
    this._initials = fisrtName[0] + lastName[0];
  }

  get userName() {
    return this._userName;
  }
}
