# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include ActiveResponse::Controller
  include LinkedRails::Controller
  include OauthHelper
  before_action :set_manifest_header

  private

  def current_pod
    @current_pod ||= User.find_by!(pod_name: Apartment::Tenant.current).pod unless Apartment::Tenant.current == 'public'
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
