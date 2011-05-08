class DealsController < ApplicationController
  before_filter :require_user
  before_filter :require_user_ownership_of_deal, :only => [:edit, :update]
  before_filter :require_user_access_to_deal, :only => [:show]
  
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
    @deal = Deal.find(params[:id])
    if @deal.update_attributes(params[:deal])
      redirect_to deals_path
    else
      render :action => 'edit'
    end
  end
  
  def show
  end
  
  def index
    @deals = Deal.where(:user_id => current_user)
    @invitations = current_user.invitations
    accepted_invitations = @invitations.select { |invite| invite.accepted? }
    @deals_invited_to = accepted_invitations.collect { |invite| invite.deal }
    
    @all_deals = @deals + @deals_invited_to
    
    @new_deals_count = count_deals_with_status 'new'
    @due_diligence_deals_count = count_deals_with_status 'due_diligence'
    @pending_deals_count = count_deals_with_status 'pending'
    @invites_this_month_count = count_invites_this_month
  end
  
  private
  
  def require_user_ownership_of_deal
    @deal = Deal.find(params[:id])
    unless current_user.owns? @deal
      redirect_to @deal, :notice => "You need to own this deal to edit it."
    end
  end
  
  def deal_parameters
    params[:deal].merge({:user => current_user})
  end
  
  def count_deals_with_status status
    @all_deals.count { |deal| deal.status == status }
  end
  
  def count_invites_this_month
    @invitations.count do |invite| 
      date_created = invite.created_at.to_date
      today = Date.today
      date_created.month == today.month and date_created.year == today.year
    end
  end
end
