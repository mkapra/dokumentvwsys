# frozen_string_literal: true

Rails.application.routes.draw do
  get 'errors/not_found'
  get 'errors/internal_server_error'

  match "/404", :to => "errors#not_found", :via => :all
  match "/500", :to => "errors#internal_server_error", :via => :all

  resources :preferences
  resources :administration, only: %i[index new edit destroy]

  get 'documents/all', to: 'documents#all'
  resources :documents

  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  root to: 'documents#index'
end
