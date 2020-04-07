# frozen_string_literal: true

class VocabulariesController < LinkedRails::VocabulariesController
  def vocab_graph
    Rails.cache.fetch([::VERSION, 'ns_core'].join('.')) do
      super
    end
  end
end
