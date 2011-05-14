require 'spec_helper'

describe PasswordResetsController do
  
  before :each do
    @user = mock_model(User, :perishable_token => "RW78z", :update_attributes => true, :reset_perishable_token! => true)
    User.should_receive(:find_using_perishable_token).with("RW78z").and_return(@user)
  end
  
  describe "edit" do
    it "should load the user with the token requested" do
      get :edit, :id => @user.perishable_token
      
      assigns(:user).should == @user
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
    
    it "should redirect to login if reset successful" do    
      put :update, :id => @user.perishable_token
      
      response.should redirect_to login_path
      flash[:notice].should == "Your password was reset. You can now use your new password to log in."
    end
    
    it "should render edit template again if reset unsuccessful" do
      @user.should_receive(:update_attributes).and_return(false)
      
      put :update, :id => @user.perishable_token
      
      response.should render_template 'edit'
    end
    
  end
end
