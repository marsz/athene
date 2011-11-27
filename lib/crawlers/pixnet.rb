# encoding : utf-8
class Crawlers::Pixnet
  include ActAsCrawler
  
  # monitor post start
  def posts_urls_by_user user
    urls = []
    current_url = url_posts(user)
    urls << current_url
    content = fetch(current_url)
    content = content.scan(/<div class="page">(.+?)<\/div>/m)[0][0] rescue content
    total = content.scan(/\/blog\/listall\/([0-9]+)/m).map{|tmps| tmps[0].to_i}.max.to_i
    if total > 1
      (2..total).map.each do |page|
        urls << url_posts(user,:page=>page)
      end
    end
    urls
  end
  def url_posts user, options = {}
    domain = user.site_user_id.index(".") ? user.site_user_id : "#{user.site_user_id}.pixnet.net"
    "http://#{domain}/blog/listall/"+(options[:page] ? options[:page].to_s : "")
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
  def parse_site_user_id_from_url url
    url.scan(/http:\/\/([^\.]+).pixnet.net/)[0][0] rescue (url.scan(/http:\/\/([^\/]+)/)[0][0] rescue nil)
  end
  # monitor users end
  protected
  def users_monitor_parser_hash
    {:label => "pixnet-user_monitor",
     :regex => '/<li class="grid\-author"><a href="([^"]+)" target="_blank">(.+?)<\/a>/m'
    }
  end
  def seed_users_monitor_urls parser
    res = {}
    RestClient.get("http://www.pixnet.net/blog").scan(/<li class="article\-list\-menu" id="article\-list\-menu\-[0-9]+"><a href="([^"]+)">(.+?)<\/a><\/li>/m).each do |tmps|
      url = tmps[0].gsub("&amp;","&")
      url = "http://www.pixnet.net#{url}" if !url.index("http://")
      name = tmps[1]
      sub_contents = fetch(url).scan(/<ul class="menu\-2">(.*?)<\/ul>/m)
      if sub_contents.size > 0 
        content = sub_contents[0][0]
        reg_sub_urls = /<li><a href="([^"]+)">(.+?)<\/a>/m
        content.scan(reg_sub_urls).each do |sub_tmps|
          sub_url = sub_tmps[0].gsub("&amp;","&")
          sub_url = "http://www.pixnet.net#{sub_url}" if !sub_url.index("http://")
          sub_name = sub_tmps[1]
          res["#{name}-#{sub_name}"] = sub_url
        end
      end
    end
    urls = []
    res.each do |label, url|
      urls << (UsersMonitorUrl.find_by_url(url) || UsersMonitorUrl.create(:url => url, :label => label, :parser => parser, :site_id => parser.site.id, :is_enabled=>true))
    end
    urls
  end
end