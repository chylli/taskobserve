require 'tasker'
require 'benchmark'

n=20

tasker = Tasker.new

Benchmark.bm do |x|
  x.report('users.json') {n.times { tasker.users } }
  x.report('user 1801') {n.times {tasker.user(1801)}}
  x.report('current_tasks') {n.times {tasker.user_tasks(1801)}}
  x.report('task 320808') {n.times {tasker.task(320808)}}
  x.report('task 330777') {n.times {tasker.task(330777)}}
  x.report('task 338980') {n.times {tasker.task(338980)}}
  x.report('user 1801 activity') {n.times {tasker.activities(:type => 'user', :id => '1801')}}
end
