require 'spec_helper'

describe Commitment do
  include ValidationTestHelper
  
  it "should belong to a user" do
    user = mock_model(User)
    commitment = Commitment.new(valid_fields.merge(:user => user))
    commitment.save.should be_true
    commitment.user.should == user
  end
  
  it "should belong to a deal" do
    deal = mock_model(Deal)
    commitment = Commitment.new(valid_fields.merge(:deal => deal))
    commitment.save.should be_true
    commitment.deal.should == deal
  end
  
  describe "amount" do
    it "should be numeric" do
      assert_validates_numericality_of :amount
    end
    
    it "should be positive" do
      assert_validates_positiveness_of :amount
    end
    
    it "should be less than $1,000,000,000" do
      assert_validates_upper_bound_of :amount, 1000000000
    end
  end
  
  private
  
  def model
    Commitment
  end
  
  def valid_fields
    {
      :amount => 1000
    }
  end
end
