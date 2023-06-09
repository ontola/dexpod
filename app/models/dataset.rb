# frozen_string_literal: true

class Dataset < ApplicationRecord
  enhance LinkedRails::Enhancements::Actionable
  enhance LinkedRails::Enhancements::Creatable
  enhance LinkedRails::Enhancements::Updatable
  enhance LinkedRails::Enhancements::Indexable
  enhance LinkedRails::Enhancements::Tableable

  belongs_to :user
  has_many :dataset_themes, dependent: :destroy
  has_many :distributions, dependent: :destroy
  has_many :nodes, through: :distributions
  accepts_nested_attributes_for :distributions
  accepts_nested_attributes_for :dataset_themes

  attribute :license, IRIType.new
  attribute :themes, array: true

  validates :description, length: {maximum: MAXIMUM_DESCRIPTION_LENGTH}
  validates :license_description, length: {maximum: MAXIMUM_DESCRIPTION_LENGTH}

  def themes
    dataset_themes.pluck(:theme).map { |theme| RDF::URI(theme) }
  end

  def themes=(raw_value) # rubocop:disable Metrics/AbcSize
    value = raw_value.is_a?(Array) ? raw_value : [raw_value].compact

    removed_themes =
      dataset_themes
        .reject { |dataset_theme| value.include?(dataset_theme.theme) }
    new_themes = value - dataset_themes.pluck(:theme)

    removed_themes.each(&:mark_for_destruction)
    new_themes.each { |theme| dataset_themes << DatasetTheme.new(dataset: self, theme: theme) }
    themes_will_change! if removed_themes.any? || new_themes.any?
  end

  def web_id
    user&.identities&.first
  end

  class << self
    def build_new(opts = {})
      return super unless opts[:collection].parent.is_a?(Node)

      child = super
      child.distributions << Distribution.new(node: opts[:collection].parent)
      child
    end

    def show_includes
      super + [:distributions]
    end
  end
end
