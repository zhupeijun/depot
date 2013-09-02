class CustomerUsersController < ApplicationController
	skip_before_filter :authorize, only: [:new, :create]
	skip_before_filter :admin_authorize
	before_action :set_customer_user, only: [:show, :edit, :update, :destroy]

	# GET /customer_users
	# GET /customer_users.json
	def index
		@customer_users = CustomerUser.all
	end

	# GET /customer_users/1
	# GET /customer_users/1.json
	def show
	end

	# GET /customer_users/new
	def new
		@customer_user = CustomerUser.new
	end

	# GET /customer_users/1/edit
	def edit
	end

	# POST /customer_users
	# POST /customer_users.json
	def create
		@customer_user = CustomerUser.new(customer_user_params)

		respond_to do |format|
			if @customer_user.save
				format.html { redirect_to login_url, alert: "Customer user #{@customer_user.name} was successfully created." }
				format.json { render action: 'show', status: :created, location: @customer_user }
			else
				format.html { render action: 'new' }
				format.json { render json: @customer_user.errors, status: :unprocessable_entity }
			end
		end
	end

	# PATCH/PUT /customer_users/1
	# PATCH/PUT /customer_users/1.json
	def update
		respond_to do |format|
			if @customer_user.update(customer_user_params)
				format.html { redirect_to users_url, notice: "Customer user #{@customer_user.name} was successfully updated." }
				format.json { head :no_content }
			else
				format.html { render action: 'edit' }
				format.json { render json: @customer_user.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /customer_users/1
	# DELETE /customer_users/1.json
	def destroy
		begin
			@customer_user.destroy
			flash[:notice] = "User #{@customer_user.name} deleted"
		rescue Exception => e
			flash[:notice] = e.message
		end

		respond_to do |format|
			format.html { redirect_to users_url }
			format.json { head :no_content }
		end
	end

	private
		# Use callbacks to share common setup or constraints between actions.
		def set_customer_user
			@customer_user = CustomerUser.find(params[:id])
		end

		# Never trust parameters from the scary internet, only allow the white list through.
		def customer_user_params
			params.require(:customer_user).permit(:name, :password, :password_confirmation, :email)
		end
end
