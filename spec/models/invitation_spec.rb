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
  
  it "should be unique for each user and deal" do
    deal = mock_model(Deal)
    user = mock_model(User)
    Invitation.new(:deal => deal, :user => user).save.should be_true
    
    second_invitation = Invitation.new(:deal => deal, :user => user)
    second_invitation.save.should be_false
    second_invitation.errors_on(:user_id).should == ["already knows about this deal."]
  end
  
  private
  
  def model
    Invitation
  end
  
  def valid_fields
    { :user => mock_model(User), :deal => mock_model(Deal) }
  end
end
