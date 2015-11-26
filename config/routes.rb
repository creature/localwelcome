Rails.application.routes.draw do
  get 'events/show'

  root to: 'static#index'
  resources :chapters, only: [:show] do
    resources :events, only: [:show]
  end

end
