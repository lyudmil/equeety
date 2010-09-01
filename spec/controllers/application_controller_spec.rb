require 'spec_helper'

describe ApplicationController do

  describe "require user filter" do
    it "should fail and redirect if no user" do
      user_logged_out
      controller.should_receive(:redirect_to).with(login_url, {:notice => "You must be logged in to access this page"}).and_return(nil)
      controller.send(:require_user).should == false
    end
    
    it "should do nothing if user logged in" do
      user_logged_in
      controller.should_not_receive(:redirect_to)
      controller.send(:require_user).should == nil
    end
  end
  
  describe "require no user filter" do
    it "should fail and redirect if user logged in" do
      user_logged_in
      controller.should_receive(:redirect_to).with(root_url, {:notice => "You must be logged out to access this page"}).and_return(nil)
      controller.send(:require_no_user).should == false
    end
    
    it "should do nothing if no user" do
      user_logged_out
      controller.should_not_receive(:redirect_to)
      controller.send(:require_no_user)
    end
  end
  
  it "should be able to find the current user" do
    user_session = mock(UserSession)
    user = mock_model(User)
    user_session.stub(:record).and_return(user)
    UserSession.should_receive(:find).and_return(user_session)
    
    controller.send(:current_user).should == user
  end
  
  private
  
  def user_logged_in
    controller.stub(:current_user).and_return(mock_model(User))
  end
  
  def user_logged_out
    controller.stub(:current_user).and_return(nil)
  end
end