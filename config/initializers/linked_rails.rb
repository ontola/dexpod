# frozen_string_literal: true

require_relative './ns'

LinkedRails.host = ENV['HOSTNAME']
LinkedRails.scheme = :https
LinkedRails.app_ns = NS::DEX
LinkedRails.serializer_parent_class = 'LinkedSerializer'

module LinkedRails
  class << self
    def iri(opts = {})
      host =
        if Apartment::Tenant.current == 'public'
          LinkedRails.host
        else
          "#{Apartment::Tenant.current}.#{LinkedRails.host}"
        end

      RDF::URI.new(**{scheme: LinkedRails.scheme, host: host}.merge(opts))
    end
  end

  module Model
    module Iri
      private

      # @return [RDF::URI]
      def iri_with_root(root_relative_iri)
        iri = root_relative_iri.dup
        iri.scheme = LinkedRails.scheme
        iri.host =
          if Apartment::Tenant.current == 'public'
            LinkedRails.host
          else
            "#{Apartment::Tenant.current}.#{LinkedRails.host}"
          end
        iri
      end
    end
  end
end
