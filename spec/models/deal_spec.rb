require 'spec_helper'
require 'validation_test_helper'

describe Deal do
  include ValidationTestHelper
  
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
  
  it "should validate presence of startup name" do
    assert_validates_presence_of :startup_name
  end
  
  describe 'website' do
    it "should be present" do
      assert_validates_presence_of :website
    end
    
    it 'should be an URL' do
      deal = Deal.new(valid_fields)
      deal.website.should =~ Deal::URL_FORMAT
      deal.should be_valid
      validation_sanity_check
      
      %w[ftp://some.random.string .asdf.few asdf@ciao].each do |bad_website|
        deal = Deal.new(valid_fields)
        bad_website.should_not =~ Deal::URL_FORMAT
        deal.website = bad_website
        deal.should_not be_valid
        validation_sanity_check
      end

      %w[http://some.random.string https://some.random.string http://some.random.string/?ASdffa^EW$W=].each do |good_website|
        deal = Deal.new(valid_fields)
        good_website.should =~ Deal::URL_FORMAT
        deal.website = good_website
        deal.should be_valid
        validation_sanity_check
      end
    end
  end
  
  it "should validate presence of contact name" do
    assert_validates_presence_of :contact_name
  end
  
  it "should have many commitments" do
    deal = Deal.new(valid_fields)
    deal.save.should be_true
    
    deal.commitments.create.should be_true
    deal.save.should be_true
  end
  
  private
  
  def model_class
    Deal
  end
  
  def valid_fields
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
