class UserSessionsController < ApplicationController
  def new
    @session = UserSession.new
  end

  def create
    @session = UserSession.new(params[:session])
    
    if @session.save
      redirect_to home_url, :notice => 'You\'ve logged in successfully.'
    else
      flash[:error] = 'Sorry, we couldn\'t match your email and password.'
      redirect_to login_url
    end
  end

  def destroy
    @session = UserSession.find
    @session.destroy
    
    redirect_to root_url
  end
end
