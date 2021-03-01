class AddDataSets < ActiveRecord::Migration[6.0]
  def change
    create_table :datasets do |t|
      t.timestamps
      t.references :user
      t.string :title, null: false
      t.text :description
      t.string :license
      t.text :license_description
    end

    create_table :dataset_themes do |t|
      t.timestamps
      t.references :dataset, null: false
      t.string :theme
    end

    create_table :distributions do |t|
      t.timestamps
      t.references :dataset, null: false
      t.references :node, null: false
      t.string :format
    end
  end
end
