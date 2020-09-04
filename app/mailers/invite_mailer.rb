# frozen_string_literal: true

class InviteMailer < ApplicationMailer
  def invite_mail
    @invite = params[:invite]
    mail(to: @invite.email, subject: 'Uitnodiging voor Dexes')
  end
end
