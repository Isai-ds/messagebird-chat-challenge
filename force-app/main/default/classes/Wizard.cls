public with sharing class Wizard {
  private static final String SERVICE_URL = '/services/apexrest/messageBird/v1/message/';
  public String siteUrl { get; set; }
  @TestVisible
  WebHook wHook { get; set; }
  public Pagereference saveSiteUrl() {
    System.debug('##siteUrl.' + siteUrl);
    MessageBirdConfiguration__mdt messageBirdConfig = MessageBirdConfiguration__mdt.getInstance(
      'WhatsAppChannel'
    );
    try {
      WhatsAppChannel wsChannel = new WhatsAppChannel(
        messageBirdConfig.AccessKey__c
      );
      WebHookList wl = new WebHookList(wsChannel, new Map<String, Object>());
      Map<String, Object> params = new Map<String, Object>{
        'events' => new List<String>{ 'message.created', 'message.updated' },
        'channelId' => messageBirdConfig.ChannelId__c,
        'url' => siteUrl + SERVICE_URL,
        'settings' => new Map<String, Object>{
          'expected_http_code' => '200',
          'retry' => 2,
          'timeout' => 14
        }
      };
      wHook = wl.create(params);
    } catch (Exception e) {
      ApexPages.addMessage(
        new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage())
      );
    }
    return null;
  }
}
