require 'spec_helper'

describe User do
  it "should have many deals" do
    user = User.new(valid_fields)
    user.save.should be_true
    
    user.deals.create.should be_true
  end
  
  describe "budget" do
    it "should be an attribute" do
      user = User.new :budget => 1234
      user.budget.should == 1234
    end
    
    it "should be numeric" do
      user = User.new :budget => "abc"
      user.errors_on(:budget).should == ["is not a number"]
    end
    
    it "should not be negative" do
      user = User.new :budget => -1
      user.errors_on(:budget).should == ["must be greater than 0"]
    end
    
    it "should be less than $1,000,000,000" do
      user = User.new :budget => 1000000000
      user.errors_on(:budget).should == ["must be less than 1000000000"]
    end
    
    it "can be nil" do
      user = User.new :budget => nil
      user.errors_on(:budget).should be_empty
    end
  end
  
  it "should have many commitments" do
    user = User.new(valid_fields)
    user.save.should be_true
    
    user.commitments.create.should be_true
  end
  
  describe "has access to deal" do
    it "should be true if the user is the owner of the deal" do
      user = User.new
      deal = Deal.new(:user => user)
      
      user.has_access_to?(deal).should be_true
    end
    
    it "should be false if the user is not the owner of the deal" do
      user = User.new
      deal = Deal.new(:user => mock_model(User))
      
      user.has_access_to?(deal).should be_false
    end
  end
  
  describe "has invested in deal" do
    it "should be true if the user has a commitment for that deal" do
      user = User.create(valid_fields)
      deal = user.deals.create(deal_fields)
      user.commitments.create(:amount => 1, :deal => deal)
      
      user.has_invested_in?(deal).should be_true
    end
    
    it "should be false if no commitments to that deal" do
      user = User.create(valid_fields)
      deal = user.deals.create(deal_fields)
      
      user.has_invested_in?(deal).should be_false
    end
  end
  
  private
  
  def valid_fields
    {
      :email => "user@email.com",
      :password => "pass",
      :password_confirmation => "pass"
    }
  end
  
  def deal_fields
    {
      :required_amount => 111, 
      :proposed_valuation => 222, 
      :contact_email => 'me@email.com',
      :startup_name => 'equeety',
      :website => 'www.equeety.com',
      :contact_name => 'John Doe'
    }
  end
end