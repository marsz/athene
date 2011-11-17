class Post < ActiveRecord::Base
  belongs_to :site, :counter_cache => true
  belongs_to :user, :counter_cache => true
  validates_uniqueness_of :site_post_id, :scope => [:site_id]
  validates_presence_of :site_id
  validates_presence_of :site_post_id
  validates_presence_of :user_id
  validates_presence_of :url
  validates_presence_of :date
  validates_presence_of :title
  
  before_validation :sync_site_id
  
  protected
  def sync_site_id
    self.site_id = self.user.site.id if self.user
  end
end
