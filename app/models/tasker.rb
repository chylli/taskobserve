require "rest-client"
require "RMagick"
class Tasker
  attr_reader :cookies
  
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
  
  def initialize(args = {})
    @base_url = "https://inventory:3843054@#{Tasker_site}"
    @cookies = nil

    if args[:user] && args[:password]
      @base_url = "https://#{args[:user]}:#{args[:password]}@#{Tasker_site}"
    elsif args[:cookies] && args[:cookies] != ''
      @base_url = "https://#{Tasker_site}"
      @cookies = args[:cookies]
    end
  end
  
  def tasks(p=nil)
    url = @base_url + Workspace_path + "/tasks/current_tasks.json"
    ps = {:accept => :json}
    ps[:params] = p if p 
    ret = get url, ps
    tasks = JSON.parse(ret).map {|i| i["task"]}
    tasks = process_img_of_tasks(tasks)
  end
    

  def group_tags
    url = @base_url + Workspace_path + "/group_tags.json"
    ret = get url
    ret = JSON.parse(ret)
    group_tags = {}
    ret.each {|k| group_tags[k["group_tag"]["name"]] = k["group_tag"]["tags"].map {|t| t["name"]}}
    group_tags
  end

  def states
    States
  end

  def task(id)
    url = @base_url + "/tasks/#{id}.json"
    ret = get url
    ret = JSON.parse(ret)
    ret["task"]
  end


  def activities(filter = nil)
    workspace_path = Workspace_path
    if filter && filter[:type] == "task"
    then
      task = task(filter[:id])
      workspace_id = task['shared_tags'][0]['id']
      workspace_path = "/shared_tags/#{workspace_id}"
    end

    url = @base_url + workspace_path + '/activity_streams.json'
    
    if filter && filter[:type] == "user"
    then
      url = @base_url + "/users/#{filter[:id]}/activity_streams.json"
    end

    
    ps = {:accept => :json, :params => {:filter_by_date => :all}}

    ret = get url, ps
    ret = JSON.parse(ret)

    if filter
    then
      ret.select! {|x| x["description_with_meta"]["meta"][filter[:type]]["id"].to_s == filter[:id]  }
    end

    ret.each_index {|i| generate_link!(ret[i])}
    
    ret
                                    
  end

  # get image from assets
  def get_img(id,name)
    url = @base_url + "/assets/#{id}"
    new_name = "#{id}_#{name}"
    thumb_name = "thumb_#{new_name}"
    path = "app/assets/images/#{new_name}"
    thumb_path = "app/assets/images/#{thumb_name}"
    unless File.exists?(path)
      open(path,"wb") {|f| f << get(url)}
    end

    unless File.exists?(thumb_path)
      img =  Magick::Image.read(path).first      
      thumb = img.resize(100,100)
      thumb.write(thumb_path)
    end

    return {path: "/assets/#{new_name}", alt: name, thumb_path: "/assets/#{thumb_name}"}

  end


  def get_custom_fields(id)
    url = @base_url + "/tasks/#{id}/custom_field_values.json"
    ret = get url
    ret = JSON.parse(ret)
    fields = []
    ret.each do | f |
      f = f["custom_field_value"]
      fields << {f["custom_field"]["name"] => f["value"]}
    end
    fields

  end

  def users
    url = @base_url + "/users.json"
    ret = get url
    ret = JSON.parse(ret)
    ret = ret.map {|u| u["user"] }
  end
  
  def user(id)
    users = users()
    user = users.select {|u| u['id'] == id.to_i}
    user.first
    
  end
  
  def user_shared_tags(id)
    url = @base_url + "/users/#{id}/shared_tags.json"
    ret = get url
    ret = JSON.parse(ret)
    shared_tags = ret.map {|t| t['shared_tag']}
  end
  

  def user_tasks(id)
    url = @base_url + "/users/#{id}/tasks/current_tasks.json"
    ret = get url
    ret = JSON.parse(ret)
    tasks = ret.map {|t| t['task'] }
    tasks = process_img_of_tasks(tasks)
    
  end
  
  # return the array of images in attachments. if no images, return nil
  def get_task_imgs(task)
    assets = task["assets"] || []
    imgs = []

    assets.each do | t |
      if /^image/ === t["data_content_type"]
      then
        imgs << get_img(t["id"],t["data_file_name"])
      end
      
    end

    
    return imgs

  end

  private

  def get(*args)
    cookies_hash = {:cookies => @cookies}
    if args.last.instance_of? Hash
      args.last.merge!(cookies_hash)
    else
      args << cookies_hash
    end

    res = RestClient.get(*args)
    @cookies = res.cookies
    @base_url = "https://#{Tasker_site}"
    res
  end
    
  
  def generate_link!(activity)
    desc_meta = activity["description_with_meta"]
    desc_string = desc_meta["description"]
    meta = desc_meta["meta"]

    user_meta = meta["user"]
    user_string = "<a href=\"/activity/user/#{user_meta['id']}\" >#{user_meta['display_name']}</a>"
    task_meta = meta["task"]
    task_string = "<a href=\"/activity/task/#{task_meta['id']}\" >#{task_meta['description']}</a>"
    shared_tag_meta = meta["shared_tag"]
    to_user = meta["to_user"]
    to_user = "<a href=\"/activity/user/#{to_user['id']}\" >#{to_user['display_name']}</a>" if to_user
    user2 = meta["user2"]
    user2 = "<a href=\"/activity/user/#{user2['id']}\" >#{user2['display_name']}</a>" if user2
    
    
    desc_string.sub!('{user}',user_string)
    desc_string.sub!('{task}',task_string)
    desc_string.sub!('{shared_tag}', shared_tag_meta['name']) if shared_tag_meta
    desc_string.sub!('{to_user}', to_user) if to_user
    desc_string.sub!('{user2}', user2) if user2
    
    activity["description_with_link"] = desc_string

  end

  def process_img_of_tasks(tasks)
    tasks.each do |task|
      tmp = task["tags"].map {|x| x.values}
      tmp = tmp.join(", ")
      task["tags"] = tmp

      task["created_by"] = task["created_by"]["name"]

      task["user"] = task["user"]["name"]
      task[:detail] = task(task["id"])
      task[:imgs] = get_task_imgs(task[:detail])
      task[:imgs].sort! {|x,y| x[:alt] <=> y[:alt]} if task[:imgs]
    end

    tasks
    
  end
  

end
