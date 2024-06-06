class MessagesController < ApplicationController
    before_action :set_application
    before_action :set_chat
    before_action :set_message, only: [:show]
  
    # GET /applications/:application_token/chats/:chat_number/messages
    def index
      @messages = @chat.messages
      render json: @messages
    end
  
    # GET /applications/:application_token/chats/:chat_number/messages/:number
    def show
      render json: @message
    end
  
    # POST /applications/:application_token/chats/:chat_number/messages
    def create
      @message = @chat.messages.build(message_params)
  
      if @message.save
        render json: @message, status: :created, location: [@application, @chat, @message]
      else
        render json: @message.errors, status: :unprocessable_entity
      end
    end
  
    private
  
    def set_application
      @application = Application.find_by!(token: params[:application_token])
    end
  
    def set_chat
      @chat = @application.chats.find_by!(number: params[:chat_number])
    end
  
    def set_message
      @message = @chat.messages.find_by!(number: params[:number])
    end
  
    def message_params
      params.require(:message).permit(:body)
    end
  end
  