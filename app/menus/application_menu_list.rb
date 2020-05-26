# frozen_string_literal: true

class ApplicationMenuList < LinkedRails::Menus::List
  private

  def delete_iri(resource)
    iri = resource.iri.dup
    iri.path += '/delete'
    iri
  end

  def destroy_menu_item
    menu_item(
      :destroy,
      href: delete_iri(resource),
      image: 'fa-trash-o',
      policy: :destroy?
    )
  end

  def edit_iri(resource)
    iri = resource.iri.dup
    iri.path += '/edit'
    iri
  end

  def update_menu_item
    menu_item(
      :update,
      href: edit_iri(resource),
      image: 'fa-pencil',
      policy: :update?
    )
  end
end
