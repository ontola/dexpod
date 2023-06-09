# frozen_string_literal: true

class DatasetThemeSerializer < LinkedSerializer
  enum :theme, predicate: LinkedRails.app_ns[:theme], options: EnumHelper.list_options('themes', grouped: true)
end
