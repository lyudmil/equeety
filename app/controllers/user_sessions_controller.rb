class UserSessionsController < ApplicationController
  def new
    @session = UserSession.new
  end

  def create
    @session = UserSession.new(params[:session])
    
    if @session.save
      redirect_to home_url
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
