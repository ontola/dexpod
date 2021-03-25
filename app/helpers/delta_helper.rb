# frozen_string_literal: true

module DeltaHelper
  include RDF::Serializers::HextupleSerializer

  def hex_delta(array)
    array.map { |s| Oj.fast_generate(value_to_hex(*s)) }.join("\n")
  end

  def invalidate_resource(iri)
    [
      NS::SP.Variable,
      NS::SP.Variable,
      NS::SP.Variable,
      NS::ONTOLA["invalidate?graph=#{CGI.escape(iri)}"]
    ]
  end
end