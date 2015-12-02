Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "registrations" }

  root to: 'static#index'
  resources :chapters, only: [:show] do
    resources :events, only: [:show]
  end

  resources :subscriptions, only: [:index, :create, :destroy]
  resources :invitations, only: [:create, :update, :destroy]
  resources :profiles, only: [:show, :edit, :update]

  namespace :admin do
    get '/', to: "admin#index"
    resources :chapters do
      resources :events
    end
  end
end
