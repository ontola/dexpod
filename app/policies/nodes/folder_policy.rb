# frozen_string_literal: true

class FolderPolicy < NodePolicy
  permit_attributes %i[
    display_name
    title
    type
    parent
    folder_id
  ]

  def show?
    pod_owner?
  end
end
