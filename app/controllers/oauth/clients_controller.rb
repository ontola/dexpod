# frozen_string_literal: true

module Oauth
  class ClientsController < Doorkeeper::ApplicationsController
    skip_before_action :authenticate_admin!, only: %i[create]

    def create
      @application = Doorkeeper::Application.new(application_params)

      if @application.save
        render json: new_client_response
      else
        errors = @application.errors.full_messages

        render json: {errors: errors}, status: :unprocessable_entity
      end
    end

    private

    def application_params
      permitted_params = params.permit(:client_name, :issuer, :redirect_uris, :scope, redirect_uris: [], scope: [])
      {
        name: permitted_params[:client_name] || client_name_from_redirect_uri(permitted_params[:redirect_uris]),
        redirect_uri: permitted_params[:redirect_uris],
        scopes: permitted_params[:scope]
      }
    end

    def client_name_from_redirect_uri(redirect_uris)
      redirect_uris.map { |redirect_uri| URI(redirect_uri).host }.uniq.join(', ')
    end

    def new_client_response
      {
        client_id: @application.uid,
        client_secret: @application.secret,
        client_id_issued_at: @application.created_at.to_i,
        client_secret_expires_at: 0,
        redirect_uris: @application.redirect_uri.split
      }
    end
  end
end
