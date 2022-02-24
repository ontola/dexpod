# frozen_string_literal: true

class Condition < ApplicationRecord
  belongs_to :dataset

  def offer_attributes
    condition_attributes.merge(type: self.class.to_s)
  end

  class << self
    def condition_attrs(attrs = nil)
      return @condition_attrs if attrs.nil?
      raise('condition_attrs already defined') unless @condition_attrs.nil?

      define_condition_attrs(attrs)
    end

    def currency_options
      @currency_options ||= Money::Currency.table.values.map do |options|
        [
          options[:iso_code],
          identifier: options[:iso_code],
          label: "#{options[:name]} (#{options[:iso_code]})"
        ]
      end
    end

    def type_options
      @type_options ||= types.index_with do |type|
        {exact_match: type.iri}
      end
    end

    def types
      [
        ImplicitDisclaimerCondition,
        ExplicitDisclaimerCondition,
        AttributionCondition,
        PaymentCondition,
        TimespanCondition
      ]
    end

    private

    def define_condition_attrs(attrs)
      @condition_attrs = attrs

      attrs.each do |key, condition_opts|
        validates(key, presence: true) if condition_opts[:required]
      end

      typed_store :condition_attributes, coder: ActiveRecord::TypedStore::IdentityCoder do |s|
        attrs.each do |key, condition_opts|
          s.send(condition_opts[:type], key, condition_opts.except(:type))
        end
      end
    end
  end
end
