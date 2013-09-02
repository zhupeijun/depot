class OrdersController < ApplicationController
	#skip_before_filter :authorize, only: [:new, :create]
	skip_before_filter :admin_authorize, [:new, :create]
	before_action :set_order, only: [:show, :edit, :update, :destroy]

	# GET /orders
	# GET /orders.json
	def index

		selected_orders = nil

		if session[:user_type] == 'admin' 
			selected_orders = Order.all	
		elsif session[:user_type] = 'user'
			selected_orders = Order.where("customer_user_id = #{session[:user_id]}")
		end

		@orders = nil
	
		if selected_orders 
			@orders = selected_orders.paginate page: params[:page], 
				order: 'created_at desc', per_page: 10
		end
		
		respond_to do |format|
			format.html
			format.json { render json: @orders }
		end
	end

	# GET /orders/1
	# GET /orders/1.json
	def show
	end

	# GET /orders/new
	def new

		@cart = current_cart
		if @cart.line_items.empty?
			redirect_to store_url, notice: 'Your cart is empty'
			return
		end
		@order = Order.new

		respond_to do |format|
			format.html 
			format.json { render json: @order }
		end
	end

	# GET /orders/1/edit
	def edit
	end

	# POST /orders
	# POST /orders.json
	def create
		@order = Order.new(order_params)

		user = CustomerUser.find_by_id(session[:user_id])
		@order.customer_user_id = user.id
		@order.name = user.name
		@order.email = user.email

		@order.add_line_items_from_cart(current_cart)


		@order.line_items.each do |li|
			product = Product.find(li.product_id)
			product.selled_count += li.quantity
			product.save
		end

		respond_to do |format|
			if @order.save
				Cart.destroy(session[:cart_id])
				session[:cart_id] = nil
				OrderNotifier.received(@order).deliver
				format.html { redirect_to orders_path, 
					notice: 'Thanks for your order' }
				format.json { render action: 'show', 
					status: :created, location: @order }
			else
				@cart = current_cart
				format.html { render action: 'new' }
				format.json { render json: @order.errors, status: :unprocessable_entity }
			end
		end
	end

	# PATCH/PUT /orders/1
	# PATCH/PUT /orders/1.json
	def update
		respond_to do |format|
			if @order.update(order_params)
				format.html { redirect_to @order, notice: 'Order was successfully updated.' }
				format.json { head :no_content }
			else
				format.html { render action: 'edit' }
				format.json { render json: @order.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /orders/1
	# DELETE /orders/1.json
	def destroy
		@order.destroy
		respond_to do |format|
			format.html { redirect_to orders_url }
			format.json { head :no_content }
		end
	end

	private
		# Use callbacks to share common setup or constraints between actions.
		def set_order
			@order = Order.find(params[:id])
		end

		# Never trust parameters from the scary internet, only allow the white list through.
		def order_params
			params.require(:order).permit(:name, :address, :email, :pay_type, :status)
		end
end
