# frozen_string_literal: true

class NodesController < AuthorizedController
  active_response :index, :show

  Node.descendants.each do |klass|
    has_collection_action(
      "new_#{klass.name.underscore}",
      **create_collection_options(
        inherit: false,
        predicate: NS.ontola[:createAction],
        root_relative_iri: lambda {
          resource.parent.send("#{klass.name.underscore}_collection").action(:create).iri.path
        }
      )
    )
  end

  private

  def destroy_success_location
    current_resource&.parent&.iri&.to_s || current_pod.iri.to_s
  end
end
