class InventoryController < ApplicationController
  
  def show
    p = params[:tag_or_state] 
    if p =~ /^task / 
    then 
      @tasks = get_tasks_filter_state(p)
      @title = "Tasks with state #{p}"
    else 
      @tasks = get_tasks_filter_tag(p)
      @title = "Tasks with tag #{p}"
    end

  end

  def index
    @group_tags = @tasker.group_tags
    @states = @tasker.states
  end

  def item
    id = params[:id][/^\d+/]
    begin
      @task = @tasker.task(id)
    rescue RestClient::Unauthorized
      flash[:notice] = "You have no privilege to visit this task!"
      render "/root/error"
      return
    end

    group_tags = @tasker.group_tags
    @tag_info = Hash.new {|hash,key| hash[key] = []}
    @task["tags"].each do |tag|
      tag = tag["name"]
      @tag_info["Others"] << tag
      group_tags.each do |group, tags|
        if tags.include?(tag)
        then
          @tag_info[group] << tag
          @tag_info["Others"].delete(tag)
          break
        end
      end
    end
    
    if @tag_info["Others"].length == 0
    then
      @tag_info.delete("Others")
    end

  
    @imgs = @tasker.get_task_imgs(@task)

    @title = "Task #{@task['id']}: #{@task['description']}"

    @fields = @tasker.get_custom_fields(@task['id'])

    if params[:modal]
      render :layout => false    
    end
  end


  private
  def get_tasks_filter_tag(tag)
    @tasker.tasks(:filter_by_tags => tag)
  end

  def get_tasks_filter_state(state)
    tasks = @tasker.tasks()
    @tasks = tasks.select do |x|
      x["workflow_state_name"] == state
    end
  end



end
