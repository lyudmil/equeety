class UserMailer < ActionMailer::Base
  default :from => "support@equeety.com"
  
  def password_reset_email_to user
    mail(:to => user.email)
  end
  
end
