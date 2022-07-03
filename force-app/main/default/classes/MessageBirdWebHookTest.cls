@isTest
public with sharing class MessageBirdWebHookTest {
  @isTest
  public static void Given_ANewMessage_When_UserSendIt_Then_PublishEvent() {
    RestRequest request = new RestRequest();
    RestResponse reponse = new RestResponse();

    Map<String, Object> requestBody = new Map<String, Object>{
      'type' => 'message.created',
      'contact' => new Map<String, Object>{
        'id' => '2afcd667cefd48828bf89381059ba377'
      },
      'message' => new Map<String, Object>{
        'id' => 'e01a3e2595e54dee930ab4a8bbf23f0d',
        'conversationId' => '54379be50f4646c98c5cc32fbb030846',
        'channelId' => '313874cd486c4309ac49b87efef7c111',
        'direction' => 'sent'
      }
    };
    request.requestBody = Blob.valueOf(JSON.serialize(requestBody));

    Restcontext.request = request;
    Restcontext.response = reponse;
    MessageBirdWebHook.doPost();
    System.assert(reponse.statusCode == 200, 'Failed to process');
  }

  @isTest
  public static void Given_AnInvalidNewMessage_When_UserSendIt_Then_PublishEvent() {
    RestRequest request = new RestRequest();
    RestResponse reponse = new RestResponse();

    Restcontext.request = request;
    Restcontext.response = reponse;
    MessageBirdWebHook.doPost();
    System.assert(reponse.statusCode == 500, 'Should 500 response status');
  }
}
