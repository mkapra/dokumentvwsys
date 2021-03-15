Rails.application.routes.draw do
  resources :documents
  resources :preferences
  resources :administration

  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  root to: 'documents#index'
end
