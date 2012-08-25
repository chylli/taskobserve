class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authorize

  TASK_SITE = Taskobserve::Application.config.tasker_site


  protected

  def authorize
    user_id = session[:user_id]
    @page_title = "Welcome to Taskobserve"
    if user_id && @user = User.find_by_id(user_id)
    then
      #Tasker.init(@user.name,@user.password)
      @page_title = @page_title + ", #{@user.name}"
    # else
     # return redirect_to login_url, :notice => "Please Log in"
    end

  end


end
