require 'spec_helper'

describe PasswordResetsController do
  
  before :each do
    @user = mock_model(User, :email => "user@email.com", :perishable_token => "RW78z", :update_attributes => true, :reset_perishable_token! => true)
    User.stub(:find_using_perishable_token).with("RW78z").and_return(@user)
  end
    
  describe "create" do
    before :each do
      User.stub(:find_by_email).and_return(nil)
      User.stub(:find_by_email).with("user@email.com").and_return(@user)
    end
    
    it "should send an email with reset instructions" do
      mail = mock
      UserMailer.should_receive(:password_reset_email).with(@user).and_return(mail)
      mail.should_receive(:deliver).once
      
      post :create, :email => "user@email.com"      
    end
    
    it "should redirect to root with a notice" do
      post :create, :email => "user@email.com"
      
      response.should redirect_to root_path
      flash[:notice].should == "We sent you instructions to reset your password. Please check your email."
    end
    
    it "should handle inexistent emails elegantly" do
      post :create, :email => "noaccount@email.com"
      
      response.should render_template "new"
      flash[:notice].should == "We couldn't find an account for noaccount@email.com."
    end
  end
  
  describe "edit" do
    it "should load the user with the token requested" do
      get :edit, :id => @user.perishable_token
      
      assigns(:user).should == @user
    end
    
    it "should not allow logged in users" do
      controller.should_receive(:current_user).and_return(mock_model(User))
      
      get :edit, :id => @user.perishable_token
      
      response.should redirect_to root_path
    end
    
    it "should display notification if user not found" do
      User.stub(:find_using_perishable_token).with("ABC").and_return(nil)
      get :edit, :id => "ABC"
      
      response.should redirect_to root_path
      flash[:notice].should == "The password reset link has expired. Please renew your request."
    end
  end
  
  describe "update" do
    it "should load the user with the token requested" do
      put :update, :id => @user.perishable_token
      
      assigns(:user).should == @user      
    end
    
    it "should reset the user password" do
      user_params = {"password" => "new_pass", "password_confirmation" => "new_pass"}
      
      @user.should_receive(:update_attributes).with(user_params).once.and_return(true)
      @user.should_receive(:reset_perishable_token!).once
      
      put :update, :id => @user.perishable_token, :user => user_params
    end
    
    it "should redirect to dashboard if reset successful" do    
      put :update, :id => @user.perishable_token
      
      response.should redirect_to dashboard_path
      flash[:notice].should == "Your password has been reset."
    end
    
    it "should render edit template again if reset unsuccessful" do
      @user.should_receive(:update_attributes).and_return(false)
      
      put :update, :id => @user.perishable_token
      
      response.should render_template 'edit'
    end
    
    it "should not allow logged in users" do
      controller.stub(:current_user).and_return(mock_model(User))
      
      put :update, :id => @user.perishable_token
      
      response.should redirect_to root_path
    end
    
  end
end
