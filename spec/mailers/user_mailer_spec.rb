require "spec_helper"

describe UserMailer do
  describe "reset password mail" do
    it "should send the email to the correct address" do
      @user = mock_model(User, :email => 'user@email.com')
      
      mailer = UserMailer.password_reset_email @user
      
      mailer.to.size.should == 1
      mailer.from.size.should == 1
      
      mailer.to[0].should == "user@email.com"
      mailer.from[0].should == "support@equeety.com"
      mailer.subject.should == "Equeety password reset"
    end 
  end
end
