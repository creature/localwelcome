Rails.application.routes.draw do
  devise_for :users
  get 'events/show'

  root to: 'static#index'
  resources :chapters, only: [:show] do
    resources :events, only: [:show]
  end

end
