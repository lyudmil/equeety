class CommitmentsController < ApplicationController
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
    require_user_access_to_deal :deal_id
  end
  
  def require_user_access_to_commitment
    @commitment = @deal.commitments.find(params[:id])
    unless @commitment.user == current_user
      redirect_to deals_url, :notice => "You are not the original investor and therefore can't edit this investment."
    end
  end
  
end
