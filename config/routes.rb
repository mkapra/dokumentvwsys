# frozen_string_literal: true

Rails.application.routes.draw do
  get 'legal/imprint'
  get 'legal/privacy_policy'

  get 'errors/not_found'
  get 'errors/internal_server_error'

  match '/404', to: 'errors#not_found', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all

  resources :administration, only: %i[index new edit destroy show]

  resources :preferences do
    get 'logo', to: 'preferences#logo', on: :collection, as: 'logo'
  end

  get 'documents/all', to: 'documents#all'
  get 'documents/list/:id', to: 'documents#list', as: 'documents_list'
  resources :documents

  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  root to: 'documents#index'
end
