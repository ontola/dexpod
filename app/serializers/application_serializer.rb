# frozen_string_literal: true

class ApplicationSerializer
  include RDF::Serializers::ObjectSerializer

  class << self
    def never(_object, _params)
      false
    end
  end
end
