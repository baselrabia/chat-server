class MessageCreationWorker
    include Sidekiq::Worker

    def perform(application_token, chat_number, message_number, message_body)
        application = Application.find_by!(token: application_token)
        chat = application.chats.find_by!(number: chat_number)
  
        chat.messages.create!(body: message_body, number: message_number)
     end
end
