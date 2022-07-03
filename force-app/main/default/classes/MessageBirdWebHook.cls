@RestResource(urlMapping='/messageBird/v1/message/*')
global with sharing class MessageBirdWebHook {
  @HttpPost
  global static void doPost() {
    RestRequest request = Restcontext.request;
    RestResponse response = Restcontext.response;
    try {
      Map<String, Object> message = (Map<String, Object>) JSON.deserializeUntyped(
        request.requestBody.toString()
      );
      System.debug(JSON.serializePretty(message));
      response.statusCode = 200;
      EventHandler eHandler = new EventHandler();
      eHandler.publish(message);
    } catch (Exception e) {
      response.statusCode = 500;
    }
  }

  public class EventHandler {
    public void publish(Map<String, Object> message) {
      Map<String, Object> msg = (Map<String, Object>) message.get('message');
      Map<String, Object> contact = (Map<String, Object>) message.get(
        'contact'
      );

      MessageEvent__e event = new MessageEvent__e(
        MessageId__c = (String) msg.get('id'),
        ConversationId__c = (String) msg.get('conversationId'),
        ChannelId__c = (String) msg.get('channelId'),
        Direction__c = (String) msg.get('direction'),
        ContactId__c = (String) contact.get('id'),
        Type__c = (String) message.get('type')
      );

      List<Database.SaveResult> results = EventBus.publish(
        new List<MessageEvent__e>{ event }
      );
      for (Database.SaveResult sr : results) {
        if (!sr.isSuccess()) {
          Database.Error err = sr.getErrors()[0];
          throw new MessageBirdWebHookException(err.getMessage());
        }
      }
    }
  }

  public class MessageBirdWebHookException extends Exception {
  }
}
