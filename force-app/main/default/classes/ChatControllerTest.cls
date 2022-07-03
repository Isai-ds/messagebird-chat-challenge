@isTest
public with sharing class ChatControllerTest {
  @TestSetup
  static void makeData() {
    PermissionSet perMessageBirdUser = [
      SELECT Id
      FROM PermissionSet
      WHERE Name = 'MessageBirdUser'
      LIMIT 1
    ];

    Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
    User u = new User(
      Alias = 'standt',
      Email = 'standarduser@messagebird.com',
      EmailEncodingKey = 'UTF-8',
      LastName = 'Testing',
      LanguageLocaleKey = 'en_US',
      LocaleSidKey = 'en_US',
      ProfileId = p.Id,
      TimeZoneSidKey = 'America/Los_Angeles',
      UserName = 'mbu' + DateTime.now().getTime() + '@messagebird.com'
    );
    insert u;

    PermissionSetAssignment psa = new PermissionSetAssignment();
    psa.AssigneeId = u.Id;
    psa.PermissionSetId = perMessageBirdUser.Id;
    insert psa;

    Test.startTest();
    System.runAs(u) {
      Contact c = new Contact();
      c.LastName = 'Test';
      c.MobilePhone = '+5215514395236';
      insert c;
    }
    Test.stopTest();
  }

  @isTest
  public static void Given_ALoggedUser_When_ChatStarts_Then_GetUserInfo() {
    User u = [SELECT Id FROM User WHERE Email = 'standarduser@messagebird.com'];
    Test.startTest();
    System.runAs(u) {
      User context = ChatController.getContextUser(u.Id);
      System.assertEquals(context.Id, u.Id, 'Id is not equals');
    }
    Test.stopTest();
  }

  @isTest
  public static void Given_NewContactWithoutConversationId_When_ConfiguartionStart_Then_GetInfo() {
    String responseConversations = '{"offset":0,"limit":1,"count":1,"totalCount":5,"items":[{"id":"54379be50f4646c98c5cc32fbb030846","contactId":"2afcd667cefd48828bf89381059ba377","contact":{"id":"2afcd667cefd48828bf89381059ba377","href":"https://contacts.messagebird.com/v2/contacts/2afcd667cefd48828bf89381059ba377","msisdn":5215514395236,"displayName":"+5215514395236","firstName":"","lastName":"","customDetails":{},"attributes":{},"createdDatetime":"2022-06-27T20:47:28Z","updatedDatetime":"2022-06-27T20:47:28Z"},"channels":[{"id":"313874cd486c4309ac49b87efef7c111","name":"WhatsApp Sandbox","platformId":"whatsapp_sandbox","status":"active","createdDatetime":"2022-06-27T20:45:00Z","updatedDatetime":"0001-01-01T00:00:00Z"}],"status":"active","createdDatetime":"2022-06-27T20:47:28Z","updatedDatetime":"2022-06-28T17:46:23.347697229Z","lastReceivedDatetime":"2022-06-28T17:46:23.347697229Z","lastUsedChannelId":"313874cd486c4309ac49b87efef7c111","lastUsedPlatformId":"whatsapp_sandbox","messages":{"totalCount":17,"href":"https://conversations.messagebird.com/v1/conversations/54379be50f4646c98c5cc32fbb030846/messages"}}]}';
    String responseMessage = '{"id":"b2b019223808411ba80d3dd178112cc7","conversationId":"54379be50f4646c98c5cc32fbb030846","platform":"whatsapp_sandbox","to":"+447418310508","from":"+5215514395236","channelId":"313874cd486c4309ac49b87efef7c111","type":"text","content":{"text":"Hello!"},"direction":"received","status":"received","createdDatetime":"2022-06-28T17:46:23.347Z","updatedDatetime":"2022-06-28T17:46:12Z"}';
    MessageBirdRestMockUp mockConversation = new MessageBirdRestMockUp(
      MessageBirdRestMockUp.MockOption.SUCCESS,
      responseConversations
    );
    MessageBirdRestMockUp mockMessage = new MessageBirdRestMockUp(
      MessageBirdRestMockUp.MockOption.SUCCESS,
      responseMessage
    );

    Map<String, HttpCalloutMock> mockMap = new Map<String, HttpCalloutMock>();
    mockMap.put(
      'callout:MessageConversation/v1/conversations/?limit=20',
      mockConversation
    );
    mockMap.put(
      'callout:MessageConversation/v1/conversations/54379be50f4646c98c5cc32fbb030846/messages',
      mockMessage
    );
    Test.setMock(HttpCalloutMock.class, new MultiRequestMock(mockMap));

    Contact c = [SELECT Id FROM Contact LIMIT 1];
    User u = [SELECT Id FROM User WHERE Email = 'standarduser@messagebird.com'];

    Test.startTest();
    System.runAs(u) {
      Object response = ChatController.setup(c.Id, '+5215514395236');
      Map<String, Object> result = (Map<String, Object>) response;
      Boolean hasPreviousConversation = (Boolean) result.get(
        'hasPreviousConversation'
      );
      Map<String, String> setupInfo = (Map<String, String>) result.get(
        'setupInfo'
      );
      System.assertEquals(
        setupInfo.get('conversationId'),
        '54379be50f4646c98c5cc32fbb030846',
        'id wrong'
      );
      System.assertEquals(
        setupInfo.get('contactId'),
        '2afcd667cefd48828bf89381059ba377',
        'contactId wrong'
      );
    }
    Test.stopTest();
  }

  @isTest
  public static void Given_AContactWithoutConversationId_When_GetMessages_Then_GetEmptyMessages() {
    Contact c = [SELECT Id FROM Contact LIMIT 1];
    User u = [SELECT Id FROM User WHERE Email = 'standarduser@messagebird.com'];
    Test.startTest();
    System.runAs(u) {
      List<MessageResource> result = ChatController.getMessages(c.Id, 0);
      System.assert(result.isEmpty(), 'MessageResource list is not empty');
    }
    Test.stopTest();
  }

  @isTest
  public static void Given_AContactWithConversationId_When_GetMessages_Then_GetMessages() {
    String response = '{"count":1,"items":[{"id":"b2b019223808411ba80d3dd178112cc7","conversationId":"54379be50f4646c98c5cc32fbb030846","platform":"whatsapp_sandbox","to":"+447418310508","from":"+5215514395236","channelId":"313874cd486c4309ac49b87efef7c111","type":"text","content":{"text":"Hello"},"direction":"received","status":"received","createdDatetime":"2022-06-28T17:46:23.347697229Z","updatedDatetime":"2022-06-28T17:46:12Z"}],"limit":1,"offset":0,"totalCount":17}';
    Test.setMock(
      HttpCalloutMock.class,
      new MessageBirdRestMockUp(
        MessageBirdRestMockUp.MockOption.SUCCESS,
        response
      )
    );
    Contact c = [SELECT Id FROM Contact LIMIT 1];
    c.MessageBirdConversationId__c = '54379be50f4646c98c5cc32fbb030846';
    c.MessageBirdContactId__c = '2afcd667cefd48828bf89381059ba377';
    update c;

    User u = [SELECT Id FROM User WHERE Email = 'standarduser@messagebird.com'];
    Test.startTest();
    System.runAs(u) {
      List<MessageResource> result = ChatController.getMessages(c.Id, 0);
      List<MessageResource> initials = ChatController.getInitialMessages(c.Id);
      System.assert(!result.isEmpty(), 'MessageResource list is empty');
    }
    Test.stopTest();
  }

  @isTest
  public static void Given_AContactWithConversationId_When_SendMessages_Then_ReplyMessages() {
    String responseReply = '{"id":"b2b019223808411ba80d3dd178112cc7","conversationId":"54379be50f4646c98c5cc32fbb030846","platform":"whatsapp_sandbox","to":"+447418310508","from":"+5215514395236","channelId":"313874cd486c4309ac49b87efef7c111","type":"text","content":{"text":"Hello!"},"direction":"received","status":"received","createdDatetime":"2022-06-28T17:46:23.347Z","updatedDatetime":"2022-06-28T17:46:12Z"}';
    Test.setMock(
      HttpCalloutMock.class,
      new MessageBirdRestMockUp(
        MessageBirdRestMockUp.MockOption.SUCCESS,
        responseReply
      )
    );
    Contact c = [SELECT Id FROM Contact LIMIT 1];
    c.MessageBirdConversationId__c = '54379be50f4646c98c5cc32fbb030846';
    c.MessageBirdContactId__c = '2afcd667cefd48828bf89381059ba377';
    update c;

    User u = [SELECT Id FROM User WHERE Email = 'standarduser@messagebird.com'];
    Test.startTest();
    System.runAs(u) {
      Object response = ChatController.send(c.Id, 'Hello!');
      Map<String, Object> result = (Map<String, Object>) response;
      MessageResource resource = (MessageResource) result.get(
        'messageResource'
      );
      System.assertEquals(
        resource.Id,
        'b2b019223808411ba80d3dd178112cc7',
        'message id wrong'
      );
    }
    Test.stopTest();
  }

  @isTest
  public static void Given_AContactWithoutConversationIdAndNotConversationAvialables_When_SendMessage_Then_StartConversation() {
    String responseConversations = '{"offset":0,"limit":1,"count":1,"totalCount":5,"items":[{"id":"54379be50f4646c98c5cc32fbb030846","contactId":"2afcd667cefd48828bf89381059ba377","contact":{"id":"2afcd667cefd48828bf89381059ba377","href":"https://contacts.messagebird.com/v2/contacts/2afcd667cefd48828bf89381059ba377","msisdn":5215514395236,"displayName":"+5215514395236","firstName":"","lastName":"","customDetails":{},"attributes":{},"createdDatetime":"2022-06-27T20:47:28Z","updatedDatetime":"2022-06-27T20:47:28Z"},"channels":[{"id":"313874cd486c4309ac49b87efef7c111","name":"WhatsApp Sandbox","platformId":"whatsapp_sandbox","status":"active","createdDatetime":"2022-06-27T20:45:00Z","updatedDatetime":"0001-01-01T00:00:00Z"}],"status":"inactive","createdDatetime":"2022-06-27T20:47:28Z","updatedDatetime":"2022-06-28T17:46:23.347697229Z","lastReceivedDatetime":"2022-06-28T17:46:23.347697229Z","lastUsedChannelId":"313874cd486c4309ac49b87efef7c111","lastUsedPlatformId":"whatsapp_sandbox","messages":{"totalCount":17,"href":"https://conversations.messagebird.com/v1/conversations/54379be50f4646c98c5cc32fbb030846/messages"}}]}';
    String responseStartConversation = '{"id":"54379be50f4646c98c5cc32fbb030846","contactId":"2afcd667cefd48828bf89381059ba377","contact":{"id":"2afcd667cefd48828bf89381059ba377","href":"","msisdn":5215514395236,"displayName":"+5215514395236","firstName":"","lastName":"","customDetails":{},"attributes":{},"createdDatetime":"2022-06-27T20:47:28Z","updatedDatetime":"2022-06-27T20:47:28Z"},"channels":[{"id":"313874cd486c4309ac49b87efef7c111","name":"WhatsApp Sandbox","platformId":"whatsapp_sandbox","status":"active","createdDatetime":"2022-06-27T20:45:00Z","updatedDatetime":"0001-01-01T00:00:00Z"}],"status":"active","createdDatetime":"2022-06-27T20:47:28Z","updatedDatetime":"2022-06-28T00:54:10.440997605Z","lastReceivedDatetime":"2022-06-28T00:54:10.440997605Z","lastUsedChannelId":"313874cd486c4309ac49b87efef7c111","lastUsedPlatformId":"whatsapp_sandbox","messages":{"totalCount":11,"href":"https://conversations.messagebird.com/v1/conversations/54379be50f4646c98c5cc32fbb030846/messages","lastMessageId":"b2b019223808411ba80d3dd178112cc7"}}';
    String responseMessage = '{"id":"b2b019223808411ba80d3dd178112cc7","conversationId":"54379be50f4646c98c5cc32fbb030846","platform":"whatsapp_sandbox","to":"+447418310508","from":"+5215514395236","channelId":"313874cd486c4309ac49b87efef7c111","type":"text","content":{"text":"Hello"},"direction":"received","status":"received","createdDatetime":"2022-06-28T17:46:23.347Z","updatedDatetime":"2022-06-28T17:46:12Z"}';
    MessageBirdRestMockUp mockConversation = new MessageBirdRestMockUp(
      MessageBirdRestMockUp.MockOption.SUCCESS,
      responseConversations
    );
    MessageBirdRestMockUp mockConversationStart = new MessageBirdRestMockUp(
      MessageBirdRestMockUp.MockOption.SUCCESS,
      responseStartConversation
    );
    MessageBirdRestMockUp mockMessages = new MessageBirdRestMockUp(
      MessageBirdRestMockUp.MockOption.SUCCESS,
      responseMessage
    );

    Map<String, HttpCalloutMock> mockMap = new Map<String, HttpCalloutMock>();
    mockMap.put(
      'callout:MessageConversation/v1/conversations/',
      mockConversation
    );
    mockMap.put(
      'callout:MessageConversation/v1/conversations/start',
      mockConversationStart
    );
    mockMap.put(
      'callout:MessageConversation/v1/messages/b2b019223808411ba80d3dd178112cc7',
      mockMessages
    );
    Test.setMock(HttpCalloutMock.class, new MultiRequestMock(mockMap));

    Contact c = [SELECT Id FROM Contact LIMIT 1];
    User u = [SELECT Id FROM User WHERE Email = 'standarduser@messagebird.com'];
    Test.startTest();
    System.runAs(u) {
      Object response = ChatController.send(c.Id, 'Hello!');
      Map<String, Object> result = (Map<String, Object>) response;
      MessageResource resource = (MessageResource) result.get(
        'messageResource'
      );
      System.assertEquals(
        resource.Id,
        'b2b019223808411ba80d3dd178112cc7',
        'message id wrong'
      );
    }
    Test.stopTest();
  }

  @isTest
  public static void Given_ANewIncomingMessage_When_IsFireByPlatformEvent_Then_GetMessageDetail() {
    String response = '{"id":"b2b019223808411ba80d3dd178112cc7","conversationId":"54379be50f4646c98c5cc32fbb030846","platform":"whatsapp_sandbox","to":"+447418310508","from":"+5215514395236","channelId":"313874cd486c4309ac49b87efef7c111","type":"text","content":{"text":"Hello"},"direction":"received","status":"received","createdDatetime":"2022-06-28T17:46:23.347Z","updatedDatetime":"2022-06-28T17:46:12Z"}';
    Test.setMock(
      HttpCalloutMock.class,
      new MessageBirdRestMockUp(
        MessageBirdRestMockUp.MockOption.SUCCESS,
        response
      )
    );

    Contact c = [SELECT Id FROM Contact LIMIT 1];
    User u = [SELECT Id FROM User WHERE Email = 'standarduser@messagebird.com'];
    Test.startTest();
    System.runAs(u) {
      MessageResource resource = ChatController.getMessage(
        c.Id,
        'b2b019223808411ba80d3dd178112cc7'
      );
      System.assertEquals(
        resource.Id,
        'b2b019223808411ba80d3dd178112cc7',
        'message id wrong'
      );
    }
    Test.stopTest();
  }

  public class MultiRequestMock implements HttpCalloutMock {
    Map<String, HttpCalloutMock> requests;

    public MultiRequestMock(Map<String, HttpCalloutMock> requests) {
      this.requests = requests;
    }

    public HTTPResponse respond(HTTPRequest req) {
      HttpCalloutMock mock = requests.get(req.getEndpoint());
      if (mock != null) {
        return mock.respond(req);
      } else {
        throw new MockException(
          'HTTP callout not supported for test methods ' + req.getEndpoint()
        );
      }
    }

    public void addRequestMock(String url, HttpCalloutMock mock) {
      requests.put(url, mock);
    }
  }

  public class MockException extends Exception {
  }
}
