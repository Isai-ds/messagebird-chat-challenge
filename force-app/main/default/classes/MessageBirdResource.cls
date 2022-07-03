public with sharing abstract class MessageBirdResource {
  protected MessageBirdClient channel;
  protected String id;
  protected Map<String, Object> params;
  protected Boolean loaded;

  public MessageBirdResource(MessageBirdClient channel) {
    this.channel = channel;
    this.loaded = false;
  }

  protected abstract void parseResponse(MessageBirdRestResponse response);
  protected abstract String getResourceUri();

  protected void getResource(Map<String, Object> vars) {
    if (!this.loaded) {
      this.loaded = true;
      String path = this.getResourceUri();
      MessageBirdRestResponse response = this.channel.create(path, 'GET', vars);
      this.parseResponse(response);
    }
  }

  public abstract class MessageBirdSingleResource extends MessageBirdResource {
    protected abstract Object get();
    public MessageBirdSingleResource(MessageBirdClient channel) {
      super(channel);
    }
  }

  public abstract class MessageBirdListResource extends MessageBirdResource {
    private List<Object> records;
    protected Integer offset;
    protected Integer limitCount;
    protected Integer count;
    protected Integer totalCount;

    protected abstract Object createNew(
      MessageBirdClient channel,
      String response
    );

    public MessageBirdListResource(MessageBirdClient channel) {
      this(channel, new Map<String, String>());
    }

    public MessageBirdListResource(
      MessageBirdClient channel,
      Map<String, Object> params
    ) {
      super(channel);
      this.params = params;
    }

    public List<Object> getRecords() {
      this.getResource(this.params);
      return this.records;
    }

    protected override void parseResponse(MessageBirdRestResponse response) {
      Map<String, Object> res = (Map<String, Object>) JSON.deserializeUntyped(
        response.getResponseBody()
      );
      this.offset = (Integer) res.get('offset');
      this.limitCount = (Integer) res.get('limit');
      this.count = (Integer) res.get('count');
      this.totalCount = (Integer) res.get('totalCount');
      records = (List<Object>) res.get('items');
    }

    protected Object createPost(
      String resourceUri,
      Map<String, Object> params
    ) {
      MessageBirdRestResponse response = this.channel.create(
        resourceUri,
        'POST',
        params
      );
      return createNew(this.channel, response.getResponseBody());
    }

    public Integer getOffset() {
      return this.offset;
    }

    public Integer getLimitCount() {
      return this.limitCount;
    }

    public Integer getCount() {
      return this.count;
    }

    public Integer getTotalCount() {
      return this.totalCount;
    }
  }
}
