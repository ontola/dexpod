# frozen_string_literal: true

class SessionSerializer < LinkedRails::Auth::SessionSerializer
  attribute :host, predicate: NS::DEX[:providerHost]
end
