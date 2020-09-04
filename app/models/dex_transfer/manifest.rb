# frozen_string_literal: true

module DexTransfer
  class Manifest < ::Manifest
    def app_name
      'DexTransfer'
    end

    def background_color
      '#fff'
    end

    def css_class
      theme
    end

    def theme
      'dexTransfer'
    end

    def theme_options
      {
        primaryLine: app_name
      }
    end
  end
end
