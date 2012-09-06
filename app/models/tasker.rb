require "rest-client"
require "RMagick"
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
  @@base_url = "https://inventory:3843054@#{Tasker_site}"


  # called only when the update priviledge needed
  def self.init(user,password)
    @@base_url = "https://#{user}:#{password}@#{Tasker_site}"
  end

  def self.tasks(p=nil)
    url = @@base_url + Workspace_path + "/tasks/current_tasks.json"
    ps = {:accept => :json}
    ps[:params] = p if p 
    ret = RestClient.get url, ps
    tasks = JSON.parse(ret).map {|i| i["task"]}
    tasks = self.process_img_of_tasks(tasks)
  end
    

  def self.group_tags
    url = @@base_url + Workspace_path + "/group_tags.json"
    ret = RestClient.get url
    ret = JSON.parse(ret)
    group_tags = {}
    ret.each {|k| group_tags[k["group_tag"]["name"]] = k["group_tag"]["tags"].map {|t| t["name"]}}
    group_tags
  end

  def self.states
    States
  end

  def self.task(id)
    url = @@base_url + "/tasks/#{id}.json"
    ret = RestClient.get url
    ret = JSON.parse(ret)
    ret["task"]
  end


  def self.activities(filter = nil)
    url = @@base_url + Workspace_path + '/activity_streams.json'
    ps = {:accept => :json, :params => {:filter_by_date => :all}}

    ret = RestClient.get url, ps
    ret = JSON.parse(ret)

    if filter
    then
      ret.select! {|x| x["description_with_meta"]["meta"][filter[:type]]["id"].to_s == filter[:id]  }
    end

    ret.each_index {|i| generate_link!(ret[i])}
    
    ret
                                    
  end

  # get image from assets
  def self.get_img(id,name)
    url = @@base_url + "/assets/#{id}"
    new_name = "#{id}_#{name}"
    thumb_name = "thumb_#{new_name}"
    path = "app/assets/images/#{new_name}"
    thumb_path = "app/assets/images/#{thumb_name}"
    unless File.exists?(path)
      open(path,"wb") {|f| f << RestClient.get(url)}
    end

    unless File.exists?(thumb_path)
      img =  Magick::Image.read(path).first      
      thumb = img.resize(100,100)
      thumb.write(thumb_path)
    end

    return {path: "/assets/#{new_name}", alt: name, thumb_path: "/assets/#{thumb_name}"}

  end


  def self.get_custom_fields(id)
    url = @@base_url + "/tasks/#{id}/custom_field_values.json"
    ret = RestClient.get url
    ret = JSON.parse(ret)
    fields = []
    ret.each do | f |
      f = f["custom_field_value"]
      fields << {f["custom_field"]["name"] => f["value"]}
    end
    fields

  end

  def self.users
    url = @@base_url + "/users.json"
    ret = RestClient.get url
    ret = JSON.parse(ret)
    ret = ret.map {|u| u["user"] }
  end
  
  def self.user(id)
    users = self.users()
    user = users.select {|u| u['id'] == id.to_i}
    user.first
    
  end
  
  def self.user_shared_tags(id)
    url = @@base_url + "/users/#{id}/shared_tags.json"
    ret = RestClient.get url
    ret = JSON.parse(ret)
    shared_tags = ret.map {|t| t['shared_tag']}
  end
  

  def self.user_tasks(id)
    url = @@base_url + "/users/#{id}/tasks/current_tasks.json"
    ret = RestClient.get url
    ret = JSON.parse(ret)
    tasks = ret.map {|t| t['task'] }
    tasks = self.process_img_of_tasks(tasks)
    
  end
  
  # return the array of images in attachments. if no images, return nil
  def self.get_task_imgs(task)
    assets = task["assets"] || []
    imgs = []

    assets.each do | t |
      if /^image/ === t["data_content_type"]
      then
        imgs << Tasker.get_img(t["id"],t["data_file_name"])
      end
      
    end

    
    return imgs

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

  def self.process_img_of_tasks(tasks)
    tasks.each do |task|
      tmp = task["tags"].map {|x| x.values}
      tmp = tmp.join(", ")
      task["tags"] = tmp

      task["created_by"] = task["created_by"]["name"]

      task["user"] = task["user"]["name"]
      task[:detail] = self.task(task["id"])
      task[:imgs] = get_task_imgs(task[:detail])
      task[:imgs].sort! {|x,y| x[:alt] <=> y[:alt]} if task[:imgs]
    end

    tasks
    
  end
  

end
