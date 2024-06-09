class ChatsController < ApplicationController
    before_action :set_application
    before_action :set_chat, only: [:show]
  
    # GET /applications/:application_token/chats
    def index
      @chats = @application.chats
      render json: @chats
    end
  
    # GET /applications/:application_token/chats/:number
    def show
      render json: @chat
    end
  
    # POST /applications/:application_token/chats
    def create
      #validation application 
      # generated chat number
      chat_number = generate_chat_number(@application.token)
      
      # Queue the job with the application token
      ChatCreationWorker.perform_async(@application.token, chat_number)

      render json: { chat_number: chat_number }, status: :accepted   
    end
  
    private
    def generate_chat_number(application_token)
      REDIS.incr("application:#{application_token}:chat_number")
    end

    def set_application
      @application = Application.find_by!(token: params[:application_token])
    end
  
    def set_chat
      @chat = @application.chats.find_by!(number: params[:number])
    end
  end
  