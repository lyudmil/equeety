class InvitationsController < ApplicationController
  before_filter :require_user_access_to_deal_to_invite
  
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
  
  private
  
  def require_user_access_to_deal_to_invite
    require_user_access_to_deal :deal_id
  end
  
end
