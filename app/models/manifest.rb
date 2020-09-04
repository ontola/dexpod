# frozen_string_literal: true

class Manifest
  include ActiveModel::Model
  include LinkedRails::Model

  attr_accessor :pod, :scope

  def app_name
    'Dexes'
  end

  def app_theme_color
    '#64a6bd'
  end

  def background_color
    '#eef0f2'
  end

  def css_class
    'dexes'
  end

  def site_theme_color
    app_theme_color
  end

  def site_secondary_color
    '#800080'
  end

  def scope # rubocop:disable Lint/DuplicateMethods
    @scope ||= LinkedRails.iri.to_s
  end

  def site_name
    app_name
  end

  def theme; end

  def theme_options
    {}
  end

  def web_manifest
    web_manifest_base.merge(
      ontola: web_manifest_ontola_section,
      serviceworker: web_manifest_sw_section
    )
  end

  def web_manifest_base # rubocop:disable Metrics/MethodLength
    {
      background_color: background_color,
      dir: :rtl,
      display: :standalone,
      lang: :nl,
      name: app_name,
      scope: scope,
      short_name: app_name,
      start_url: scope,
      theme_color: site_theme_color
    }
  end

  def web_manifest_ontola_section
    {
      css_class: 'dexes',
      header_background: 'primary',
      header_text: 'auto',
      primary_color: site_theme_color,
      secondary_color: site_secondary_color,
      theme: theme,
      theme_options: theme_options.to_query
    }
  end

  def web_manifest_sw_section
    {
      src: "#{scope}/sw.js?manifestLocation=#{Rack::Utils.escape("#{scope}/manifest.json")}",
      scope: scope
    }
  end
end
