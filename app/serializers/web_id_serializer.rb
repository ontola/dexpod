# frozen_string_literal: true

class WebIdSerializer < LinkedSerializer
  attribute :display_name, predicate: NS.foaf.name
  has_one :profile, predicate: NS.foaf.primaryTopic
  attribute :unscoped_iri, predicate: NS.owl.sameAs

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
