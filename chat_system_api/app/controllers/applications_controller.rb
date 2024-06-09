class ApplicationsController < ApplicationController
    before_action :set_application, only: [:show, :update, :destroy]
  
    # GET /applications
    def index
      @applications = Application.all #ToDo: pagination -- uuid
      render json: @applications
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
  end
  