class LoginUser < ActiveRecord::Base
  attr_accessible :name, :password
end
