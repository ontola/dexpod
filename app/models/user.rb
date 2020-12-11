# frozen_string_literal: true

class User < ApplicationRecord
  def guest?
    false
  end
end
