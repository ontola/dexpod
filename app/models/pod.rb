# frozen_string_literal: true

class Pod < ApplicationRecord
  enhance LinkedRails::Enhancements::Updatable

  belongs_to :web_id
  belongs_to :root_node,
             class_name: 'Node',
             dependent: :destroy,
             optional: true

  after_create :setup_pod
  after_update :rename_pod, if: :rename_pod?
  validates :pod_name,
            uniqueness: true,
            presence: true
  validates :theme_color, presence: true

  alias_attribute :display_name, :pod_name

  def pod_name=(val)
    super(val&.downcase)
  end

  def iri
    @iri ||= LinkedRails.iri(host: "#{pod_name}.#{LinkedRails.host}#{root_relative_iri}")
  end

  def home_iri
    @home_iri ||= LinkedRails.iri(host: "#{pod_name}.#{LinkedRails.host}/")
  end

  def root_relative_iri
    RDF::URI('/pod')
  end

  private

  def create_tenant
    Apartment::Tenant.create(pod_name) unless ApplicationRecord.connection.schema_exists?(pod_name)

    seed_tenant
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

  def rename_pod
    ActiveRecord::Base.connection.execute(
      "ALTER SCHEMA #{ApplicationRecord.connection.quote_string(pod_name_was)} "\
      "RENAME TO #{ApplicationRecord.connection.quote_string(pod_name)}"
    )
  end

  def rename_pod?
    pod_name_previously_changed?
  end

  def seed_tenant
    Apartment::Tenant.switch(pod_name) do
      load(Dir[Rails.root.join('db/seeds/doorkeeper_apps.seeds.rb')][0])
    end
  end

  def setup_pod
    create_tenant
    create_fs
  end

  class << self
    def requested_singular_resource(_params, _user_context)
      RootHelper.current_pod
    end
  end
end
