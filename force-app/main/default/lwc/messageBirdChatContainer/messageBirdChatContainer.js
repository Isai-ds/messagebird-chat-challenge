import { LightningElement, api } from "lwc";

export default class MessageBirdChatContainer extends LightningElement {
  _messages;
  notificator = false;

  @api
  set messages(value) {
    this._messages = value;
  }

  get messages() {
    return this._messages;
  }

  renderedCallback() {
    let component = this.template.querySelector("div[data-lwc-id=scroll]");
    let topPercentage =
      ((component.scrollTop + component.clientHeight) /
        component.scrollHeight) *
      100.0;
    if (topPercentage > 70.0) {
      component.scrollTop = component.scrollHeight;
    }
  }

  handleOnScroll(event) {
    event.preventDefault();
    let component = this.template.querySelector("div[data-lwc-id=scroll]");
    if (component.scrollTop === 0) {
      let scrollMessagesEvent = new CustomEvent("querymorebirdmessages", {
        bubbles: true
      });
      this.dispatchEvent(scrollMessagesEvent);
    }
    let topPercentage =
      ((component.scrollTop + component.clientHeight) /
        component.scrollHeight) *
      100.0;
    if (topPercentage > 60.0) {
      this.notificator = false;
    }
  }

  handleShowLastNotifications() {
    let component = this.template.querySelector("div[data-lwc-id=scroll]");
    component.scrollTop = component.scrollHeight;
    this.notificator = false;
  }

  @api
  scrollTopMessages() {
    let component = this.template.querySelector("div[data-lwc-id=scroll]");
    component.scrollTop = 10;
  }

  @api
  scrollBottomMessages() {
    let component = this.template.querySelector("div[data-lwc-id=scroll]");
    component.scrollTop = component.scrollHeight;
  }

  @api
  inboudNotification() {
    this.notificator = true;
  }
}
