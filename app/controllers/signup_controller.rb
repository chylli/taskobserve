class SignupController < ApplicationController
  skip_before_filter :authorize

  def new
    url = 'https://railstest.tasker.ly/users/new.json'
    res = RestClient.get url, {:accept => :json}
    res = JSON.parse res
    @captcha = res["captcha"]
    puts "x" * 80
    puts @captcha

  end

  def create
    user = {}
    user["name"] = params[:name]
    user["login"] = params[:login]
    user["email"] = params[:email]
    user["password"] = params[:password]
    user["password_confirmation"] = params[:password_confirmation]
    post_param = {"user" => user}
    puts post_param.to_json
    ret = RestClient.post "https://railstest.tasker.ly/users.json", post_param.to_json, :content_type => :json, :accept => :json
    render(:text => JSON.parse(ret))
    #render(:text => post_param.to_json)

  end
end
