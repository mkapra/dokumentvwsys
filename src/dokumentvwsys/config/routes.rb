Rails.application.routes.draw do
  resources :documents
  resources :administration

  devise_for :users, controllers: {
    registrations: 'users/registrations',
  }

  root to: 'documents#index'
end
