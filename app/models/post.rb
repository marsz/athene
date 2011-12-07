class Post < ActiveRecord::Base
  include ActAsTagsStripable
  act_as_tags_stripable :columns => [:title]
  
  belongs_to :site, :counter_cache => true
  belongs_to :user, :counter_cache => true
  validates_uniqueness_of :site_post_id, :scope => [:site_id]
  validates_presence_of [:site_id,:site_post_id,:user_id,:url,:date,:title]
  
  before_validation :sync_site_id_from_user
  
  def self.new_by_user(user, hash = {})
    post = user.posts.build(hash)
    post.site = user.site
    post.site_post_id = user.crawler.parse_site_post_id_from_url(post.url) if post.url
    post
  end
  
  protected
  def sync_site_id_from_user
    self.site_id = self.user.site.id if self.user
  end
end
