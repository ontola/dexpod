# frozen_string_literal: true

class CurrentUser
  include ActiveModel::Model

  include LinkedRails::Model

  attr_accessor :user

  def actor_type
    if user.is_a?(GuestUser)
      'GuestUser'
    else
      'ConfirmedUser'
    end
  end

  def rdf_type
    NS.ontola[actor_type]
  end

  class << self
    def route_key
      :c_a
    end
  end
end
