module ActAsUserChecker
  extend ActiveSupport::Concern
  CHECK_WITHIN_DAYS = 7
  
  module Worker
    @queue = "check_users"
    
    def self.perform(user_id)
      user = User.find(user_id)
      if user && user.checking_check_state
        user.check_is_enabled rescue user.reset_check_state
        user.checked_check_state
      end
    end
  end
  
  module ClassMethods
    def act_as_user_checker
      if !self.method_defined?(:crawler)
        delegate :crawler, :to => :site
      end
      
      if Rails.env != "test"
        after_create :async_check_is_enabled
      end
      
      scope :enabled_checking, where(:check_state => "idle").where('checked_at < ? OR checked_at is null', Time.now-CHECK_WITHIN_DAYS.days)
      scope :enabled_checking_by_avatar, where(:check_state => "idle", :avatar => nil, :is_enabled => true)
      
      init_check_state
    end
    
    protected
    def init_check_state
      state_machine :check_state, :initial => :idle, :namespace => :check_state do
        state :idle
        state :queuing
        state :checking
        
        event :reset do
          transition any => :idle
        end
        event :async_checking do
          transition [nil,:idle] => :queuing
        end
        event :checking do
          transition :queuing => :checking
        end
        event :checked do
          transition :checking => :idle
        end
      end
    end
  end
  
  module InstanceMethods
    def async_check_is_enabled
      if async_checking_check_state
        Resque.enqueue(ActAsUserChecker::Worker, self.id)
      end
    end
    
    def check_is_enabled
      if crawler.check_user_is_enabled(self)
        self.enable
      else
        self.disable
      end
      self.update_attributes(:checked_at => Time.now)
    end
  end
end