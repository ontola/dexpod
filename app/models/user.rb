# frozen_string_literal: true

class User < ApplicationRecord
  include RootHelper

  has_many :identities, dependent: :destroy

  def display_name
    pod_name || "User #{id}"
  end

  def guest?
    false
  end

  def pod_name
    @pod_name ||=
      dex_identity&.identifier&.match(%r{^https:\/\/(\w*)\.#{LinkedRails.host}\/pod\/profile#me$})&.captures&.first
  end

  def pod_owner?
    !public_tenant? && pod&.pod_name == current_tenant.to_s
  end

  def pod
    Pod.find_by!(pod_name: pod_name) if pod_name
  end

  private

  def dex_identity
    identities.dexpod.first
  end
end
