class DashboardController < ApplicationController
  before_filter :require_user
  
  helper_method :private_invitations
  helper_method :public_invitations
  
  def index
    @invitations = Invitation.where(:user_id => current_user)
  end
  
  private
  
  def private_invitations
    @invitations.select { |invitation| not (invitation.public? or invitation.accepted?) }
  end
  
  def public_invitations
    @invitations.select { |invitation| invitation.public? and not invitation.accepted? }
  end
end
