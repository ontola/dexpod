# frozen_string_literal: true

class AppMenuList < ApplicationMenuList
  include RootHelper

  has_menu :info,
           label: -> { 'Gebruiker' },
           menus: -> { info_links }
  has_menu :navigations,
           iri_base: '/menus',
           menus: -> { navigation_links }
  has_menu :user,
           label: -> { user_context.display_name },
           menus: -> { user_menu_items }
  has_menu :session,
           menus: -> { session_links }

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

    items
  end

  def info_links # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
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
        href: LinkedRails.iri(host: LinkedRails.host)
      )
    end
    items
  end

  def session_links # rubocop:disable Metrics/MethodLength
    items = []
    items << menu_item(
      :sign_in,
      label: I18n.t('actions.sessions.create.label'),
      href: LinkedRails.iri(path: 'u/sign_in')
    )
    items << menu_item(
      :password,
      label: I18n.t('actions.passwords.create.label'),
      href: LinkedRails.iri(path: 'users/password/new')
    )
    items << menu_item(
      :confirmation,
      label: I18n.t('actions.confirmations.create.label'),
      href: LinkedRails.iri(path: 'users/confirmation/new')
    )
    items
  end

  def user_menu_items
    return [] if user_context.guest?

    items = []
    items << update_pod_item if user_context.try(:pod_owner?)
    items << user_menu_sign_out_item
    items
  end

  def update_pod_item
    menu_item(
      :settings,
      label: I18n.t('users.settings.title'),
      href: current_pod.action(:update).iri
    )
  end

  def user_menu_sign_out_item
    menu_item(
      :signout,
      action: NS::LIBRO['actions/logout'],
      label: I18n.t('menu.sign_out'),
      href: LinkedRails.iri(path: :logout)
    )
  end
end
