Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :channels, only: [:index, :create, :destroy] do
        resources :messages, only: [:index, :create]
      end

      resources :users, only: [:create]
      resources :sessions, only: [:create, :destroy]
    end
  end

  devise_for :users
end
