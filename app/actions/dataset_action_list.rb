# frozen_string_literal: true

class DatasetActionList < LinkedRails.action_list_parent_class
  has_action(
    :create,
    create_options.merge(
      image: 'fa-send'
    )
  )
  has_action(
    :update,
    update_options.merge(
      image: 'fa-send'
    )
  )
end
