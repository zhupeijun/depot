class AdminSessionsController < ApplicationController
	skip_before_filter :authorize
	skip_before_filter :admin_authorize

	def new
	end

	def create
		admin_user = User.find_by_name(params[:name])
		if admin_user and admin_user.authenticate(params[:password])
			session[:user_id] = admin_user.id 
			session[:user_type] = 'admin'
			redirect_to admin_url
		else 
			redirect_to admin_login_url, alert: "Invalid user/password combination"
		end
	end

	def destroy
		session[:user_id] = nil
		session[:user_type] = nil
		redirect_to store_url, notice: "Logged out"
	end
end
