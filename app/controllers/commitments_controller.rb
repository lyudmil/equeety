class CommitmentsController < ApplicationController
  
  def new
    @deal = Deal.find(params[:deal_id])
    @commitment = @deal.commitments.build
  end
  
  def create
    @deal = Deal.find(params[:deal_id])
    @commitment = @deal.commitments.build(params[:commitment])
    @commitment.user = current_user
    
    if @commitment.save
      redirect_to @deal
    else
      render :new
    end
  end
  
  def edit
    @deal = Deal.find(params[:deal_id])
    @commitment = @deal.commitments.find(params[:id])
  end
  
  def update
    @deal = Deal.find(params[:deal_id])
    @commitment = @deal.commitments.find(params[:id])
    @commitment.update_attributes(params[:commitment])
  end
  
end
