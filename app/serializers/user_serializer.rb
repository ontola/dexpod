# frozen_string_literal: true

class UserSerializer < LinkedSerializer
  has_one :pod,
          predicate: NS::ARGU[:pod]

  attribute :display_name, predicate: NS::FOAF[:name]

  attribute :password, predicate: NS::ARGU[:password], datatype: NS::ONTOLA[:'datatype/password'], if: method(:never)
  attribute :password_confirmation,
            predicate: NS::ARGU[:passwordConfirmation],
            datatype: NS::ONTOLA[:'datatype/password'],
            if: method(:never)
  attribute :current_password,
            predicate: NS::ARGU[:currentPassword],
            datatype: NS::ONTOLA[:'datatype/password'],
            if: method(:never)

  with_collection :agreements, predicate: NS::DEX[:agreements]
end
