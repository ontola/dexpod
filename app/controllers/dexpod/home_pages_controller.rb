# frozen_string_literal: true

module Dexpod
  # Controls the homepage for individual pods
  class HomePagesController < ::HomePageController
    active_response :show

    private

    def homepage_widgets
      return [] unless pod_owner?

      @homepage_widgets ||= [
        root_node_widget,
        shared_with_me_widget
      ]
    end

    def shared_with_me_iri
      current_pod.web_id.recipient_agreement_collection.iri
    end

    def shared_with_me_widget
      LinkedRails::Widget.new(
        size: 3,
        resources: [shared_with_me_iri]
      )
    end

    def root_node_widget
      LinkedRails::Widget.new(
        size: 3,
        resources: [current_pod.root_node.iri],
        topology: NS.argu[:largeContainer]
      )
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
