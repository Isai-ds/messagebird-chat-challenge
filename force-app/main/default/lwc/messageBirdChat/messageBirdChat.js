import { LightningElement, wire, api, track } from "lwc";
import { subscribe } from "lightning/empApi";
import {
  getRecord,
  updateRecord,
  getRecordNotifyChange
} from "lightning/uiRecordApi";

import USER_Id_FIELD from "@salesforce/user/Id";
import CONTACT_ID_FIELD from "@salesforce/schema/Contact.Id";
import CONTACT_NAME_FIELD from "@salesforce/schema/Contact.Name";
import CONTACT_MESSAGEBIRDCONTACTID_FIELD from "@salesforce/schema/Contact.MessageBirdContactId__c";
import CONTACT_MESSAGEBIRDCONVERSATIONID_FIELD from "@salesforce/schema/Contact.MessageBirdConversationId__c";
import CONTACT_MESSAGEBIRDDISPLAYWINDOWCONFIGURATION_FIELD from "@salesforce/schema/Contact.MessageBirdDisplayWindowConfiguration__c";
import CONTACT_MOBILEPHONE_FIELD from "@salesforce/schema/Contact.MobilePhone";

import getContextUser from "@salesforce/apex/ChatController.getContextUser";
import send from "@salesforce/apex/ChatController.send";
import getInitialMessages from "@salesforce/apex/ChatController.getInitialMessages";
import getMessages from "@salesforce/apex/ChatController.getMessages";
import getMessage from "@salesforce/apex/ChatController.getMessage";

const DELAY = 100;
const channelName = "/event/MessageEvent__e";
const SCROLL_BOTTOM = "BOTTOM";
const SCROLL_TOP = "TOP";
export default class MessageBirdChat extends LightningElement {
  userId = USER_Id_FIELD;
  message;
  @track contact = { data: {}, error: {} };
  @track messages = { data: [], error: {} };

  @track _scrollObject = {
    currentTopValue: 0,
    oldTopValue: 0,
    currentSendValue: 0,
    oldSendValue: 0,
    initial: 0,
    preventFireScrollEvent: false
  };
  _recordId;
  _objectApiName;
  _displayWindowSetup = false;
  _displayChat = false;
  _offset = 0;
  _spinner = false;
  _isRecordUpdated = false;

  connectedCallback() {
    this.handleSubscribe();
  }

  renderedCallback() {
    this._scrollObject.initial++;
    if (this._scrollObject.initial === 2 && this._displayChat) {
      this.scrollChatContainer(SCROLL_BOTTOM);
    }
    if (
      this._scrollObject.oldSendValue !== this._scrollObject.currentSendValue
    ) {
      this.scrollChatContainer(SCROLL_BOTTOM);
    } else if (
      this._scrollObject.oldTopValue !== this._scrollObject.currentTopValue
    ) {
      this.scrollChatContainer(SCROLL_TOP);
    }
    console.log("messageBirdChat.renderedCallback", this._scrollObject.initial);
  }

  scrollChatContainer(direction) {
    let container = this.template.querySelector(
      "c-message-bird-chat-container"
    );
    if (direction === SCROLL_BOTTOM) {
      container.scrollBottomMessages();
    } else if (direction === SCROLL_TOP) {
      container.scrollTopMessages();
    }
  }

  handleOnSend(event) {
    this.message = event.detail;
    window.clearTimeout(this.delayTimeout);
    // eslint-disable-next-line @lwc/lwc/no-async-operation
    this.delayTimeout = setTimeout(() => {
      this.scrollChatContainer(SCROLL_BOTTOM);
      this.sendMessage();
    }, DELAY);
  }

  sendMessage() {
    send({
      recordId: this.recordId,
      message: this.message
    })
      .then((response) => {
        if (response.messageResource) {
          this.appendNewMessage(response.messageResource);
        }
        if (!response.hasPreviousConversation && !this._isRecordUpdated) {
          let fields = this.getContactFields(response);
          this.updateContact(fields)
            .then(() => {
              this._isrecordUpdated = true;
              getRecordNotifyChange([{ recordId: this.recordId }]);
            })
            .catch((error) => {
              console.log(error);
            });
        }
      })
      .cath((error) => {
        console.log("error", error);
      });
  }

  getContactFields(response) {
    var fields = {};
    fields[CONTACT_ID_FIELD.fieldApiName] = this.recordId;
    if (!response.hasPreviousConversation) {
      fields[CONTACT_MESSAGEBIRDCONTACTID_FIELD.fieldApiName] =
        response.setupInfo.contactId;
      fields[CONTACT_MESSAGEBIRDCONVERSATIONID_FIELD.fieldApiName] =
        response.setupInfo.conversationId;
    }
    return fields;
  }

  getContactFieldsSetup(detail) {
    let response = detail.response;
    var fields = {};
    fields[CONTACT_ID_FIELD.fieldApiName] = this.recordId;
    if (response.hasPreviousConversation) {
      fields[CONTACT_MESSAGEBIRDCONTACTID_FIELD.fieldApiName] =
        response.setupInfo.contactId;
      fields[CONTACT_MESSAGEBIRDCONVERSATIONID_FIELD.fieldApiName] =
        response.setupInfo.conversationId;
    }
    fields[
      CONTACT_MESSAGEBIRDDISPLAYWINDOWCONFIGURATION_FIELD.fieldApiName
    ] = true;
    fields[CONTACT_MOBILEPHONE_FIELD.fieldApiName] = detail.mobilePhone;
    return fields;
  }

  updateContact(fields) {
    return new Promise(function (resolve, reject) {
      updateRecord({ fields })
        .then(() => {
          resolve();
        })
        .catch((error) => {
          reject(error);
        });
    });
  }

  @wire(getContextUser, { recordId: "$userId" })
  user;

  @wire(getRecord, {
    recordId: "$recordId",
    fields: [
      CONTACT_NAME_FIELD,
      CONTACT_MESSAGEBIRDCONTACTID_FIELD,
      CONTACT_MESSAGEBIRDCONVERSATIONID_FIELD,
      CONTACT_MESSAGEBIRDDISPLAYWINDOWCONFIGURATION_FIELD,
      CONTACT_MOBILEPHONE_FIELD
    ]
  })
  wiredContact({ error, data }) {
    if (data) {
      this.contact.data = data;
      this.contact.error = undefined;
      this._displayWindowSetup =
        !this.contact.data.fields.MessageBirdDisplayWindowConfiguration__c
          .value;
      this._displayChat =
        this.contact.data.fields.MessageBirdDisplayWindowConfiguration__c.value;
    } else if (error) {
      this.contact.error = error;
      this.contact.data = undefined;
      console.error("wiredContact.error", error);
    }
  }

  parseMessage(record) {
    let tempData = Object.assign({}, record);
    tempData.createdDatetime = new Date(tempData.createdDatetime);
    tempData.localTime = tempData.createdDatetime.toLocaleTimeString([], {
      hour: "2-digit",
      minute: "2-digit"
    });
    return tempData;
  }

  appendNewMessage(data) {
    let newMessage = this.parseMessage(data);
    this.messages.data.push(newMessage);
  }

  @wire(getMessages, { recordId: "$recordId", offset: "$_offset" })
  wiredMessages({ error, data }) {
    if (data) {
      this.handleMessageHistoryChat(data);
    } else if (error) {
      this.messages.error = error;
      this.messages.data = undefined;
      console.error("wiredMessages.error", error);
    }
    this._spinner = false;
  }

  handleMessageHistoryChat(data) {
    if (data.length) {
      let tempDataArray = [];
      let self = this;
      Object.keys(data)
        .reverse()
        .forEach(function (index) {
          let tempData = self.parseMessage(data[index]);
          tempDataArray.push(tempData);
        });
      this.messages.data = [...tempDataArray, ...this.messages.data];
      this.messages.error = undefined;
      this._scrollObject.preventFireScrollEvent = false;
    }
  }

  handleIndboudMessages(messageId) {
    // eslint-disable-next-line @lwc/lwc/no-async-operation
    this.delayTimeout = setTimeout(() => {
      getMessage({
        recordId: this.recordId,
        messageId: messageId
      })
        .then((response) => {
          this.handleInboudNotifications();
          this.appendNewMessage(response);
        })
        .catch((error) => {
          console.error("handleIndboudMessages.error", error);
        });
    }, DELAY);
  }

  handleInboudNotifications() {
    let component = this.template.querySelector(
      "c-message-bird-chat-container"
    );
    component.inboudNotification();
  }

  handleSubscribe() {
    // Callback invoked whenever a new event message is received
    const self = this;
    const messageCallback = function (response) {
      let sfContactConversationId =
        self.contact.data.fields.MessageBirdConversationId__c.value;
      let sfContactContactId =
        self.contact.data.fields.MessageBirdContactId__c.value;
      if (sfContactConversationId && sfContactContactId) {
        if (
          response.data.payload.ContactId__c === sfContactContactId &&
          response.data.payload.ConversationId__c === sfContactConversationId
        ) {
          if (response.data.payload.Direction__c === "received") {
            console.log("ContactId__c", response.data.payload.ContactId__c);
            console.log(
              "ConversationId__c",
              response.data.payload.ConversationId__c
            );
            console.log("Type__c", response.data.payload.Type__c);
            self.handleIndboudMessages(response.data.payload.MessageId__c);
          }
        }
      }
    };

    // Invoke subscribe method of empApi. Pass reference to messageCallback
    subscribe(channelName, -1, messageCallback).then((response) => {
      console.log("Subscription request");
      this.subscription = response;
    });
  }

  handleOnScrollmessages() {
    if (!this._scrollObject.preventFireScrollEvent) {
      this._spinner = true;
      this._scrollObject.oldTopValue = this._scrollObject.currentTopValue;
      this._scrollObject.currentTopValue++;
      this._offset += 10;
      this._scrollObject.preventFireScrollEvent = true;
    }
  }

  @api set recordId(value) {
    this._recordId = value;
  }

  get recordId() {
    return this._recordId;
  }

  @api set objectApiName(value) {
    this._objectApiName = value;
  }

  get objectApiName() {
    return this._objectApiName;
  }

  mobilePhone;

  handleOnConfigure(event) {
    this._spinner = true;
    let fields = this.getContactFieldsSetup(event.detail);
    this.updateContact(fields)
      .then(() => {
        getInitialMessages({ recordId: this.recordId })
          .then((responseInitial) => {
            this.handleMessageHistoryChat(responseInitial);
            this._spinner = false;
          })
          .catch((error) => {
            this.messages.error = error;
            this.messages.data = undefined;
            console.error("handleOnConfigure.getInitialMessages.error", error);
          });
        getRecordNotifyChange([{ recordId: this.recordId }]);
      })
      .catch((error) => {
        console.error("handleOnConfigure.updateContact.error", error);
      });
  }
}
