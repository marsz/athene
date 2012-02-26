module Search::Posts
  extend ActiveSupport::Concern
  
  include Search::Base
  
  module ClassMethods
    
    protected
    
    def do_search_scoped opts = {}
      paginates_per 50
      includes([:user,:site]).page(opts[:page]).order("date DESC") 
    end
    def do_search_by opts = {}
      posts = Post.scoped
      if opts[:q]
        posts = posts.where("title LIKE ?", "%#{opts[:q]}%")
      end
      if opts[:site]
        site = Site.find_by_domain(opts[:site].to_s.downcase)
        posts = posts.where(:site_id => site ? site.id : 0)
        if opts[:post]
          posts = posts.where(:site_post_id => opts[:post])
        end
        if opts[:user]
          user = User.find_by_site_user_id(opts[:user])
          posts = posts.where(:user_id => user ? user.id : 0)
        end
      end
      posts
    end
  end

  module InstanceMethods
    def to_api_hash
      { :id => id,
        :title => title,
        :date => date,
        :url => url
      }
    end
  end
end