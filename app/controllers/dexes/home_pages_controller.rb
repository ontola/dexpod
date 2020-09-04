# frozen_string_literal: true

module Dexes
  # Controls the homepage for dexes
  class HomePagesController < ::HomePageController
    active_response :show

    private

    def homepage_widgets
      @homepage_widgets ||= []
    end

    def welcome_text
      'Welkom bij Dexes!'
    end
  end
end
