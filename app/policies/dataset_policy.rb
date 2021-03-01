# frozen_string_literal: true

class DatasetPolicy < ApplicationPolicy
  permit_attributes %i[title description license license_description]
  permit_array_attributes %i[themes]
  permit_nested_attributes %i[distributions]

  def show?
    true
  end
end
