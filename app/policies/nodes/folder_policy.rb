# frozen_string_literal: true

class FolderPolicy < NodePolicy
  permit_attributes %i[
    display_name
    title
    type
    parent
    folder_id
  ]
end
