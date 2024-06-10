class Chat < ApplicationRecord
  belongs_to :application
  has_many :messages, dependent: :destroy

  validates :number,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 1 },
            uniqueness: { scope: :application_id }

  after_commit :enqueue_increment_chat_count_job, on: :create

  private

  def enqueue_increment_chat_count_job
    IncrementChatCountJob.perform_later(application_id)
  end
  
end
