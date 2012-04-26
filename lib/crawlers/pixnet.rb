# encoding : utf-8
class Crawlers::Pixnet
  include ActAsCrawler
  
  REGEXP_POSTS_PAGE_NUMBER = /<a href=".+?blog\/listall\/([0-9]+)" class="">/m
  
  # monitor post start
  
  def url_posts user, page = 0
    domain = user.site_user_id.index(".") ? user.site_user_id : "#{user.site_user_id}.pixnet.net"
    "http://#{domain}/blog/listall"+(page > 0 ? "/#{page}" : "")
  end
  def parse_posts_from_posts_page content
    posts = []
    content.scan(/<td class="list\-date">(.+?)<\/td>.+?<td class="list\-title">.+?<a href="([^"]+)">(.+?)<\/a>/m).each do |tmps|
      date = tmps[0]
      url = tmps[1]
      title = tmps[2]
      posts << {:date=>date,:url=>url,:title=>title}
    end
    posts
  end
  def parse_site_post_id_from_url url
    url.scan(/blog\/post\/([0-9]+)/)[0][0] rescue nil
  end
  # monitor post end
  # monitor users start
  def parse_site_user_id_from_url(url)
    rules = [/http:\/\/([^\.]+).pixnet.net/, /\/blog\/profile\/([^\/]+)/, /http:\/\/([^\/]+)/]
    rules.each do |rule|
      tmps = url.scan(rule)
      return tmps[0][0] if tmps.size > 0
    end
    nil
  end
  # monitor users end
  
  def seed_users_monitor_urls parser
    res = {}
    content = RestClient.get("http://www.pixnet.net/blog")
    content.scan(/<a href="\/blog\/articles\/group\/[0-9]+">(.+?)<\/a>.*?<ul>(.+?)<\/ul>/m).each do |tmps|
      name = tmps[0]
      sub_content = tmps[1]
      sub_content.scan(/<li><a href="\/blog\/([^"]+)">(.+?)<\/a><\/li>/m).each do |tmps|
        url = "/blog/"+tmps[0].gsub("&amp;","&")
        url = "http://www.pixnet.net#{url}" if !url.index("http://")
        sub_name = tmps[1]
        res["#{name}-#{sub_name}"] = url
      end
    end
    urls = []
    res.each do |label, url|
      urls << (UsersMonitorUrl.find_by_url(url) || UsersMonitorUrl.create(:url => url, :label => label, :parser => parser, :site_id => parser.site.id, :is_enabled=>true))
    end
    urls
  end

  def url_user user
    "http://#{user.site_user_id}.pixne.net/blog"
  end
  def parse_user_avatar_url content, user
    "http://s1.pimg.tw/avatar/#{user.site_user_id}/0/0/zoomcrop/300x300.jpg"
    # tmps = content.scan /<a class="user\-img" .*?<img src="([^\?"]+)/m
    # if tmps.size > 0
    #   url = tmps[0][0].gsub("90x90.","300x300.")
    # end
    # url || nil
  end
    
  protected
  
  def users_monitor_parser_hash
    {:label => "pixnet-user_monitor",
     :regex => '/<a href="([^"]+)" class="author"><img[^>]+>(.+?)<\/a>/m'
    }
  end
  def download_options
    { :referer => "www.pixnet.net" }
  end

end