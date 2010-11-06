class OffersController < ApplicationController
  def new
    @deal = Deal.new
  end
  
  def create
    @deal = Deal.new(params[:deal])
    if @deal.save
      user = User.find_by_nickname(params[:nickname])
      invitation = @deal.invitations.build(:user => user)
      redirect_to root_path if @deal.save
    else
      render :new
    end
  end
end
