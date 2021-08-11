# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  include RootHelper
  include LinkedRails::Model

  MAXIMUM_DESCRIPTION_LENGTH = 20_000

  self.abstract_class = true
end
