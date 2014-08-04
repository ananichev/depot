require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
  fixtures :products
  fixtures :carts

  test "buying a product" do
    LineItem.delete_all
    Order.delete_all
    ruby_book = products(:ruby)

    get "/"
    assert_response :success
    assert_template "index"

    xml_http_request :post, '/line_items', product_id: ruby_book.id
    assert_response :success

    cart = Cart.find(session[:cart_id])
    assert_equal 1, cart.line_items.size
    assert_equal ruby_book, cart.line_items[0].product

    get "orders/new"
    assert_response :success
    assert_template "new"

    post_via_redirect "/orders", order: { name: "MyString",  address: "MyText", email: "MyString@example.com", pay_type: "Check"  }
    assert_response :success
    assert_template "index"
    cart = Cart.find(session[:cart_id])
    assert_equal 0, cart.line_items.size

    orders = Order.all
    assert_equal 1, orders.size
    order = orders[0]

    assert_equal "MyString", order.name
    assert_equal "MyText", order.address
    assert_equal "MyString@example.com", order.email
    assert_equal "Check", order.pay_type

    assert_equal 1, order.line_items.size
    line_item = order.line_items[0]
    assert_equal ruby_book, line_item.product

    mail = ActionMailer::Base.deliveries.last
    assert_equal ["MyString@example.com"], mail.to
    assert_equal "Vitalik <depot@example.com>", mail[:from].value
    assert_equal "Confirm order in Pragmatic Store", mail.subject
  end

  test "should fail on acsess of sensitive data" do
    user = users(:one)
    get '/login'
    assert_response :success
    post_via_redirect '/login', name: user.name, password: '123'
    assert_response :success
    assert_equal '/admin', path

    xml_http_request :post, '/line_items', product_id: products(:ruby).id
    assert_response :success

    cart = Cart.find(session[:cart_id])

    get "/carts/#{cart.id}"
    assert_response :success
    assert_equal "/carts/#{cart.id}", path

    delete '/logout'
    assert_response :redirect
    assert_template '/'

    get "/carts/#{cart.id}"
    assert_response :redirect
    assert_redirected_to login_path
  end

  test "should logout and not be allowed back in" do
    delete 'logout'
    assert_response :redirect
    assert_redirected_to store_url

    get '/users'
    assert_response :redirect
    assert_redirected_to login_path
  end

end
