class StoreController < ApplicationController
	skip_before_filter :authorize
	skip_before_filter :admin_authorize
	def index

		if params[:set_locale]
			redirect_to store_path(locale: params[:set_locale])
		else 

			@products = nil


			if params[:search_key_words] == nil 
				sp = Product.all
			else 
				sp = Product.where("title like ? or description like ?", "%" + params[:search_key_words] + "%", "%" + params[:search_key_words] + "%")
			end



			if params[:order_by] == 'selledcount'
				@products = sp.order("selled_count desc")
			elsif params[:order_by] == 'pricedesc'
				@products = sp.order("price desc")
			elsif params[:order_by] == 'priceasc'
				@products = sp.order("price asc")
			else 
				@products = sp.order(:title)
			end
			
			@cart = current_cart
		end
	end
end
