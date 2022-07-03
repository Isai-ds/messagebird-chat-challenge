import { LightningElement, api } from "lwc";

export default class MessageBirdChatMessage extends LightningElement {
  isInbound = false;
  isOutbound = false;
  _message;
  @api
  set message(value) {
    this._message = value;
    this.isInbound = this._message.direction === "received" ? true : false;
    this.isOutbound = this._message.direction === "sent" ? true : false;
  }
  get message() {
    return this._message;
  }
}
