# frozen_string_literal: true

class Session < LinkedRails::Auth::Session
  attr_accessor :host

  class << self
    def action_list
      SessionActionList
    end
  end
end
