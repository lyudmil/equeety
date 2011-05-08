class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :current_user
  
  private
  
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
  
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end
  
  def require_user
    unless current_user
      store_location
      redirect_to login_path, :notice => "You must be logged in to access this page"
      return false
    end
  end
  
  def require_no_user
    if current_user
      redirect_to root_path, :notice => "You must be logged out to access this page"
      return false
    end
  end
  
  def require_user_access_to_deal key_in_params = :id
    @deal = Deal.find(params[key_in_params])
    unless current_user.can_view? @deal
      redirect_to deals_path, :notice => "You don't have access to this deal."
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end
end
