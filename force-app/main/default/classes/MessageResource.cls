public with sharing class MessageResource {
  @AuraEnabled
  public String id { get; set; }
  @AuraEnabled
  public String conversationId { get; set; }
  @AuraEnabled
  public String platform { get; set; }
  @AuraEnabled
  public String toPhone { get; set; }
  @AuraEnabled
  public String fromPhone { get; set; }
  @AuraEnabled
  public Content content { get; set; }
  @AuraEnabled
  public String direction { get; set; }
  @AuraEnabled
  public String status { get; set; }
  @AuraEnabled
  public String createdDatetime { get; set; }
  @AuraEnabled
  public String updatedDatetime { get; set; }
  @AuraEnabled
  public String origin { get; set; }
  @AuraEnabled
  public String type { get; set; }
  @AuraEnabled
  public String channelId { get; set; }

  public class Content {
    @AuraEnabled
    public String text { get; set; }
  }
}
