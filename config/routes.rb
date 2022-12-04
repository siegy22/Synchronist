Rails.application.routes.draw do
  root "dashboard#index"

  resource :config, only: [:edit, :update]
end
