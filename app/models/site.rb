class Site < ActiveRecord::Base
  validates_format_of :domain, :with => /[a-z\-]+/
  validates_uniqueness_of :domain
  validates_presence_of :url
  validates_presence_of :name
  validates_presence_of :domain
end
