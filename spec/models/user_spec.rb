require 'spec_helper'

describe User do
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
  end
  
end