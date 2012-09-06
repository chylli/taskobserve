class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authorize

  protected

  def authorize
    login_user_id = session[:login_user_id]
    @page_title = "Welcome to Taskobserve"
    if login_user_id && @login_user = LoginUser.find_by_id(login_user_id)
    then
      #Tasker.init(@user.name,@user.password)
      @page_title = @page_title + ", #{@login_user.name}"
    # else
     # return redirect_to login_url, :notice => "Please Log in"
    end

  end


end
