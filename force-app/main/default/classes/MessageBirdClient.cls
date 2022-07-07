public abstract class MessageBirdClient {
  private String endpoint = 'callout:MessageConversation';
  protected String accessKey;

  public MessageBirdClient(String accessKey) {
    this.accessKey = accessKey;
  }

  private HttpRequest buildMethod(
    String method,
    String path,
    Map<String, Object> params
  ) {
    if (method.equalsIgnoreCase('GET')) {
      return createGetRequest(path, params);
    } else if (method.equalsIgnoreCase('POST')) {
      return createPostRequest(path, params);
    } else {
      throw new MessageBirdRestException('Unknown Method: ' + method);
    }
  }

  private HttpRequest createGetRequest(
    String path,
    Map<String, Object> params
  ) {
    URL uri = buildUri(path, params);
    System.debug('GET::' + uri.toExternalForm());
    HttpRequest req = new HttpRequest();
    req.setEndpoint(uri.toExternalForm());
    req.setMethod('GET');
    return req;
  }

  private HttpRequest createPostRequest(
    String path,
    Map<String, Object> params
  ) {
    URL uri = buildUri(path);
    System.debug('POST::' + uri.toExternalForm());
    HttpRequest req = new HttpRequest();
    req.setEndpoint(uri.toExternalForm());
    req.setMethod('POST');
    req.setBody(JSON.serialize(params));

    return req;
  }

  private String buildEntityBody(Map<String, Object> params) {
    String entityBody = '';
    if (params != null) {
      for (String key : params.keySet()) {
        try {
          entityBody +=
            (entityBody == '' ? '' : '&') +
            key +
            '=' +
            (String) params.get(key);
        } catch (Exception e) {
          System.debug('ERROR: ' + e);
        }
      }
    }
    return entityBody;
  }

  private URL buildUri(String path) {
    return buildUri(path, new Map<String, Object>());
  }

  private URL buildUri(String path, Map<String, Object> queryStringParams) {
    String sb = path;

    if (queryStringParams != null && queryStringParams.size() > 0) {
      sb += '?';
      sb += buildEntityBody(queryStringParams);
    }

    URL uri;
    try {
      uri = new URL(sb);
    } catch (Exception e) {
      throw new MessageBirdRestException('Invalid uri: ' + sb, e);
    }

    return uri;
  }

  public MessageBirdRestResponse create(
    String path,
    String method,
    Map<String, Object> vars
  ) {
    HttpRequest request = setupRequest(path, method, vars);

    String responseBody;
    Integer statusCode;
    String contentType;

    HttpResponse response = (new Http()).send(request);
    responseBody = (response.getBody() == null) ? '' : response.getBody();
    system.debug(
      responseBody +
      '-----------------------------------------' +
      response
    );
    statusCode = response.getStatusCode();
    contentType = response.getHeader('Content-Type');

    MessageBirdRestResponse restResponse = new MessageBirdRestResponse(
      request.getEndpoint(),
      responseBody,
      statusCode
    );
    restResponse.setContentType(contentType);
    if (restResponse.isClientError() || restResponse.isServerError()) {
      throw new MessageBirdRestException(
        'Error to get the resource: ' + statusCode
      );
    }

    return restResponse;
  }

  private HttpRequest setupRequest(
    String path,
    String method,
    Map<String, Object> params
  ) {
    String normalizedPath = path.toLowerCase();
    String sb = '';
    sb += this.getEndpoint();

    if (!normalizedPath.startsWith('/')) {
      sb += '/';
    }
    sb += path;

    path = sb;

    HttpRequest request = buildMethod(method, path, params);
    request.setHeader('Accept', 'application/json');
    request.setHeader('Authorization', 'AccessKey ' + this.accessKey);
    return request;
  }

  public String getEndpoint() {
    return endpoint;
  }

  public void setEndpoint(String endpoint) {
    this.endpoint = endpoint;
  }
}
