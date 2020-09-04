# frozen_string_literal: true

module DexTransfer
  # Controls the homepage of DexTransfer
  class HomePagesController < ::HomePageController
    active_response :show

    private

    def homepage_widgets
      @homepage_widgets ||= []
    end

    def welcome_text
      'Welkom bij DexTransfer!'
    end
  end
end
