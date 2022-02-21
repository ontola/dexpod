# frozen_string_literal: true

class Dataspace < Dexcat::Resource
  collection_options(
    association_scope: :to_a,
    include_members: true,
    policy_scope: false
  )
end
