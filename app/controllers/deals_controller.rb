class DealsController < ApplicationController
  before_filter :require_user
  before_filter :require_user_access_to_deal, :only => [:edit, :update, :show]
  
  def new
    @deal = Deal.new
  end

  def create
    @deal = current_user.deals.build(params[:deal])
    if @deal.save
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @deal.update_attributes(params[:deal])
      redirect_to deals_url
    else
      render :action => 'edit'
    end
  end
  
  def show
  end
  
  def index
    @deals = Deal.where(:user_id => current_user)
  end
  
  private
  
  def deal_parameters
    params[:deal].merge({:user => current_user})
  end
end
