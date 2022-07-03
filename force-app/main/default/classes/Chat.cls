public with sharing class Chat {
  Contact c;
  ChatServiceAPI chatAPI;
  ConversationHandler converHandler;
  Boolean hasPreviousConversation;
  public Chat(String recordId) {
    c = ChatQuery.getContact(recordId);
    this.hasPreviousConversation = String.isNotBlank(
      this.c.MessageBirdConversationId__c
    );
    this.chatAPI = new ChatServiceAPI();
    this.converHandler = new ConversationHandler(chatAPI);
  }

  public MessageResource send(String message) {
    if (!this.hasPreviousConversation) {
      handleConversation(message);
      return this.converHandler.getMessageResource();
    }
    return chatAPI.reply(this.c.MessageBirdConversationId__c, message);
  }

  public List<MessageResource> getMessages(Integer offset) {
    if (String.isBlank(this.c.MessageBirdConversationId__c)) {
      return new List<MessageResource>();
    }
    return chatAPI.getMessages(this.c.MessageBirdConversationId__c, offset);
  }

  public MessageResource getMessage(String messageId) {
    return chatAPI.getMessage(messageId);
  }

  public void setup(String phone) {
    this.converHandler.searchConversation(phone);
    if (this.converHandler.hasPreviousConversation()) {
      this.hasPreviousConversation = true;
      this.setMessageBirdInfo();
    } else {
      this.hasPreviousConversation = false;
    }
  }

  private void handleConversation(String message) {
    this.converHandler.start(this.c.MobilePhone, message);
    this.setMessageBirdInfo();
  }

  private void setMessageBirdInfo() {
    this.c.MessageBirdConversationId__c = this.converHandler.getConversationId();
    this.c.MessageBirdContactId__c = this.converHandler.getContactId();
  }

  public Boolean hasPreviousConversation() {
    return this.hasPreviousConversation;
  }

  public String getConversationId() {
    return this.converHandler.getConversationId();
  }

  public String getContactId() {
    return this.converHandler.getContactId();
  }

  public class ConversationHandler {
    ChatServiceAPI chatAPI;
    ConversationResource cr;
    MessageResource mr;
    Boolean hasPreviousConversation;

    public ConversationHandler(ChatServiceAPI chatAPI) {
      this.chatAPI = chatAPI;
      this.hasPreviousConversation = false;
    }

    public void searchConversation(String phone) {
      for (ConversationResource r : chatAPI.getConversations()) {
        if (
          r.contact.displayName.contains(phone) ||
          r.contact.displayName.equals(phone)
        ) {
          this.cr = r;
          this.hasPreviousConversation = true;
        }
      }
    }

    public void start(String toPhone, String message) {
      this.cr = chatAPI.start(toPhone, message);
      this.mr = chatAPI.getMessage(this.cr.messages.lastMessageId);
    }

    public String getConversationId() {
      return this.cr.id;
    }

    public String getContactId() {
      return this.cr.contactId;
    }

    public MessageResource getMessageResource() {
      return this.mr;
    }

    public Boolean hasPreviousConversation() {
      return this.hasPreviousConversation;
    }
  }
}
