module ActAsCrawler
  extend ActiveSupport::Concern
  include ActAsFetcher
  module ClassMethods
  end
  module InstanceMethods
    def initialize site = nil
      @site = site 
    end
    def seed
      parser = seed_users_monitor_parser(seed_site)
      seed_users_monitor_urls(parser)
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