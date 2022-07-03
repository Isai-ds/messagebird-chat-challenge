public with sharing class WebHookResource {
  @AuraEnabled
  public String id { get; set; }
  @AuraEnabled
  public String url { get; set; }
  @AuraEnabled
  public String channelId { get; set; }
  @AuraEnabled
  public List<String> events { get; set; }
  @AuraEnabled
  public String status { get; set; }
  @AuraEnabled
  public String createdDatetime { get; set; }
  @AuraEnabled
  public String updatedDatetime { get; set; }
  @AuraEnabled
  public Setting settings { get; set; }

  public class Setting {
    @AuraEnabled
    public String expected_http_code { get; set; }
    @AuraEnabled
    public Header headers { get; set; }
    @AuraEnabled
    public String query_params { get; set; }
    @AuraEnabled
    public Integer retry { get; set; }
    @AuraEnabled
    public Integer timeout { get; set; }
  }

  public class Header {
    @AuraEnabled
    public String from1 { get; set; }
  }
}
