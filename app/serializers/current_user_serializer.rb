# frozen_string_literal: true

class CurrentUserSerializer < LinkedSerializer
  attribute :actor_type, predicate: NS.ontola[:actorType], key: :body
  attribute :actor, predicate: NS.ontola[:actor]
end
