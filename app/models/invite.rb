# frozen_string_literal: true

class Invite < ApplicationRecord
  enhance LinkedRails::Enhancements::Actionable
  enhance LinkedRails::Enhancements::Indexable
  belongs_to :offer
  has_one :user, through: :offer
  before_create :generate_secret
  after_create :send_invite_mail

  def assigner_email
    user.email
  end

  private

  def generate_secret
    self.secret = SecureRandom.urlsafe_base64(128)
  end

  def send_invite_mail
    InviteMailer.with({invite: self}).invite_mail.deliver_now
  end
end
