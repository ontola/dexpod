class CreateNodes < ActiveRecord::Migration[6.0]
  def change
    create_table :nodes do |t|
      t.string :type, null: false, default: 'folder'
      t.bigint :root_id
      t.bigint :parent_id
      t.ltree :path
      t.string :title
      t.timestamps
    end
  end
end
