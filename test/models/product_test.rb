require 'test_helper'

class ProductTest < ActiveSupport::TestCase

  fixtures :products

  test "product attributes must not be emty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:image_url].any?
    assert product.errors[:price].any?
  end

  test "price must be greater than or equal to 0.01" do
    product = Product.new(title: "New", description: "Description", image_url: "pic.jpg", price: -1)
    assert product.invalid?
    assert "must be greater than or equal to 0.01", product.errors[:price].join('; ')
    product.price = 0
    assert product.invalid?
    assert "must be greater than or equal to 0.01", product.errors[:price].join('; ')
    product.price = 1
    assert product.valid?
  end

  def new_product(image_url)
    Product.new(title: "New", description: "Description", image_url: image_url, price: 1)
  end

  test "image_url" do
    ok  = ['pic.jpg', 'pic.gif', 'pic.png', 'PIC.GIF', 'http://a.b.c./z-x-d/pic.jpg']
    bad = ['pic,jpg', 'pic.pdf', 'pic.png/asd', 'pic.png.lala']

    ok.each do |name|
      assert new_product(name).valid?, "#{name} shouldn't be invalid"
    end

    bad.each do |name|
      assert new_product(name).invalid?, "#{name} shouldn't be invalid"
    end
  end

  test "product is not valid without a unique title" do
    product = Product.new(title: products(:ruby).title, description: "New", image_url: "pic.jpg", price: 10)

    assert !product.save
    assert_equal "has already been taken", product.errors[:title].join('; ')

  end

end
