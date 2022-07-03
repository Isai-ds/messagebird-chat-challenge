public with sharing class MessageList extends MessageBirdResource.MessageBirdListResource {
  private String conversationId;
  public MessageList(WhatsAppChannel channel, String conversationId) {
    super(channel);
    this.conversationId = conversationId;
  }

  public MessageList(
    WhatsAppChannel channel,
    String conversationId,
    Map<String, Object> params
  ) {
    super(channel, params);
    this.conversationId = conversationId;
  }

  public override String getResourceUri() {
    return '/v1/conversations/' + this.conversationId + '/messages';
  }

  public override Object createNew(MessageBirdClient channel, String response) {
    MessageResource resource = parseResorce(response);
    return new Message((WhatsAppChannel) channel, resource);
  }

  public Message reply(Map<String, Object> params) {
    return (Message) this.createPost(this.getResourceUri(), params);
  }

  public List<Message> getMessages() {
    List<Message> records = new List<Message>();

    for (Object o : this.getRecords()) {
      MessageResource resource = parseResorce(JSON.serialize(o));
      Message c = new Message((WhatsAppChannel) this.channel, resource);
      records.add(c);
    }
    return records;
  }

  private MessageResource parseResorce(String body) {
    return (MessageResource) JSON.deserialize(
      body.replace('to', 'toPhone').replace('from', 'fromPhone'),
      MessageResource.class
    );
  }
}
