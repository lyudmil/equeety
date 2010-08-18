class UsersController < ApplicationController
  before_filter :require_user, :only => [:budget, :update, :show]
  before_filter :require_no_user, :only => [:new, :create]
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])

    if @user.save
      redirect_to deals_url, :notice => 'You have signed up successfully.'
    else
      render :action => "new"
    end
  end
  
  def show
    @user = current_user
  end
  
  def budget
    @user = current_user
  end
  
  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      redirect_to @user
    else
      render :action => "budget"
    end
  end
end
