public with sharing class WebHook extends MessageBirdResource.MessageBirdSingleResource {
  WebHookResource resource;
  public WebHook(WhatsAppChannel channel, WebHookResource resource) {
    super(channel);
    this.resource = resource;
    this.id = resource.id;
  }

  public WebHook(WhatsAppChannel channel, String id) {
    super(channel);
    this.id = id;
  }

  public override void parseResponse(MessageBirdRestResponse response) {
    this.resource = (WebHookResource) JSON.deserialize(
      response.getResponseBody().replace('from', 'from1'),
      WebHookResource.class
    );
  }

  public WebHookResource getResource() {
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
    return '/v1/webhooks/' + this.id;
  }
}
