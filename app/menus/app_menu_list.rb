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

  def dataset_item
    menu_item(
      :datasets,
      label: I18n.t('menu.datasets'),
      href: Dataset.collection_iri
    )
  end

  def navigation_links
    items = []
    items << menu_item(
      :home,
      label: I18n.t('menu.home'),
      href: LinkedRails.iri
    )
    items << dataset_item if RootHelper.pod?
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

    items << switch_to_pod_item if RootHelper.public_tenant
    items << switch_to_dexes_item unless RootHelper.public_tenant
    items << update_pod_item if user_context.try(:pod_owner?)
    items
  end

  def switch_to_pod_item
    return nil if user_context.guest?

    menu_item(
      :my_pod,
      label: I18n.t('menu.my_pod'),
      href: user_context.pod.home_iri
    )
  end

  def switch_to_dexes_item
    menu_item(
      :dexes_home,
      label: I18n.t('menu.dexes'),
      href: LinkedRails.iri(host: Rails.application.config.host_name)
    )
  end

  def update_pod_item
    menu_item(
      :settings,
      label: I18n.t('users.settings.title'),
      href: Pod.singular_resource(current_pod.dup).action(:update).iri
    )
  end
end
