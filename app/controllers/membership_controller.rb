class MembershipController < ApplicationController
  def index
    @users = @tasker.users
    @title = 'Membership'
  end

  def show
    id = params[:id]
    @user = @tasker.user(id)
    @title = "#{@user['display_name']}'s information"
    # @shared_tags = @tasker.user_shared_tags(id)
    # @tasks = @tasker.user_tasks(id)
    # @activities = @tasker.activities(:type => 'user', :id => id)
  end

  def shared_tags
    @shared_tags = @tasker.user_shared_tags(params[:id])
    render :layout => false
  end
  
  def tasks
    @tasks = @tasker.user_tasks(params[:id])
    render 'inventory/_show',:layout => false
  end
  
  def activities
    @activities = @tasker.activities(:type => 'user', :id => params[:id], :filter_by_date => params[:filter_by_date])
    render 'activity/_index',:layout => false
  end
  
end
