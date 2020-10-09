# frozen_string_literal: true

class MediaObjectForm < NodeForm
  include LinkedRails::Policy::AttributeConditions

  field :content_url, min_count: 1, datatype: NS::LL[:blob]
end
