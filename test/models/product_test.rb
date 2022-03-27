require "test_helper"

class ProductTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  fixtures :products

  def setup
    @valid_product_excep_price = Product.new(title: "valid ttile",
                                             description: "valid description",
                                             image_url: "image.png")
  end

  def new_product(image_url)
    Product.new(title: "Book Title",
                description: "Just some book",
                image_url: image_url,
                price: 0.01)
  end

  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end

  test "product price can not be smaller than 0.01" do
    @valid_product_excep_price.price = -0.01
    assert @valid_product_excep_price.invalid?
  end

  test "product price must be at least 0.01" do
    @valid_product_excep_price.price = 0.01
    assert @valid_product_excep_price.valid?
  end

  test "product price can be greater than 0.01" do
    @valid_product_excep_price.price = 1
    assert @valid_product_excep_price.valid?
  end

  test "test image_url" do
    good_urls = %w{ hello.png ok.jpg hi.gif }
    bad_urls = %w{ bad.doc not_good.gif.txt }

    good_urls.each do |url|
      assert new_product(url).valid?, "#{url} url must be valid"
    end

    bad_urls.each do |url|
      assert new_product(url).invalid?, "#{url} url must be invalid"
    end
  end

  test "product is invalid when violating uniqueness in the title" do
    product = Product.new(title: products(:api).title,
                          description: "some description",
                          image_url: "hello.png",
                          price: 1.00)
    assert product.invalid?, "title #{products(:api).title} should be unique"
  end

  test "product's title must be invalid if less than 10 characters" do
    product = Product.new(title: "book",
                          description: "some description",
                          image_url: "hello.png",
                          price: 1.00)
    assert product.invalid?, "title length is #{product.title.length}"
    assert_equal product.errors.full_messages, ["Title is too short (minimum is 10 characters)"]
  end

  test "product's title must be valid if at least 10 characters" do
    product = Product.new(title: "Another book",
                          description: "some description",
                          image_url: "hello.png",
                          price: 1.00)
    assert product.valid?, "title length is #{product.title.length}"
  end
end
