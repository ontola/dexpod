# frozen_string_literal: true

class DatasetPolicy < ApplicationPolicy
  permit_attributes %i[title description license dataspace_id data_owned]
  permit_attributes %i[data_owner], has_values: {data_owned: false}
  permit_array_attributes %i[themes]
  permit_nested_attributes(Condition.types.map { |klass| klass.name.underscore.to_sym })
  permit_nested_attributes %i[distributions]

  def show?
    true
  end
end
