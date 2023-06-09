# frozen_string_literal: true

class SessionForm < LinkedRails.form_parent_class
  field :host,
        datatype: NS::XSD[:string]

  hidden do
    field :redirect_url
  end
end
