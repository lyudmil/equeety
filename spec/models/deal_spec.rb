require 'spec_helper'

describe Deal do  
  it "should belong to a user" do
    user = mock_model('User')
    deal = Deal.new(:user => user)
    deal.user.should == user
  end
  
  describe "required amount" do
    it "should be numeric" do
      assert_validates_numericality_of :required_amount
    end
    
    it "should be positive" do
      assert_validates_positiveness_of :required_amount
    end
    
    it "should be less than $10,000,000" do
      assert_validates_upper_bound_of :required_amount, 10000000
    end
  end
  
  describe "proposed valuation" do
    it "should be numeric" do
      assert_validates_numericality_of :proposed_valuation
    end
    
    it "should be positive" do
      assert_validates_positiveness_of :proposed_valuation
    end
    
    it "should be less than $1,000,000,000" do
      assert_validates_upper_bound_of :proposed_valuation, 1000000000
    end
  end
  
  it "should validate contact email address" do
    deal = Deal.new(valid_fields.except(:contact_email))
    deal.contact_email = 'some.random.string'
    deal.should_not be_valid
    deal.errors_on(:contact_email).should == ["is invalid"]
    
    validation_sanity_check
  end
  
  def assert_validates_numericality_of field
    deal = Deal.new(valid_fields.except(field))
    deal.should_not be_valid
    deal.errors_on(field).should == ["is not a number"]
    
    validation_sanity_check
  end
  
  def assert_validates_positiveness_of field
    deal = Deal.new(valid_fields.except(field).merge({field => 0}))
    deal.should_not be_valid
    deal.errors_on(field).should == ["must be greater than 0"]
    
    validation_sanity_check
  end
  
  def assert_validates_upper_bound_of field, upper_bound
    deal = Deal.new(valid_fields.except(field).merge({field => upper_bound}))
    deal.should_not be_valid
    deal.errors_on(field).should == ["must be less than #{upper_bound}"]
    
    validation_sanity_check
  end
  
  def valid_fields
    {:required_amount => 111, :proposed_valuation => 222, :contact_email => 'me@email.com'}
  end
  
  def validation_sanity_check
     deal = Deal.new(valid_fields)
     deal.should be_valid
  end
end
