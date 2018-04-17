Rails.application.routes.draw do
  resources :accounts

  root 'welcome#index'
end
