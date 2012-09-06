class MembershipController < ApplicationController
  def index
    @users = Tasker.users
    @title = 'Membership'
  end

  def show
    id = params[:id]
    @user = Tasker.user(id)
    @title = "#{@user['display_name']}'s information"
    @shared_tags = Tasker.user_shared_tags(id)
    @tasks = Tasker.user_tasks(id)
    @activities = Tasker.activities(:type => 'user', :id => id)
  end
  
end
