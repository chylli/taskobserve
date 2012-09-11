require 'tasker'
require 'benchmark'
require 'json'

n=20

tasker = Tasker.new

Benchmark.bm do |x|
  x.report('usersn') {n.times { tasker.users } }
  x.report('user1801_shared_tags') {n.times {tasker.user_shared_tags(1801)}}
  x.report('current_tasks') {n.times {tasker.user_tasks(1801)}}
  x.report('task320808') {n.times {tasker.task(320808)}}
  x.report('task330777') {n.times {tasker.task(330777)}}
  x.report('task338980') {n.times {tasker.task(338980)}}
  x.report('user1801_activity') {n.times {tasker.activities(:type => 'user', :id => '1801')}}
end
