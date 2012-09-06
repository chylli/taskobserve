class RenameUsersToLoginUsers < ActiveRecord::Migration
  def change
    rename_table :users, :login_users
  end
end
