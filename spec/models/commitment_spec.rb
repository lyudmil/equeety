require 'spec_helper'

describe Commitment do
  include ValidationTestHelper
  
  it "should belong to a user" do
    user = mock_model(User, :remaining_budget => 100000, :commitments => [])
    commitment = Commitment.new(valid_fields.merge :user => user)
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
  
  it "should be unique for each investor and deal" do
    user = mock_model(User, :remaining_budget => 100000, :commitments => [])
    deal = mock_model(Deal)
    Commitment.new(:amount => 1, :user => user, :deal => deal).save.should be_true
    
    second_investment = Commitment.new(:amount => 2, :user => user, :deal => deal)
    second_investment.valid?.should be_false
    second_investment.errors_on(:user_id).should == ["You can only invest in a deal once."]
  end
  
  describe "should not cause the investor to go over budget" do
    it "should fail validation when it is nagative" do
      user = User.new(:budget => 100)
      commitment = Commitment.new(:amount => 101, :user => user)
      
      commitment.valid?.should be_false
      commitment.errors_on(:base).should == ["You can't exceed your budget."]
    end
    
    it "should pass validation when it is non negative" do
      user = User.new(:budget => 100)
      commitment = Commitment.new(:amount => 100, :user => user)
      
      commitment.valid?.should be_true
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
