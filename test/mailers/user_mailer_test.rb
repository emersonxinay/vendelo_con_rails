require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  def setup
    @user = User.last
  end
  
  test "welcome" do
    mail = UserMailer.with(user: @user).welcome
    assert_equal "Bienvenido a vendelo", mail.subject
    assert_equal [@user.email], mail.to
    assert_equal ["no-replay@vendelo.com"], mail.from
    assert_match "Hey #{@user.username}, bienvenido a vendelo ", mail.body.encoded
  end

end
