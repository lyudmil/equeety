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
  
  private
  
  def valid_fields
  {
    :email => "user@email.com",
    :password => "pass",
    :password_confirmation => "pass"
  }
  end
end