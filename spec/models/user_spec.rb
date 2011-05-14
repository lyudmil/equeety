require 'spec_helper'

describe User do
  it "should have a nickname" do
    user = User.new(valid_fields)
    user.nickname = 'nickname'
    
    user.save.should be_true
    assert_equal 'nickname', user.reload.nickname
  end
  
  it "should have a unique nickname" do
    user1 = User.new(valid_fields)
    user1.nickname = 'nickname'
    user1.save.should be_true
    
    user2 = User.new(valid_fields)
    user2.nickname = 'niCKnamE'
    user2.errors_on(:nickname).should == ['has already been taken']
  end
  
  it "should have many deals" do
    user = User.new(valid_fields)
    user.save.should be_true
    
    user.deals.create.should be_true
  end
  
  it "should have many commitments" do
    user = User.new(valid_fields)
    user.save.should be_true
    
    user.commitments.create.should be_true
  end
  
  it "should have many invitations" do
    user = User.new(valid_fields)
    user.save.should be_true
    
    user.invitations.create.should be_true
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
    
  describe "can view deal" do
    it "should be true if the user is the owner of the deal" do
      user = User.new
      deal = Deal.new(:user => user)
      
      user.can_view?(deal).should be_true
    end
    
    it "should be true if the user has been invited to the deal" do
      user = User.new
      deal = Deal.new(:user => mock_model(User))
      user.invitations.build(:deal => deal)
      
      user.can_view?(deal).should be_true
    end
    
    it "should be false if the user is not the owner of the deal and has not been invited to it" do
      user = User.new
      deal = Deal.new(:user => mock_model(User))
      
      user.can_view?(deal).should be_false
    end
  end
  
  describe "can invest in deal" do
    before :each do
      @user = User.new
    end
    
    it "should be true if the user is the owner of the deal" do
      deal = Deal.new(:user => @user)
      @user.can_invest_in?(deal).should be_true      
    end
    
    it "should be false if the user is not the owner and is not invited to the deal" do
      deal = Deal.new
      @user.can_invest_in?(deal).should be_false
    end
    
    it "should be true if the user has an accepted invitation to the deal" do
      deal = Deal.new
      @user.invitations.build(:deal => deal, :accepted => true)
      
      @user.can_invest_in?(deal).should be_true
    end
    
    it "should be false if the user has an unaccepted invitation to the deal" do
      deal = Deal.new
      @user.invitations.build(:deal => deal, :accepted => false)
      
      @user.can_invest_in?(deal).should be_false
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
  
  describe "committed budget" do
    it "should be the total commitments" do
      user = User.create(valid_fields)
      user.commitments.create(:amount => 111)
      user.commitments.create(:amount => 222)
      
      user.committed_budget.should == 333
    end
  end
  
  describe "remaining budget" do
    it "should be the difference between the original budget and the comitted budget" do
      user = User.create(valid_fields.merge :budget => 1000)
      user.commitments.create(:amount => 340)
      
      user.remaining_budget.should == 660
    end
    
    it "should not blow up when budget not set" do
      user = User.create(valid_fields)
      user.commitments.create(:amount => 100)
      
      user.remaining_budget.should == -100
    end
  end
  
  describe "owns?" do
    it "should be true if user is the owner of the deal" do
      user = User.new
      deal = Deal.new(:user => user)
      user.deals.push(deal)
      
      user.owns?(deal).should be_true
    end
    
    it "should be false if user is not the owner of the deal" do
      user = User.new
      deal = Deal.new(:user => mock_model(User))
      
      user.owns?(deal).should be_false
    end
  end
  
  it "should have a perishable token" do
    user = User.new(valid_fields)
    user.save
    
    user.perishable_token.should_not be_nil
    User.find_using_perishable_token(user.perishable_token).should == user
  end
  
  it "should be able to reset its perishable token" do
    user = User.new(valid_fields)
    user.save
    old_token = user.perishable_token
    
    user.reset_perishable_token!
    
    user.perishable_token.should_not == old_token
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