class CreatePods < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :pod_name, :string
    add_column :users, :theme_color, :string
    add_index :users, :pod_name, unique: true
  end
end
