require 'sidekiq/web'

Rails.application.routes.draw do
  root "dashboard#index"

  resources :syncs, only: [:index, :show]
  resource :config, only: [:edit, :update]

  namespace :sender do
    resources :payloads, only: :index
  end

  namespace :receiver do
    resources :payloads, only: :index
  end

  mount Sidekiq::Web => '/sidekiq', as: :sidekiq
end
