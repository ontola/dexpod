# frozen_string_literal: true

class ApplicationForm < LinkedRails::Form
  class << self
    def form_options_iri(attr, klass = model_class)
      -> { LinkedRails.iri(path: "/enums/#{klass.to_s.tableize}/#{attr}") }
    end
  end
end
