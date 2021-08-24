# frozen_string_literal: true

class DatasetMenuList < ApplicationMenuList
  has_menu :actions,
           image: 'fa-ellipsis-v',
           menus: -> { actions_links }

  def actions_links
    [
      menu_item(
        :update,
        href: resource.action(:update)&.iri,
        image: 'fa-edit'
      )
    ].compact
  end
end
