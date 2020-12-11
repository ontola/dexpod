# frozen_string_literal: true

require 'constraints/dex_transfer_constraint'
require 'constraints/dexes_constraint'
require 'constraints/dexpod_constraint'

Rails.application.routes.draw do
  concern :nested_actionable do
    namespace :actions do
      resources :items, path: '', only: %i[index show], collection: @scope.parent.try(:[], :controller)
    end
  end

  concern :site_setup do
    resource :home_page,
             only: :show,
             path: '/'
    resource :home_page,
             only: :show,
             path: :home do
      concerns :nested_actionable
      include_route_concerns
    end
  end

  use_linked_rails(
    bulk: 'bulk',
    current_user: 'current_user',
    manifests: 'manifests'
  )
  use_doorkeeper_openid_connect do
    controllers discovery: 'oauth/discovery'
  end

  get '_public/spi/find_tenant', to: 'manifests#tenant'

  scope 'oauth' do
    post 'register', to: 'oauth/clients#create'
  end

  namespace :actions do
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

  constraints(Constraints::DexTransferConstraint) do
    namespace :dex_transfer, path: nil do
      concerns :site_setup
    end
    resources :offers, only: %i[new create]

    # Stop routing for DexTransfer
    match '*path', to: 'not_found#show', via: :all
  end
  constraints(Constraints::DexesConstraint) do
    use_linked_rails_auth(
      authorizations: 'oauth/authorizations',
      devise_scope: :web_ids
    )
    namespace :dexes, path: nil do
      concerns :site_setup
    end
  end
  constraints(Constraints::DexpodConstraint) do # rubocop:disable Metrics/BlockLength
    use_linked_rails_auth(
      sessions: 'sessions'
    )
    resources :providers, only: [] do
      resource :identity, only: %i[show]
    end

    namespace :dexpod, path: nil do
      concerns :site_setup
    end
    resources :offers do
      include_route_concerns
      collection do
        concerns :nested_actionable
      end
      resources :invites, only: :index
      resources :rules, only: :index
      Rule.descendants.each do |klass|
        resources klass.route_key, only: :index
      end
    end
    resources :invites do
      include_route_concerns
      collection do
        concerns :nested_actionable
      end
      post '/accept', to: 'agreements#create'
    end
    resources :rules do
      include_route_concerns
    end
    Rule.descendants.each do |klass|
      resources klass.route_key do
        include_route_concerns
      end
    end
    resources :agreements
  end

  get :pod, to: 'pods#show'

  constraints(Constraints::DexpodConstraint) do
    resources :nodes,
              only: %i[index show new create] do
      include_route_concerns
      collection do
        concerns :nested_actionable
      end
    end

    Node.descendants.each do |klass|
      resource_name = klass.model_name.route_key

      resources resource_name, only: %i[show new create] do
        klass.collections.each do |collection|
          resources collection[:name], only: %i[index new create] do
            include_route_concerns
            collection do
              concerns :nested_actionable
            end
          end
        end

        include_route_concerns
        collection do
          concerns :nested_actionable
        end
      end
    end
  end

  resources :users,
            only: %i[show new create] do
    include_route_concerns
  end

  resource :profile, only: :show, path: :profile

  match '*path', to: 'not_found#show', via: :all, constraints: lambda { |req|
                                                                 req.path.exclude? 'rails/active_storage'
                                                               }
end
