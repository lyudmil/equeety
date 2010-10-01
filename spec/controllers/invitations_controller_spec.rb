require 'spec_helper'

describe InvitationsController do
  
  before :each do
    @current_user = mock_model(User, :has_access_to? => true)
    controller.stub(:current_user).and_return(@current_user)
    
    @invitation = mock_model(Invitation, :user= => true, :save => true)
    
    @deal = mock_model(Deal, :user => @current_user, :startup_name => 'startup')
    @deal.stub(:invitations).and_return(mock(:build => @invitation))
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
      @invitation.should_receive(:user=).with(@user)
      
      post 'create', :deal_id => @deal.id, :email => @user.email
    end
    
    it "should redirect to deal if save successful" do
      @invitation.should_receive(:save).and_return(true)
      
      post 'create', :deal_id => @deal.id, :email => @user.email
      
      response.should redirect_to @deal
      flash[:notice].should == "You've invited #{@user.email} to invest in #{@deal.startup_name}."
    end
  end
  
end
