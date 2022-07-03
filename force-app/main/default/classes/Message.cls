public with sharing class Message extends MessageBirdResource.MessageBirdSingleResource {
  private MessageResource resource;
  public Message(WhatsAppChannel channel, MessageResource resource) {
    super(channel);
    this.resource = resource;
    this.id = resource.id;
  }

  public Message(WhatsAppChannel channel, String id) {
    super(channel);
    this.id = id;
  }

  public override void parseResponse(MessageBirdRestResponse response) {
    this.resource = (MessageResource) JSON.deserialize(
      response.getResponseBody()
        .replace('to', 'toPhone')
        .replace('from', 'fromPhone'),
      MessageResource.class
    );
  }

  public MessageResource getResource() {
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
    return '/v1/messages/' + this.id;
  }
}
