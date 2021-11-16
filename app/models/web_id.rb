# frozen_string_literal: true

class WebId < ApplicationRecord
  devise :confirmable, :database_authenticatable, :lockable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable
  attr_accessor :redirect_url

  has_one :otp_secret,
          dependent: :destroy,
          foreign_key: :owner_id,
          inverse_of: :owner
  has_one :pod,
          inverse_of: :web_id,
          autosave: true,
          dependent: :restrict_with_exception

  accepts_nested_attributes_for :pod

  def display_name
    pod&.pod_name || email
  end

  def guest?
    false
  end

  def otp_active?
    otp_secret&.active?
  end

  def password_required?
    !password.nil? || !password_confirmation.nil?
  end

  def profile
    @profile ||= Profile.new(web_id: self) if pod
  end

  def recipient_agreement_collection
    Deal.root_collection.new_child(
      filter: {NS.app[:recipients] => [profile.iri]}
    )
  end

  def owner_agreement_collection
    Deal.root_collection.new_child(
      filter: {NS.app[:dataOwner] => [profile.iri]}
    )
  end

  class << self
    def iri
      NS.schema.Person
    end

    def requested_singular_resource(_params, user_context)
      RootHelper.pod? ? user_context.pod.web_id : user_context
    end
  end
end
