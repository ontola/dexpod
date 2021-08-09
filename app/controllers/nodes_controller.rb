# frozen_string_literal: true

class NodesController < AuthorizedController
  active_response :index, :show

  private

  def actions_array
    Node
      .descendants
      .map { |node| node.root_collection.action(:create, user_context) }
      .select(&:available?)
  end

  def actions_collection
    @actions_collection ||= LinkedRails::Collection.new(
      collection_options.merge(
        association_base: actions_array,
        association_class: LinkedRails::Actions::Item,
        default_display: :grid,
        default_type: :paginated
      )
    )
  end

  def new_success
    return super unless self.class == NodesController

    respond_with_collection(index_success_options_rdf.merge(collection: collection_or_view(actions_collection)))
  end
end
