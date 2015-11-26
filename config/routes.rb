Rails.application.routes.draw do
  devise_for :users

  root to: 'static#index'
  resources :chapters, only: [:show] do
    resources :events, only: [:show]
  end

  namespace :admin do
    get '/', to: "admin#index"
    resources :chapters do
      resources :events
    end
  end
end
