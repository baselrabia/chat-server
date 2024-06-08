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
      ChatCreationWorker.perform_async(@application.token)
      render json: { message: 'Chat creation initiated' }, status: :accepted
    end
  
    private
  
    def set_application
      @application = Application.find_by!(token: params[:application_token])
    end
  
    def set_chat
      @chat = @application.chats.find_by!(number: params[:number])
    end
  end
  