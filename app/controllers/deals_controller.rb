class DealsController < ApplicationController
  def new
    @deal = Deal.new
  end

  def create
    @deal = Deal.new(deal_parameters)
    @deal.save
    redirect_to :action => 'index'
  end
  
  def index
    @deals = Deal.where(:user_id => current_user)
  end
  
  private
  
  def deal_parameters
    params[:deal].merge({:user => current_user})
  end
end
