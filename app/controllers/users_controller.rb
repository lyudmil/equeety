class UsersController < ApplicationController
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
      redirect_to deals_url
    else
      render :action => "budget"
    end
  end
end
