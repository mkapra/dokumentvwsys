Rails.application.routes.draw do
  resources :documents
  resources :administration
  devise_for :users

  root to: 'documents#index'
end
