# frozen_string_literal: true

class DatasetActionList < LinkedRails.action_list_parent_class
  has_collection_create_action(
    image: 'fa-send'
  )

  has_resource_update_action(
    image: 'fa-send'
  )
end
