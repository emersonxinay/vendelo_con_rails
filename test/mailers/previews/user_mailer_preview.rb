# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/Welcome
  def Welcome
    UserMailer.with(user: User.last).welcome
  end

end
