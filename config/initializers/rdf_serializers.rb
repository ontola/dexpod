# frozen_string_literal: true

RDF::Serializers.configure do |config|
  config.default_graph = NS.ld[:supplant]
end
