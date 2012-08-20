class SignupController < ApplicationController
  skip_before_filter :authorize

  def new
    url = 'https://railstest.tasker.ly/users/new.json'
    res = RestClient.get url, {:accept => :json}
    res = JSON.parse res
    @captcha = res["captcha"]
    @tmp_user = flash[:tmp_user] || {}
  end

  def create
    @tmp_user = params[:user]
    post_param = {"user" => @tmp_user}.to_json
    ret = RestClient.post("https://railstest.tasker.ly/users.json", post_param, :content_type => :json, :accept => :json) {|response| response}
    
    case ret.code
    when 200
      user = User.new(:name => @tmp_user["name"], :password => @tmp_user["password"])
      user.save
      session[:user_id] = user.id
      redirect_to root_url
    else
      error = JSON.parse(ret)
      flash[:tmp_user] = @tmp_user
      flash[:error] = error["errors"]
      redirect_to(:action => 'new')
    end
    #render(:text => post_param.to_json)

  end
end
