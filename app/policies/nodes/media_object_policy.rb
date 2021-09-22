# frozen_string_literal: true

class MediaObjectPolicy < NodePolicy
  permit_attributes %i[title description]
  permit_attributes %i[content_source]

  private

  def authorized_resource
    record.parent
  end
end
