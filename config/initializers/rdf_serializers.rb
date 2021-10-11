# frozen_string_literal: true

RDF::Serializers.configure do |config|
  config.default_graph = NS.ll[:supplant]
end
