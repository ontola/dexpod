# frozen_string_literal: true

class DatasetThemeSerializer < LinkedSerializer
  enum :theme, predicate: NS.app[:theme], options: EnumHelper.list_options('themes', grouped: true)
end
