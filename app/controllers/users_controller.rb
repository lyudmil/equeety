class UsersController < ApplicationController
  before_filter :require_user, :only => [:edit, :update, :show]
  before_filter :require_no_user, :only => [:new, :create]
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])

    if @user.save
      redirect_to deals_path, :notice => 'You have signed up successfully.'
    else
      render :new
    end
  end
  
  def show
    @user = current_user
  end
  
  def edit
    @user = current_user
  end
  
  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      redirect_to @user
    else
      render :edit
    end
  end
end
