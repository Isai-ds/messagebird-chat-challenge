public class MessageBirdRestResponse {
  private String responseBody;
  private Integer httpStatus;
  private String url;
  private String queryString;
  private Boolean error;
  private String contentType;

  public MessageBirdRestResponse(
    String url,
    String responseBody,
    Integer status
  ) {
    Pattern p = Pattern.compile('([^?]+)\\??(.*)');
    Matcher m = p.matcher(url);
    m.matches();
    this.url = m.group(1);
    this.queryString = m.group(2);
    this.responseBody = responseBody;
    this.httpStatus = status;
    this.error = (status >= 400);
  }

  public String getResponseBody() {
    return responseBody;
  }

  public Integer getHttpStatus() {
    return httpStatus;
  }

  public Boolean isClientError() {
    return (this.getHttpStatus() >= 400 && this.getHttpStatus() < 500);
  }

  public Boolean isServerError() {
    return this.getHttpStatus() >= 500;
  }

  public void setContentType(String contentType) {
    this.contentType = contentType;
  }
}
