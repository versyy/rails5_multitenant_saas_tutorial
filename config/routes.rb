Rails.application.routes.draw do
  devise_for :users
  resources :accounts

  get 'welcome/index'

  root 'welcome#index'
end
