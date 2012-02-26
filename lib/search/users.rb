module Search::Users
  extend ActiveSupport::Concern
  
  include Search::Base
  
  module ClassMethods
    
    protected
    
    def do_search_scoped opts = {}
      paginates_per 100
      User.page(opts[:page])
    end
    
    def do_search_by opts = {}
      users = User.scoped
      if opts[:site]
        site = Site.find_by_domain(opts[:site].to_s.downcase)
        users = users.where(:site_id => site ? site.id : 0)
        if opts[:user]
          user = User.find_by_site_user_id(opts[:user])
          users = users.where(:id => user ? user.id : 0)
        end
      end
      users
    end
  end

  module InstanceMethods
    def to_api_hash
      hash = { :id => id, :site_user_id => site_user_id, :posts_count => posts_count || 0}
      if avatar.url
        hash[:avatar] = {
          :origin => avatar.url,
          :thumb => avatar.thumb.url,
          :medium_pad => avatar.medium_pad.url,
          :medium => avatar.medium.url
        }        
      end
      hash
    end
  end
end