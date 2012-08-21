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

  def self.tasks
    url = @@base_url + Workspace_path + "/tasks.json"
    ret = RestClient.get url, {:accept => :json}
    JSON.parse(ret).map {|i| i["task"]}
  end
    
  def self.group_tags
    return Group_tags
  end

  def self.states
    States
  end


end
