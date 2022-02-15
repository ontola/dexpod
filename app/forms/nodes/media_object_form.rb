# frozen_string_literal: true

class MediaObjectForm < NodeForm
  include LinkedRails::Policy::AttributeConditions

  field :content_url,
        min_count: 1,
        datatype: NS.ll[:blob],
        label: ''
  field :payment_pointer

  hidden do
    field :content_type, sh_in: -> { MediaObject::CONTENT_TYPES }
    field :filename
  end
end
