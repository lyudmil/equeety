class UserSessionController < ApplicationController
  def new
    @session = UserSession.new
  end

  def create
    @session = UserSession.new(params[:session])
    
    if @session.save
      redirect_to :controller => 'static_pages', :action => 'home'
    else
      render :action => 'new'
    end
  end

  def destroy
    @session = UserSession.find
    @session.destroy
    
    redirect_to :controller => 'static_pages', :action => 'home'
  end
end
