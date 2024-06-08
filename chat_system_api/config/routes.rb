require 'sidekiq/web'


Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  # Sidekiq Web UI
  mount Sidekiq::Web => '/sidekiq'

  resources :applications, param: :token do
    resources :chats, param: :number, only: [:index, :show, :create] do
      resources :messages, param: :number, only: [:index, :show, :create] do
        collection do
          get 'search'
        end
      end
    end
  end
end
