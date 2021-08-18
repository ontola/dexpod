# frozen_string_literal: true

module Dexes
  # Controls the homepage for dexes
  class HomePagesController < ::HomePageController
    active_response :show

    private

    def homepage_widgets
      @homepage_widgets ||= [
        LinkedRails::Widget.new(
          size: 3,
          resources: [LinkedRails.iri(path: '/u/session/new')]
        )
      ]
    end

    def welcome_text
      'Welkom bij Dexes!'
    end
  end
end
