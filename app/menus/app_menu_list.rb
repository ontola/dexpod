# frozen_string_literal: true

class AppMenuList < ApplicationMenuList
  include RootHelper

  has_menu :session,
           menus: -> { session_menu_items }
  has_menu :navigations,
           iri_base: '/menus',
           menus: -> { navigation_links }
  has_menu :user,
           label: -> { user_context.display_name },
           menus: -> { user_menu_items }

  def iri_template
    @iri_template ||= URITemplate.new('/menus{#fragment}')
  end

  private

  def navigation_links
    items = []
    items << menu_item(
      :home,
      label: I18n.t('menu.home'),
      href: LinkedRails.iri,
      image: 'fa-home'
    )
    if RootHelper.pod?
      items << menu_item(
        :datasets,
        label: I18n.t('menu.datasets'),
        href: Dataset.collection_iri
      )
    end

    items
  end

  def session_menu_items
    [
      sign_out_menu_item
    ]
  end

  def sign_out_menu_item
    menu_item(
      :signout,
      action: NS.libro['actions/logout'],
      label: I18n.t('menu.sign_out'),
      href: LinkedRails.iri(path: 'u/logout')
    )
  end

  def user_menu_items
    return [] if user_context.guest?

    items = []
    if !user_context.guest? && RootHelper.public_tenant?
      items << menu_item(
        :my_pod,
        label: I18n.t('menu.my_pod'),
        href: user_context.pod.home_iri
      )
    end
    unless RootHelper.public_tenant?
      items << menu_item(
        :dexes_home,
        label: I18n.t('menu.dexes'),
        href: LinkedRails.iri(host: Rails.application.config.host_name)
      )
    end
    items << update_pod_item if user_context.try(:pod_owner?)
    items
  end

  def update_pod_item
    menu_item(
      :settings,
      label: I18n.t('users.settings.title'),
      href: Pod.singular_resource(current_pod.dup).action(:update).iri
    )
  end
end
