public with sharing class WhatsAppHandler {
  WhatsAppChannel channel;
  public WhatsAppHandler(WhatsAppChannel channel) {
    this.channel = channel;
  }

  public List<WebHook> getWebHooks() {
    return this.getWebHooks(new Map<String, Object>());
  }

  public List<WebHook> getWebHooks(Map<String, Object> params) {
    WebHookList webHookList = new WebHookList(channel, params);
    return webHookList.getWebHooks();
  }

  public WebHook createWebHook(Map<String, Object> params) {
    WebHookList webHookList = new WebHookList(channel, params);
    return webHookList.create(params);
  }

  public Message getMessage(String conversationId) {
    Message msg = new Message(channel, conversationId);
    return msg;
  }

  public List<Message> getMessages(String conversationId) {
    return this.getMessages(conversationId, new Map<String, Object>());
  }

  public List<Message> getMessages(
    String conversationId,
    Map<String, Object> params
  ) {
    MessageList messageList = new MessageList(channel, conversationId, params);
    return messageList.getMessages();
  }

  public Message reply(String conversationId, Map<String, Object> params) {
    MessageList messageList = new MessageList(channel, conversationId, params);
    return messageList.reply(params);
  }

  public List<Conversation> getConversations() {
    return this.getConversations(new Map<String, Object>());
  }

  public List<Conversation> getConversations(Map<String, Object> params) {
    ConversationList conversationList = new ConversationList(channel, params);
    return conversationList.getConversations();
  }

  public Conversation start(Map<String, Object> params) {
    ConversationList conversationList = new ConversationList(channel, params);
    return conversationList.start(params);
  }
}
