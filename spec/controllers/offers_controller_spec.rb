require 'spec_helper'

describe OffersController do
  before :each do
    @deal = mock_model(Deal)
  end
  
  describe "new" do
    it "should create a new deal" do
      Deal.should_receive(:new).and_return(@deal)
      
      get 'new', :nickname => 'lyudmil'
      assigns(:deal).should == @deal
    end
  end
  
  describe "create" do
    before :each do
      @invitations = mock(:build => mock_model(Invitation))
      @deal.stub(:invitations).and_return(@invitations)
      @deal.stub(:save).and_return(true)
      Deal.should_receive(:new).with(deal_parameters).and_return(@deal)
    end
    
    it "should create a new deal based on the submitted parameters" do
      post 'create', :nickname => 'lyudmil', :deal => deal_parameters
      assigns(:deal).should == @deal
    end
    
    it "should invite the appropriate user to the deal" do
      user = mock_model(User)
      User.stub(:find_by_nickname).with('lyudmil').and_return(user)
      
      @invitations.should_receive(:build).with(:user => user)
      post 'create', :nickname => 'lyudmil', :deal => deal_parameters
    end
    
    it "should redirect to home page if all saves are successful" do
      @deal.should_receive(:save).and_return(true)
      
      post 'create', :nickname => 'lyudmil', :deal => deal_parameters
      response.should redirect_to root_path
    end
    
    it "should render the new template again if deal could not be saved" do
      @deal.should_receive(:save).and_return(false)
      
      post 'create', :nickname => 'lyudmil', :deal => deal_parameters
      response.should render_template 'new'
    end
  end
  
  private
  
  def deal_parameters
    {
      'startup_name' => 'equeety',
      'website' => 'equeety.com',
      'contact_name' => 'stefano',
      'contact_email' => 'me@email.com',
      'required_amount' => '111', 
      'proposed_valuation' => '222'
    }
  end
end
