# frozen_string_literal: true

module DeltaHelper
  include LinkedRails::Helpers::DeltaHelper
  include RDF::Serializers::HextupleSerializer

  def hex_delta(array)
    array.map { |s| Oj.fast_generate(value_to_hex(*s)) }.join("\n")
  end

  def invalidate_resource(iri)
    [
      NS.sp.Variable,
      NS.sp.Variable,
      NS.sp.Variable,
      NS.ontola["invalidate?graph=#{CGI.escape(iri)}"]
    ]
  end

  def resource_added_delta(resource)
    delta = super
    delta.concat(resource.added_delta) if resource.respond_to?(:added_delta)
    delta
  end
end
