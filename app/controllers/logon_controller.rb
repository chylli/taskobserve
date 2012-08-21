require 'rest-client'
require 'json'

class LogonController < ApplicationController
  skip_before_filter :authorize, :only => [:new, :create]

  def new
  end

  def create

    user_name = params[:user_name]
    password = params[:password]
    ret = RestClient.post "https://#{TASK_SITE}/session.json", :login => user_name, :password =>  password

    ret = JSON.parse(ret)
    if ret["errors"] 
    then
      return redirect_to login_url, :status => 303, :notice => ret["errors"][0]
      #render(:text => "failed")
    end

    user = User.new(:name => user_name, :password => password)
    user.save
    session[:user_id] = user.id
    redirect_to root_url



    

  end

  def destroy
    @user.delete
    redirect_to root_url
  end
end
