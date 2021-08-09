# frozen_string_literal: true

class DatasetsController < AuthorizedController
  private

  def resource_added_delta(resource)
    super + resource.nodes.map(&method(:invalidate_resource_delta))
  end
end
