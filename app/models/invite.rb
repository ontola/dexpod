# frozen_string_literal: true

class Invite < ApplicationRecord
  enhance LinkedRails::Enhancements::Actionable
  enhance LinkedRails::Enhancements::Indexable
  belongs_to :offer
  before_create :generate_secret
  after_create :send_invite_mail
  alias_attribute :name, :email

  private

  def generate_secret
    self.secret = SecureRandom.urlsafe_base64(128)
  end

  def send_invite_mail
    InviteMailer.with({invite: self}).invite_mail.deliver_now
  end
end
