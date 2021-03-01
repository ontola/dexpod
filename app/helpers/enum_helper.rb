# frozen_string_literal: true

module EnumHelper
  module_function

  def list_options(name, grouped: false) # rubocop:disable Metrics/MethodLength
    list = EnumHelper.read_list(name)

    Hash[
      list.map do |key, value|
        [
          RDF::URI(key),
          {
            iri: RDF::URI(key),
            group_by: grouped ? RDF::URI(value['parent'] || key) : nil,
            label: -> { value['labels'].map { |locale, label| RDF::Literal(label, language: locale.split('-').first) } }
          }
        ]
      end
    ]
  end

  def read_list(name)
    JSON.parse(File.read(Rails.root.join("config/lists/#{name}.json")))
  end
end
