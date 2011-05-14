require 'spec_helper'

describe PasswordResetsController do
  
  before :each do
    @user = mock_model(User, :perishable_token => "RW78z", :update_attributes => true, :reset_perishable_token! => true)
    User.stub(:find_using_perishable_token).with("RW78z").and_return(@user)
  end
  
  it "should display message if user not found"
  
  describe "new" do
    it "should send an email with reset instructions"
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
