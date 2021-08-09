class Add2Fa < ActiveRecord::Migration[6.1]
  def change
    create_table :otp_secrets do |t|
      t.timestamps
      t.integer :owner_id, null: false
      t.string :otp_secret_key, null: false
      t.boolean :active, default: false
      t.index :owner_id, unique: true
    end
  end
end
