# frozen_string_literal: true

require 'constraints/dexes_constraint'
require 'constraints/dexpod_constraint'

Rails.application.routes.draw do
  concern :site_setup do
    resource :home_page,
             only: :show,
             path: '/'
    resource :home_page,
             only: :show,
             path: :home
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

  constraints(Constraints::DexesConstraint) do
    use_linked_rails_auth(
      authorizations: 'oauth/authorizations',
      devise_scope: :web_ids
    )
    namespace :dexes, path: nil do
      concerns :site_setup
    end
  end

  constraints(Constraints::DexpodConstraint) do
    use_linked_rails_auth(
      sessions: 'sessions'
    )
    resources :providers, only: [] do
      resource :identity, only: %i[show]
    end

    namespace :dexpod, path: nil do
      concerns :site_setup
    end
  end

  singular_linked_resource(Pod)
  singular_linked_resource(WebId)

  constraints(Constraints::DexpodConstraint) do
    linked_resource(Node)
    Node.descendants.each do |klass|
      linked_resource(klass)
    end
    linked_resource(Condition)
    Condition.types.each do |condition_class|
      linked_resource(condition_class, controller: :conditions)
    end
    linked_resource(Dataset)
    linked_resource(Dataspace)
    linked_resource(Deal)
    linked_resource(Distribution)
    linked_resource(Offer)
  end

  linked_resource(User)
  singular_linked_resource(Profile)

  match '*path',
        to: 'not_found#show',
        via: :all,
        constraints: lambda { |req|
          req.path.exclude? 'rails/active_storage'
        }
end
