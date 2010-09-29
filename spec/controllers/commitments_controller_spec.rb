require 'spec_helper'

describe CommitmentsController do
  
  before do
    @current_user = User.new({:email => "me@somewhere.com", :password => "pass", :password_confirmation => "pass"})
    @current_user.save.should be_true
    @deal = @current_user.deals.create(deal_parameters)
    controller.stub(:current_user).and_return(@current_user)
    
    @commitment = @deal.commitments.create(:amount => 123, :user => @current_user)
  end
  
  describe "new" do
    it "should be success" do
      get 'new', :deal_id => @deal.id
    end
    
    it "should create a new commitment" do
      commitment = newly_created_commitment
      get 'new', :deal_id => @deal.id
      
      assigns(:deal).should == @deal
      assigns(:commitment).should == commitment
    end
  end
  
  describe "create" do
    it "should create a commitment based on submitted parameters" do
      post 'create', :deal_id => @deal.id, :commitment => commitment_parameters
      
      assigns(:commitment).amount.should == 1000
      assigns(:commitment).deal.should == @deal
      assigns(:commitment).user.should == @current_user
    end
    
    it "should redirect to the deal if save successful" do
      newly_created_commitment.should_receive(:save).and_return(true)
      post 'create', :deal_id => @deal.id, :commitment => commitment_parameters
      
      response.should redirect_to @deal
    end
    
    it "should render the new template again if save not successful" do
      newly_created_commitment.should_receive(:save).and_return(false)
      post 'create', :deal_id => @deal.id, :commitment => commitment_parameters
      
      response.should render_template 'new'
    end
  end
  
  describe "edit" do
    it "should find the right commitment" do
      get 'edit', :deal_id => @deal.id, :id => @commitment.id
      
      response.should be_success
      assigns(:deal).should == @deal
      assigns(:commitment).should == @commitment
    end
    
    it "should refuse to edit if the current user is not the original investor" do
      controller.stub(:current_user).and_return(mock_model(User))
      get 'edit', :deal_id => @deal.id, :id => @commitment.id

      response.should redirect_to :controller => :deals, :action => :index
      flash[:notice].should == "You are not the original investor and therefore can't edit this investment."
    end
  end
  
  describe "update" do
    it "should update the commitment attributes accordingly" do
      put 'update', :deal_id => @deal.id, :id => @commitment.id, :commitment => commitment_parameters
      
      @commitment.reload.amount.should == 1000
    end
    
    it "should redirect to deal if update successful" do
      put 'update', :deal_id => @deal.id, :id => @commitment.id, :commitment => commitment_parameters
      
      response.should redirect_to @deal
    end
    
    it "should render the edit action again if update not successful" do
      put 'update', :deal_id => @deal.id, :id => @commitment.id, :commitment => {'amount' => '-100'}
      
      response.should render_template 'edit'
    end
    
    it "should refuse to update if the current user is not the original investor" do
      controller.stub(:current_user).and_return(mock_model(User))
      put 'update', :deal_id => @deal.id, :id => @commitment.id, :commitment => commitment_parameters
      
      response.should redirect_to :controller => :deals, :action => :index
      flash[:notice].should == "You are not the original investor and therefore can't edit this investment."
    end
  end
  
  private
  
  def newly_created_commitment
    commitment = Commitment.new
    Commitment.stub(:new).and_return(commitment)
    commitment
  end
  
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
