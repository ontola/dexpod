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

  def iri
    singular_iri
  end

  def offer_collection
    Offer.root_collection.new_child(
      filter: {NS.app[:recipients] => [profile.iri.to_s.sub('dexpods.localdev', 'staging.dexpods.eu')]}
    )
  end

  def otp_active?
    otp_secret&.active?
  end

  def owner_agreement_collection
    Deal.root_collection.new_child(
      filter: {NS.app[:recipients] => [profile.iri.to_s.sub('dexpods.localdev', 'staging.dexpods.eu')]},
      table_type: :owner
    )
  end

  def password_required?
    !password.nil? || !password_confirmation.nil?
  end

  def profile
    @profile ||= Profile.new(web_id: self) if pod
  end

  def recipient_agreement_collection
    Deal.root_collection.new_child(
      filter: {NS.app[:recipients] => [profile.iri.to_s.sub('dexpods.localdev', 'staging.dexpods.eu')]}
    )
  end

  def singular_iri
    @singular_iri ||= LinkedRails.iri(host: pod.pod_host, path: :profile)
  end

  def unscoped_iri
    LinkedRails.iri(path: :profile)
  end

  class << self
    def iri
      NS.foaf.PersonalProfileDocument
    end

    def singular_route_key
      :profile
    end

    def route_key
      :profile
    end

    def requested_singular_resource(_params, user_context)
      return RootHelper.current_pod&.web_id if RootHelper.pod?

      user_context.pod.web_id
    end
  end
end
