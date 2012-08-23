class RootController < ApplicationController
  def index
    @group_tags = Tasker.group_tags
    @states = Tasker.states
    @activities = Tasker.activities
  end
end
