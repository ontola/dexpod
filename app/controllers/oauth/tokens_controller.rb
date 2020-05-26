# frozen_string_literal: true

require 'errors'

module Oauth
  class TokensController < Doorkeeper::TokensController
    include ActionController::MimeResponds
    include LinkedRails::Helpers::OntolaActionsHelper
    include LinkedRails::Controller::ErrorHandling

    private

    def handle_token_exception(exception) # rubocop:disable Metrics/AbcSize
      error = get_error_response_from_exception(exception)
      headers.merge!(error.headers)
      Rails.logger.info(error.body.merge(code: error_id(exception)).to_json)
      self.response_body = error.body.merge(code: error_id(exception)).to_json
      self.status = error.status
    end

    def raise_login_error(request) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      raise(
        if User.find_by(email: request.params[:user][:email]).nil?
          Errors::UnknownEmail.new
        elsif request.env['warden'].message == :invalid
          Errors::WrongPassword.new
        elsif request.env['warden'].message == :not_found_in_database
          Errors::WrongPassword.new
        else
          "unhandled login state #{request.env['warden'].message}"
        end
      )
    end
  end
end
