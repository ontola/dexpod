# frozen_string_literal: true

class DatasetsController < AuthorizedController
  has_collection_create_action(
    image: 'fa-send',
  )
  has_resource_update_action(
    image: 'fa-send',
  )

  private

  def resource_added_delta(resource)
    super + resource.nodes.map(&method(:invalidate_resource_delta))
  end
end
