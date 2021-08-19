# frozen_string_literal: true

class WebIdSerializer < LinkedSerializer
  has_one :pod,
          predicate: NS.argu[:pod]

  attribute :display_name, predicate: NS.foaf[:name]

  attribute :password, predicate: NS.argu[:password], datatype: NS.ontola[:'datatype/password'], if: method(:never)
  attribute :password_confirmation,
            predicate: NS.argu[:passwordConfirmation],
            datatype: NS.ontola[:'datatype/password'],
            if: method(:never)
  attribute :current_password,
            predicate: NS.argu[:currentPassword],
            datatype: NS.ontola[:'datatype/password'],
            if: method(:never)
end
