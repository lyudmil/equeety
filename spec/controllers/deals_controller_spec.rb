require 'spec_helper'
require 'deal'

describe DealsController do
  
  before :each do
    @current_user = mock_model(User)
    @current_user.stub(:deals).and_return(Deal)
    @current_user.stub(:can_view?).and_return(true)
    
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
      @deals = [
        mock_model(Deal, :status => 'new'), 
        mock_model(Deal, :status => 'due_diligence'),
        mock_model(Deal, :status => 'pending')
      ]
      Deal.should_receive(:where).with(:user_id => @current_user).and_return(@deals)
      
      @deals_invited_to = [
        mock_model(Deal, :status => 'new'), 
        mock_model(Deal, :status => 'due_diligence'),
        mock_model(Deal, :status => 'pending')
      ]
      
      now = DateTime.now
      invitations = [
        Invitation.new(:deal => @deals_invited_to[0], :accepted => true, :created_at => now), 
        Invitation.new(:deal => @deals_invited_to[1], :accepted => true, :created_at => now),
        Invitation.new(:deal => @deals_invited_to[2], :accepted => true, :created_at => now - 1.month),
        Invitation.new(:deal => mock_model(Deal), :accepted => false, :created_at => now)
      ]
      @current_user.stub(:invitations).and_return(invitations)
    end
    
    it "should be successful" do
      get 'index'
      
      response.should be_success
    end
    
    it "should find all deals owned by the current user" do
      get 'index' 
      
      assigns(:deals).should == @deals
    end
    
    it "should find all the deals the current user has been invited to" do
      get 'index'
      
      assigns(:deals_invited_to).should == @deals_invited_to
    end
    
    it "should calculate the number of new deals" do
      get 'index'
      
      assigns(:new_deals_count).should == 2
    end
    
    it "should calculate the number of due diligence deals" do
      get 'index'
      
      assigns(:due_diligence_deals_count).should == 2
    end
    
    it "should calculate the number of pending deals" do
      get 'index'
      
      assigns(:pending_deals_count).should == 2
    end
    
    it "should calculate the number of deals received this month" do
      get 'index'
      
      assigns(:invites_this_month_count).should == 3
    end
    
    it "should display all deals by default" do
      get 'index'
      
      assigns(:deals_displayed).should == @deals + @deals_invited_to
    end
    
    it "should display only new deals if specified" do
      get 'index', :status => 'new'
      
      assigns(:deals_displayed).should == [@deals[0], @deals_invited_to[0]]
    end
    
    it "should display only due diligence deals if specified" do
      get 'index', :status => 'due_diligence'
      
      assigns(:deals_displayed).should == [@deals[1], @deals_invited_to[1]]
    end    
    
    it "should display only pending deals if specified" do
      get 'index', :status => 'pending'
      
      assigns(:deals_displayed).should == [@deals[2], @deals_invited_to[2]]
    end
  end
  
  describe "edit" do
    before :each do
      @deal = mock_model(Deal)
      Deal.stub(:find).with(@deal.id).and_return(@deal)
    end
    
    it "should find the deal to edit" do
      @current_user.stub(:owns?).with(@deal).and_return(true)
      get 'edit', :id => @deal.id
      
      assigns(:deal).should == @deal
    end
    
    it "should fail if user does not own the deal" do
      @current_user.stub(:owns?).with(@deal).and_return(false)
      get 'edit', :id => @deal.id
      
      response.should redirect_to @deal
    end
  end
  
  describe "update" do
    before do
      @deal = mock_model(Deal)
      Deal.stub(:find).with(23).and_return(@deal)
      
      @current_user.stub(:owns?).and_return(true)
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
    
    it "should fail if user does not own the deal" do
      @deal.stub(:update_attributes).and_return(true)
      @current_user.stub(:owns?).with(@deal).and_return(false)
      put 'update', :id => 23
      
      response.should redirect_to @deal
      flash[:notice].should == "You need to own this deal to edit it."
    end
  end
  
  describe "show" do
    it "should find the right deal" do
      Deal.should_receive(:find).with(34)
      get 'show', :id => 34
    end
    
    it "should require deal access" do
      controller.should_receive(:require_user_access_to_deal)
      
      get 'show', :id => 1
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
      'proposed_valuation' => '222',
      'status' => 'new'
    }
  end
end
