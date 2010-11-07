require 'spec_helper'

describe DashboardController do
  describe "index" do
    before :each do
      @current_user = mock_model(User)
      controller.stub(:current_user).and_return(@current_user)
    end
    
    it "should collect all the inviations for the current user" do
      invitations = mock
      Invitation.should_receive(:where).with(:user_id => @current_user, :accepted => false).and_return(invitations)
      
      get 'index'
      assigns(:invitations).should == invitations
    end
    
    it "should select the public unseen invitations" do
      public, private = setup_invitations

      get 'index'
      
      public_invitations = controller.send(:public_invitations)
      public_invitations.should == [public]
    end
    
    it "should select the non public unseen invitations" do
      public, private = setup_invitations
      
      get 'index'
      
      private_invitations = controller.send(:private_invitations)
      private_invitations.should == [private]
    end
    
    it "should require login" do
      controller.should_receive(:require_user)
      
      get 'index'
    end
  end
  
  private
  
  def setup_invitations
    invitation1 = mock_model(Invitation, :public? => true)
    invitation2 = mock_model(Invitation, :public? => false)
    @invitations = [invitation1, invitation2]
    Invitation.stub(:where).and_return(@invitations)
    @invitations
  end
end
