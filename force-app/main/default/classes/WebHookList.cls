public with sharing class WebHookList extends MessageBirdResource.MessageBirdListResource {
  public WebHookList(WhatsAppChannel channel) {
    super(channel);
  }

  public WebHookList(WhatsAppChannel channel, Map<String, Object> params) {
    super(channel, params);
  }

  public override String getResourceUri() {
    return '/v1/webhooks/';
  }

  public override Object createNew(MessageBirdClient channel, String response) {
    WebHookResource resource = parseResorce(response);
    return new WebHook((WhatsAppChannel) channel, resource);
  }

  public WebHook create(Map<String, Object> params) {
    return (WebHook) this.createPost(this.getResourceUri(), params);
  }

  public List<WebHook> getWebHooks() {
    List<WebHook> records = new List<WebHook>();

    for (Object o : this.getRecords()) {
      WebHookResource resource = parseResorce(JSON.serialize(o));
      WebHook c = new WebHook((WhatsAppChannel) this.channel, resource);
      records.add(c);
    }
    return records;
  }

  private WebHookResource parseResorce(String body) {
    return (WebHookResource) JSON.deserialize(
      body.replace('from', 'from1'),
      WebHookResource.class
    );
  }
}
