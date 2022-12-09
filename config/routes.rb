require 'sidekiq/web'

Rails.application.routes.draw do
  root "dashboard#index"

  resources :syncs, only: [:index, :show]
  resource :config, only: [:edit, :update]

  mount Sidekiq::Web => '/sidekiq', as: :sidekiq
end
