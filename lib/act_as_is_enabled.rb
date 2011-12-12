module ActAsIsEnabled
  extend ActiveSupport::Concern
  
  module ClassMethods
    def act_as_is_enabled
      scope :enabled, where(:is_enabled => true)
    end
  end
  
  module InstanceMethods
    
    def enabled?
      is_enabled
    end
    
    def enable
      update_attributes :is_enabled => true
    end
    
    def disable
      update_attributes :is_enabled => false
    end
    
  end
  
end