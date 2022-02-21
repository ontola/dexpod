class AddDataspaces < ActiveRecord::Migration[6.1]
  def change
    add_column :datasets, :dataspace_id, :integer
  end
end
