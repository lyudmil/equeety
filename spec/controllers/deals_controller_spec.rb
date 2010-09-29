require 'spec_helper'
require 'deal'

describe DealsController do
  
  before :each do
    @current_user = mock_model(User)
    @current_user.stub(:deals).and_return(Deal)
    @current_user.stub(:has_access_to?).and_return(true)
    
    @deal = mock_model(Deal)
    @deal.stub(:user).and_return(@current_user)
    
    controller.stub(:current_user).and_return(@current_user)
  end

  describe "new" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
    
    it "should create a new deal" do
      deal = mock_model(Deal)
      Deal.should_receive(:new).and_return(deal)
      get 'new'
      
      assigns(:deal).should == deal
    end
  end
  
  describe "create" do
    before :each do
      @current_user.should_receive(:deals).and_return(Deal)
      Deal.should_receive(:build).with(deal_parameters).and_return(@deal)
    end
    
    it "should redirect to the index action if create successful" do
      @deal.should_receive(:save).and_return(true)
      post 'create', {:deal => deal_parameters}
      
      response.should redirect_to :controller => 'deals', :action => 'index'
    end
    
    it "should render the new template again if create was not successful" do
      @deal.should_receive(:save).and_return(false)
      post 'create', {:deal => deal_parameters}
      
      response.should render_template 'new'
    end
    
    it "should create a deal based on the submitted parameters" do
      @deal.should_receive(:save).and_return(true)
      post 'create', {:deal => deal_parameters}
      
      assigns(:deal).should == @deal
    end
  end

  describe "index" do
    before do
      @deals = [mock_model(Deal), mock_model(Deal)]
      Deal.should_receive(:where).with(:user_id => @current_user).and_return(@deals)
    end
    
    it "should be successful" do
      get 'index'
      response.should be_success
    end
    
    it "should find all deals owned by the current user" do
      get 'index' 
      assigns(:deals).should == @deals
    end
  end
  
  describe "edit" do
    it "should find the deal to edit" do
      deal = mock_model(Deal)
      Deal.should_receive(:find).with(1).and_return(deal)
      get 'edit', :id => 1
      
      # assigns(:deal).should == deal
    end
  end
  
  %w(edit show).each do |action|
    it "#{action} should require deal access" do
      controller.should_receive(:require_user_access_to_deal)
      
      get action, :id => 1
    end
  end
  
  describe "update" do
    before do
      @deal = mock_model(Deal)
      Deal.should_receive(:find).with(23).and_return(@deal)
    end
    
    it "should update the deal based on the submitted parameters" do
      @deal.should_receive(:update_attributes).with(deal_parameters)
      put 'update', :id => 23, :deal => deal_parameters
    end
    
    it "should redirect to index action if update successful" do
      @deal.stub(:update_attributes).and_return(true)
      put 'update', :id => 23
      
      response.should redirect_to :controller => 'deals', :action => 'index'
    end
    
    it "should render the edit template if update unsuccessful" do
      @deal.stub(:update_attributes).and_return(false)
      put 'update', :id => 23
      
      response.should render_template 'edit'
    end
    
    it "should fail if user does not have access to deal" do
      @current_user.stub(:has_access_to?).with(@deal).and_return(false)
      put 'update', :id => 23
      
      response.should redirect_to deals_url
    end
  end
  
  describe "show" do
    it "should find the right deal" do
      Deal.should_receive(:find).with(34)
      get 'show', :id => 34
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
