class DealsController < ApplicationController
  before_filter :require_user
  
  def new
    @deal = Deal.new
  end

  def create
    @deal = Deal.new(deal_parameters)
    if @deal.save
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end
  
  def edit
    @deal = Deal.find(params[:id])
  end
  
  def update
    @deal = Deal.find(params[:id])
    if @deal.update_attributes(params[:deal])
      redirect_to deals_url
    else
      render :action => 'edit'
    end
  end
  
  def index
    @deals = Deal.where(:user_id => current_user)
  end
  
  private
  
  def deal_parameters
    params[:deal].merge({:user => current_user})
  end
end
