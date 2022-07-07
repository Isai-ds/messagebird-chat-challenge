public class MessageBirdRestResponse {
  private String responseBody;
  private Integer httpStatus;
  private String url;
  private Boolean error;
  private String contentType;

  public MessageBirdRestResponse(
    String url,
    String responseBody,
    Integer status
  ) {
    this.url = url;
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
