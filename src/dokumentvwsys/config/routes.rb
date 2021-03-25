# frozen_string_literal: true

Rails.application.routes.draw do
  resources :administration

  resources :preferences do
    get 'logo', to: 'preferences#logo', on: :collection, as: 'logo'
  end

  get 'documents/all', to: 'documents#all'
  resources :documents

  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  root to: 'documents#index'
end
