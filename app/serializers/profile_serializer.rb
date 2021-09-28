# frozen_string_literal: true

class ProfileSerializer < LinkedSerializer
  attribute :display_name,
            predicate: NS.foaf[:name]

  attribute :email,
            predicate: NS.foaf[:mbox],
            if: lambda { |record, context|
              !context[:scope].guest? && context[:scope].email == record.email
            }
end
