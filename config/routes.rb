# frozen_string_literal: true

Rails.application.routes.draw do
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

  resources :users
end
