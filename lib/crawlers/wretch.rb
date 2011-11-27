# encoding : utf-8
class Crawlers::Wretch
  include ActAsCrawler
  
  # monitor post start
  def posts_urls_by_user user
    current_url = url_posts(user)
    content = fetch(current_url)
    hash = {current_url=>current_url}
    content.scan(/<span><a href="([^"]+)"/m).each do |tmps|
      hash[tmps[0]] = tmps[0] if tmps[0].index("list=1&page=")
    end
    hash.map{|url,tmp| url}
  end
  def url_posts user, options = {}
    "http://www.wretch.cc/blog/#{user.site_user_id}&list=1"+(options[:page] ? "&page=#{options[:page]}" : "")
  end
  def parse_posts_from_posts_page content
    posts = []
    content.scan(/<td nowrap>.*?([0-9\.]+).*?href="([^"]+)">(.+?)<\/a>/m).each do |tmps|
      date = tmps[0].gsub(".","-")
      url = "http://www.wretch.cc#{tmps[1]}"
      title = tmps[2]
      posts << {:date=>date,:url=>url,:title=>title}
    end
    posts
  end
  def parse_site_post_id_from_url url
    url.scan(/\/blog\/[^\/]+\/([0-9]+)/)[0][0] rescue nil
  end
  # monitor post end
  # monitor users start
  def parse_site_user_id_from_url url
    url.scan(/cc\/blog\/([^\/]+)/)[0][0].downcase rescue nil
  end
  # monitor users end
  protected
  def users_monitor_parser_hash
    {:label => "wretch-user_monitor",
     :regex => '/<h2><a .*? href="[^\*]+?\*([^"]+)">.*?<\/a>.*?<h4><a [^<]+?>(.*?)<\/a><em>/m'
    }
  end
  def seed_users_monitor_urls parser
    res = {}
    RestClient.get("http://www.wretch.cc/blog/").scan(/<td ><a href="[^"\*]+?\*([^"]+)">(.+?)<\/a>/).each do |tmps|
      reg_sub_urls = /<li ><a href="[^\*]+?\*([^"]+)">(.+?)<\/a>/
      url = tmps[0].gsub("&amp;","&")
      name = tmps[1]
      content = fetch(url)
      content.scan(reg_sub_urls).each do |sub_tmps|
        sub_url = sub_tmps[0].gsub("&amp;","&")
        sub_name = sub_tmps[1]
        res["#{name}-#{sub_name}"] = sub_url
      end
    end
    urls = []
    res.each do |label, url|
      urls << (UsersMonitorUrl.find_by_url(url) || UsersMonitorUrl.create(:url => url, :label => label, :parser => parser, :site_id => parser.site.id, :is_enabled=>true))
    end
    urls
  end
end