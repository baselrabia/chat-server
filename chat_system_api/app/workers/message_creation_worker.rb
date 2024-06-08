class MessageCreationWorker
    include Sidekiq::Worker

    def perform(application_token, chat_number, message_body)
        application = Application.find_by!(token: application_token)
        chat = application.chats.find_by!(number: chat_number)

        Message.transaction do
            last_message = chat.messages.order(:number).last
            message_number = last_message ? last_message.number + 1 : 1

            message = chat.messages.create(body: message_body, number: message_number)
            message.save!
        end
    end
end
