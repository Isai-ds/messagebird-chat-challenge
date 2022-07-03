public with sharing class ConversationResource {
  @AuraEnabled
  public String id { get; set; }
  @AuraEnabled
  public String contactId { get; set; }
  @AuraEnabled
  public Contact contact { get; set; }
  @AuraEnabled
  public List<Channel> channels { get; set; }
  @AuraEnabled
  public String status { get; set; }
  @AuraEnabled
  public String createdDatetime { get; set; }
  @AuraEnabled
  public String updatedDatetime { get; set; }
  @AuraEnabled
  public String lastReceivedDatetime { get; set; }
  @AuraEnabled
  public String lastUsedChannelId { get; set; }
  @AuraEnabled
  public String lastUsedPlatformId { get; set; }
  @AuraEnabled
  public Message messages { get; set; }

  public class Contact {
    @AuraEnabled
    public String id { get; set; }
    @AuraEnabled
    public String href { get; set; }
    @AuraEnabled
    public String msisdn { get; set; }
    @AuraEnabled
    public String displayName { get; set; }
    @AuraEnabled
    public String firstName { get; set; }
    @AuraEnabled
    public String lastName { get; set; }
    @AuraEnabled
    public String createdDatetime { get; set; }
    @AuraEnabled
    public String updatedDatetime { get; set; }
  }

  public class Channel {
    @AuraEnabled
    public String id { get; set; }
    @AuraEnabled
    public String name { get; set; }
    @AuraEnabled
    public String platformId { get; set; }
    @AuraEnabled
    public String status { get; set; }
    @AuraEnabled
    public String createdDatetime { get; set; }
    @AuraEnabled
    public String updatedDatetime { get; set; }
  }

  public class Message {
    @AuraEnabled
    public Integer totalCount { get; set; }
    @AuraEnabled
    public String href { get; set; }
    @AuraEnabled
    public String lastMessageId { get; set; }
  }
}
