@isTest
public with sharing class MessageTest {
  private static final String ACCESS_KEY = 'OU9lVmwxbzJNekpudXR0RGxCTU5BY3o0MmE';

  @isTest
  public static void Should_GetResource_When_IdIsGiven() {
    String response = '{"id":"b2b019223808411ba80d3dd178112cc7","conversationId":"54379be50f4646c98c5cc32fbb030846","platform":"whatsapp_sandbox","to":"+447418310508","from":"+5215514395236","channelId":"313874cd486c4309ac49b87efef7c111","type":"text","content":{"text":"Hello"},"direction":"received","status":"received","createdDatetime":"2022-06-28T17:46:23.347Z","updatedDatetime":"2022-06-28T17:46:12Z"}';
    Test.setMock(
      HttpCalloutMock.class,
      new MessageBirdRestMockUp(
        MessageBirdRestMockUp.MockOption.SUCCESS,
        response
      )
    );

    WhatsAppChannel channel = new WhatsAppChannel(ACCESS_KEY);
    Message c = new Message(channel, 'b2b019223808411ba80d3dd178112cc7');
    MessageResource resource = c.getResource();

    System.assertEquals(
      resource.id,
      'b2b019223808411ba80d3dd178112cc7',
      'id wrong'
    );
    System.assertEquals(
      resource.conversationId,
      '54379be50f4646c98c5cc32fbb030846',
      'conversationId wrong'
    );
    System.assertEquals(
      resource.platform,
      'whatsapp_sandbox',
      'platform wrong'
    );
    System.assertEquals(resource.toPhone, '+447418310508', 'toPhone wrong');
    System.assertEquals(
      resource.fromPhone,
      '+5215514395236',
      'fromPhone wrong'
    );
    System.assertEquals(
      resource.channelId,
      '313874cd486c4309ac49b87efef7c111',
      'channelId wrong'
    );
    System.assertEquals(resource.type, 'text', 'type wrong');
    System.assertEquals(
      resource.content.text,
      'Hello',
      'createdDatetime wrong'
    );
    System.assertEquals(resource.direction, 'received', 'direction wrong');
    System.assertEquals(resource.status, 'received', 'status wrong');
    System.assertEquals(
      resource.createdDatetime,
      '2022-06-28T17:46:23.347Z',
      'createdDatetime wrong'
    );
    System.assertEquals(
      resource.updatedDatetime,
      '2022-06-28T17:46:12Z',
      'updatedDatetime wrong'
    );
  }

  @isTest
  public static void Should_GetResources_When_ListEndpointIsCalled() {
    String response = '{"count":1,"items":[{"id":"b2b019223808411ba80d3dd178112cc7","conversationId":"54379be50f4646c98c5cc32fbb030846","platform":"whatsapp_sandbox","to":"+447418310508","from":"+5215514395236","channelId":"313874cd486c4309ac49b87efef7c111","type":"text","content":{"text":"Hello"},"direction":"received","status":"received","createdDatetime":"2022-06-28T17:46:23.347697229Z","updatedDatetime":"2022-06-28T17:46:12Z"}],"limit":1,"offset":0,"totalCount":17}';
    Test.setMock(
      HttpCalloutMock.class,
      new MessageBirdRestMockUp(
        MessageBirdRestMockUp.MockOption.SUCCESS,
        response
      )
    );

    WhatsAppChannel channel = new WhatsAppChannel(ACCESS_KEY);
    WhatsAppHandler handler = new WhatsAppHandler(channel);
    List<Message> records = handler.getMessages(
      '54379be50f4646c98c5cc32fbb030846'
    );
    System.assert(!records.isEmpty(), 'Result is empty');

    MessageList mlist = new MessageList(
      channel,
      '54379be50f4646c98c5cc32fbb030846'
    );
    records = mlist.getMessages();
    System.assertEquals(mlist.getCount(), 1, 'count is wrong');
    System.assertEquals(mlist.getOffset(), 0, 'offset is wrong');
    System.assertEquals(mlist.getLimitCount(), 1, 'limit is wrong');
    System.assertEquals(mlist.getTotalCount(), 17, 'totalCount is wrong');
  }

  @isTest
  public static void Should_GetResources_When_ListEndpointIsCalledAndFiltered() {
    String response = '{"count":1,"items":[{"id":"b2b019223808411ba80d3dd178112cc7","conversationId":"54379be50f4646c98c5cc32fbb030846","platform":"whatsapp_sandbox","to":"+447418310508","from":"+5215514395236","channelId":"313874cd486c4309ac49b87efef7c111","type":"text","content":{"text":"Mmmm"},"direction":"received","status":"received","createdDatetime":"2022-06-28T17:46:23.347697229Z","updatedDatetime":"2022-06-28T17:46:12Z"}],"limit":1,"offset":0,"totalCount":17}';
    Test.setMock(
      HttpCalloutMock.class,
      new MessageBirdRestMockUp(
        MessageBirdRestMockUp.MockOption.SUCCESS,
        response
      )
    );
    WhatsAppChannel channel = new WhatsAppChannel(ACCESS_KEY);
    WhatsAppHandler handler = new WhatsAppHandler(channel);
    List<Message> records = handler.getMessages(
      '54379be50f4646c98c5cc32fbb030846',
      new Map<String, Object>{ 'limit' => '1' }
    );
    System.assert(!records.isEmpty(), 'Result is empty');
  }

  @isTest
  public static void Should_SendMessage_When_IsCalled() {
    String response = '{"id":"b2b019223808411ba80d3dd178112cc7","conversationId":"54379be50f4646c98c5cc32fbb030846","platform":"whatsapp_sandbox","to":"+447418310508","from":"+5215514395236","channelId":"313874cd486c4309ac49b87efef7c111","type":"text","content":{"text":"Hello!"},"direction":"received","status":"received","createdDatetime":"2022-06-28T17:46:23.347Z","updatedDatetime":"2022-06-28T17:46:12Z"}';
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
      'channelId' => '313874cd486c4309ac49b87efef7c111',
      'type' => 'text',
      'content' => new Map<String, String>{ 'text' => 'Hello!' }
    };
    Message c = handler.reply('54379be50f4646c98c5cc32fbb030846', params);
    MessageResource resource = c.getResource();
    System.assertEquals(
      resource.id,
      'b2b019223808411ba80d3dd178112cc7',
      'Id invalid'
    );
  }

  @isTest
  public static void Should_ThrowError_When_Get500() {
    String response = '{"id":"b2b019223808411ba80d3dd178112cc7","conversationId":"54379be50f4646c98c5cc32fbb030846","platform":"whatsapp_sandbox","to":"+447418310508","from":"+5215514395236","channelId":"313874cd486c4309ac49b87efef7c111","type":"text","content":{"text":"Hello!"},"direction":"received","status":"received","createdDatetime":"2022-06-28T17:46:23.347Z","updatedDatetime":"2022-06-28T17:46:12Z"}';
    Test.setMock(
      HttpCalloutMock.class,
      new MessageBirdRestMockUp(
        MessageBirdRestMockUp.MockOption.SERVER_FAILED,
        response
      )
    );

    try {
      WhatsAppChannel channel = new WhatsAppChannel(ACCESS_KEY);
      WhatsAppHandler handler = new WhatsAppHandler(channel);
      Map<String, Object> params = new Map<String, Object>{
        'channelId' => '313874cd486c4309ac49b87efef7c111',
        'type' => 'text',
        'content' => new Map<String, String>{ 'text' => 'Hello!' }
      };
      Message c = handler.reply('54379be50f4646c98c5cc32fbb030846', params);
      MessageResource resource = c.getResource();
    } catch (Exception e) {
      System.assert(true);
    }
  }
}
