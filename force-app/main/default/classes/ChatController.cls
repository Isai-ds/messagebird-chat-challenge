public without sharing class ChatController {
  @AuraEnabled
  public static Object send(String recordId, String message) {
    Map<String, Object> result = new Map<String, Object>();
    MessageResource resource;
    try {
      Chat c = new Chat(recordId);
      resource = c.send(message);
      result.put('messageResource', resource);
      result.put('hasPreviousConversation', c.hasPreviousConversation());
      if (!c.hasPreviousConversation()) {
        result.put(
          'setupInfo',
          new Map<String, String>{
            'conversationId' => c.getConversationId(),
            'contactId' => c.getContactId()
          }
        );
      }
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
    return result;
  }

  @AuraEnabled(cacheable=true)
  public static List<MessageResource> getMessages(
    String recordId,
    Integer offset
  ) {
    List<MessageResource> resources;
    try {
      Chat c = new Chat(recordId);
      resources = c.getMessages(offset);
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
    return resources;
  }

  @AuraEnabled
  public static MessageResource getMessage(String recordId, String messageId) {
    MessageResource resource;
    try {
      Chat c = new Chat(recordId);
      resource = c.getMessage(messageId);
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
    return resource;
  }

  @AuraEnabled(cacheable=true)
  public static User getContextUser(String recordId) {
    User u;
    try {
      u = [SELECT Id, Name FROM User WHERE Id = :recordId];
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
    return u;
  }

  @AuraEnabled
  public static Object setup(String recordId, String mobilePhone) {
    Map<String, Object> result = new Map<String, Object>();
    try {
      Chat c = new Chat(recordId);
      c.setup(mobilePhone);
      result.put('hasPreviousConversation', c.hasPreviousConversation());
      if (c.hasPreviousConversation()) {
        result.put(
          'setupInfo',
          new Map<String, String>{
            'conversationId' => c.getConversationId(),
            'contactId' => c.getContactId()
          }
        );
      }
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
    return result;
  }

  @AuraEnabled
  public static List<MessageResource> getInitialMessages(String recordId) {
    List<MessageResource> resources;
    try {
      Chat c = new Chat(recordId);
      resources = c.getMessages(0);
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
    return resources;
  }
}
