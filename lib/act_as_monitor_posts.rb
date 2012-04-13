module ActAsMonitorPosts
  extend ActiveSupport::Concern
  include ActAsFetcher
  
  MONITOR_POSTS_INTERVAL_DAYS = 3
  
  module Worker
    @queue = "monitor_posts"
    
    def self.perform(user_id)
      user = User.find(user_id)
      if user && user.monitoring_posts
        user.monitor_posts rescue user.reset_posts_monitoring_state
        user.monitored_posts
      end
    end
  end
  
  module ClassMethods
    
    attr_accessor :queue
    
    def act_as_monitor_posts
      delegate :crawler, :to => :site
      scope :posts_monitoring, where(:posts_monitoring_state => nil).where("monitored_at < ? OR monitored_at is null", Time.now - MONITOR_POSTS_INTERVAL_DAYS.days).order("monitored_at ASC")
      init_state_monitoring_posts
    end
    
    protected
        
    def init_state_monitoring_posts
      state_machine :attribute => :posts_monitoring_state, :initial => :posts_monitor_idle do
        state :posts_monitor_idle, :value => nil
        state :posts_monitor_queuing
        state :posts_monitoring
        # state :posts_monitored, :value => :monitored
        
        event :reset_posts_monitoring_state do
          transition any => :posts_monitor_idle
        end
        event :async_monitoring_posting do
          transition [nil,:posts_monitor_idle] => :posts_monitor_queuing
        end
        event :monitoring_posts do
          transition :posts_monitor_queuing => :monitoring_posts
        end
        event :monitored_posts do
          transition :monitoring_posts => :posts_monitor_idle
        end
      end
    end
    
  end
  
  module InstanceMethods
    
    def async_monitor_posts
      if async_monitoring_posting
        Resque.enqueue(ActAsMonitorPosts::Worker, self.id) rescue reset_posts_monitoring_state
      end
    end
    
    def monitor_posts
      new_posts = []
      page = 1
      begin
        tmps = crawler.fetch_posts_by_user(self, page)
        if tmps
          new_posts.concat tmps
          self.monitored
        end
        page += 1
      end while tmps && tmps.size > 0
      new_posts
    end
    
    def monitored
      self.update_attributes(:monitored_at => Time.now)
    end
    
  end
end