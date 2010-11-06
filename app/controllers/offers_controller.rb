class OffersController < ApplicationController
  before_filter :require_user_public_path
  
  def new
    @deal = Deal.new
  end
  
  def create
    @deal = Deal.new(params[:deal])
    if @deal.save
      invitation = @deal.invitations.create(:user => @user)
      redirect_to root_path, :notice => "Thank you. Your deal proposal has been submitted."
    else
      render :new
    end
  end
  
  private
  
  def require_user_public_path
    @user = User.find_by_nickname(params[:nickname])
    unless @user
      flash[:error] = "The page you tried to access is not available."
      redirect_to root_path 
      return false
    end
  end
end
