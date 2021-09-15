# frozen_string_literal: true

class ApplicationSerializer
  class << self
    def never(_object, _params)
      false
    end
  end
end
