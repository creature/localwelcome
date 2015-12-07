Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "registrations" }

  root to: 'static#index'
  resources :chapters, only: [:show] do
    resources :events, only: [:show]
  end

  resources :subscriptions, only: [:index, :create, :destroy]
  resources :invitations, only: [:create, :update, :destroy]
  get '/invitations/:token/accept', to: "invitations#accept", as: :accept_invitation
  get '/invitations/:token/decline', to: "invitations#decline", as: :decline_invitation

  resource :profile, only: [:show, :edit, :update]

  namespace :admin do
    get '/', to: "admin#index"
    post 'invitations/:id/invite', to: "invitations#invite", as: :invite
    post 'invitations/:id/mark_as_attended', to: "invitations#mark_as_attended", as: :mark_as_attended
    post 'invitations/:id/mark_as_no_show', to: "invitations#mark_as_no_show", as: :mark_as_no_show
    resources :chapters, only: [:show] do
      resources :events, only: [:show, :create, :edit, :update]
    end
  end
end
