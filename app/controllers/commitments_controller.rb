class CommitmentsController < ApplicationController
  before_filter :require_user_access_to_deal
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
  
  def require_user_access_to_deal
    @deal = Deal.find(params[:deal_id])
  end
  
  def require_user_access_to_commitment
    @commitment = @deal.commitments.find(params[:id])
  end
  
end
