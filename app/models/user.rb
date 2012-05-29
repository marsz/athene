class User < ActiveRecord::Base
  include Search::Users
  acts_as_searchable

  include ActAsIsEnabled
  act_as_is_enabled
  
  include ActAsMonitorPosts
  act_as_monitor_posts
  
  include ActAsUserChecker
  act_as_user_checker
  
  include ActAsUserAvatar
  act_as_user_avatar
  
  belongs_to :site, :counter_cache => true
  validates_uniqueness_of :site_user_id, :scope => [:site_id], :case_sensitive => false
  validates_presence_of :site_id
  validates_presence_of :site_user_id
  validates_format_of :site_user_id, :with => /\A[^\n\/\?>< ]+\z/
  has_many :posts, :order => "date DESC,datetime DESC", :dependent => :destroy
  scope :blacklist, where(:is_black => true)
  
  def self.new_by_url(url, hash = {})
    if site = (hash[:site] || Site.find_by_url(url))
      user = User.new(hash)
      user.site = site
      user.site_user_id = site.crawler.parse_site_user_id_from_url(url)
      User.find_by_site_user_id_and_site_id(user.site_user_id, site.id) || user
    end
  end
end
