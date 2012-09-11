require 'test_helper'
require 'rails/performance_test_help'

class BrowsingTest < ActionDispatch::PerformanceTest
  # Refer to the documentation for all available options
  self.profile_options = { :runs => 20, :metrics => [:wall_time, :memory]
                           :output => 'tmp/performance', :formats => [:flat] }

  def test_membership_user
    get '/membership/1801'
  end
end
