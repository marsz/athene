module ActAsIsEnabled
  extend ActiveSupport::Concern
  
  module ClassMethods
    def act_as_is_enabled
      scope :enabled, where(:is_enabled => true)
      scope :disabled, where("is_enabled is null OR is_enabled = 0")
    end
  end
  
  module InstanceMethods
    
    def enabled?
      is_enabled
    end
    
    def disabled?
      !is_enabled
    end
    
    def enable
      update_attributes :is_enabled => true
    end
    
    def disable
      update_attributes :is_enabled => false
    end
    
  end
  
end