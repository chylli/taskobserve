require 'test_helper'

class TaskerTest < ActiveSupport::TestCase
  TaskId = 320808

  def setup
    @tasker = Tasker.new()
  end
  test "tasks" do
    tasks = @tasker.tasks
    assert tasks.length > 0
  end

  test "task" do
    task = @tasker.task(TaskId)
    assert task["id"] == TaskId

  end


  test "get custom fields" do
    fields = @tasker.get_custom_fields(TaskId)
    field_names = fields.map {|f| f.keys.first}
    assert field_names.include?("Price")
  end

  test "get users" do
    users = @tasker.users
    assert users.length > 0
  end

  # test "the truth" do
  #   assert true
  # end
end
