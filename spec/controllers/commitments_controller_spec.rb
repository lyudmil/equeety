require 'spec_helper'

describe CommitmentsController do
  
  before :each do
    @current_user = mock_model(User, :budget => 100000)
    @current_user.stub(:deals).and_return(Deal)
    @current_user.stub(:has_access_to?).and_return(true)
    
    @exiting_deal = mock_model(Deal, deal_parameters.merge(:user => @current_user))
    @exiting_deal.stub(:commitments).and_return(Commitment)
    Deal.stub(:find).with(@exiting_deal.id).and_return(@exiting_deal)
    
    @commitment = mock_model(Commitment, :amount => 123, :user => @current_user)
    Commitment.stub(:find).with(@commitment.id).and_return(@commitment)
    
    controller.stub(:current_user).and_return(@current_user)
  end
  
  describe "new" do
    it "should create a new commitment" do
      Commitment.stub(:build).and_return(@commitment)
      get 'new', :deal_id => @exiting_deal.id
      
      assigns(:deal).should == @exiting_deal
      assigns(:commitment).should == @commitment
    end
    
    it "should not allow users that do not have access to a deal to invest" do
      controller.stub(:current_user).and_return(mock_model(User, :has_access_to? => false))
      get 'new', :deal_id => @exiting_deal.id
      
      response.should redirect_to :controller => :deals, :action => :index
      flash[:notice].should == "You don't have access to this deal and therefore can't invest in it."
    end
  end
  
  describe "create" do
    before :each do
      @created_commitment = mock_model(Commitment)
      @created_commitment.should_receive(:user=).with(@current_user)
      @created_commitment.stub(:save)
      Commitment.stub(:build).with(commitment_parameters).and_return(@created_commitment)
      
      @exiting_deal.should_receive(:commitments).and_return(Commitment)  
    end
    
    it "should create a commitment based on submitted parameters" do
      Commitment.should_receive(:build).with(commitment_parameters).and_return(@created_commitment)
      post 'create', :deal_id => @exiting_deal.id, :commitment => commitment_parameters
    end
    
    it "should redirect to the deal if save successful" do
      @created_commitment.should_receive(:save).and_return(true)
      post 'create', :deal_id => @exiting_deal.id, :commitment => commitment_parameters
      
      response.should redirect_to @exiting_deal
    end
    
    it "should render the new template again if save not successful" do
      @created_commitment.should_receive(:save).and_return(false)
      post 'create', :deal_id => @exiting_deal.id, :commitment => commitment_parameters
      
      response.should render_template 'new'
    end
  end
  
  describe "edit" do
    it "should find the right commitment" do
      get 'edit', :deal_id => @exiting_deal.id, :id => @commitment.id
      
      response.should be_success
      assigns(:deal).should == @exiting_deal
      assigns(:commitment).should == @commitment
    end
  end
  
  describe "update" do
    it "should update the commitment attributes accordingly" do
      @commitment.should_receive(:update_attributes).with(commitment_parameters)
      
      put 'update', :deal_id => @exiting_deal.id, :id => @commitment.id, :commitment => commitment_parameters
    end
    
    it "should redirect to deal if update successful" do
      @commitment.should_receive(:update_attributes).with(commitment_parameters).and_return(true)
      put 'update', :deal_id => @exiting_deal.id, :id => @commitment.id, :commitment => commitment_parameters
      
      response.should redirect_to @exiting_deal
    end
    
    it "should render the edit action again if update not successful" do
      @commitment.should_receive(:update_attributes).with(commitment_parameters).and_return(false)
      put 'update', :deal_id => @exiting_deal.id, :id => @commitment.id, :commitment => commitment_parameters
      
      response.should render_template 'edit'
    end
  end
  
  describe "enforcement of access rules for commitments" do
    %w(edit update).each do |action|
      it "should refuse to #{action} if the current user is not the original investor" do
        controller.stub(:current_user).and_return(mock_model(User, :has_access_to? => true))
        
        get 'edit', :deal_id => @exiting_deal.id, :id => @commitment.id if action == 'edit'
        put 'update', :deal_id => @exiting_deal.id, :id => @commitment.id if action == 'update'

        response.should redirect_to :controller => :deals, :action => :index
        flash[:notice].should == "You are not the original investor and therefore can't edit this investment."
      end
    end
  end
  
  describe "enforcement of access rules for deals" do
    %w(new create edit update).each do |action|
      it "#{action} should not allow users that do not have access to a deal to invest" do
        controller.stub(:current_user).and_return(mock_model(User, :has_access_to? => false))
        
        get 'new', :deal_id => @exiting_deal.id if action == 'new'
        post 'create', :deal_id => @exiting_deal.id if action == 'create'
        get 'edit', :deal_id => @exiting_deal.id, :id => @commitment.id if action == 'edit'
        put 'update', :deal_id => @exiting_deal.id, :id => @commitment.id if action == 'update'
        
        response.should redirect_to :controller => :deals, :action => :index
        flash[:notice].should == "You don't have access to this deal and therefore can't invest in it."
      end
    end
  end
  
  private
  
  def commitment_parameters
  {
    "amount" => "1000"
  }
  end
  
  def deal_parameters
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
