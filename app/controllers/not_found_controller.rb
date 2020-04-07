# frozen_string_literal: true

class NotFoundController < LinkedRails::NotFoundController
  private

  def verify_logged_in?
    false
  end
end
