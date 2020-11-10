# frozen_string_literal: true

class ApplicationController < ActionController::API
  NAME_SPACES = %w[DexTransfer Dexes DexPod].freeze

  include ActionController::MimeResponds
  include ActiveResponse::Controller
  include LinkedRails::Controller
  include OauthHelper
  include RootHelper

  before_action :set_manifest_header

  private

  def const_get(const)
    namespace ? namespace.const_get(const) : const.to_s.safe_constantize
  end

  def current_manifest
    @current_manifest ||= manifest_class.new(pod: current_pod)
  end

  # The pod targeted in this request, if any
  def current_pod
    @current_pod ||= Pod.find_by!(pod_name: current_tenant) if pod?
  end

  def handle_and_report_error(error)
    raise if Rails.env.development? || Rails.env.test?

    Bugsnag.notify(error)
    raise if response_body

    handle_error(error)
  end

  def pod_owner?
    current_user.pod_owner?
  end

  def manifest_class
    case current_tenant
    when :dex_transfer
      DexTransfer::Manifest
    when :public
      Manifest
    else
      Dexpod::Manifest
    end
  end

  def namespace
    return unless params[:controller].include?('/')

    @namespace ||= NAME_SPACES
                     .detect { |name| params[:controller].split('/').shift.classify == name }
                     &.safe_constantize
  end

  def serializer_params
    {
      manifest: current_manifest,
      scope: current_user
    }
  end

  def set_manifest_header
    response.headers['Manifest'] = "#{LinkedRails.iri}/manifest.json"
  end
end
