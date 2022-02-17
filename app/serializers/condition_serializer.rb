# frozen_string_literal: true

class ConditionSerializer < LinkedSerializer
  enum :type,
       options: Condition.type_options,
       predicate: NS.app[:conditionType], &:rdf_type

  class << self
    def inherited(klass)
      super

      klass.serializable_class&.condition_attrs&.each do |key, options|
        klass.attribute(key, predicate: options[:predicate] || NS.app["condition#{key.to_s.camelize}"])
      end
    end
  end
end
