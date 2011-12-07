module ActAsCrawler
  extend ActiveSupport::Concern
  include ActAsFetcher
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
    
    def posts_urls_by_user user
      raise "not implement"
    end
    def url_posts user, options = {}
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
    
    protected
    def site_hash
      raise "not implement"
    end
    def users_monitor_parser_hash
      raise "not implement"
    end
    def seed_users_monitor_urls(parser)
      raise "not implement"
    end
  end
end