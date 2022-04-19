# frozen_string_literal: true

class User < ApplicationRecord
  POD_NAME_MATCH = %r{^https:\/\/(\w*)\.#{Rails.application.config.host_name}\/profile#me$}.freeze

  has_many :identities, dependent: :destroy

  def dex_identity
    identities.dexpod.first
  end

  def display_name
    pod_name || "User #{id}"
  end

  def guest?
    false
  end

  def pod_name
    @pod_name ||= dex_identity&.identifier&.match(POD_NAME_MATCH)&.captures&.first
  end

  def pod_owner?
    !public_tenant? && pod&.pod_name == current_tenant.to_s
  end

  def pod
    Pod.find_by!(pod_name: pod_name) if pod_name
  end

  class << self
    def iri
      NS.schema.Person
    end
  end
end
