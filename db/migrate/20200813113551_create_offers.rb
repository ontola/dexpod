class CreateOffers < ActiveRecord::Migration[6.0]
  def change
    create_table :offers do |t|
      t.timestamps
      t.integer :user_id, null: false
      t.integer :node_id, null: false
      t.index :user_id
      t.index :node_id
    end
    add_foreign_key(:offers, :nodes)

    create_table :rules do |t|
      t.timestamps
      t.string :type
      t.integer :offer_id, null: false
      t.integer :action, null: false
      t.text :description
      t.index :offer_id
    end

    add_foreign_key(:rules, :offers)

    create_table :invites do |t|
      t.timestamps
      t.string :email
      t.integer :offer_id, null: false
      t.index :offer_id
      t.string :secret, null: false
      t.index :secret
    end

    add_foreign_key(:invites, :offers)
  end
end
