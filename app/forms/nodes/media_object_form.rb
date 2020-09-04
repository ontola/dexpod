# frozen_string_literal: true

class MediaObjectForm < NodeForm
  include LinkedRails::Policy::AttributeConditions

  field :content, min_count: 1
end
