Rails.application.routes.draw do
  resources :accounts

  get 'welcome/index'

  root 'welcome#index'
end
