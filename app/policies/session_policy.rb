# frozen_string_literal: true

class SessionPolicy < LinkedRails::Auth::SessionPolicy
  permit_attributes %i[host]
end
