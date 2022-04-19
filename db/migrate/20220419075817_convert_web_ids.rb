class ConvertWebIds < ActiveRecord::Migration[6.1]
  def change
    Identity.update_all("identifier = REPLACE(identifier, '/pod/profile', '/profile')")
  end
end
