class InvitationsController < ApplicationController
  before_filter :require_user_access_to_deal_to_invite
  
  def new
    @invitation = @deal.invitations.build
  end
  
  def create
    @invitation = @deal.invitations.build
    user = User.find_by_email(params[:email])
    @invitation.user = user
    @invitation.save
    
    redirect_to @deal, :notice => "You've invited #{user.email} to invest in #{@deal.startup_name}."
  end
  
  private
  
  def require_user_access_to_deal_to_invite
    require_user_access_to_deal :deal_id
  end
  
end
