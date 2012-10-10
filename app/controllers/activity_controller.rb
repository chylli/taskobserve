# -*- coding: utf-8 -*-
class ActivityController < ApplicationController
  def index
    @title = 'Activity'
    @activities = @tasker.activities(:filter_by_date => params[:filter_by_date])
  end

  def show
    @activities = @tasker.activities(:type => params[:type], :id => params[:id])
    if @activities.length == 0
    then
      if params[:type] == 'user'
      then
        obj = @tasker.user(params[:id])
        @title = obj['display_name']
      elsif params[:type] == 'task'
      then
        obj = @tasker.task(params[:id])
        @title = obj['description']
      end
      
      
    elsif params[:type] == "user"
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
