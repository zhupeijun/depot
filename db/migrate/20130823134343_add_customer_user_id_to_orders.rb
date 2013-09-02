class AddCustomerUserIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :customer_user_id, :integer
  end
end
