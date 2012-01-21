module Search::Users
  extend ActiveSupport::Concern
  
  module ClassMethods
    def searchable
      paginates_per 100
      scope :search, lambda{ |opts| do_search(opts) }
    end
    
    def do_search opts = {}
      users = User.page(opts[:page])
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
      { :id => id, :site_user_id => site_user_id, :posts_count => posts_count || 0 }
    end
  end
end