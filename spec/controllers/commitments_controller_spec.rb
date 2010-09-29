require 'spec_helper'

describe CommitmentsController do
  
  before :each do
    @deal = Deal.new(deal_parameters)
    @deal.save
    @commitments = @deal.commitments
    
    @current_user = mock_model(User)
    controller.stub(:current_user).and_return(@current_user)
  end

  describe "new" do
    it "should be success" do
      get 'new', :deal_id => @deal.id
    end
    
    it "should create a new commitment" do
      commitment = mock_model(Commitment)
      Commitment.should_receive(:new).and_return(commitment)
      
      get 'new', :deal_id => @deal.id
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
  
  private
  
  def newly_created_commitment
    commitment = Commitment.new
    Commitment.stub(:new).and_return(commitment)
    commitment
  end
  
  def commitment_parameters
    {
      'amount' => '1000'
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
