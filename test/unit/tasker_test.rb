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

  # test "the truth" do
  #   assert true
  # end
end
