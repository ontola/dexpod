# frozen_string_literal: true

class OfferSerializer < LinkedSerializer
  has_one :node,
          predicate: NS::DEX[:file]
  attribute :attribution_description,
            predicate: NS::DEX[:attributionDescription]
  with_collection :invites, predicate: NS::DEX[:invites] #, if: method(:creator?)
  with_collection :obligations, predicate: NS::DEX[:obligations]
  with_collection :permissions, predicate: NS::DEX[:permissions]
  with_collection :prohibitions, predicate: NS::DEX[:prohibitions]

  enum :rule_sets, predicate: NS::DEX[:ruleSets]
end
