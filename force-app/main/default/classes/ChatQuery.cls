public with sharing class ChatQuery {
  public static Contact getContact(String recordId) {
    return [
      SELECT
        Id,
        Phone,
        MobilePhone,
        OtherPhone,
        MessageBirdContactId__c,
        MessageBirdConversationId__c,
        MessageBirdCountryCode__c,
        MessageBirdDisplayWindowConfiguration__c
      FROM Contact
      WHERE Id = :recordId
      WITH SECURITY_ENFORCED
    ];
  }
}
