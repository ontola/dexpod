# frozen_string_literal: true

class NodePolicy < ApplicationPolicy
  permit_attributes %i[
    content_url
    display_name
    page
    folder_id
    owner
    parent_id
    payment_pointer
  ]

  def show?
    pod_owner? || broker_authorization(:show, record)
  end

  def create?
    pod_owner?
  end

  def update?
    pod_owner?
  end

  def delete?
    destroy?
  end

  def destroy?
    pod_owner?
  end

  def index_children?(_klass, _opts = {})
    show?
  end

  private

  def broker_authorization(action, resource)
    web_id = user_context&.dex_identity&.identifier
    return false if web_id.blank? || resource.new_record?

    DexBroker.authorize(
      action,
      resource.iri,
      web_id
    )
  end
end
