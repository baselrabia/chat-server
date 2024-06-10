class ChatsController < ApplicationController
    before_action :set_application
    before_action :set_chat, only: [:show]
  
    # GET /applications/:application_token/chats
    def index
      @chats = @application.chats.order(number: :desc).page(params[:page]).per(params[:per_page] || 10)
      render json: {
          data: ActiveModelSerializers::SerializableResource.new(@chats, each_serializer: ChatSerializer),
          meta: pagination_meta(@chats)
        }
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

    def pagination_meta(chats)
      {
        total_pages: chats.total_pages,
        current_page: chats.current_page,
        next_page: chats.next_page,
        prev_page: chats.prev_page,
        total_count: chats.total_count
      }
    end
  end
  