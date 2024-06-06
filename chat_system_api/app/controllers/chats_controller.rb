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
      @chat = @application.chats.build
  
      if @chat.save
        render json: @chat, status: :created, location: [@application, @chat]
      else
        render json: @chat.errors, status: :unprocessable_entity
      end
    end
  
    private
  
    def set_application
      @application = Application.find_by!(token: params[:application_token])
    end
  
    def set_chat
      @chat = @application.chats.find_by!(number: params[:number])
    end
  end
  