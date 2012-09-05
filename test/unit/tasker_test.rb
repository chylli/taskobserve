require 'test_helper'

class TaskerTest < ActiveSupport::TestCase
  TaskId = 320808
  
  test "tasks" do
    tasks = Tasker.tasks
    assert tasks.length > 0
  end

  test "task" do
    task = Tasker.task(TaskId)
    assert task["id"] == TaskId

  end


  test "get custom fields" do
    fields = Tasker.get_custom_fields(TaskId)
    field_names = fields.map {|f| f.keys.first}
    assert field_names.include?("Price")
  end

  test "get users" do
    users = Tasker.users
    assert users.length > 0
  end

  # test "the truth" do
  #   assert true
  # end
end
