# frozen_string_literal: true

class NodePolicy < ApplicationPolicy
  permit_attributes %i[
    display_name
    page
    folder_id
    owner
    parent_id
    rdf_type
  ]

  def show?
    pod_owner?

    # @todo pod_owner, shared or invitee
    # Invitees can only see the node, not the content
    true
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

  def index_children?(klass, opts = {})
    pod_owner?
  end

  def new_folder
    pod_owner?
  end

  def new_media_object
    pod_owner?
  end
end
