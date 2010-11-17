require 'spec_helper'

describe OffersController do
  before :each do
    @deal = mock_model(Deal)
    User.stub(:find_by_nickname).with('lyudmil').and_return(mock_model(User))
  end
  
  describe "new" do
    it "should create a new deal" do
      Deal.should_receive(:new).and_return(@deal)
      
      get 'new', :nickname => 'lyudmil'
      response.should be_success
      assigns(:deal).should == @deal
    end
    
    it "should redirect to home page if no user with the given nickname exists" do
      User.should_receive(:find_by_nickname).with('lyudmil').and_return(nil)
      
      get 'new', :nickname => 'lyudmil'
      response.should redirect_to root_path
      flash[:error].should == "The page you tried to access is not available."
    end
  end
  
  describe "create" do
    before :each do
      @invitations = mock(:create => mock_model(Invitation, :public => nil))
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
      
      @invitations.should_receive(:create).with(:user => user, :public => true)
      post 'create', :nickname => 'lyudmil', :deal => deal_parameters
    end
    
    it "should redirect to home page if all saves are successful" do
      @deal.should_receive(:save).and_return(true)
      
      post 'create', :nickname => 'lyudmil', :deal => deal_parameters
      response.should redirect_to root_path
      flash[:notice].should == "Thank you. Your deal proposal has been submitted."
    end
    
    it "should render the new template again if deal could not be saved" do
      @deal.should_receive(:save).and_return(false)
      
      post 'create', :nickname => 'lyudmil', :deal => deal_parameters
      response.should render_template 'new'
    end
    
    it "should apply public user path filter" do
      controller.should_receive(:require_user_public_path)
      
      post 'create', :nickname => 'lyudmil', :deal => deal_parameters
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
