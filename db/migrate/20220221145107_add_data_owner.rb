class AddDataOwner < ActiveRecord::Migration[6.1]
  def change
    add_column :datasets, :data_owner, :string
  end
end
