require 'test_helper'

class CartTest < ActiveSupport::TestCase

  fixtures :products

  test 'cart should create a new line item when adding a new product' do
    cart = Cart.create
    cart.add_product(products(:ruby).id, products(:ruby).price)
    assert_equal 1, cart.line_items.find_by_product_id(products(:ruby).id).quantity
  end

  test 'cart should not create a new line item when adding same product' do
    cart = Cart.create
    cart.add_product(products(:ruby).id, products(:ruby).price)
    cart.add_product(products(:ruby).id, products(:ruby).price)
    p cart.line_items
    assert_equal 1, cart.line_items.find_by_product_id(products(:ruby).id).quantity
  end

end
