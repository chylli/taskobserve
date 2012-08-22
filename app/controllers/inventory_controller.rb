class InventoryController < ApplicationController
  
  def show
    @tasks = if params[:tag_or_state] =~ /^task/ then :state else get_tasks_filter_tag(params[:tag_or_state]) end

  end

  def index
    @group_tags = Tasker.group_tags
    @states = Tasker.states
  end

  private
  def get_tasks_filter_tag(tag)
    Tasker.tasks(:filter_by_tags => tag)
  end
end
