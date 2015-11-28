Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "registrations" }

  root to: 'static#index'
  resources :chapters, only: [:show] do
    resources :events, only: [:show]
  end

  resources :subscriptions

  namespace :admin do
    get '/', to: "admin#index"
    resources :chapters do
      resources :events
    end
  end
end
