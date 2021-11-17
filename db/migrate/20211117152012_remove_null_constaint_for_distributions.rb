class RemoveNullConstaintForDistributions < ActiveRecord::Migration[6.1]
  def change
    change_column_null :distributions, :node_id, true
  end
end
