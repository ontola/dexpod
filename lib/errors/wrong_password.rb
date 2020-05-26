# frozen_string_literal: true

module Errors
  class WrongPassword < Doorkeeper::Errors::InvalidGrantReuse
  end
end
