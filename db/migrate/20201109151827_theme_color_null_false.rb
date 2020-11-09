class ThemeColorNullFalse < ActiveRecord::Migration[6.0]
  def change
    change_column :pods, :theme_color, :string, default: '#000000', null: false
  end
end
