require 'spec_helper'

describe Invitation do
  
  it "should be addressed to a user" do
    user = mock_model(User)
    invitation = Invitation.new(:user => user)
    
    invitation.save.should be_true
    invitation.user.should == user
  end
  
  it "should be to deal" do
    deal = mock_model(Deal)
    invitation = Invitation.new(:deal => deal)
    
    invitation.save.should be_true
    invitation.deal.should == deal
  end
  
end
