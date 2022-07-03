@isTest
public with sharing class WebHookTest {
  private static final String ACCESS_KEY = 'OU9lVmwxbzJNekpudXR0RGxCTU5BY3o0MmE';

  @isTest
  public static void Should_GetResource_When_IdIsGiven() {
    String response = '{"id":"b57cfe20451a4487aebcf62513ec9931","url":"https://force.com/services/apexrest/messageBird/v1/message/","channelId":"313874cd486c4309ac49b87efef7c111","events":["message.created","message.updated"],"status":"enabled","createdDatetime":"2022-06-28T16:54:36Z","updatedDatetime":null,"settings":{"expected_http_code":"200","retry":2,"timeout":14}}';
    Test.setMock(
      HttpCalloutMock.class,
      new MessageBirdRestMockUp(
        MessageBirdRestMockUp.MockOption.SUCCESS,
        response
      )
    );

    WhatsAppChannel channel = new WhatsAppChannel(ACCESS_KEY);
    WebHook c = new WebHook(channel, '54379be50f4646c98c5cc32fbb030846');
    WebHookResource resource = c.getResource();
    System.assertEquals(
      resource.id,
      'b57cfe20451a4487aebcf62513ec9931',
      'id wrong'
    );
    System.assertEquals(
      resource.url,
      'https://force.com/services/apexrest/messageBird/v1/message/',
      'url wrong'
    );
    System.assertEquals(
      resource.channelId,
      '313874cd486c4309ac49b87efef7c111',
      'channelId wrong'
    );
    System.assertEquals(resource.events[0], 'message.created', 'events wrong');
    System.assertEquals(resource.events[1], 'message.updated', 'events wrong');
    System.assertEquals(resource.status, 'enabled', 'status wrong');
    System.assertEquals(
      resource.createdDatetime,
      '2022-06-28T16:54:36Z',
      'createdDatetime wrong'
    );
    System.assertEquals(
      resource.updatedDatetime,
      null,
      'createdDatetime wrong'
    );
    System.assertEquals(
      resource.settings.expected_http_code,
      '200',
      'expected_http_code wrong'
    );
    System.assertEquals(resource.settings.retry, 2, 'retry wrong');
    System.assertEquals(resource.settings.timeout, 14, 'timeout wrong');
    resource.settings.headers = new WebHookResource.Header();
    System.assertEquals(
      resource.settings.headers.from1,
      null,
      'headers.from1 wrong'
    );
    System.assertEquals(
      resource.settings.query_params,
      null,
      'query_params wrong'
    );
  }

  @isTest
  public static void Should_GetResources_When_ListEndpointIsCalled() {
    String response = '{"offset":0,"limit":10,"count":1,"totalCount":1,"items":[{"id":"b57cfe20451a4487aebcf62513ec9931","url":"https://mbdev01-developer-edition.na210.force.com/services/apexrest/messageBird/v1/message/","channelId":"313874cd486c4309ac49b87efef7c111","events":["message.created","message.updated"],"status":"enabled","createdDatetime":"2022-06-28T16:54:36Z","updatedDatetime":null,"settings":{"expected_http_code":"200","retry":2,"timeout":14}}]}';
    Test.setMock(
      HttpCalloutMock.class,
      new MessageBirdRestMockUp(
        MessageBirdRestMockUp.MockOption.SUCCESS,
        response
      )
    );

    WhatsAppChannel channel = new WhatsAppChannel(ACCESS_KEY);
    WhatsAppHandler handler = new WhatsAppHandler(channel);
    List<WebHook> records = handler.getWebHooks();
    System.assert(!records.isEmpty(), 'Result is empty');

    WebHookList wlist = new WebHookList(channel);
    records = wlist.getWebHooks();
    System.assertEquals(wlist.getCount(), 1, 'count is wrong');
    System.assertEquals(wlist.getOffset(), 0, 'offset is wrong');
    System.assertEquals(wlist.getLimitCount(), 10, 'limit is wrong');
    System.assertEquals(wlist.getTotalCount(), 1, 'totalCount is wrong');
  }

  @isTest
  public static void Should_GetResources_When_ListEndpointIsCalledAndFiltered() {
    String response = '{"offset":0,"limit":1,"count":1,"totalCount":1,"items":[{"id":"b57cfe20451a4487aebcf62513ec9931","url":"https://mbdev01-developer-edition.na210.force.com/services/apexrest/messageBird/v1/message/","channelId":"313874cd486c4309ac49b87efef7c111","events":["message.created","message.updated"],"status":"enabled","createdDatetime":"2022-06-28T16:54:36Z","updatedDatetime":null,"settings":{"expected_http_code":"200","retry":2,"timeout":14}}]}';
    Test.setMock(
      HttpCalloutMock.class,
      new MessageBirdRestMockUp(
        MessageBirdRestMockUp.MockOption.SUCCESS,
        response
      )
    );

    WhatsAppChannel channel = new WhatsAppChannel(ACCESS_KEY);
    WhatsAppHandler handler = new WhatsAppHandler(channel);
    List<WebHook> records = handler.getWebHooks(
      new Map<String, Object>{ 'limit' => '1' }
    );
    System.assert(!records.isEmpty(), 'Result is empty');
  }

  @isTest
  public static void Should_CreateWebHook_When_IsCalled() {
    String response = '{"id":"b57cfe20451a4487aebcf62513ec9931","url":"https://force.com/services/apexrest/messageBird/v1/message/","channelId":"313874cd486c4309ac49b87efef7c111","events":["message.created","message.updated"],"status":"enabled","createdDatetime":"2022-06-28T16:54:36Z","updatedDatetime":null,"settings":{"expected_http_code":"200","retry":2,"timeout":14}}';
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
      'events' => new List<String>{ 'message.created', 'message.updated' },
      'channelId' => '313874cd486c4309ac49b87efef7c111',
      'url' => 'https://mbdev01-developer-edition.na210.force.com/services/apexrest/messageBird/v1/message/',
      'settings' => new Map<String, Object>{
        'expected_http_code' => '200',
        'retry' => 2,
        'timeout' => 14
      }
    };
    WebHook c = handler.createWebHook(params);
    WebHookResource resource = c.getResource();
    System.assertEquals(
      resource.id,
      'b57cfe20451a4487aebcf62513ec9931',
      'Id invalid'
    );
  }
}
