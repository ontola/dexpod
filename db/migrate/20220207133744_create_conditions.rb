class CreateConditions < ActiveRecord::Migration[6.1]
  def change
    create_table :conditions do |t|
      t.timestamps
      t.string :type, null: false
      t.integer :dataset_id, null: false
      t.jsonb :condition_attributes
      t.foreign_key :datasets
    end
  end
end
