require 'spec_helper'

describe DashboardController do
  describe "index" do
    it "should collect all the inviations for the current user" do
      user = mock_model(User)
      controller.stub(:current_user).and_return(user)
      invitations = mock
      Invitation.should_receive(:where).with(:user => user).and_return(invitations)
      
      get 'index'
      assigns(:invitations).should == invitations
    end
  end
end
