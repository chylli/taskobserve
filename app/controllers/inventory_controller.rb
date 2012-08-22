class InventoryController < ApplicationController
  
  def show
    if params[:tag_or_state] =~ /^task/ 
    then 
      @tasks = get_tasks_filter_state(params[:tag_or_state])
    else 
      @tasks = get_tasks_filter_tag(params[:tag_or_state])
    end

  end

  def index
    @group_tags = Tasker.group_tags
    @states = Tasker.states
  end

  private
  def get_tasks_filter_tag(tag)
    Tasker.tasks(:filter_by_tags => tag)
  end

  def get_tasks_filter_state(state)
    tasks = Tasker.tasks()
    @tasks = tasks.select do |x|
      x["workflow_state_name"] == state
    end
  end

end
