# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include ActiveResponse::Controller
  include LinkedRails::Controller
  before_action :set_manifest_header

  private

  def current_user
    @current_user ||= GuestUser.new
  end

  def serializer_params
    {
      scope: current_user
    }
  end

  def set_manifest_header
    response.headers['Manifest'] = "#{LinkedRails.iri}/manifest.json"
  end
end
