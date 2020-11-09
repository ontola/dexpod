# frozen_string_literal: true

class Pod < ApplicationRecord
  enhance LinkedRails::Enhancements::Updatable

  belongs_to :user
  belongs_to :root_node,
             class_name: 'Node',
             dependent: :destroy,
             optional: true

  after_create :setup_pod
  after_update :rename_pod, if: :rename_pod?
  validates :pod_name, uniqueness: true
  validates :theme_color, presence: true

  alias_attribute :display_name, :pod_name

  def pod_name=(val)
    super(val&.downcase)
  end

  def iri
    @iri ||= LinkedRails.iri(host: "#{pod_name}.#{LinkedRails.host}/pod")
  end

  def home_iri
    @home_iri ||= LinkedRails.iri(host: "#{pod_name}.#{LinkedRails.host}/")
  end

  private

  def create_tenant
    Apartment::Tenant.create(pod_name)

    Apartment::Tenant.switch(pod_name) do
      load(Dir[Rails.root.join('db/seeds/doorkeeper_apps.seeds.rb')][0])
      libro_app = Doorkeeper::Application.find_by(uid: ENV['LIBRO_CLIENT_ID'])
      create_system_token(libro_app, 'service', ENV['RAILS_OAUTH_TOKEN'])
    end
  end

  def create_fs
    Apartment::Tenant.switch(pod_name) do
      self.root_node = Folder.new(
        root_id: nil,
        parent_id: nil,
        title: I18n.t('nodes.my_files')
      )
      root_node.save(validate: false)
    end
    save!
  end

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

  def rename_pod
    ActiveRecord::Base.connection.execute(
      "ALTER SCHEMA #{ApplicationRecord.connection.quote_string(pod_name_was)} "\
      "RENAME TO #{ApplicationRecord.connection.quote_string(pod_name)}"
    )
  end

  def rename_pod?
    pod_name_previously_changed?
  end

  def setup_pod
    create_tenant
    create_fs
  end
end
