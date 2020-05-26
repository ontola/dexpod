# frozen_string_literal: true

class AppMenuList < ApplicationMenuList
  has_menu :info,
           label: -> { 'Gebruiker' },
           menus: -> { info_links }
  has_menu :navigations,
           iri_base: '/menus',
           menus: -> { navigation_links }
  has_menu :user,
           menus: -> { [] }

  def iri_template
    @iri_template ||= URITemplate.new('/apex/menus{#fragment}')
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

    items
  end

  def info_links
    items = []
    items << menu_item(
      :signout,
      action: NS::ONTOLA['actions/logout'],
      label: I18n.t('menu.sign_out'),
      href: LinkedRails.iri(path: :logout)
    )
    items
  end
end
