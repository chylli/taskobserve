class ActivityController < ApplicationController
  def index
    @activities = Tasker.activities
  end

  def show

    @activities = Tasker.activities(:type => params[:type], :id => params[:id])
  end

end
