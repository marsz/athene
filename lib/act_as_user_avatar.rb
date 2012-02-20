module ActAsUserAvatar
  extend ActiveSupport::Concern
  
  module ClassMethods
    def act_as_user_avatar
      mount_uploader :avatar, UserAvatarUploader
      if !self.method_defined?(:crawler)
        delegate :crawler, :to => :site
      end
      scope :no_avatar, where(:avatar => nil)
    end
  end
  
  module InstanceMethods
    def download_avatar
      crawler.download_user_avatar self
    end
  end
end