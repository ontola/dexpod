class CreatePod < ActiveRecord::Migration[6.0]
  def up
    create_table :pods do |t|
      t.references :user, null: false
      t.bigint :root_node_id
      t.string :pod_name, null: false
      t.string :theme_color
      t.timestamps

      t.index [:user_id, :pod_name]
      t.index :pod_name, unique: true
    end

    User.all.each do |u|
      Pod.create!(
        pod_name: u.pod_name,
        user_id: u.id,
        theme_color: u.theme_color
      )
    end
  end

  def down
    drop_table :pods
  end
end
