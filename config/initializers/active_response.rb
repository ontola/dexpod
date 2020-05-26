# frozen_string_literal: true

module ActiveResponse
  module Responders
    class Base
      class << self
        def available_formats # rubocop:disable Metrics/MethodLength
          return @available_formats if @available_formats.present?

          @available_formats =
            ActiveResponse.registered_responders.map(&:formats).flatten.sort_by do |format|
              case format
              when :html
                0
              when :ttl
                1
              else
                2
              end
            end
        end
      end
    end
  end
end
