class StoreController < ApplicationController
  def index
    @products = Product.order(:title)
    @count = visits_counter
    @cart = current_cart
  end

  def visits_counter
    session[:counter] ||= 0
    session[:counter] +=  1
  end

end
