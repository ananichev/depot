require 'test_helper'

class OrderNotifierTest < ActionMailer::TestCase
  test "received" do
    mail = OrderNotifier.received(orders(:one))
    assert_equal "Confirm order in Pragmatic Store", mail.subject
    assert_equal ["MyString@example.com"], mail.to
    assert_equal ["depot@example.com"], mail.from
    assert_match "Hi #{orders(:one).name}", mail.body.encoded
  end

  test "shipped" do
    mail = OrderNotifier.shipped(orders(:one))
    assert_equal "Order from Prafmatic Store is delivered", mail.subject
    assert_equal ["MyString@example.com"], mail.to
    assert_equal ["depot@example.com"], mail.from
    assert_match "OrderNotifier#shipped", mail.body.encoded
  end

end
