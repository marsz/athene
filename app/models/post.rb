class Post < ActiveRecord::Base
  paginates_per 50
  
  include ActAsTagsStripable
  act_as_tags_stripable :columns => [:title]
  
  belongs_to :site, :counter_cache => true
  belongs_to :user, :counter_cache => true
  validates_uniqueness_of :site_post_id, :scope => [:site_id]
  validates_presence_of [:site_id,:site_post_id,:user_id,:url,:date]
  validates_presence_of :title, :unless => Proc.new{|post|post.title.to_s.size > 0}
  
  before_validation :sync_site_id_from_user
  
  def self.new_by_user(user, hash = {})
    post = self.new(hash)
    post.user = user
    post.site = user.site
    post.site_post_id = user.crawler.parse_site_post_id_from_url(post.url) if post.url
    post
  end
  
  protected
  def sync_site_id_from_user
    self.site_id = self.user.site.id if self.user
  end
end
