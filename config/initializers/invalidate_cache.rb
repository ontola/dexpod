# frozen_string_literal: true

LinkedRails::Cache.invalidate_all if Rails.env.development? || ENV['INVALIDATE_CACHE_ON_BOOT']
