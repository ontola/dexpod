# frozen_string_literal: true

load(Dir[Rails.root.join('db/seeds/doorkeeper_apps.seeds.rb')][0])

Pod.new(pod_name: 'dex_transfer').send(:seed_tenant) if Apartment::Tenant.current == 'public'
