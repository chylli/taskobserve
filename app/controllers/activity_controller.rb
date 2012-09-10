# -*- coding: utf-8 -*-
class ActivityController < ApplicationController
  def index
    @title = 'Activity'
    @activities = Tasker.activities
  end

  def show
    @activities = Tasker.activities(:type => params[:type], :id => params[:id])
    if params[:type] == "user"
    then
      @title = @activities[0]['description_with_meta']['meta']['user']['display_name']
    elsif params[:type] == "task"
    then
      @title = @activities[0]['description_with_meta']['meta']['task']['description']
    end
    @title2 = "#{params[:type]} <em>#{@title}</em> activity"
    @title = "#{params[:type]} #{@title} activity"

    if params[:modal]
      render :layout => false
    end
  end

end
