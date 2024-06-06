Rails.application.routes.draw do
  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check

  resources :applications, param: :token do
    resources :chats, param: :number, only: [:index, :show, :create] do
      resources :messages, param: :number, only: [:index, :show, :create]
    end
  end
end
