module ActAsMonitorPosts
  extend ActiveSupport::Concern
  include ActAsFetcher
  
  module ClassMethods
    def act_as_monitor_posts
      delegate :crawler, :to => :site
      scope :posts_monitoring, where("monitored_at < ? OR monitored_at is null", Time.now-24.hours).order("monitored_at ASC")
    end
  end
  
  module InstanceMethods
    def monitor_posts
      new_posts = []
      page = 1
      begin
        tmps = crawler.fetch_posts_by_user(self, page)
        new_posts.concat tmps
      end while tmps.size > 0
      if self.monitored
        new_posts
      else
        puts errors.full_messages.inspect
        nil
      end
    end
    
    def monitored
      self.update_attributes(:monitored_at => Time.now)
    end
    
  end
end