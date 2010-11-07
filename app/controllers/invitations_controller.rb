class InvitationsController < ApplicationController
  before_filter :require_user
  before_filter :require_user_access_to_deal_to_invite, :only => [:new, :create]
  before_filter :require_invitation_to_current_user, :only => [:update, :destroy]
  
  def new
    @invitation = @deal.invitations.build
  end
  
  def create
    user = User.find_by_email(params[:email])
    @invitation = @deal.invitations.build(:user => user)
    
    if @invitation.save
      redirect_to @deal, :notice => "You've invited #{user.email} to invest in #{@deal.startup_name}."
    else
      render :new
    end
  end
  
  def destroy
    @invitation.destroy
    
    redirect_to dashboard_path
  end
  
  def update
    invitation = Invitation.find(params[:id])
    invitation.accepted = true
    invitation.save
    
    redirect_to deals_path
  end
  
  private
  
  def require_user_access_to_deal_to_invite
    require_user_access_to_deal :deal_id
  end
  
  def require_invitation_to_current_user
    @invitation = Invitation.find(params[:id])
    unless @invitation.user == current_user
      flash[:error] = "You don't have access to this deal."
      redirect_to dashboard_path
      return false
    end
  end
  
end
