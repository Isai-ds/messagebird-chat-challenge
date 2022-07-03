@isTest
public with sharing class MessageBirdRestMockUp implements HttpCalloutMock {
  MockOption option;
  String responseBody;

  public MessageBirdRestMockUp(MockOption option, String responseBody) {
    this.option = option;
    this.responseBody = responseBody;
  }

  public HTTPResponse respond(HTTPRequest req) {
    // Create a fake response
    HttpResponse res = new HttpResponse();
    res.setBody(responseBody);
    if (option == MockOption.SUCCESS) {
      res.setStatusCode(200);
    } else if (option == MockOption.CLIENT_FAILED) {
      res.setStatusCode(400);
    } else if (option == MockOption.SERVER_FAILED) {
      res.setStatusCode(500);
    }
    res.setHeader('Content-Type', 'application/json');
    return res;
  }

  public enum MockOption {
    SUCCESS,
    CLIENT_FAILED,
    SERVER_FAILED
  }
}
