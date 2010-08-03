require 'spec_helper'

describe UserSessionController do

  before :each do
    @session = mock('UserSession')
    UserSession.stub(:new).and_return(@session)
    UserSession.stub(:find).and_return(@session)
  end
  
  describe "new" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
    
    it "should create a new session" do
      UserSession.should_receive(:new)
      get 'new'
    end
  end

  describe "create" do
    it "should create a new session based on the parameters" do
      session_parameters = {"param1" => "value1", "param2" => "value2"}
      parameters = {:session => session_parameters}
      session = mock('UserSession')
      session.stub(:save)
      UserSession.should_receive(:new).with(session_parameters).and_return(session)
      
      post 'create', parameters
    end
    
    it "should redirect to home page if login successful" do
      @session.stub(:save).and_return(true)   
      post 'create'
      
      response.should redirect_to :controller => 'static_pages', :action => 'home'
    end
    
    it "should render the login dialog if login unsuccessful" do
      @session.stub(:save).and_return(false)
      post 'create'
      
      response.should render_template 'new'
    end
  end

  describe "destroy" do
    it "should find and destroy the current session" do
      UserSession.should_receive(:find).and_return(@session)
      @session.should_receive(:destroy)
      
      get 'destroy'
    end
    
    it "should redirect to the home page" do
      @session.stub(:destroy)
      get 'destroy'
      
      response.should redirect_to :controller => 'static_pages', :action => 'home'
    end
  end

end
