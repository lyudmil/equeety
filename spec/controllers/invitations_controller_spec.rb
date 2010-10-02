require 'spec_helper'

describe InvitationsController do
  
  before :each do
    @current_user = mock_model(User, :has_access_to? => true)
    controller.stub(:current_user).and_return(@current_user)
    
    @invitation = mock_model(Invitation, :user= => true, :save => true)
    
    @deal = mock_model(Deal, :user => @current_user, :startup_name => 'startup')
    @invitations = mock(:build => @invitation)
    @deal.stub(:invitations).and_return(@invitations)
    Deal.stub(:find).with(@deal.id).and_return(@deal)
  end
  
  describe "new" do
    it "should build a new invitation for the correct deal" do
      get 'new', :deal_id => @deal.id
      
      assigns(:deal).should == @deal
      assigns(:invitation).should == @invitation
    end
  end
  
  describe "create" do
    before :each do
      @user = mock_model(User, :email => 'mock@email.com')
      User.stub(:find_by_email).with(@user.email).and_return(@user)
    end
    
    it "should build a new invitation addressed to the appropriate user" do  
      @invitations.should_receive(:build).with(:user => @user)
      
      post 'create', :deal_id => @deal.id, :email => @user.email
    end
    
    it "should redirect to deal if save successful" do
      @invitation.should_receive(:save).and_return(true)
      
      post 'create', :deal_id => @deal.id, :email => @user.email
      
      response.should redirect_to @deal
      flash[:notice].should == "You've invited #{@user.email} to invest in #{@deal.startup_name}."
    end
    
    it "should render the new template if save not successful" do
      @invitation.should_receive(:save).and_return(false)
      
      post 'create', :deal_id => @deal.id, :email => @user.email
      
      response.should render_template 'new'
    end
  end
  
  describe "require login for" do
    %w(new create).each do |action|
      it action do
        user = mock_model(User, :email => 'mock@email.com')
        User.stub(:find_by_email).with(user.email).and_return(user)
        
        controller.should_receive(:require_user)
        
        get 'new', :deal_id => @deal.id if action == 'new'
        post 'create', :deal_id => @deal.id, :email => user.email if action == 'create'
      end
    end
  end
  
end
