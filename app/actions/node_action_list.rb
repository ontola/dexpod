# frozen_string_literal: true

class NodeActionList < ApplicationActionList
  include Rails.application.routes.url_helpers

  Node.descendants.each do |klass|
    has_collection_action(
      "new_#{klass.name.underscore}",
      predicate: NS.ontola[:createAction],
      root_relative_iri: lambda {
        resource.parent.send("#{klass.name.underscore}_collection").action(:create).iri.path
      }
    )
  end
end
