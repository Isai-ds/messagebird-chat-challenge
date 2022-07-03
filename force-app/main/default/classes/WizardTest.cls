@isTest
public with sharing class WizardTest {
  @isTest
  public static void Given_ANewConfiguration_When_UrlSiteIsProvided_Then_CreatesWebHook() {
    String response = '{"id":"b57cfe20451a4487aebcf62513ec9931","url":"https://force.com/services/apexrest/messageBird/v1/message/","channelId":"313874cd486c4309ac49b87efef7c111","events":["message.created","message.updated"],"status":"enabled","createdDatetime":"2022-06-28T16:54:36Z","updatedDatetime":null,"settings":{"expected_http_code":"200","retry":2,"timeout":14}}';
    Test.setMock(
      HttpCalloutMock.class,
      new MessageBirdRestMockUp(
        MessageBirdRestMockUp.MockOption.SUCCESS,
        response
      )
    );
    Wizard w = new Wizard();
    w.siteUrl = 'https://mbdev01-developer-edition.na210.force.com/services/apexrest/messageBird/v1/message/';
    w.saveSiteUrl();
    System.assertEquals(
      w.wHook.getResource().id,
      'b57cfe20451a4487aebcf62513ec9931',
      'Id invalid'
    );
  }
}
