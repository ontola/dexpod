class ChangeDefaultNodeType < ActiveRecord::Migration[6.0]
  def change
    change_column_default :nodes, :type, 'Folder'
  end
end
