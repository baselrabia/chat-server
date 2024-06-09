class MessagesController < ApplicationController
    before_action :set_application
    before_action :set_chat
    before_action :set_message, only: [:show]
  
    # GET /applications/:application_token/chats/:chat_number/messages
    def index
      @messages = @chat.messages #todo pagination // sorted desc  
      render json: @messages.as_json(except: [:id, :chat_id])
    end
  
    # GET /applications/:application_token/chats/:chat_number/messages/:number
    def show
      render json: {message_number: @message.number, chat_number: @chat.number, body: @message.body}
    end
  
    # POST /applications/:application_token/chats/:chat_number/messages
    def create
      msg_number = generate_message_number(@application.token, @chat.number)

      MessageCreationWorker.perform_async(@application.token, @chat.number, msg_number, message_params[:body])

      render json: { message_number: msg_number }, status: :accepted
    end
    
    # GET /applications/:application_token/chats/:chat_number/messages/search
    def search
        # 
        if params[:query].present?
            @messages = @chat.messages.search(params[:query],@chat.id)
            render json: @messages 
        else
            render json: { error: "Query parameter is missing" }, status: :unprocessable_entity
        end
    end


    private

    def generate_message_number(application_token, chat_number)
      REDIS.incr("application:#{application_token},chat:#{chat_number}:msg_number")
    end
    
  
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
  