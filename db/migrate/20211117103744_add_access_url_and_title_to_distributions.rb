class AddAccessUrlAndTitleToDistributions < ActiveRecord::Migration[6.1]
  def change
    add_column :distributions, :title, :string
    add_column :distributions, :access_url, :string
  end
end
