# frozen_string_literal: true

class BulkController < LinkedRails::BulkController
  private

  def handle_resource_error(_opts, error)
    Bugsnag.notify(error)

    super
  end
end
