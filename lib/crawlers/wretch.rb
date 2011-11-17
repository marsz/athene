# encoding : utf-8
class Crawlers::Wretch < Crawlers
  def posts_urls_by_user user
    current_url = url_posts(user)
    content = fetch(current_url)
    hash = {current_url=>current_url}
    content.scan(/<span><a href="([^"]+)"/m).each do |tmps|
      hash[tmps[0]] = tmps[0] if tmps[0].index("list=1&page=")
    end
    hash.map{|url,tmp| url}
  end
  def new_post user, options
    if options[:hash]
      post = user.posts.build(options[:hash])
      post.site_post_id = parse_site_post_id_from_url(post.url)
      post.site = seed_site
      post
    end
  end
  def monitor_all_users_posts
    seed_site.users.each do |user|
      # TODO check last monitored
      fetch_all_posts_by_user(user)
    end
  end
  def fetch_all_posts_by_user user
    posts = []
    posts_by_user(user).each do |post_hash|
      post = new_post(user, :hash=>post_hash)
      if !post.save
        post = Post.find_by_site_id_and_site_post_id(post.site_id,post.site_post_id)
        post.update_attributes(post_hash)
      end
      posts << post
    end
    posts
  end
  def posts_by_user user
    posts = []
    posts_urls_by_user(user).each do |url|
      content = fetch(url)
      posts.concat(parse_posts_from_posts_page(content))
    end
    posts
  end
  def url_posts user, options = {}
    "http://www.wretch.cc/blog/#{user.site_user_id}&list=1"+(options[:page] ? "&page=#{options[:page]}" : "")
  end
  def seed
    seed_users_monitor_urls
  end
  def seed_users_monitor_parser site
    label = "wretch-user_monitor"
    regex = '/<h2><a .*? href="[^\*]+?\*([^"]+)">.*?<\/a>.*?<h4><a [^<]+?>(.*?)<\/a><em>/m'
    UsersMonitorParser.find_by_label(label) || UsersMonitorParser.create(:label=>label,:regex => regex, :site => site)
  end
  def seed_users_monitor_urls
    if wretch = seed_site
      parser = seed_users_monitor_parser(wretch)
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
        urls << (UsersMonitorUrl.find_by_url(url) || UsersMonitorUrl.create(:url => url, :label => label, :parser => parser, :site_id => wretch.id, :is_enabled=>true))
      end
      urls
    end
  end
  def seed_site
    if !@site
      @site = Site.find_by_domain("wretch") || Site.create({:name => "無名小站", :domain => :wretch, :url => "http://www.wretch.cc"})
    end
    @site
  end
  def new_user options
    if options[:url]
      site_user_id = parse_site_user_id_from_url(options[:url])
      site = seed_site
      user = User.find_by_site_user_id_and_site_id(site_user_id, site.id) || User.new(:site_id=>site.id,:site_user_id=>site_user_id,:name=>options[:name])
    end
  end
  def monitor_users
    users_monitor_urls.each do |users_monitor_url|
      patt = users_monitor_url.parser.to_regex
      fetch(users_monitor_url.url).scan(patt).each do |tmps|
        u = new_user(:url=>tmps[0],:name=>tmps[1])
        u.save if u.new_record?
      end
      users_monitor_url.monitored
    end
  end
  protected
  def parse_site_post_id_from_url url
    url.scan(/\/blog\/[^\/]+\/([0-9]+)/)[0][0] rescue nil
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
  def parse_site_user_id_from_url url
    url.scan(/cc\/blog\/([^\/]+)/)[0][0]
  end
  def users_monitor_urls
    seed_site.users_monitor_urls.enabled
  end
end