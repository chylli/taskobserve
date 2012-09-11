class RootController < ApplicationController
  def index
    @group_tags = @tasker.group_tags
    @states = @tasker.states
    @activities = @tasker.activities
  end
end
