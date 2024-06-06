class Message < ApplicationRecord
  belongs_to :chat, counter_cache: true

  
  validates :number,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 1 },
            uniqueness: { scope: :chat_id }
  validates :body, presence: true

  before_validation :set_number, on: :create

  private

  def set_number
    self.number = (chat.messages.maximum(:number) || 0) + 1
  end
end
