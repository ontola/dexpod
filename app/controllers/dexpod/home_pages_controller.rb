# frozen_string_literal: true

module Dexpod
  # Controls the homepage for individual pods
  class HomePagesController < ::HomePageController
    active_response :show

    private

    def homepage_widgets
      return [] unless pod_owner?

      @homepage_widgets ||= [
        LinkedRails::Widget.new(
          size: 3,
          resources: [
            current_pod.root_node.iri
          ]
        )
      ]
    end

    def welcome_text
      if pod_owner?
        'Welkom bij je pod!'
      else
        "Welkom bij de '#{current_pod.pod_name}' pod!"
      end
    end
  end
end
