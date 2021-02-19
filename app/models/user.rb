# frozen_string_literal: true

class User < ApplicationRecord
  include RootHelper

  has_many :identities, dependent: :destroy

  def display_name
    "User #{id}"
  end

  def guest?
    false
  end

  def pod_owner?
    !public_tenant? && !dex_transfer? && pod&.pod_name == current_tenant.to_s
  end

  def pod
    dex_identity = identities.dexpod.first
    name = dex_identity&.identifier&.match(%r{^https:\/\/(\w*)\.#{LinkedRails.host}\/pod\/profile#me$})&.captures&.first

    Pod.find_by!(pod_name: name) if name
  end
end
