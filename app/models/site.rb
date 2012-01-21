class Site < ActiveRecord::Base
  include ActAsFetcher
  include ActAsHavingCrawler
  include Search::Sites
  searchable
  
  validates_format_of :domain, :with => /\A[a-z\-\.0-9]+\z/
  validates_uniqueness_of :domain
  validates_presence_of :url
  validates_presence_of :name
  validates_presence_of :domain
  has_many :users_monitor_urls, :include => [:parser]
  has_many :users
  has_many :posts
  
end
