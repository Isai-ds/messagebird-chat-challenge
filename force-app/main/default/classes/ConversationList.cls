public with sharing class ConversationList extends MessageBirdResource.MessageBirdListResource {
  public ConversationList(WhatsAppChannel channel) {
    super(channel);
  }

  public ConversationList(WhatsAppChannel channel, Map<String, Object> params) {
    super(channel, params);
  }

  public override String getResourceUri() {
    return '/v1/conversations/';
  }

  public override Object createNew(MessageBirdClient channel, String response) {
    ConversationResource resource = (ConversationResource) JSON.deserialize(
      response,
      ConversationResource.class
    );
    return new Conversation((WhatsAppChannel) channel, resource);
  }

  public Conversation start(Map<String, Object> params) {
    return (Conversation) this.createPost(
      this.getResourceUri() + 'start',
      params
    );
  }

  public List<Conversation> getConversations() {
    List<Conversation> records = new List<Conversation>();

    for (Object o : this.getRecords()) {
      ConversationResource resource = (ConversationResource) JSON.deserialize(
        JSON.serialize(o),
        ConversationResource.class
      );
      Conversation c = new Conversation(
        (WhatsAppChannel) this.channel,
        resource
      );
      records.add(c);
    }
    return records;
  }
}
