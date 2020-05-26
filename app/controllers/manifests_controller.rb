# frozen_string_literal: true

class ManifestsController < ApplicationController
  def show
    render json: manifest
  end

  private

  def app_name
    'Dexes'
  end

  def manifest # rubocop:disable Metrics/MethodLength
    {
      background_color: '#eef0f2',
      dir: :rtl,
      display: :standalone,
      lang: :nl,
      name: app_name,
      ontola: {
        secondary_main: theme_color,
        secondary_text: '#FFFFFF',
        css_class: 'dexes',
        primary_main: theme_color,
        primary_text: '#FFFFFF'
      },
      scope: scope,
      serviceworker: {
        src: "#{scope}/sw.js?manifestLocation=#{Rack::Utils.escape("#{scope}/manifest.json")}",
        scope: scope
      },
      short_name: app_name,
      start_url: scope,
      theme_color: theme_color
    }
  end

  def scope
    @scope ||= LinkedRails.iri.to_s
  end

  def theme_color
    current_pod&.theme_color || '#64a6bd'
  end

  def valid_token?
    true
  end

  def verify_logged_in?
    false
  end
end
