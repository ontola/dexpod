# frozen_string_literal: true

class UserForm < ApplicationForm
  has_one :pod,
          min_count: 1

  group :authentication_section, label: 'authentication' do
    field :password
    field :password_confirmation
    field :current_password
  end
end
