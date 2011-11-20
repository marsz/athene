class User < ActiveRecord::Base
  include ActAsMonitorPosts
  act_as_monitor_posts
  
  belongs_to :site, :counter_cache => true
  validates_uniqueness_of :site_user_id, :scope => [:site_id]
  validates_presence_of :site_id
  validates_presence_of :site_user_id
  has_many :posts, :order => "date DESC,datetime DESC"
  
  def self.new_by_url(url, hash = {})
    if site = Site.find_by_url(url)
      user = User.new(hash)
      user.site = site
      user.site_user_id = site.crawler.parse_site_user_id_from_url(url)
      User.find_by_site_user_id_and_site_id(user.site_user_id, site.id) || user
    end
  end
end
