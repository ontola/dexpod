# frozen_string_literal: true

module Dexpod
  class Manifest < ::Manifest
    def app_name
      'Dexes'
    end

    def site_name
      pod.display_name
    end

    def site_theme_color
      pod.theme_color
    end
  end
end
