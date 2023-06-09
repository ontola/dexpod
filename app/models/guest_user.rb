# frozen_string_literal: true

class GuestUser < User
  include LinkedRails::Model
  attr_writer :id

  def display_name
    'Gast'
  end

  def email; end

  def guest?
    true
  end

  def id
    @id ||= SecureRandom.hex
  end

  def iri_opts
    {id: id}
  end

  def pod_owner?
    false
  end

  def self.iri
    NS::ONTOLA[:GuestUser]
  end
end
