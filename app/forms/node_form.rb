# frozen_string_literal: true

class NodeForm < ApplicationForm
  field :display_name, datatype: NS::XSD[:string]
end
