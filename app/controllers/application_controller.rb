class ApplicationController < ActionController::Base
	before_filter :authorize
	before_filter :admin_authorize


	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception

	private
		def current_cart
			Cart.find(session[:cart_id])
		rescue ActiveRecord::RecordNotFound
			cart = Cart.create
			session[:cart_id] = cart.id;
			cart
		end
	
	protected
		def authorize
			unless CustomerUser.find_by_id(session[:user_id]) or User.find_by_id(session[:admin_user_id])
				redirect_to login_url, notice: "Please log in"
			end
		end

		def admin_authorize
			unless User.find_by_id(session[:user_id])
				redirect_to admin_login_url, notice: "Please log in"
			end
		end
end
