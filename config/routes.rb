Rails.application.routes.draw do
  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    invitations: 'users/invitations',
    passwords: 'users/passwords',
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  resources :accounts

  get 'welcome/index'

  root 'welcome#index'
end
