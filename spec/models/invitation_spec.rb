require 'spec_helper'

describe Invitation do
  include ValidationTestHelper
  
  it "should be addressed to a user" do
    user = mock_model(User)
    invitation = Invitation.new(:user => user, :deal => mock_model(Deal))
    
    invitation.save.should be_true
    invitation.user.should == user
  end
  
  it "should be to a deal" do
    deal = mock_model(Deal)
    invitation = Invitation.new(:deal => deal, :user => mock_model(User))
    
    invitation.save.should be_true
    invitation.deal.should == deal
  end
  
  it "should always have a user" do
    assert_validates_presence_of :user
  end
  
  it "should always have a deal" do
    assert_validates_presence_of :deal
  end
  
  private
  
  def model
    Invitation
  end
  
  def valid_fields
    { :user => mock_model(User), :deal => mock_model(Deal) }
  end
end
