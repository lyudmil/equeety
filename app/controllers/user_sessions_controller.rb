class UserSessionsController < ApplicationController
  def new
    @session = UserSession.new
  end

  def create
    @session = UserSession.new(params[:session])
    
    if @session.save
      redirect_to dashboard_path
    else
      flash[:error] = 'Sorry, we couldn\'t match your email and password.'
      redirect_to login_path
    end
  end

  def destroy
    @session = UserSession.find
    @session.destroy
    
    redirect_to root_path
  end
end
