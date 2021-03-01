# frozen_string_literal: true

module Distributable
  module Model
    extend ActiveSupport::Concern

    included do
      with_collection :datasets
    end
  end
end
