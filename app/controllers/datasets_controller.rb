# frozen_string_literal: true

class DatasetsController < AuthorizedController
  private

  def new_resource_params
    super.merge(
      user: current_user
    )
  end

  def resource_added_delta(resource)
    super + resource.nodes.map(&method(:invalidate_resource_delta))
  end
end
