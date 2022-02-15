class RemoveForeignKeysToApps < ActiveRecord::Migration[6.1]
  def change
    remove_foreign_key "oauth_access_grants", "oauth_applications", column: "application_id"
    remove_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
  end
end
