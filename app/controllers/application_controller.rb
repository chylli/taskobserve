class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authorize

  protected

  def authorize
    if session[:user_id]
    then
      render(:text => "Welcome #{session[:user_id]}")
    else
      redirect_to login_url, :notice => "Please Log in"
    end
    
    
  end


end
