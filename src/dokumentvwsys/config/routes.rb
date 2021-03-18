# frozen_string_literal: true

Rails.application.routes.draw do
  resources :preferences
  resources :administration

  get 'documents/all', to: 'documents#all'
  resources :documents

  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  root to: 'documents#index'
end
