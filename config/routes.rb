Rails.application.routes.draw do
  root to: 'static#index'
  resources :chapters, only: [:show]
end
