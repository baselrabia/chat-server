Elasticsearch::Model.client = Elasticsearch::Client.new(
  host: ENV['ELASTICSEARCH_HOST'],
  transport_options: {
    request: { timeout: 5 }
  },
  log: true
)
