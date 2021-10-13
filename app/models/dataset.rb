# frozen_string_literal: true

class Dataset < ApplicationRecord
  include Invalidatable

  enhance LinkedRails::Enhancements::Creatable
  enhance LinkedRails::Enhancements::Updatable

  belongs_to :user
  has_many :dataset_themes, dependent: :destroy
  has_many :distributions, dependent: :destroy
  has_many :nodes, through: :distributions
  accepts_nested_attributes_for :distributions
  accepts_nested_attributes_for :dataset_themes

  attribute :license, IRIType.new
  attribute :themes, array: true

  validates :title, presence: true
  validates :description, length: {maximum: MAXIMUM_DESCRIPTION_LENGTH}, presence: true
  validates :license_description, length: {maximum: MAXIMUM_DESCRIPTION_LENGTH}

  def show_includes
    super + %i[
      distributions
    ]
  end

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
    def attributes_for_new(opts)
      {user: opts[:user_context]}
    end

    def build_new(opts = {})
      return super unless opts[:parent].is_a?(Node)

      child = super
      child.distributions << Distribution.new(node: opts[:parent])
      child
    end
  end
end
