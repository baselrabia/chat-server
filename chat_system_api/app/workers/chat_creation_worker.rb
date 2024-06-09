class ChatCreationWorker
    include Sidekiq::Worker
  
    def perform(application_token, chat_number)
        application = Application.find_by!(token: application_token)
   
        # Create the chat with the provided chat number
        application.chats.create!(number: chat_number)
    end
end
  