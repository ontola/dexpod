# frozen_string_literal: true

class WebId < ApplicationRecord
  devise :confirmable, :database_authenticatable, :lockable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable
  attr_accessor :redirect_url

  has_one :pod,
          inverse_of: :web_id,
          autosave: true,
          dependent: :restrict_with_exception

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

  def profile
    @profile ||= Profile.new(web_id: self) if pod
  end

  private

  def create_pod?
    pod.blank? || pod.pod_name_previously_changed?
  end
end
