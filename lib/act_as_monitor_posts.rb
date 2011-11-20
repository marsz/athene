module ActAsMonitorPosts
  extend ActiveSupport::Concern
  include ActAsFetcher
  
  module ClassMethods
    def act_as_monitor_posts
      delegate :crawler, :to => :site
    end
  end
  
  module InstanceMethods
    def monitor_posts
      content = fetch(crawler.url_posts(self))
      fetch_all = true
      crawler.parse_posts_from_posts_page(content).each do |post_hash|
        post = Post.new_by_user(self, post_hash)
        if !post.save
          fetch_all = false
          Post.find_by_site_id_and_site_post_id(post.site_id,post.site_post_id).update_attributes(post_hash)
        end
      end
      if fetch_all
        fetch_all_posts
      end
      self.update_attributes(:monitored_at => Time.now)
    end
    
    def fetch_all_posts
      posts = []
      fetch_hash_posts.each do |post_hash|
        post = Post.new_by_user(self, post_hash)
        if !post.save
          post = Post.find_by_site_id_and_site_post_id(post.site_id,post.site_post_id)
          post.update_attributes(post_hash)
        end
        posts << post
      end
      posts
    end
    
    def fetch_hash_posts
      posts = []
      crawler.posts_urls_by_user(self).each do |url|
        content = fetch(url)
        posts.concat(crawler.parse_posts_from_posts_page(content))
      end
      posts
    end
  end
end