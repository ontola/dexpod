# frozen_string_literal: true

class Agreement < ApplicationRecord
  enhance LinkedRails::Enhancements::Creatable
  belongs_to :assignee,
             class_name: 'User',
             foreign_key: :user_id,
             inverse_of: :agreements
  belongs_to :invite
  has_one :offer, through: :invite
  has_one :assigner, class_name: 'User', through: :offer, source: :user

  delegate :email, to: :invite
end
