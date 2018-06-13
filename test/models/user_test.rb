require 'test_helper'

class UserTest < ActiveSupport::TestCase

  # 임의예시로 유저를 생성함
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end


  test "should be valid" do
    # 유저가 있는거지? 맞아?
    assert @user.valid?
  end

  test "name should be present" do
    # assert_not의 의미는
    # 지금 user.name이 비어있는가?
    @user.name = ""
    # 비어있지 않은거지? 그치?
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = ""
    assert_not @user.valid?
  end

  test "name should not be too long" do
    # 이름이 51개로 되어있나?
    @user.name = "a"*51
    # 아니지? 그치?
    assert_not @user.valid?
  end

  test "email should not be too long" do
    # 메일이 256자로 되어있나?
    @user.email = "a"*244+"@example.com"
    #아니지? 그치?
    assert_not @user.valid?
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@examlpe.
                foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be valid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " "*6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a"*5
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?('')
  end
end
