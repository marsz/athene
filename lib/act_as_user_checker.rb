module ActAsUserChecker
  extend ActiveSupport::Concern
  
  module ClassMethods
    def act_as_user_checker
      if !self.method_defined?(:crawler)
        delegate :crawler, :to => :site
      end
    end
  end
  
  module InstanceMethods
    def check_is_enabled
      if crawler.check_user_is_enabled(self)
        self.enable
      else
        self.disable
      end
    end
  end
end