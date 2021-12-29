class AddPaymentPointerToNodes < ActiveRecord::Migration[6.1]
  def change
    add_column :nodes, :payment_pointer, :string
  end
end
