class RefactorUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :providers do |t|
      t.timestamps
      t.string :issuer
      t.string :jwks_uri
      t.string :name
      t.string :identifier
      t.string :secret
      t.string :scopes_supported
      t.string :host
      t.string :scheme
      t.string :authorization_endpoint
      t.string :token_endpoint
      t.string :userinfo_endpoint
      t.datetime :expires_at

      t.index %i[issuer], unique: true
    end

    rename_table :users, :web_ids
    rename_column :pods, :user_id, :web_id_id
    add_foreign_key :pods, :web_ids

    create_table :users do |t|
      t.timestamps
      t.string :name
    end

    create_table :identities do |t|
      t.timestamps
      t.integer :user_id
      t.integer :provider_id, null: false
      t.string :identifier
      t.string :access_token, limit: 1024
      t.string :id_token, limit: 2048

      t.foreign_key :users
      t.foreign_key :providers

      t.index %i[identifier provider_id], unique: true
    end

    add_foreign_key :agreements, :users
    add_foreign_key :offers, :users

    change_column :oauth_access_tokens, :resource_owner_id, :string
  end
end
