require 'test_helper'

class Cheftest < ActiveSupport::TestCase

  def setup
    @chef = Chef.new(chefname: "Joe", email: "email@example.com")
  end

  test "should be valid" do
    assert @chef.valid?
  end

  test "name should be present" do
    @chef.chefname = " "
    assert_not @chef.valid?
  end

  test "name should be less than 30 chars" do
    @chef.chefname = "a" * 31
    assert_not @chef.valid?
  end

  test "email should be present" do
    @chef.email = " "
    assert_not @chef.valid?
  end

  test "email should not be too long" do
    @chef.email = "a" * 245 + "@example.com"
    assert_not @chef.valid?
  end

  test "email should be properly formatted" do
      valid_emails = %w[user@example.com IVO@hello.com fname.lname@example.co]
      valid_emails.each do |validates|
        @chef.email = validates
        assert @chef.valid? "#{validates.inspect} should be valid"
      end
  end

  test "should reject invalid emails" do
    invalid_emails = %w[hello@a foobar.co fname@@@lname.a]
    invalid_emails.each do |invalids|
      @chef.email = invalids
      assert_not @chef.valid?, "#{invalids.inspect} should be invalid"
    end
  end

  test "email should be unique and case insentivie" do
    duplicate_chef = @chef.dup
    duplicate_chef.email = @chef.email.upcase
    @chef.save
    assert_not duplicate_chef.valid?
  end

  test " email should be lower case before saving to db" do
    mixed_email = "Hello@Foo.com"
    @chef.email = mixed_email
    @chef.save
    assert_equal mixed_email.downcase, @chef.reload.email
  end

end
