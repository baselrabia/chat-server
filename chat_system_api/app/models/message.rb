class Message < ApplicationRecord
  belongs_to :chat

  validates :number, presence: true, uniqueness: { scope: :chat_id }
  validates :body, presence: true

  after_commit :enqueue_increment_messages_count_job, on: :create
  after_commit :enqueue_index_message_job, on: :create
  after_commit :enqueue_delete_message_job, on: :destroy
  
  
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  settings do
    mapping dynamic: false do
      indexes :body, type: :text, analyzer: :english
      indexes :chat_id
    end
  end

  def as_indexed_json(options={})
    self.as_json(only: [:body, :number, :chat_id])
  end
  
  def self.search(term, chat_id)
    response = __elasticsearch__.search(
        query: {
            bool: {
                must: [
                  { match: { chat_id: chat_id } },
                  { match: { body: term } }, 
                ]
            }
        }
    )
    response.results.map { |r| {body: r._source.body, number: r._source.number} }
  end

  private
  def enqueue_increment_messages_count_job
    IncrementMessagesCountJob.perform_later(chat_id)
  end

  def enqueue_index_message_job
    MessageIndexerWorker.perform_async('index', id)
  end

  def enqueue_delete_message_job
    MessageIndexerWorker.perform_async('delete', id)
  end
end
# # Ensure the Elasticsearch index is created and the model data is indexed
# Message.__elasticsearch__.create_index! index: Message.index_name, force: true
# Message.import force: true