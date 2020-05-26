# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#show'
  get '/home', to: 'home#show'
  get '/c_a', to: 'current_user#show'
  get '/ns/core', to: 'vocabularies#show'
  get '/manifest', to: 'manifests#show'

  namespace :actions, module: 'linked_rails' do
    resources :items, path: '', only: %i[index show]
  end
  resources :menus, module: 'linked_rails', only: %i[show index] do
    resources :sub_menus, only: :index, path: 'menus'
  end
  scope :apex, module: 'linked_rails' do
    resources :menus, only: %i[show index] do
      resources :sub_menus, only: :index, path: 'menus'
    end
  end

  use_doorkeeper do
    controllers tokens: 'oauth/tokens'
    controllers authorizations: 'oauth/authorizations'
  end
  use_doorkeeper_openid_connect do
    controllers discovery: 'oauth/discovery'
  end
  scope 'oauth' do
    post 'register', to: 'oauth/clients#create'
  end

  devise_for :users, skip: :all

  devise_scope :user do
    post '/users', to: 'registrations#create'
    delete '/account', to: 'registrations#destroy'
    put '/password', to: 'devise/passwords#update'
    post '/password', to: 'devise/passwords#create'
    get '/confirmation', to: 'devise/confirmations#show'
    post '/unlock', to: 'devise/unlocks#create'
    get '/unlock', to: 'devise/unlocks#show'
  end

  resources :users do
    include_route_concerns
  end

  match '*path', to: 'not_found#show', via: :all
end
