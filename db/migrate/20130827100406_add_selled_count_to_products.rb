class AddSelledCountToProducts < ActiveRecord::Migration
  def change
    add_column :products, :selled_count, :integer, default: 0
  end
end
