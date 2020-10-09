# frozen_string_literal: true

class MediaObjectPolicy < NodePolicy
  permit_attributes %i[title description]
  permit_attributes %i[content_source]
end
