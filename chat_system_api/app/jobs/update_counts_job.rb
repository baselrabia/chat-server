class UpdateCountsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Application.find_each do |application|
      application.update(chats_count: application.chats.size)
    end

    Chat.find_each do |chat|
      chat.update(messages_count: chat.messages.size)
    end
  end
end
