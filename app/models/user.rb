# frozen_string_literal: true

class User < ApplicationRecord
  enhance LinkedRails::Enhancements::Actionable
  enhance LinkedRails::Enhancements::Updatable
  include RootHelper
  devise :confirmable, :database_authenticatable, :lockable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable
  attr_accessor :redirect_url

  has_one :pod,
          inverse_of: :user,
          autosave: true,
          dependent: :restrict_with_exception
  has_many :agreements

  with_collection :agreements

  accepts_nested_attributes_for :pod

  def display_name
    email
  end

  def guest?
    false
  end

  def password_required?
    !password.nil? || !password_confirmation.nil?
  end

  def pod_owner?
    !public_tenant? && !dex_transfer? && pod&.pod_name == current_tenant.to_s
  end

  def profile
    @profile ||= Profile.new(user: self) if pod
  end

  private

  def create_pod?
    pod.blank? || pod.pod_name_previously_changed?
  end
end
