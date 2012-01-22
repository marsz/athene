module ActAsHavingCrawler
  extend ActiveSupport::Concern
  
  CRAWLERS = Configs[:seed_sites].map{|name,tmps| "Crawlers::#{name.to_s.camelize}".constantize}
  delegate :monitor_users, :to => :crawler
  
  module ClassMethods
    def find_by_url(url)
      Site.all.each do |site|
        return site if site.crawler && site.crawler.parse_site_user_id_from_url(url)
      end
      nil
    end
  end
  module InstanceMethods
    def crawler
      begin
        "Crawlers::#{self.domain.camelize}".constantize.new(self)
      rescue NameError
        nil
      end
    end
  end
end