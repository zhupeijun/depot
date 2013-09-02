class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :product_id
      t.integer :order_id
      t.string :comment
      t.date :date
      t.integer :score

      t.timestamps
    end
  end
end
