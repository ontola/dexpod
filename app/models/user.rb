# frozen_string_literal: true

class User < ApplicationRecord
  enhance LinkedRails::Enhancements::Actionable
  enhance LinkedRails::Enhancements::Updatable
  devise :confirmable, :database_authenticatable, :lockable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable
  after_save :create_tenant, if: :create_tenant?

  def display_name
    email
  end

  def guest?
    false
  end

  def password_required?
    !password.nil? || !password_confirmation.nil?
  end

  def pod
    @pod ||= Pod.new(user: self) if pod_name
  end

  private

  def create_tenant
    pod.create_tenant
  end

  def create_tenant?
    pod_name_previously_changed?
  end
end
