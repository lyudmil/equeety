require 'spec_helper'

describe UsersController do
  before :each do
    @user = mock_model(User)
    user_session = mock('UserSession')
    user_session.stub(:record).and_return(@user)
    UserSession.should_receive(:find).and_return(user_session)
  end
  
  describe "new" do
    it "should require the user to be logged out"
  end
  
  describe "create" do
    it "should require the user to be logged out"
  end
  
  describe "budget" do 
    it "should be success" do
      get 'budget'
      response.should be_success
    end
    
    it "should find the current user" do
      get 'budget'
    
      assigns(:user).should == @user
    end
    
    it "should require the user to be logged in"
  end
  
  describe "update" do
    it "should find the current user" do
      @user.stub(:update_attributes)
      put 'update', :user => {}      
      
      assigns(:user).should == @user
    end
    
    it "should update the current user according to the submitted parameters" do
      @user.should_receive(:update_attributes).with(user_parameters)
            
      put 'update', :user => user_parameters
    end
    
    it "should redirect to deals page on successful update" do
      @user.stub(:update_attributes).and_return(true)
      put 'update', :user => {}
      
      response.should redirect_to :controller => 'deals', :action => 'index'
    end
    
    it "should render the budget template if update unsuccessful" do
      @user.stub(:update_attributes).and_return(false)
      put 'update', :user => {}
      
      response.should render_template 'budget'
    end
    
    it "should require the user to be logged in"
  end
  
  describe "show" do
    it "should be success" do
      get 'show'
      response.should be_success
    end
    
    it "should find the currently logged in user" do
      get 'show'
      assigns(:user).should == @user
    end
    
    it "should require the user to be logged in"
  end
  
  private
  
  def user_parameters
    {
      'budget' => 2000
    }
  end
end