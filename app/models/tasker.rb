require "rest-client"
class Tasker
  # attr_accessible :title, :body
  Tasker_site = "railstest.tasker.ly"
  Workspace_path = "/shared_tags/443"
  Group_tags = {
      "Color" => %w[Brown Black Red],
      "Length" => %w[Long Middle Short],
      "Style" => %w[Morden Classic Seventys Eightys],
      "Brand" => %w[Jon India],
      "Type" => %w[Synthetic Natural]
            }

  States = ["task request","task doing","task test","task finish"]

  def self.init(user,password)
    @@base_url = "https://#{user}:#{password}@#{Tasker_site}"
    puts @@base_url
  end

  def self.tasks(p=nil)
    url = @@base_url + Workspace_path + "/tasks/current_tasks.json"
    ps = {:accept => :json}
    ps[:params] = p if p 
    ret = RestClient.get url, ps
    JSON.parse(ret).map {|i| i["task"]}
  end
    
  def self.group_tags
    return Group_tags
  end

  def self.states
    States
  end


  def self.activities
    url = @@base_url + Workspace_path + '/activity_streams.json'
    ps = {:accept => :json, :params => {:filter_by_date => :all}}

    ret = RestClient.get url, ps
    JSON.parse(ret)


  end
  

end
