# frozen_string_literal: true

class Rule < ApplicationRecord
  enhance LinkedRails::Enhancements::Indexable

  belongs_to :offer
  enum action: {contains_private: 0, edit: 1, share: 2, attribution: 3}
end
