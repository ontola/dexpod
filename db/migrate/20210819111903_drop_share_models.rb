class DropShareModels < ActiveRecord::Migration[6.0]
  def change
    drop_table :agreements
    drop_table :invites
    drop_table :rules
    drop_table :offers
  end
end
