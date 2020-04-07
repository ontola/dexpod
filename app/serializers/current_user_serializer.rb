# frozen_string_literal: true

class CurrentUserSerializer < LinkedSerializer
  attribute :actor_type, predicate: NS::ONTOLA[:actorType], key: :body
end
