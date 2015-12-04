Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "registrations" }

  root to: 'static#index'
  resources :chapters, only: [:show] do
    resources :events, only: [:show]
  end

  resources :subscriptions, only: [:index, :create, :destroy]
  resources :invitations, only: [:create, :update, :destroy]
  resource :profile, only: [:show, :edit, :update]

  namespace :admin do
    get '/', to: "admin#index"
    post 'invitations/invite/:id', to: "invitations#invite", as: :invite
    resources :chapters do
      resources :events
    end
  end
end
