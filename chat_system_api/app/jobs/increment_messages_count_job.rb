class IncrementMessagesCountJob < ApplicationJob
  queue_as :counter

  sidekiq_options unique: :until_executed, unique_args: ->(args) { [args.first] }

  def perform(chat_id)
    chat = Chat.find(chat_id)
    chat.increment!(:messages_count)
  end
end
