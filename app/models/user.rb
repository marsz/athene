class User < ActiveRecord::Base
  belongs_to :site, :counter_cache => true
  validates_uniqueness_of :site_user_id, :scope => [:site_id]
  validates_presence_of :site_id
  validates_presence_of :site_user_id
  has_many :posts, :order => "date DESC,datetime DESC"
  # validates_presence_of :url
end
