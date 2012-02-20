module ActAsCrawler
  extend ActiveSupport::Concern
  
  include ActAsFetcher
  
  REGEXP_POSTS_PAGE_NUMBER = nil
  
  module ClassMethods
    def seed
      result = {}
      instance = self.new
      result[:site] = instance.seed_site
      result[:users_monitor_parser] = instance.seed_users_monitor_parser(result[:site])
      result[:users_monitor_urls] = instance.seed_users_monitor_urls(result[:users_monitor_parser])
      result
    end
  end
  module InstanceMethods
    
    def initialize site = nil
      @site = site 
    end
    
    def seed_site
      if !@site
        site_hash = Configs[:seed_sites][self.class.to_s.split("::").pop.underscore]
        @site = Site.find_by_domain(site_hash[:domain]) || Site.create(site_hash)
      end
      @site
    end
    
    def seed_users_monitor_parser site
      UsersMonitorParser.find_by_label(users_monitor_parser_hash[:label]) || UsersMonitorParser.create(users_monitor_parser_hash.merge(:site=>site))
    end
    
    def monitor_users
      new_users = []
      @site.users_monitor_urls.enabled.each do |users_monitor_url|
        patt = users_monitor_url.parser.to_regex
        fetch(users_monitor_url.url).scan(patt).each do |tmps|
          u = User.new_by_url(tmps[0],:name=>tmps[1], :site => users_monitor_url.site)
          if u && u.new_record?
            u.save
            new_users << u
          end
        end
        users_monitor_url.monitored
      end
      new_users
    end
    
    def fetch_posts_by_user user, page = 0
      new_posts = []
      content = fetch(url_posts(user, page))
      return nil if content.blank?
      parse_posts_from_posts_page(content).each do |post_hash|
        post = Post.new_by_user(user, post_hash)
        if post.save
          new_posts << post
        else  
          exists_post = Post.find_by_site_id_and_site_post_id(post.site_id,post.site_post_id)
          exists_post.update_attributes(post_hash)
        end
      end
      new_posts
    end
    
    def parse_posts_page_size content
      pages = [1]
      regexp = eval("#{self.class.to_s}::REGEXP_POSTS_PAGE_NUMBER")
      content.scan(regexp).each do |tmps|
        pages << tmps[0].to_i
      end
      pages.max
    end
    
    def check_user_is_enabled(user)
      res = self.fetch_status(url_posts(user)) == 200
      if Rails.env != "test" && !res # double check
        res = self.fetch_status(url_posts(user)) == 200 
      end
      res
    end
    
    def download_user_avatar(user)
      content = fetch(url_user(user))
      avatar_url = parse_user_avatar_url(content, user)
      if avatar_url
        data = download(avatar_url, download_options)
        if [304,200].include?data[:status]
          user.remote_avatar_url = data[:url]
          user.save
        end
      end
    end
    
    def url_posts user, page = 0
      raise "not implement"
    end
    
    def url_user user
      raise "not implement"
    end
    
    def parse_posts_from_posts_page content
      raise "not implement"
    end
    
    def parse_site_post_id_from_url url
      raise "not implement"
    end
    
    def parse_site_user_id_from_url url
      raise "not implement"
    end
    
    def seed_users_monitor_urls(parser)
      raise "not implement"
    end
    
    def parse_user_avatar_url content, user
      raise "not implement"
    end
    
    protected
    
    def users_monitor_parser_hash
      raise "not implement"
    end
    def download_options
      raise "not implement"
    end
  end
end