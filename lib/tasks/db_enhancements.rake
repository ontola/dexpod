# frozen_string_literal: true

# lib/tasks/db_enhancements.rake

####### Important information ####################
# This file is used to setup a shared extensions #
# within a dedicated schema. This gives us the   #
# advantage of only needing to enable extensions #
# in one place.                                  #
#                                                #
# This task should be run AFTER db:create but    #
# BEFORE db:migrate.                             #
##################################################

namespace :db do
  desc 'Also create shared_extensions Schema'
  task extensions: :environment do
    # Create shared_extensions
    ActiveRecord::Base.connection.execute 'CREATE SCHEMA IF NOT EXISTS shared_extensions;'
    %w[plpgsql hstore ltree uuid-ossp].each do |extension|
      ActiveRecord::Base.connection.execute(
        "CREATE EXTENSION IF NOT EXISTS \"#{extension}\" SCHEMA shared_extensions;"
      )
    end

    # Grant shared_extensions usage to public
    ActiveRecord::Base.connection.execute 'GRANT usage ON SCHEMA shared_extensions to public;'

    # Create dex_transfer
    Apartment::Tenant.create('dex_transfer')
  end
end

Rake::Task['db:create'].enhance do
  Rake::Task['db:extensions'].invoke
end

Rake::Task['db:test:purge'].enhance do
  Rake::Task['db:extensions'].invoke
end
