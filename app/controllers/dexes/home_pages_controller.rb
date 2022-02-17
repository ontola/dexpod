# frozen_string_literal: true

module Dexes
  # Controls the homepage for dexes
  class HomePagesController < ::HomePageController
    active_response :show

    private

    def go_to_pod_action
      LinkedRails::Actions::Item.new(
        http_method: :GET,
        label: '',
        root_relative_iri: '/home#go_to_pod',
        submit_label: I18n.t('menu.my_pod'),
        description: "Welkom terug, #{current_user.display_name}!",
        target_url: current_user.pod.home_iri
      )
    end

    def homepage_includes
      return [] if current_user.guest?

      [go_to_pod_action]
    end

    def homepage_widgets
      current_user.guest? ? homepage_widgets_guest : homepage_widgets_user
    end

    def homepage_widgets_user
      @homepage_widgets ||= [
        LinkedRails::Widget.new(
          size: 1,
          resources: [go_to_pod_action.target.iri],
          topology: NS.argu[:grid]
        )
      ]
    end

    def homepage_widgets_guest
      @homepage_widgets ||= [
        LinkedRails::Widget.new(
          size: 3,
          resources: [LinkedRails.iri(path: '/u/session/new')]
        )
      ]
    end

    def welcome_text
      'Welkom bij DexPods!'
    end
  end
end
