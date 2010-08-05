require 'spec_helper'

describe DealsController do
  
  before :each do
    @current_user = mock_model(User)
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
    it "should redirect to the index action if create successful" do
      post 'create', {:deal => {}}
      response.should redirect_to :controller => 'deals', :action => 'index'
    end
    
    it "should create a deal based on the submitted parameters" do
      deal_parameters = {
        'startup_name' => 'equeety',
        'website' => 'equeety.com',
        'contact_name' => 'stefano',
      }
      post 'create', {:deal => deal_parameters}
      
      assigns(:deal).user.should == @current_user
      assigns(:deal).startup_name.should == 'equeety'
      assigns(:deal).website.should == 'equeety.com'
      assigns(:deal).contact_name.should == 'stefano'
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
end
