# frozen_string_literal: true

class MediaObjectPolicy < NodePolicy
  permit_attributes %i[title description]
  permit_attributes %i[content_source]

  def show?
    super || broker_authorization(:show, record.parent)
  end
end
