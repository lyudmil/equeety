class OffersController < ApplicationController
  def new
    @deal = Deal.new
  end
  
  def create
    @deal = Deal.new(params[:deal])
    user = User.find_by_nickname(params[:nickname])
    invitation = @deal.invitations.build(:user => user)
    
    if @deal.save
      redirect_to root_path
    else
      render :new
    end
  end
end
