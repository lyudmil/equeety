class DealsController < ApplicationController
  def new
    @deal = Deal.new
  end

  def create
    @deal = Deal.new(deal_parameters)
    redirect_to :action => 'index'
  end
  
  def index
    @deals = current_user.deals
  end
  
  private
  
  def deal_parameters
    params[:deal].merge({:owner => current_user})
  end
end
