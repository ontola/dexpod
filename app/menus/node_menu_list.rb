# frozen_string_literal: true

class NodeMenuList < ApplicationMenuList
  has_menu :quick,
           menus: -> { quick_links }

  def quick_links
    [
      menu_item(:update, image: 'fa-pencil', href: resource.action(:update)&.iri),
      menu_item(:destroy, image: 'fa-close', href: resource.action(:destroy)&.iri),
      menu_item(:publish, image: 'fa-send', href: publish_action)
    ].compact
  end

  private

  def publish_action
    if resource.datasets.any?
      resource.datasets.first.iri
    else
      resource.dataset_collection.action(:create)&.iri
    end
  end
end
