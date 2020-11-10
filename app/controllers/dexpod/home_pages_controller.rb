# frozen_string_literal: true

module Dexpod
  # Controls the homepage for individual pods
  class HomePagesController < ::HomePageController
    active_response :show

    private

    def homepage_widgets # rubocop:disable Metrics/MethodLength
      return [] unless pod_owner?

      @homepage_widgets ||= [
        LinkedRails::Widget.new(
          size: 3,
          resources: [
            current_pod.root_node.iri
          ]
        ),
        LinkedRails::Widget.new(
          size: 3,
          resources: [
            Agreement.root_collection.iri
          ]
        )
      ]
    end

    def welcome_text
      "Welkom bij de '#{current_pod.pod_name}' pod!"
    end
  end
end
