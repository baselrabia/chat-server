class IncrementChatCountJob < ApplicationJob
  queue_as :counter

  sidekiq_options unique: :until_executed, unique_args: ->(args) { [args.first] }

  def perform(application_id)
    application = Application.find(application_id)
    application.increment!(:chats_count)
  end
end
