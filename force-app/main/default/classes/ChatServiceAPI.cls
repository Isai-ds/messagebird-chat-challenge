public with sharing class ChatServiceAPI {
  MessageBirdConfiguration__mdt messageBirdConfig;
  WhatsAppChannel channel;

  public ChatServiceAPI() {
    this.messageBirdConfig = MessageBirdConfiguration__mdt.getInstance(
      'WhatsAppChannel'
    );
    this.channel = new WhatsAppChannel(messageBirdConfig.AccessKey__c);
  }

  public List<MessageResource> getMessages(
    String conversationId,
    Integer offset
  ) {
    WhatsAppHandler handler = (new WhatsAppHandler(this.channel));
    Map<String, Object> params = new Map<String, Object>{
      'offset' => String.valueOf(offset)
    };
    List<MessageResource> messages = new List<MessageResource>();

    for (Message msg : handler.getMessages(conversationId, params)) {
      messages.add(msg.getResource());
    }
    return messages;
  }

  public List<ConversationResource> getConversations() {
    WhatsAppHandler handler = (new WhatsAppHandler(this.channel));
    List<ConversationResource> conversations = new List<ConversationResource>();
    Map<String, Object> params = new Map<String, Object>{ 'limit' => '20' };
    for (Conversation c : handler.getConversations(params)) {
      conversations.add(c.getResource());
    }
    return conversations;
  }

  public MessageResource reply(String conversationId, String message) {
    Map<String, Object> params = new Map<String, Object>{
      'channelId' => this.messageBirdConfig.ChannelId__c,
      'type' => 'text',
      'content' => new Map<String, String>{ 'text' => message }
    };
    WhatsAppHandler handler = (new WhatsAppHandler(this.channel));
    return (handler.reply(conversationId, params)).getResource();
  }

  public ConversationResource start(String toPhone, String message) {
    Map<String, Object> params = new Map<String, Object>{
      'to' => toPhone,
      'channelId' => messageBirdConfig.ChannelId__c,
      'type' => 'text',
      'content' => new Map<String, String>{ 'text' => message }
    };
    WhatsAppHandler handler = (new WhatsAppHandler(this.channel));
    return (handler.start(params)).getResource();
  }

  public MessageResource getMessage(String messageId) {
    WhatsAppHandler handler = (new WhatsAppHandler(this.channel));
    return (handler.getMessage(messageId)).getResource();
  }
}
