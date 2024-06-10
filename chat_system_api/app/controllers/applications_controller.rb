class ApplicationsController < ApplicationController
    before_action :set_application, only: [:show, :update, :destroy]
  
    # GET /applications
    def index
      @applications = Application.order(created_at: :desc).page(params[:page]).per(params[:per_page] || 10)
      render json: {
          applications: ActiveModelSerializers::SerializableResource.new(@applications, each_serializer: ApplicationSerializer),
          meta: pagination_meta(@applications)
        }
    end
  
    # GET /applications/:token
    def show
      render json: @application
    end
  
    # POST /applications
    def create
      @application = Application.new(application_params)
  
      if @application.save
        render json: @application, status: :created, location: @application
      else
        render json: @application.errors, status: :unprocessable_entity
      end
    end
  
    # PUT /applications/:token
    def update
      if @application.update(application_params)
        render json: @application
      else
        render json: @application.errors, status: :unprocessable_entity
      end
    end
  
    # DELETE /applications/:token
    def destroy
      @application.destroy
    end
  
    private
  
    def set_application
      @application = Application.find_by!(token: params[:token])
    end
  
    def application_params
      params.require(:application).permit(:name)
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
  