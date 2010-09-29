require 'spec_helper'

describe Commitment do
  it "should belong to a user" do
    user = mock_model(User)
    commitment = Commitment.new :user => user
    commitment.save.should be_true
    commitment.user.should == user
  end
  
  it "should belong to a deal" do
    deal = mock_model(Deal)
    commitment = Commitment.new :deal => deal
    commitment.save.should be_true
    commitment.deal.should == deal
  end
  
  describe "amount" do
    it "should be numeric"
    it "should be positive"
    it "should be less than $1,000,000,000"
  end
end
