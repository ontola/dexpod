# frozen_string_literal: true

class Pod
  include ActiveModel::Model
  include LinkedRails::Model

  attr_accessor :user
  delegate :pod_name, :theme_color, to: :user

  def iri
    @iri ||= LinkedRails.iri(host: "#{pod_name}.#{LinkedRails.host}")
  end

  def create_tenant
    Apartment::Tenant.create(pod_name)

    Apartment::Tenant.switch(pod_name) do
      load(Dir[Rails.root.join('db/seeds/doorkeeper_apps.seeds.rb')][0])
      libro_app = Doorkeeper::Application.find_by(uid: ENV['ARGU_APP_ID'])
      create_system_token(libro_app, 'service', ENV['RAILS_OAUTH_TOKEN'])
    end
  end

  private

  def create_system_token(app, scopes, secret)
    token = Doorkeeper::AccessToken.find_or_create_for(
      application: app,
      scopes: scopes,
      expires_in: 10.years.to_i,
      resource_owner: nil,
      use_refresh_token: true
    )
    token.update(token: secret)
    token
  end
end
