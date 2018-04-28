require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    invitations: 'users/invitations',
    passwords: 'users/passwords',
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  resources :accounts
  resources :plans, except: [:destroy]
  resources :products, except: [:destroy]

  get 'dashboard', to: 'dashboard#index'
  scope 'settings', as: 'settings' do
    resources :billing, only: [:index], controller: 'settings/billing'
    resources :subscriptions, except: [:new], controller: 'settings/subscriptions'
  end

  authenticate :user, ->(u) { u.is_admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  root 'welcome#index'
end
