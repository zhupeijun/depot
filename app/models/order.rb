class Order < ActiveRecord::Base
	has_many :line_items, dependent: :destroy
	belongs_to :customer_user

	PAYMENT_TYPES = [ "Check", "Credit card", "Purchase order" ]
	STATUS = ['Padding', 'Shipping', 'Accepted']


	validates :name, :address, :email, presence: true
	validates :pay_type, inclusion: PAYMENT_TYPES
	
	def add_line_items_from_cart(cart)
		cart.line_items.each do |item|
			item.cart_id = nil
			line_items << item
		end
	end
end
