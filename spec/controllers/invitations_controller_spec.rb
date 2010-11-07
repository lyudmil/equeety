require 'spec_helper'

describe InvitationsController do
  
  before :each do
    @current_user = mock_model(User, :has_access_to? => true)
    controller.stub(:current_user).and_return(@current_user)
    
    @invitation = mock_model(Invitation, :id => 23, :user= => true, :save => true)
    
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
  
  describe "destroy" do
    before :each do
      Invitation.stub(:find).with(@invitation.id).and_return(@invitation)
      @invitation.stub(:user).and_return(@current_user)
    end
    
    it "should redirect to dashboard" do
      delete :destroy, :id => @invitation.id
      
      response.should redirect_to dashboard_path
    end
    
    it "should delete invitation" do
      @invitation.should_receive(:destroy)
      
      delete :destroy, :id => @invitation.id
    end
    
    it "should only proceed if the invite belongs to the current user" do
      @invitation.stub(:user).and_return(mock_model(User))
      @invitation.should_not_receive(:destroy)
      
      delete :destroy, :id => @invitation.id
      
      response.should redirect_to dashboard_path
      flash[:error].should == "You don't have access to this deal."
    end
  end
  
  describe "update" do
    before :each do
      Invitation.stub(:find).with(@invitation.id).and_return(@invitation)
      @invitation.stub(:accepted=)
      @invitation.stub(:save)
      @invitation.stub(:user).and_return(@current_user)
    end
    
    it "should save the invitation as accepted" do
      @invitation.should_receive(:accepted=).with(true)
      @invitation.should_receive(:save)
      
      put :update, :id => @invitation.id
    end
    
    it "should redirect to deals" do      
      put :update, :id => @invitation.id
      response.should redirect_to deals_path
    end
    
    it "should only proceed if the invite belongs to the current user" do
      @invitation.stub(:user).and_return(mock_model(User))
      controller.should_receive(:require_invitation_to_current_user)
      
      put :update, :id => @invitation.id
    end
  end
  
  describe "require login for" do
    %w(new create update destroy).each do |action|
      it action do
        user = mock_model(User, :email => 'mock@email.com')
        invitation = mock_model(Invitation, :id => 3, :accepted= => nil, :save => nil, :destroy => nil, :user => user)
        User.stub(:find_by_email).with(user.email).and_return(user)
        Invitation.stub(:find).and_return(invitation)
        
        controller.should_receive(:require_user)
        
        case action
        when 'new'
          get 'new', :deal_id => @deal.id
        when 'create'
          post 'create', :deal_id => @deal.id, :email => user.email
        when 'update'
          put 'update', :id => 3
        when 'destroy'
          delete 'destroy', :id => 3
        end
      end
    end
  end
  
end
