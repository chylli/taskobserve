class InventoryController < ApplicationController
  
  def show
    p = params[:tag_or_state] 
    if p =~ /^task/ 
    then 
      @tasks = get_tasks_filter_state(p)
      @title = "Tasks with state #{p}"
    else 
      @tasks = get_tasks_filter_tag(p)
      @title = "Tasks with tag #{p}"
    end

    @tasks.each do |t|
      tmp = t["tags"].map {|x| x.values}
      tmp = tmp.join(", ")
      t["tags"] = tmp

      t["created_by"] = t["created_by"]["name"]

      t["user"] = t["user"]["name"]

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
