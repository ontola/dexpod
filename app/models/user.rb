# frozen_string_literal: true

class User < ApplicationRecord
  devise :confirmable, :database_authenticatable, :lockable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable

  def guest?
    false
  end

  def password_required?
    !password.nil? || !password_confirmation.nil?
  end
end
