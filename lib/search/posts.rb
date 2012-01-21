module Search::Posts
  extend ActiveSupport::Concern
  
  module ClassMethods
    def searchable
      scope :search, lambda{ |opts| do_search(opts) }
    end
    
    def do_search opts = {}
      paginates_per 50
      posts = Post.includes([:user,:site]).page(opts[:page]).order("date DESC")
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