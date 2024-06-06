class Message < ApplicationRecord
  belongs_to :chat, counter_cache: true

  validates :number, presence: true, uniqueness: { scope: :chat_id }
  validates :body, presence: true

  before_validation :set_number, on: :create

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
                    { query_string: { query: "*#{term}*", fields: [:body] } }
                ]
            }
        }
    )
    response.results.map { |r| {body: r._source.body, number: r._source.number} }
  end

  private

  def set_number
    self.number = (chat.messages.maximum(:number) || 0) + 1
  end
end

# Ensure the Elasticsearch index is created and the model data is indexed
Message.__elasticsearch__.create_index! index: Message.index_name, force: true
Message.import force: true