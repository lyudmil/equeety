class CommitmentsController < ApplicationController
  before_filter :require_user
  before_filter :require_user_access_to_deal_to_invest
  before_filter :require_user_access_to_commitment, :only => [:edit, :update]
  
  def new
    @commitment = @deal.commitments.build
  end
  
  def create
    @commitment = @deal.commitments.build(params[:commitment])
    @commitment.user = current_user
    
    if @commitment.save
      redirect_to @deal
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @commitment.update_attributes(params[:commitment])
      redirect_to @deal
    else
      render :edit
    end
  end
  
  private
  
  def require_user_access_to_deal_to_invest
    @deal = Deal.find(params[:deal_id])
    
    unless current_user.can_invest_in? @deal
      redirect_to deals_path, :notice => "You don't have access to this deal and therefore can't invest in it."
    end
  end
  
  def require_user_access_to_commitment
    @commitment = @deal.commitments.find(params[:id])
    unless @commitment.user == current_user
      redirect_to deals_path, :notice => "You are not the original investor and therefore can't edit this investment."
    end
  end
  
end
