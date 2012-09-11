class MembershipController < ApplicationController
  def index
    @users = @tasker.users
    @title = 'Membership'
  end

  def show
    id = params[:id]
    @user = @tasker.user(id)
    @title = "#{@user['display_name']}'s information"
    @shared_tags = @tasker.user_shared_tags(id)
    @tasks = @tasker.user_tasks(id)
    @activities = @tasker.activities(:type => 'user', :id => id)
  end
  
end
