class UserMailer < ActionMailer::Base
  default :from => "support@equeety.com"
  
  def password_reset_email user
    mail(:to => user.email, :subject => "Equeety password reset")
  end
  
end
