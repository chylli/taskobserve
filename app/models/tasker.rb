require "rest-client"
class Tasker
  # attr_accessible :title, :body
  Tasker_site = "railstest.tasker.ly"
  Workspace_path = "/shared_tags/443"
  Workspace_name = "task_workspace"
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
    ret = JSON.parse(ret)
    ret.each_index {|i| generate_link!(ret[i])}
    puts ret
    
    ret
                                    
  end

  private

  def self.generate_link!(activity)
    desc_meta = activity["description_with_meta"]
    desc_string = desc_meta["description"]
    meta = desc_meta["meta"]

    user_meta = meta["user"]
    user_string = "<a href=\"/activity/user/#{user_meta['id']}\">#{user_meta['display_name']}</a>"
    task_meta = meta["task"]
    task_string = "<a href=\"/activity/task/#{task_meta['id']}\">#{task_meta['description']}</a>"
    shared_tag_meta = meta["shared_tag"]

    desc_string.sub!('{user}',user_string)
    desc_string.sub!('{task}',task_string)
    desc_string.sub!('{shared_tag}', Workspace_name)
    activity["description_with_link"] = desc_string

  end

  

end
