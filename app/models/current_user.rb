# frozen_string_literal: true

class CurrentUser
  include ActiveModel::Model

  include LinkedRails::Model

  attr_accessor :user

  def actor
    LinkedRails.iri(path: :web_id)
  end

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
    def requested_resource(_opts, user_context)
      new(user: user_context)
    end

    def route_key
      :c_a
    end
  end
end
