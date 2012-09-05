class MembershipController < ApplicationController
  def index
    @users = Tasker.users
    @title = 'Membership'
  end

end
