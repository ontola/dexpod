# frozen_string_literal: true

class ApplicationForm < LinkedRails::Form
  class << self
    def form_options_iri(attr)
      -> { LinkedRails.iri(path: "/enums/#{model_class.to_s.tableize}/#{attr}") }
    end
  end
end
