require 'rest-client'
require 'json'

class LogonController < ApplicationController
  skip_before_filter :authorize

  def new
  end

  def create

    user_name = params[:user_name]
    password = params[:password]
    ret = RestClient.post "https://tasker.ly/session.json", :login => user_name, :password =>  password

    ret = JSON.parse(ret)
    if ret["errors"] 
    then
      redirect_to login_url, :status => 303, :notice => ret["errors"][0]
      #render(:text => "failed")
    else
      render(:text => "#{user_name} #{password}")
      
    end
    

  end

  def destroy
  end
end
