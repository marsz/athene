module ActAsUserChecker
  extend ActiveSupport::Concern
  
  module ClassMethods
    def act_as_user_checker
      if !self.method_defined?(:crawler)
        delegate :crawler, :to => :site
      end
      scope :enabled_checking, where('checked_at < ? OR checked_at is null', Time.now-3.days)
    end
  end
  
  module InstanceMethods
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