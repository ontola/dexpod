# frozen_string_literal: true

class PodsController < ApplicationController
  active_response :show

  private

  def update_success
    respond_with_redirect(
      location: LinkedRails.iri.to_s,
      reload: true
    )
  end
end
