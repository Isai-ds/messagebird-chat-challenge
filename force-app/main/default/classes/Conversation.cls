public with sharing class Conversation extends MessageBirdResource.MessageBirdSingleResource {
  private ConversationResource resource;

  public Conversation(WhatsAppChannel channel, ConversationResource resource) {
    super(channel);
    this.resource = resource;
    this.id = resource.id;
  }

  public Conversation(WhatsAppChannel channel, String id) {
    super(channel);
    this.id = id;
  }

  public override void parseResponse(MessageBirdRestResponse response) {
    this.resource = (ConversationResource) JSON.deserialize(
      response.getResponseBody(),
      ConversationResource.class
    );
  }

  public ConversationResource getResource() {
    this.get();
    return this.resource;
  }

  public override Object get() {
    if (this.resource == null) {
      this.getResource(new Map<String, Object>());
    }
    return this.resource;
  }

  public override String getResourceUri() {
    return '/v1/conversations/' + this.id;
  }
}
