# frozen_string_literal: true

require_relative './ns'

LinkedRails.host = ENV['HOSTNAME']
LinkedRails.scheme = :https
LinkedRails.app_ns = NS::DEX
LinkedRails.serializer_parent_class = 'LinkedSerializer'
