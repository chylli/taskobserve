class InventoryController < ApplicationController
  
  def show
    @value = if params[:tag_or_state] =~ /^task/ then "state" else "tag" end
  end

  def index
    @group_tags = Tasker.group_tags
    @states = Tasker.states
  end

  private
    
end
