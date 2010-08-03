class UserSessionsController < ApplicationController
  def new
    @session = UserSession.new
  end

  def create
    @session = UserSession.new(params[:session])
    
    if @session.save
      redirect_to home_url, :notice => 'You\'ve logged in successfully.'
    else
      render :action => 'new'
    end
  end

  def destroy
    @session = UserSession.find
    @session.destroy
    
    redirect_to home_url
  end
end
