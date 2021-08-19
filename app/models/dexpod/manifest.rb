# frozen_string_literal: true

module Dexpod
  class Manifest < ::Manifest
    def app_name
      'DexPods'
    end

    def site_name
      pod.display_name
    end

    def site_theme_color
      pod.theme_color
    end

    def header_text
      'auto'
    end
  end
end
