# frozen_string_literal: true

class ManifestsController < ApplicationController
  def show
    render json: current_resource.web_manifest
  end

  def tenant
    render json: {
      iri_prefix: LinkedRails.iri.host
    }
  end

  private

  def current_resource
    current_manifest
  end

  def valid_token?
    true
  end

  def verify_logged_in?
    false
  end
end
