class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authorize

  protected

  def authorize
    user_id = session[:user_id]
    unless user_id && @user = User.find_by_id(user_id)
      return redirect_to login_url, :notice => "Please Log in"
    end

  end


end
