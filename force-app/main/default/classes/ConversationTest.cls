@IsTest
public with sharing class ConversationTest {
  private static final String ACCESS_KEY = 'OU9lVmwxbzJNekpudXR0RGxCTU5BY3o0MmE';

  @isTest
  public static void Should_GetResource_When_IdIsGiven() {
    String response = '{"id":"54379be50f4646c98c5cc32fbb030846","contactId":"2afcd667cefd48828bf89381059ba377","contact":{"id":"2afcd667cefd48828bf89381059ba377","href":"https://contacts.messagebird.com/v2/contacts/2afcd667cefd48828bf89381059ba377","msisdn":5215514395236,"displayName":"+5215514395236","firstName":"","lastName":"","customDetails":{},"attributes":{},"createdDatetime":"2022-06-27T20:47:28Z","updatedDatetime":"2022-06-27T20:47:28Z"},"channels":[{"id":"313874cd486c4309ac49b87efef7c111","name":"WhatsApp Sandbox","platformId":"whatsapp_sandbox","status":"active","createdDatetime":"2022-06-27T20:45:00Z","updatedDatetime":"0001-01-01T00:00:00Z"}],"status":"active","createdDatetime":"2022-06-27T20:47:28Z","updatedDatetime":"2022-06-28T17:46:23.347697229Z","lastReceivedDatetime":"2022-06-28T17:46:23.347697229Z","lastUsedChannelId":"313874cd486c4309ac49b87efef7c111","lastUsedPlatformId":"whatsapp_sandbox","messages":{"totalCount":17,"href":"https://conversations.messagebird.com/v1/conversations/54379be50f4646c98c5cc32fbb030846/messages"}}';
    Test.setMock(
      HttpCalloutMock.class,
      new MessageBirdRestMockUp(
        MessageBirdRestMockUp.MockOption.SUCCESS,
        response
      )
    );

    WhatsAppChannel channel = new WhatsAppChannel(ACCESS_KEY);
    Conversation c = new Conversation(
      channel,
      '54379be50f4646c98c5cc32fbb030846'
    );
    ConversationResource resource = c.getResource();
    System.assertEquals(
      resource.id,
      '54379be50f4646c98c5cc32fbb030846',
      'Id invalid'
    );
    System.assertEquals(
      resource.contactId,
      '2afcd667cefd48828bf89381059ba377',
      'contactId invalid'
    );
    System.assertEquals(
      resource.contact.id,
      '2afcd667cefd48828bf89381059ba377',
      'contact.id invalid'
    );
    System.assertEquals(
      resource.contact.href,
      'https://contacts.messagebird.com/v2/contacts/2afcd667cefd48828bf89381059ba377',
      'contact.href invalid'
    );
    System.assertEquals(
      resource.contact.msisdn,
      '5215514395236',
      'contact.msisdn invalid'
    );
    System.assertEquals(
      resource.contact.displayName,
      '+5215514395236',
      'contact.displayName invalid'
    );
    System.assertEquals(
      resource.contact.firstName,
      '',
      'contact.firstName invalid'
    );
    System.assertEquals(
      resource.contact.lastName,
      '',
      'contact.lastName invalid'
    );
    System.assertEquals(
      resource.contact.createdDatetime,
      '2022-06-27T20:47:28Z',
      'contact.createdDatetime invalid'
    );
    System.assertEquals(
      resource.contact.updatedDatetime,
      '2022-06-27T20:47:28Z',
      'contact.updatedDatetime invalid'
    );
    System.assertEquals(
      resource.channels[0].id,
      '313874cd486c4309ac49b87efef7c111',
      'channels.id invalid'
    );
    System.assertEquals(
      resource.channels[0].name,
      'WhatsApp Sandbox',
      'channels.name invalid'
    );
    System.assertEquals(
      resource.channels[0].platformId,
      'whatsapp_sandbox',
      'channels.platformId invalid'
    );
    System.assertEquals(
      resource.channels[0].status,
      'active',
      'channels.status invalid'
    );
    System.assertEquals(
      resource.channels[0].createdDatetime,
      '2022-06-27T20:45:00Z',
      'channels.createdDatetime invalid'
    );
    System.assertEquals(
      resource.channels[0].updatedDatetime,
      '0001-01-01T00:00:00Z',
      'channels.updatedDatetime invalid'
    );
    System.assertEquals(resource.status, 'active', 'status invalid');
    System.assertEquals(
      resource.createdDatetime,
      '2022-06-27T20:47:28Z',
      'createdDatetime invalid'
    );
    System.assertEquals(
      resource.updatedDatetime,
      '2022-06-28T17:46:23.347697229Z',
      'updatedDatetime invalid'
    );
    System.assertEquals(
      resource.lastReceivedDatetime,
      '2022-06-28T17:46:23.347697229Z',
      'lastReceivedDatetime invalid'
    );
    System.assertEquals(
      resource.lastUsedChannelId,
      '313874cd486c4309ac49b87efef7c111',
      'lastUsedChannelId invalid'
    );
    System.assertEquals(
      resource.lastUsedPlatformId,
      'whatsapp_sandbox',
      'lastUsedPlatformId invalid'
    );
    System.assertEquals(
      resource.messages.totalCount,
      17,
      'messages.totalCount invalid'
    );
    System.assertEquals(
      resource.messages.href,
      'https://conversations.messagebird.com/v1/conversations/54379be50f4646c98c5cc32fbb030846/messages',
      'messages.href invalid'
    );
  }

  @isTest
  public static void Should_GetResources_When_ListEndpointIsCalled() {
    String response = '{"offset":0,"limit":1,"count":1,"totalCount":5,"items":[{"id":"54379be50f4646c98c5cc32fbb030846","contactId":"2afcd667cefd48828bf89381059ba377","contact":{"id":"2afcd667cefd48828bf89381059ba377","href":"https://contacts.messagebird.com/v2/contacts/2afcd667cefd48828bf89381059ba377","msisdn":5215514395236,"displayName":"+5215514395236","firstName":"","lastName":"","customDetails":{},"attributes":{},"createdDatetime":"2022-06-27T20:47:28Z","updatedDatetime":"2022-06-27T20:47:28Z"},"channels":[{"id":"313874cd486c4309ac49b87efef7c111","name":"WhatsApp Sandbox","platformId":"whatsapp_sandbox","status":"active","createdDatetime":"2022-06-27T20:45:00Z","updatedDatetime":"0001-01-01T00:00:00Z"}],"status":"active","createdDatetime":"2022-06-27T20:47:28Z","updatedDatetime":"2022-06-28T17:46:23.347697229Z","lastReceivedDatetime":"2022-06-28T17:46:23.347697229Z","lastUsedChannelId":"313874cd486c4309ac49b87efef7c111","lastUsedPlatformId":"whatsapp_sandbox","messages":{"totalCount":17,"href":"https://conversations.messagebird.com/v1/conversations/54379be50f4646c98c5cc32fbb030846/messages"}}]}';
    Test.setMock(
      HttpCalloutMock.class,
      new MessageBirdRestMockUp(
        MessageBirdRestMockUp.MockOption.SUCCESS,
        response
      )
    );

    WhatsAppChannel channel = new WhatsAppChannel(ACCESS_KEY);
    WhatsAppHandler handler = new WhatsAppHandler(channel);
    List<Conversation> records = handler.getConversations();
    System.assert(!records.isEmpty(), 'Result is empty');

    ConversationList clist = new ConversationList(channel);
    records = clist.getConversations();
    System.assertEquals(clist.getCount(), 1, 'count is wrong');
    System.assertEquals(clist.getOffset(), 0, 'offset is wrong');
    System.assertEquals(clist.getLimitCount(), 1, 'limit is wrong');
    System.assertEquals(clist.getTotalCount(), 5, 'totalCount is wrong');
  }

  @isTest
  public static void Should_GetResources_When_ListEndpointIsCalledAndFiltered() {
    String response = '{"offset":0,"limit":1,"count":1,"totalCount":5,"items":[{"id":"54379be50f4646c98c5cc32fbb030846","contactId":"2afcd667cefd48828bf89381059ba377","contact":{"id":"2afcd667cefd48828bf89381059ba377","href":"https://contacts.messagebird.com/v2/contacts/2afcd667cefd48828bf89381059ba377","msisdn":5215514395236,"displayName":"+5215514395236","firstName":"","lastName":"","customDetails":{},"attributes":{},"createdDatetime":"2022-06-27T20:47:28Z","updatedDatetime":"2022-06-27T20:47:28Z"},"channels":[{"id":"313874cd486c4309ac49b87efef7c111","name":"WhatsApp Sandbox","platformId":"whatsapp_sandbox","status":"active","createdDatetime":"2022-06-27T20:45:00Z","updatedDatetime":"0001-01-01T00:00:00Z"}],"status":"active","createdDatetime":"2022-06-27T20:47:28Z","updatedDatetime":"2022-06-28T17:46:23.347697229Z","lastReceivedDatetime":"2022-06-28T17:46:23.347697229Z","lastUsedChannelId":"313874cd486c4309ac49b87efef7c111","lastUsedPlatformId":"whatsapp_sandbox","messages":{"totalCount":17,"href":"https://conversations.messagebird.com/v1/conversations/54379be50f4646c98c5cc32fbb030846/messages"}}]}';
    Test.setMock(
      HttpCalloutMock.class,
      new MessageBirdRestMockUp(
        MessageBirdRestMockUp.MockOption.SUCCESS,
        response
      )
    );

    WhatsAppChannel channel = new WhatsAppChannel(ACCESS_KEY);
    WhatsAppHandler handler = new WhatsAppHandler(channel);
    List<Conversation> records = handler.getConversations(
      new Map<String, Object>{ 'limit' => '1' }
    );
    System.assert(!records.isEmpty(), 'Result is empty');
  }

  @isTest
  public static void Should_GetConversation_When_Start() {
    String response = '{"id":"54379be50f4646c98c5cc32fbb030846","contactId":"2afcd667cefd48828bf89381059ba377","contact":{"id":"2afcd667cefd48828bf89381059ba377","href":"","msisdn":5215514395236,"displayName":"+5215514395236","firstName":"","lastName":"","customDetails":{},"attributes":{},"createdDatetime":"2022-06-27T20:47:28Z","updatedDatetime":"2022-06-27T20:47:28Z"},"channels":[{"id":"313874cd486c4309ac49b87efef7c111","name":"WhatsApp Sandbox","platformId":"whatsapp_sandbox","status":"active","createdDatetime":"2022-06-27T20:45:00Z","updatedDatetime":"0001-01-01T00:00:00Z"}],"status":"active","createdDatetime":"2022-06-27T20:47:28Z","updatedDatetime":"2022-06-28T00:54:10.440997605Z","lastReceivedDatetime":"2022-06-28T00:54:10.440997605Z","lastUsedChannelId":"313874cd486c4309ac49b87efef7c111","lastUsedPlatformId":"whatsapp_sandbox","messages":{"totalCount":11,"href":"https://conversations.messagebird.com/v1/conversations/54379be50f4646c98c5cc32fbb030846/messages","lastMessageId":"b6a2749c833c4fc299be8167cbb345da"}}';
    Test.setMock(
      HttpCalloutMock.class,
      new MessageBirdRestMockUp(
        MessageBirdRestMockUp.MockOption.SUCCESS,
        response
      )
    );

    WhatsAppChannel channel = new WhatsAppChannel(ACCESS_KEY);
    WhatsAppHandler handler = new WhatsAppHandler(channel);
    Map<String, Object> params = new Map<String, Object>{
      'to' => '+5215514395236',
      'channelId' => '313874cd486c4309ac49b87efef7c111',
      'type' => 'text',
      'content' => new Map<String, Object>{ 'text' => 'Hello' }
    };
    Conversation c = handler.start(params);
    ConversationResource resource = c.getResource();
    System.assertEquals(
      resource.id,
      '54379be50f4646c98c5cc32fbb030846',
      'Id invalid'
    );
  }
}
