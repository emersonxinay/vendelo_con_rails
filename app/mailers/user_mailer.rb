class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.Welcome.subject
  #
  def welcome
    @user = params[:user]
    @username = @user.username

    mail to: @user.email
  end
end
