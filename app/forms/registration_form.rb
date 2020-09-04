# frozen_string_literal: true

class RegistrationForm < LinkedRails::Auth::RegistrationForm
  self.model_class = LinkedRails::Auth::Registration

  field :email,
        input_field: LinkedRails::Form::Field::EmailInput,
        min_count: 1
  has_one :pod,
          min_count: 1
  field :password,
        input_field: LinkedRails::Form::Field::PasswordInput,
        min_count: 1
  field :password_confirmation,
        input_field: LinkedRails::Form::Field::PasswordInput,
        min_count: 1

  hidden do
    field :redirect_url
  end
end
