class ActivityController < ApplicationController
  def index
    @activities = Tasker.activities
  end
end
