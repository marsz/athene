module ActAsHavingCrawler
  extend ActiveSupport::Concern
  
  CRAWLERS = Configs[:seed_sites].map{|name,tmps| "Crawlers::#{name.to_s.camelize}".constantize}
  
  module ClassMethods
    def find_by_url(url)
      Site.all.each do |site|
        return site if site.crawler.parse_site_user_id_from_url(url)
      end
    end
  end
  module InstanceMethods
    def crawler
      "Crawlers::#{self.domain.camelize}".constantize.new(self)
    end
  end
end