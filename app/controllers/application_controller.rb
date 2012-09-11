class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authorize
  after_filter  :set_tasker_cookies

  protected

  def authorize
    login_user_id = session[:login_user_id]
    @page_title = "Welcome to Taskobserve"
    if login_user_id && @login_user = LoginUser.find_by_id(login_user_id)
    then
      @page_title = @page_title + ", #{@login_user.name}"
    # else
     # return redirect_to login_url, :notice => "Please Log in"
    end
    tasker_cookies = cookies[:tasker_cookies]
    if tasker_cookies && tasker_cookies != ''
      tasker_cookies = Marshal.load(tasker_cookies)
    end
    @tasker = Tasker.new(:cookies => tasker_cookies)
  end

  
  def set_tasker_cookies
    cookies[:tasker_cookies] = Marshal.dump(@tasker.cookies)
  end
    

end

