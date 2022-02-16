# frozen_string_literal: true

class NodeMenuList < ApplicationMenuList
  has_menu :quick,
           image: 'fa-ellipsis-v',
           label: '',
           menus: -> { quick_links }

  def quick_links
    [
      menu_item(:update, image: 'fa-pencil', href: resource.action(:update)&.iri),
      menu_item(:destroy, image: 'fa-close', href: resource.action(:destroy)&.iri)
    ].compact
  end
end
