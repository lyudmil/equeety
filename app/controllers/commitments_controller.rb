class CommitmentsController < ApplicationController
  
  def new
    @commitment = Commitment.new
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
  
end
