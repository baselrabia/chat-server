class ChatCreationWorker
    include Sidekiq::Worker

    def perform(application_token)
        application = Application.find_by!(token: application_token)

        # Use transaction for atomicity
        Chat.transaction do
            last_chat = application.chats.order(:number).last
            chat_number = last_chat ? last_chat.number + 1 : 1

            chat = application.chats.create(number: chat_number)
            chat.save!
        end
    end
end