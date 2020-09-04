class CreateAgreements < ActiveRecord::Migration[6.0]
  def change
    create_table :agreements do |t|
      t.timestamps
      t.integer :invite_id, null: false
      t.integer :user_id, null: false
      t.index :invite_id
      t.index :user_id
    end
    add_foreign_key(:agreements, :invites)
  end
end
